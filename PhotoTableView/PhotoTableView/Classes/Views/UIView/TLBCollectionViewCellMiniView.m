//
//  TLBCollectionViewCellMiniView.m
//  Twincue
//
//  Created by mizogaki masahito on 7/25/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBCollectionViewCellMiniView.h"

@interface TLBCollectionViewCellMiniView ()

//** 年齢ラベル */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

//** ログインステータス */
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;

//** 出身ラベル */
@property (weak, nonatomic) IBOutlet UILabel *homeTownLabel;

//** いいねボタン */
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

//** プロフィールイメージ */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

//** プロフィールNEWのイメージ */
@property (weak, nonatomic) IBOutlet UIImageView *userProfileNewImageView;

/** ボタンフラグ */
@property BOOL buttonFlag;

/** ユーザ情報 */
@property (nonatomic,weak) TLBAccount *userInfo;

/** ハートアイコンのUIImageView */
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@end


@implementation TLBCollectionViewCellMiniView

+ (id)loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    return [nib instantiateWithOwner:nil options:nil][0];
}

+ (CGFloat)height {
   return 180;
}

#pragma mark LikeButton
- (IBAction)likeButton:(id)sender {
    self.likesBlock();
    
    
    self.likeButton.enabled = NO;
    
    // ハートを表示する
    self.heartImageView.alpha = 1.0f;
}

#pragma mark Public Cell Method
- (void)userDataCollectionCell {
   
}


- (void)userProfileNewImage:(BOOL)newImageFlag {
    // プロフィール画像のNewマーク
    self.userProfileNewImageView.hidden = !newImageFlag;
}

@end
