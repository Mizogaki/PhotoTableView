//
//  TLBViewController.m
//  Twincue
//
//  Created by Tanaka Hiroki on 2014/04/15.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import "TLBViewController.h"

#import "TLBNavigationController.h"

@interface TLBViewController ()

@end

@implementation TLBViewController

#pragma mark - Public Method
- (void)setNavigationBarColor:(UIColor *)color animated:(BOOL)animated {
    // ナビゲーションバーの色を設定
    if ([TLBTwincueUtil isiOS7]) {
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
        self.navigationController.navigationBar.tintColor = color;
    }
    
    // ステータスバー対応
    if ([TLBTwincueUtil isiOS7] &&
        [self.navigationController isKindOfClass:[TLBNavigationController class]]) {
        TLBNavigationController *naviCon = (TLBNavigationController *)self.navigationController;
        [naviCon setStatusBarColor:color animated:animated];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ナビゲーションバーの色
    [self setNavigationBarColor:THEME_COLOR_2 animated:YES];
    
    // ヘッダーイメージを設定
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header"]];
    [headerImageView sizeToFit];
    self.navigationItem.titleView = headerImageView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // タイトルの文字色を再設定するため
    if (self.title.length > 0) {
        self.title = self.title;
    }
}

#pragma mark - OverRide
- (void)setTitle:(NSString *)title {
    // ヘッダーに既にラベルをセットしている場合は再利用
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
        titleLabel.text = title;
        titleLabel.textColor = [self titleColor];
        CGPoint center = titleLabel.center;
        [titleLabel sizeToFit];
        titleLabel.center = center;
    }
    else {
        // タイトルを設定
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [TLBTwincueUtil fontWithSize:TLBFontSizeL isBold:YES];
        [titleLabel sizeToFit];
        titleLabel.textColor = [self titleColor];
        self.navigationItem.titleView = titleLabel;
    }
    
    [super setTitle:title];
}

#pragma mark - IBAction PopView
/**
 * StoryBoard上で戻るボタンを設置した際に、Actionを繋げられるように親クラスで定義
 */
- (IBAction)popviewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Method
/**
 * タイトルの文字色を返します
 */
- (UIColor *)titleColor {
    UIColor *navigationBarColor = nil;
    if ([TLBTwincueUtil isiOS7]) {
        navigationBarColor = self.navigationController.navigationBar.barTintColor;
    }
    else {
        navigationBarColor = self.navigationController.navigationBar.tintColor;
    }
    
    if ([navigationBarColor isEqual:THEME_COLOR_1]) {
        return THEME_COLOR_2;
    }
    else if ([navigationBarColor isEqual:THEME_COLOR_2]) {
        return TEXT_COLOR_1;
    }
    else {
        return nil;
    }
}

@end
