//
//  TLBCollectionListViewCell.m
//  Twincue
//
//  Created by mizogaki masahito on 7/24/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBCollectionListViewCell.h"
#import "TLBCollectionViewCellBigView.h"
#import "TLBCollectionViewCellMiniView.h"

#import "TLBAccount.h"

@interface TLBCollectionListViewCell ()

/** インスタンス */
@property (strong,nonatomic)TLBCollectionViewCellBigView *collectionViewCellLargeView;

/** インスタンス */
@property (strong,nonatomic)TLBCollectionViewCellMiniView *collectionViewCellMiniView;

@end

@implementation TLBCollectionListViewCell


- (void)awakeFromNib {
    // 使いまわすのでインスタンスに保持
    self.collectionViewCellLargeView = [TLBCollectionViewCellBigView loadFromNib];
    self.collectionViewCellMiniView  = [TLBCollectionViewCellMiniView loadFromNib];
    
    // ブロックの実装
    __weak typeof(self) weakSelf = self;
    void (^likesBlock)() = ^() {
        [weakSelf.delegate collectionListCellTapLikes:weakSelf];
    };
    
    self.collectionViewCellLargeView.likesBlock = likesBlock;
    self.collectionViewCellMiniView.likesBlock = likesBlock;
}

- (void)setCustomCollectionCell:(NSIndexPath *)indexPath account:(TLBAccount *)account {

    
    // TLBCollectionViewCellに各データとレイアウトを追加
    if ([[self class] displayTypeWithIndexPath:indexPath] == CollectionViewCellTypeBig) {
        
        [self.collectionViewCellMiniView removeFromSuperview];
        
        // サイズを再設定
        self.collectionViewCellLargeView.size = self.size;
        [self.contentView addSubview:self.collectionViewCellLargeView];
        [self.collectionViewCellLargeView userDataCollectionCell:account];
    }
    else{

        [self.collectionViewCellLargeView removeFromSuperview];
        
        // サイズを再設定
        self.collectionViewCellMiniView.size = self.size;
        [self.contentView addSubview:self.collectionViewCellMiniView];
        [self.collectionViewCellMiniView userDataCollectionCell:account];
    }
}

#pragma mark - Public Method
+ (CollectionViewCellType)displayTypeWithIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row + 1) % COLLECTIONVIEW_INDEX == 0 && indexPath.row != 0) {
        return CollectionViewCellTypeBig;
    }
    else {
        return CollectionViewCellTypeSmall;
    }
}

+ (CGFloat)height:(CollectionViewCellType)type {
    switch (type) {
        case CollectionViewCellTypeBig:
            return [TLBCollectionViewCellBigView height];
            break;
            
        case CollectionViewCellTypeSmall:
            return [TLBCollectionViewCellMiniView height];
            break;
            
        default:
            return 0;
            break;
    }
}


@end
