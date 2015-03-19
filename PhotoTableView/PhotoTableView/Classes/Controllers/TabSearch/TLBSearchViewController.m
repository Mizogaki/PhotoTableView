//
//  TLBSearchViewController.m
//  Twincue
//
//  Created by mizogaki masahito on 7/8/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBSearchViewController.h"

#import "TLBOnlyContainerViewController.h"
#import "TLBCollectionListViewController.h"

#import "TLBSetOfConditionsViewController.h"

#import "TLBAccountManager.h"

#import "TLBOtherGenderDetailViewController.h"

#import "TLBLikeThankAlertView.h"
#import "TLBResultEmptyView.h"

#define KEY_USERDEFAULTS_VIEW_TYPE @"viewType"
#define EMPTY_VIEW_TAG 1

typedef enum SearchViewType : NSInteger {
    SearchViewTypeTable = 1,
    SearchViewTypeCollection = 2,
} SearchViewType;

@interface TLBSearchViewController ()

/** containerViewの切り替え制御 */
@property(nonatomic) SearchViewType viewType;

/** 件数表示ラベル */
@property(weak, nonatomic) IBOutlet UILabel *countLabel;
/** コンテナ */
@property(weak, nonatomic) IBOutlet UIView *containerView;

/** ページング用のプロパティ */
@property(nonatomic) NSInteger paging;

/** 1列表示のレイアウト 中身はテーブルView */
@property(strong, nonatomic) TLBOnlyContainerViewController *onlyViewController;
/** 2列表示のレイアウト 中身はコレクションView */
@property(strong, nonatomic) TLBCollectionListViewController *collectionViewController;

/** 異性詳細ViewController */
@property(strong, nonatomic) TLBOtherGenderDetailViewController *otherGenderViewController;

@end

@implementation TLBSearchViewController


#pragma mark - ViewController LifeCycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // ページング用のフラグを初期化
        self.paging = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // containerViewFlagを初期化
    self.viewType = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_USERDEFAULTS_VIEW_TYPE];
    // 初期値が設定されていない場合、2列表示をデフォルトとする
    if (self.viewType <= 0) {
        self.viewType = SearchViewTypeCollection;
        
        [self saveViewType];
    }
    
    // onlyContainerViewにTLBOnlyContainerViewControllerを代入
    TLBOnlyContainerViewController *onlyContainerVC =
    [[TLBOnlyContainerViewController alloc] initWithNibName:NSStringFromClass([TLBOnlyContainerViewController class]) bundle:nil];
    
    [self addChildViewController:onlyContainerVC];
    onlyContainerVC.view.frame = CGRectMake(0, 0, self.containerView.width, self.containerView.height);
    [self.containerView addSubview:onlyContainerVC.view];
    [onlyContainerVC didMoveToParentViewController:self];
    
    self.onlyViewController = onlyContainerVC;
    
    // プロパティとして保持
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[TLBCollectionListViewController class]]) {
            self.collectionViewController = (TLBCollectionListViewController *) controller;
            break;
        }
    }
    
    // 各コンテナにBlockをセットする
    [self setBlock];
    
    // 画面の初期表示
    if (self.viewType == SearchViewTypeTable) {
        self.onlyViewController.view.hidden = NO;
        self.collectionViewController.view.hidden = YES;
    }
    else {
        self.collectionViewController.view.hidden = NO;
        self.onlyViewController.view.hidden = YES;
    }
    
    // データを取得する
    [self requestUserData];
    
    // ナビゲーションバーをピンクに
    [self setNavigationBarColor:THEME_COLOR_1 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ナビゲーションバーをピンクに
    [self setNavigationBarColor:THEME_COLOR_1 animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 設定画面への遷移
    if ([segue.identifier isEqualToString:@"searchCondition"]) {
        __weak typeof (self) weakSelf = self;
        UINavigationController *navigationController = [segue destinationViewController];
        TLBSetOfConditionsViewController *controller = navigationController.viewControllers[0];
        // 条件変更がされた場合、データを再取得する
        controller.reloadBlock = ^{
            [[weakSelf.view viewWithTag:EMPTY_VIEW_TAG] removeFromSuperview];
            weakSelf.paging = 1;
            [weakSelf requestUserData];
        };
    }
}

#pragma mark - IBAction
- (IBAction)changeContainerView:(id)sender {
    
    if (self.viewType == SearchViewTypeTable) {
        // onlyContainerViewを最前面へ
        self.collectionViewController.view.hidden = NO;
        self.onlyViewController.view.hidden = YES;
        [self.view bringSubviewToFront:self.collectionViewController.view];
        self.viewType = SearchViewTypeCollection;
    }
    else {
        // listContainerViewを最前面へ
        self.collectionViewController.view.hidden = YES;
        self.onlyViewController.view.hidden = NO;
        [self.containerView bringSubviewToFront:self.onlyViewController.view];
        self.viewType = SearchViewTypeTable;
    }
    
    [self saveViewType];
}

#pragma mark - Private Method
- (void)setBlock {
    
    __weak typeof(self) weakSelf = self;
    // PullRefresh用のブロック
    void (^pullRefreshBlock)() = ^() {
        weakSelf.paging = 1;
        [weakSelf requestUserData];
    };
    
    // paging用のブロック
    void (^pagingBlock)() = ^() {
        weakSelf.paging++;
        [weakSelf requestUserData];
    };
    
    /**
     * 表示されている異性が変更された際のBlock
     * 異性詳細で、横スクロールして表示しているユーザが変更された場合に呼ばれる
     * 現在表示されているユーザまで各Viewをスクロールさせる
     */
    void (^changeDispLayUserBlock)(TLBAccount *account) = ^(TLBAccount *account) {
        [weakSelf.collectionViewController scrollAccount:account];
        [weakSelf.onlyViewController scrollAccount:account];
    };
    
    // いいね！を押した時のブロック
    void(^likesBlock)(TLBAccount *) = ^(TLBAccount *account) {
        // いいねをもらっているユーザの時は、専用アラートを表示する
        if (account.sendLikes) {
            [[[TLBLikeThankAlertView alloc] initWithNickName:account.nickname
                                                  alertBlock:^(TLBAlertView *alertView, NSInteger buttonIndex) {
                                                      if (buttonIndex == alertView.registButtonIndex) {
#warning 確か大丈夫だと思うけど、いいねありがとうの時もAPI一緒でおｋ？
                                                          [weakSelf sendLike:account.accountId];
                                                      }
                                                  }] show];
        }
        else {
            [weakSelf sendLike:account.accountId];
        }
    };
    
    {
        // ブロックのセット
        self.onlyViewController.pullRefreshBlock = pullRefreshBlock;
        self.onlyViewController.pagingBlock = pagingBlock;
        self.onlyViewController.tapLikesBlock = likesBlock;
        self.onlyViewController.tapDetailBlock = ^(TLBAccount *account) {
            TLBOtherGenderDetailViewController *controller = [TLBOtherGenderDetailViewController loadStoryBoard];
            controller.account = account;
            controller.dataSource = weakSelf.onlyViewController.datasource;
            
            controller.changeDisplayAccountBlock = changeDispLayUserBlock;
            
            controller.pagingBlock = ^(TLBOtherGenderDetailViewController *controller){
                if (weakSelf.onlyViewController.isPagingEnabled) {
                    weakSelf.paging++;
                    [weakSelf requestUserData];
                }
            };
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
            weakSelf.otherGenderViewController = controller;
        };
    }
    
    {
        // ブロックのセット
        self.collectionViewController.pullRefreshBlock = pullRefreshBlock;
        self.collectionViewController.pagingBlock = pagingBlock;
        self.collectionViewController.tapLikesBlock = likesBlock;
        self.collectionViewController.tapDetailBlock = ^(TLBAccount *account) {
            TLBOtherGenderDetailViewController *controller = [TLBOtherGenderDetailViewController loadStoryBoard];
            controller.account = account;
            controller.dataSource = weakSelf.collectionViewController.datasource;
            
            controller.changeDisplayAccountBlock = changeDispLayUserBlock;
            
            controller.pagingBlock = ^(TLBOtherGenderDetailViewController *controller){
                if (weakSelf.collectionViewController.isPagingEnabled) {
                    weakSelf.paging++;
                    [weakSelf requestUserData];
                }
            };
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
            weakSelf.otherGenderViewController = controller;
        };
    }
}

- (void)saveViewType {
    [[NSUserDefaults standardUserDefaults] setInteger:self.viewType forKey:KEY_USERDEFAULTS_VIEW_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendLike:(NSNumber *)targetUserId {
    // マッチング成立アラートはマネージャー任せなので特にハンドリングしない。。。
    [[TLBAccountManager sharedInstance] sendLikes:targetUserId
                                         succsess:^(id result) {
                                             
                                         }
                                          failure:^(NSError *error) {
                                              
                                          }];
}

- (void)requestUserData {
    __weak typeof (self) weakSelf = self;
    
    [[TLBAccountManager sharedInstance]
     requestUserList:@{REQUEST_KEY_COMMON_PAGE : @(self.paging)}
     succsess:^(id result) {
         
         // 検索結果無し
         if ([result[RESULT_KEY_COMMON_LIST] count] == 0) {
             [weakSelf.view addSubview:[weakSelf createEmptyView:NO]];
             return;
         }
         
         TLBAccount *me = [[TLBAccountManager sharedInstance] meInfo];
         NSString *gender = ([TLBGenderEnum genderWithGenderString:me.gender] == GenderMale) ? NSLocalizedString(@"女性", nil)
         : NSLocalizedString(@"男性", nil);
         weakSelf.countLabel.text = [NSString stringWithFormat:@"%d%@%@%@", [result[RESULT_KEY_COMMON_MAX_COUNT] intValue], NSLocalizedString(@"人の", nil), gender, NSLocalizedString(@"がヒットしました", nil)];
         
         // 検索結果有り
         // 1行レイアウトにデータをセット
         [weakSelf.onlyViewController setData:result[RESULT_KEY_COMMON_LIST]
                                         page:weakSelf.paging
                                     maxCount:[result[RESULT_KEY_COMMON_MAX_COUNT] integerValue]];
         // 2行レイアウトにデータをセット
         [weakSelf.collectionViewController setData:result[RESULT_KEY_COMMON_LIST]
                                               page:weakSelf.paging
                                           maxCount:[result[RESULT_KEY_COMMON_MAX_COUNT] integerValue]];
         
         // 異性詳細画面に遷移している際は通知を送る
         if (weakSelf.otherGenderViewController) {
             [weakSelf.otherGenderViewController pagingFinished];
         }
     }
     failure:^(NSError *error) {
         if (NSURLErrorCannotConnectToHost == error.code
             || NSURLErrorNotConnectedToInternet == error.code) {
             [weakSelf.view addSubview:[weakSelf createEmptyView:YES]];
         }
     }];
}

/**
 * 検索結果が0件の時、オフラインの時のビューを作成する
 * @param isApiFailure APIエラーかどうか
 * @return EmptyView 表示するビュー
 */
- (UIView *)createEmptyView:(BOOL)isApiFailure {
    TLBResultEmptyView *emptyView = [TLBResultEmptyView loadFromNib];
    UIView *outerView;
    if (isApiFailure) {
        outerView = [[UIView alloc] initWithFrame:CGRectMake(self.countLabel.frame.origin.x, self.countLabel.frame.origin.y
                                                             , self.containerView.width, self.containerView.height + self.countLabel.height)];
        emptyView.frame = CGRectMake(self.containerView.frame.origin.x
                                     , self.containerView.height - emptyView.frame.size.height + self.countLabel.height, emptyView.width, emptyView.height);
        [emptyView setMessage:NSLocalizedString(@"インターネットに\n接続できませんでした。", nil)
                   subMessage:NSLocalizedString(@"インターネット接続を確認してください。", nil)];
    } else {
        outerView = [[UIView alloc] initWithFrame:self.containerView.frame];
        emptyView.frame = CGRectMake(self.containerView.frame.origin.x
                                     , self.containerView.height - emptyView.frame.size.height, emptyView.width, emptyView.height);
        [emptyView setMessage:NSLocalizedString(@"あなたの条件にマッチする\nお相手が見つかりませんでした。", nil)
                   subMessage:NSLocalizedString(@"条件を変えて、\nもう一度検索してみましょう！", nil)];
    }
    outerView.backgroundColor = [UIColor whiteColor];
    outerView.tag = EMPTY_VIEW_TAG;
    [outerView addSubview:emptyView];
    return outerView;
}

@end
