//
//  TLBCollectionListViewController.m
//  Twincue
//
//  Created by mizogaki masahito on 7/24/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBCollectionListViewController.h"
#import "TLBCollectionListViewCell.h"
#import "TLBCollectionViewCellMiniView.h"

#import "TLBAccount.h"

@interface TLBCollectionListViewController ()
<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TLBCollectionListViewCellDelegate>

/** collectionView:コレクションビュー */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionListView;

/** pull refresh用 */
@property (strong, nonatomic) UIRefreshControl *refreshControl;
/** データ配列 */
@property (strong, nonatomic) NSArray *userArray;

/** ページング用ぐるぐる */
@property (strong, nonatomic) UIActivityIndicatorView *pagingIndicator;
/** フッターView */
@property (strong, nonatomic) UIView    *footerView;

@end

@implementation TLBCollectionListViewController

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pullRefresh用
    UIRefreshControl *refreshConytol = [[UIRefreshControl alloc] init];
    [refreshConytol addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionListView addSubview:refreshConytol];
    self.refreshControl = refreshConytol;
    
    // ページング用インジケーターを作成
    self.pagingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIView *pagingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionListView.width, 40)];
    self.pagingIndicator.center = CGPointMake(pagingView.width / 2, pagingView.height / 2);
    [pagingView addSubview:self.pagingIndicator];
    [self.collectionListView addSubview:pagingView];
    self.footerView = pagingView;
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
    
    // page == 1の場合は配列を置き換え、それ以外はappend
    if (page == 1) {
        self.userArray = dataArray;
    }
    else {
        self.userArray = [self.userArray arrayByAddingObjectsFromArray:dataArray];
    }
    
    [self.collectionListView reloadData];
    
    // 最大件数と、現在のカウントを比較、ページングViewを表示非表示を切り分ける
    if (maxCount <= self.userArray.count + dataArray.count) {
        [self redrawFooterView:YES];
    }
    else {
        [self redrawFooterView:NO];
    }
    
}

- (NSArray *)datasource {
    return self.userArray;
}

- (void)scrollAccount:(TLBAccount *)account {
    NSInteger index = [self.userArray indexOfObject:account];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionListView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
    }
}

- (BOOL)isPagingEnabled {
    return !self.footerView.hidden;
}

#pragma mark - Private Method
/**
 * フッターの位置を再描画します
 */
- (void)redrawFooterView:(BOOL)hidden {
    
    if (self.footerView.superview) {
        [self.collectionListView addSubview:self.footerView];
    }
    
    UIEdgeInsets insets = self.collectionListView.contentInset;
    if (!hidden) {
        insets.bottom = self.footerView.height;
        self.footerView.top = self.collectionListView.collectionViewLayout.collectionViewContentSize.height;
    }
    else {
        insets.bottom = 0;
    }
    
    self.collectionListView.contentInset = insets;
    
    self.footerView.hidden = hidden;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.footerView.hidden && ![self.pagingIndicator isAnimating]) {
        CGPoint offset = scrollView.contentOffset;
        if (self.pagingBlock &&
            offset.y > self.footerView.top + self.footerView.height / 2 - self.collectionListView.height) {
            [self.pagingIndicator startAnimating];
            self.pagingBlock();
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TLBCollectionListViewCell *collectionListViewCell =
    [self.collectionListView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TLBCollectionListViewCell class])
                                                   forIndexPath:indexPath];
    // Cellにレイアウトとデータを追加する
    [collectionListViewCell setCustomCollectionCell:indexPath account:self.userArray[indexPath.row]];
    collectionListViewCell.delegate = self;
    return collectionListViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    const float miniCollctionCellWidth = ((self.collectionListView.width / 2) - 15);
    const float bigCollctionCellWidth  =  self.collectionListView.width - 20;
    
    // indexPathによって出し分ける
    if ([TLBCollectionListViewCell displayTypeWithIndexPath:indexPath] == CollectionViewCellTypeBig) {
        return CGSizeMake(bigCollctionCellWidth, [TLBCollectionListViewCell height:CollectionViewCellTypeBig]);
    }
    else {
        return CGSizeMake(miniCollctionCellWidth, [TLBCollectionListViewCell height:CollectionViewCellTypeSmall]);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.tapDetailBlock(self.userArray[indexPath.row]);
}

#pragma mark - TLBCollectionListViewCellDelegate
- (void)collectionListCellTapLikes:(TLBCollectionListViewCell *)cell {
    NSIndexPath *index = [self.collectionListView indexPathForCell:cell];
    TLBAccount *account = self.userArray[index.row];
 
    self.tapLikesBlock(account);
}


@end

