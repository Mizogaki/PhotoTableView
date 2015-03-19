//
//  TLBCollectionViewCellLageLargeView.h
//  Twincue
//
//  Created by mizogaki masahito on 7/25/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TLBCollectionViewCellBigView : UIView

/** いいね！を押された時のブロックです */
@property (nonatomic, copy) void(^likesBlock)();

/**
 * TLBCollectionViewCellLargeViewを呼び出す
 * @return:id Xibファイル
 */
+ (id)loadFromNib;

/**
 * 高さを返します
 */
+ (CGFloat)height;

/**
 * TLBCollectionListViewCellにデータを反映させる
 * @param:accountInfo ユーザーデータを反映させる
 */
- (void)userDataCollectionCell;

@end

