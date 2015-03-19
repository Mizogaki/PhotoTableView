//
//  TLBListTableViewCell.h
//  Twincue
//
//  Created by mizogaki masahito on 7/11/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLBThumbnailTableCellDelegate;

@interface TLBThumbnailTableCell : UITableViewCell


/** イイねを押した時に使用するdelegateです */
@property (weak,nonatomic) id<TLBThumbnailTableCellDelegate> delegate;

/**
 * ThumbnailTableCellにデータを反映させる
 * @param:account ユーザ情報
 */
- (void)setUserData:(TLBAccount *)account;

@end

@protocol TLBThumbnailTableCellDelegate <NSObject>
@required
- (void)thumbnailCellTapLikes:(TLBThumbnailTableCell *)cell;

@end
