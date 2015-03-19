//
//  TLBOnlyContainerViewController.m
//  Twincue
//
//  Created by mizogaki masahito on 7/18/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBOnlyContainerViewController.h"
#import "TLBOnlyPageView.h"
#import "TLBThumbnailTableCell.h"


@interface TLBOnlyContainerViewController ()<UIScrollViewDelegate,TLBThumbnailTableCellDelegate>

/** onlyTableView:テーブルビュー */
@property (weak, nonatomic) IBOutlet UITableView *onlyTableView;

/** リフレッシュコントロール */
@property (strong, nonatomic) UIRefreshControl *refreshControl;
/** ユーザ情報 */
@property (strong, nonatomic) NSArray *userArray;
/** ページング用ぐるぐる */
@property (strong, nonatomic) UIActivityIndicatorView *pagingIndicator;

@end

@implementation TLBOnlyContainerViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
   
    // pullRefresh用
    UIRefreshControl *refreshConytol = [[UIRefreshControl alloc] init];
    [refreshConytol addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.onlyTableView addSubview:refreshConytol];
    self.refreshControl = refreshConytol;
    
    // ページング用インジケーターを作成
    self.pagingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *pagingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.onlyTableView.width, 40)];
    self.pagingIndicator.center = CGPointMake(pagingView.width / 2, pagingView.height / 2);
    [pagingView addSubview:self.pagingIndicator];
    self.onlyTableView.tableFooterView = pagingView;
    
    // セルの登録
    [self.onlyTableView registerNib:
     [UINib nibWithNibName:NSStringFromClass([TLBThumbnailTableCell class])  bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([TLBThumbnailTableCell class])];
    
    self.onlyTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Pull Refresh
- (void)pullRefresh:(id)sender {
    if (self.pullRefreshBlock) {
        self.pullRefreshBlock();
    }
}

#pragma mark - Public Method
- (void)setData:(NSArray *)dataArray page:(NSInteger)page maxCount:(NSInteger)maxCount {
    // ぐるぐる停止
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    
    if ([self.pagingIndicator isAnimating]) {
        [self.pagingIndicator stopAnimating];
    }
    
    // 最大件数と、現在のカウントを比較、ページングViewを表示非表示を切り分ける
    if (maxCount <= self.userArray.count + dataArray.count) {
        self.onlyTableView.tableFooterView.hidden = YES;
    }
    else {
        self.onlyTableView.tableFooterView.hidden = NO;
    }
    
    // page == 1の場合は配列を置き換え、それ以外はappend
    if (page == 1) {
        self.userArray = dataArray;
    }
    else {
        self.userArray = [self.userArray arrayByAddingObjectsFromArray:dataArray];
    }
    
    [self.onlyTableView reloadData];
}

- (NSInteger )maxCount {
    return self.userArray.count;
}

- (NSArray *)datasource {
    return self.userArray;
}

- (void)scrollAccount:(TLBAccount *)account {
    NSInteger index = [self.userArray indexOfObject:account];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.onlyTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (BOOL)isPagingEnabled {
    return !self.onlyTableView.tableFooterView.hidden;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.onlyTableView.tableFooterView.hidden &&
        ![self.pagingIndicator isAnimating]) {
        CGRect bounds = scrollView.bounds;
        if (bounds.origin.y > scrollView.contentSize.height - self.onlyTableView.height / 2 &&
            self.pagingBlock) {
            [self.pagingIndicator startAnimating];
            self.pagingBlock();
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLBThumbnailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TLBThumbnailTableCell class])];
    [cell setUserData:self.userArray[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 460;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tapDetailBlock(self.userArray[indexPath.row]);
}

#pragma mark - TLBThumbnailTableCellDelegate
- (void)thumbnailCellTapLikes:(TLBThumbnailTableCell *)cell {
    NSIndexPath *index = [self.onlyTableView indexPathForCell:cell];
    TLBAccount *account = self.userArray[index.row];
    self.tapLikesBlock(account);
}

@end
