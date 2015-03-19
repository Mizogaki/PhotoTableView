//
//  TLBViewController.h
//  Twincue
//
//  Created by Tanaka Hiroki on 2014/04/15.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBViewController : UIViewController

@property (nonatomic,weak) id delegate;

/**
 * ナビゲーションバーの色を設定します
 * @param color ナビゲーションバーの色
 * @param animated ステータスバーの色をセットする際のアニメーションフラグ
 */
- (void)setNavigationBarColor:(UIColor *)color animated:(BOOL)animated;

@end

@protocol TLBViewControllerDelegate <NSObject>

- (void)setProfile;

@end
