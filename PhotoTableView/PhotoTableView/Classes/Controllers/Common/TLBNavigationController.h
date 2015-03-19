//
//  TLBNavigationController.h
//  Twincue
//
//  Created by user01 on 2014/08/20.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBNavigationController : UINavigationController

/**
 * ステータスバーの背景色を設定します
 * @param color 背景色
 * @param animated フェードアニメーションのありなし
 */
- (void)setStatusBarColor:(UIColor *)color animated:(BOOL)animated;

@end
