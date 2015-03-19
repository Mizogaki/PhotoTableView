//
//  TLBCollectionViewCellLageLargeView.m
//  Twincue
//
//  Created by mizogaki masahito on 7/25/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBCollectionViewCellBigView.h"


#import "UIView+animation.h"

@interface TLBCollectionViewCellBigView ()

/** いいねボタン */
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

/** ユーザ画像 */
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

/** newラベル */
@property (weak, nonatomic) IBOutlet UIImageView *userProfileNewImageView;

/** イニシャルラベル */
@property (weak, nonatomic) IBOutlet UILabel *initialLabel;

/** 年齢ラベル */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

/** 出身ラベル */
@property (weak, nonatomic) IBOutlet UILabel *hometownLabel;

/** いいね数ラベル */
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;

/** オンラインステータスのイメージ */
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;

/** オンラインステータスのラベル */
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

/** ボタンフラグ */
@property BOOL buttonFlag;

/** ユーザ情報 */
@property (nonatomic,weak) TLBAccount *userInfo;

/** ハートアイコンのUIImageView */
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@end


@implementation TLBCollectionViewCellBigView

+ (id)loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    return [nib instantiateWithOwner:nil options:nil][0];
}

+ (CGFloat)height {
    return 340;
}

#pragma mark LikeButton
- (IBAction)likeButton:(id)sender {
    
    self.likesBlock();
    
    self.userInfo.sendLikes = YES;

    self.likeButton.enabled = NO;
    
    // ハートを表示する
    self.heartImageView.alpha = 1.0f;
    
    // アニメーション開始
    [UIView startHeartAnimation:self.heartImageView
                 expandDuration:0.3f
                displayDuration:0.6f
                fedeOutDuration:0.1f
                       maxScale:15.0f
                     completion:nil];
}

#pragma mark Public Cell Method
- (void)userDataCollectionCell:(TLBAccount *)accountInfo {
    self.userInfo = accountInfo;
    
    self.likeButton.enabled = !accountInfo.sendLikes;
    
    self.ageLabel.text = [accountInfo.age stringValue];
    self.hometownLabel.text = [TLBPrefectureEnum displayNameWithProperty:accountInfo.hometown];
    [self userLoginStatus:accountInfo];
    
    [self userProfileNewImage:[accountInfo.isNewFlg boolValue]];
    
    TLBAccountImage *imageModel = (accountInfo.picture.count > 0) ? accountInfo.picture[0] : nil;
    if ([imageModel isDisplay]) {
        [self userProfileImageView:[NSURL URLWithString:imageModel.url]];
    }
    else {
        [self userProfileImageView:nil];
    }

    // ハートを非表示にする
    self.heartImageView.alpha = 0.0f;
}

- (void)userLoginStatus:(TLBAccount *)account {
    switch ([account onlineStatus]) {
        case OnlineStatusOnline:
            self.loginImageView.image = [UIImage imageNamed:@"ico_online01"];
            break;
            
        case OnlineStatus1Day:
        case OnlineStatus3days:
        case OnlineStatus1Week:
            self.loginImageView.image = [UIImage imageNamed:@"ico_online02"];
            break;
            
        default:
            self.loginImageView.image = [UIImage imageNamed:@"ico_online03"];
            break;
    }
    
    self.onlineLabel.text = [account onlineStatusStr];
}

- (void)userProfileImageView:(NSURL*)imageUrl {
    // プロフィール画像イメージ
    [self.userImageView setImageWithURL:imageUrl placeholderImage:nil];
}

- (void)userProfileNewImage:(BOOL)newImageFlag{
    // プロフィール画像のNewマーク
    self.userProfileNewImageView.hidden = !newImageFlag;
}

@end
