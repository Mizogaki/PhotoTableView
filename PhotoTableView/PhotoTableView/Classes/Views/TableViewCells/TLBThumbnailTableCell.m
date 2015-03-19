//
//  TLBListTableViewCell.m
//  Twincue
//
//  Created by mizogaki masahito on 7/11/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBThumbnailTableCell.h"
#import "TLBOnlyPageView.h"
#import <QuartzCore/QuartzCore.h>


@interface TLBThumbnailTableCell()<UIScrollViewDelegate>

/** 横スクロール */
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
/** いいねボタン */
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
/** newラベル */
@property (weak, nonatomic) IBOutlet UIImageView *userProfileNewImageView;
/** ページコントロール */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/** イニシャルラベル */
@property (weak, nonatomic) IBOutlet UILabel *initialLabel;
/** 年齢ラベル */
@property (weak, nonatomic) IBOutlet UILabel *ageLablel;
/** 出身ラベル */
@property (weak, nonatomic) IBOutlet UILabel *hometownLabel;
/** いいね数ラベル */
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
/** 身長ラベル */
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
/** 体型ラベル */
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
/** 職業タイトルラベル */
@property (weak, nonatomic) IBOutlet UILabel *jobTitlelabel;
/** 職業ラベル */
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
/** 年収ラベル */
@property (weak, nonatomic) IBOutlet UILabel *annualIncomeLalbel;
/** 自己紹介ラベル */
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
/** オンラインステータスのイメージ */
@property (weak, nonatomic) IBOutlet UIImageView *onlineImageVeiw;
/** オンラインステータスのラベル */
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

/** ユーザイメージの配列 */
@property (strong, nonatomic) NSArray *profileImageArray;

/** ボタンフラグ */
@property BOOL buttonFlag;

 /** アカウント情報 */
@property (nonatomic, weak) TLBAccount *userInfo;

/** ハートアイコンのUIImageView */
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@end

@implementation TLBThumbnailTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // プロフィールイメージ用のViewを生成
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pageScrollView.frame.width * i),
                                                                               0,
                                                                               self.pageScrollView.size.width,
                                                                               self.pageScrollView.size.height)];
		[self.pageScrollView addSubview:imageView];
        [array addObject:imageView];
    }
    
    self.profileImageArray = [NSArray arrayWithArray:array];
}

#pragma mark LikeButton

- (IBAction)likeButton:(id)sender {
    [self.delegate thumbnailCellTapLikes:self];
    
    self.likeButton.enabled = NO;


    // ハートを表示にする
    self.heartImageView.alpha = 1.0f;

}

#pragma mark Public Cell Method
- (void)setUserData:(TLBAccount *)account {
    // ユーザ情報を保持
    self.userInfo = account;
    
    // ログインステータスを反映
    [self userLoginStatus:account];
    
    // プロフィールイメージを反映
    //[self userProfileImageView:];
    
    // イイネを送っている場合、ボタンを無効化する
    //self.likeButton.enabled = !account.sendLikes;
    
    // データセット
    //self.initialLabel.text = account.nickname;
    
   // self.ageLablel.text = @"Hoge";
    
    self.hometownLabel.text = @"Tokyo";
    
  
    self.likeNumLabel.text = @"999";
   
    
    self.heightLabel.text = @"";
    self.weightLabel.text = @"";
    self.jobLabel.text = @"Programer";
    
    
    /**
     * 年収表示
     * ここだけ特別仕様
     * データ的には「〇〇万以上〜〇〇万未満」となっているが、「〇〇〜〇〇万円」とする
     */

    self.annualIncomeLalbel.text = @"1000";
    [self.annualIncomeLalbel sizeToFit];
    
    
    self.introductionLabel.text = @"1234";
    
    //[self userProfileNewImage:[account.isNewFlg boolValue]];
    
    // ハートを非表示にする
    self.heartImageView.alpha = 0.0f;

    // レイアウト設定
    // 右の位置は変えない
//    CGFloat beforeRight = self.jobLabel.right;
//    [self.jobLabel sizeToFit];
//    self.jobLabel.right = beforeRight;
//    self.jobTitlelabel.right = self.jobLabel.left + 1;
    
}

- (void)userProfileImageView:(NSArray *)imageArray {
    
    self.pageControl.numberOfPages = imageArray.count;
    
    // 1ページのフレームサイズ
	self.pageScrollView.contentSize =
	CGSizeMake((self.pageScrollView.frame.size.width * imageArray.count),self.pageScrollView.frame.size.height);

    for(int i = 0; i < self.profileImageArray.count; i++) {
        UIImageView *imageView = self.profileImageArray[i];
        if (imageArray.count > i) {
//            TLBAccountImage *imageModel = imageArray[i];
//            [imageView setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:nil];
        }
        else {
            imageView.image = nil;
        }
	}
}

- (void)userProfileNewImage:(BOOL)newImageFlag {
    // プロフィール画像のNewマークをYESなら消す
    self.userProfileNewImageView.hidden = !newImageFlag;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 現在のページ番号を調べる
	CGFloat pageWidth = self.pageScrollView.frame.size.width;
	int pageNo = floor((self.pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = pageNo;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    // スクロールビューはコンテンツの上部にスクロールする必要がある場合
    return NO;
}

@end

