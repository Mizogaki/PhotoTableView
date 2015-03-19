//
//  TLBCollectionListViewCell.h
//  Twincue
//
//  Created by mizogaki masahito on 7/24/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLLECTIONVIEW_INDEX 11

typedef enum CollectionViewCellType : NSInteger {
    CollectionViewCellTypeBig = 0,
    CollectionViewCellTypeSmall = 1
} CollectionViewCellType;

@class TLBAccount;
@protocol TLBCollectionListViewCellDelegate;

@interface TLBCollectionListViewCell : UICollectionViewCell

/** イイねを押した時に使用するdelegateです */
@property (weak,nonatomic) id<TLBCollectionListViewCellDelegate> delegate;

/**
 * TLBCollectionListViewCellにUIViewを追加
 * @param:indexPath テーブルインデックス
 * @param:account  ユーザーデータ
 */
- (void)setCustomCollectionCell:(NSIndexPath *)indexPath account:(TLBAccount *)account;

/**
 * 高さを返します
 */
+ (CGFloat)height:(CollectionViewCellType)type;

/**
 * NSIndexPathから表示するcellのタイプを返します
 * @param indexPath 表示対象のIndexPath
 * @return CollectionViewCellType 表示するcellのタイプ
 */
+ (CollectionViewCellType)displayTypeWithIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TLBCollectionListViewCellDelegate <NSObject>
@required
- (void)collectionListCellTapLikes:(TLBCollectionListViewCell *)cell;


@end
