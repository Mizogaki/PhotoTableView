//
//  TLBNavigationController.m
//  Twincue
//
//  Created by user01 on 2014/08/20.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import "TLBNavigationController.h"

@interface TLBNavigationController ()

@property (nonatomic,strong) UIView *statusBackgroundView;

@end

@implementation TLBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ステータスバー対応
    if ([TLBTwincueUtil isiOS7]) {
        // ステータスバーの下にViewをしいて、背景色を設定できるようにする
        self.statusBackgroundView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        [self.view addSubview:self.statusBackgroundView];
        self.statusBackgroundView.backgroundColor = THEME_COLOR_1;
    }
}

#pragma mark - Public Method
- (void)setStatusBarColor:(UIColor *)color animated:(BOOL)animated {
    [self.view bringSubviewToFront:self.statusBackgroundView];
    
    if (animated) {
        // フェードアニメーション
        UIView *beforeView = [[UIView alloc] initWithFrame:self.statusBackgroundView.frame];
        beforeView.backgroundColor = self.statusBackgroundView.backgroundColor;
        [self.view addSubview:beforeView];
        self.statusBackgroundView.backgroundColor = color;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             beforeView.alpha = 0;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [beforeView removeFromSuperview];
                             }
                         }];
    }
    else {
        self.statusBackgroundView.backgroundColor = color;
    }
    
}

@end
