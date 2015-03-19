//
//  TLBSearchListBaseViewController.h
//  Twincue
//
//  Created by Sasho on 2014/07/29.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import "TLBViewController.h"

@class TLBAccount;

@interface TLBSearchListBaseViewController : TLBViewController

/**
 * ページング用のブロックです
 */
@property (nonatomic, copy) void(^pagingBlock)();

/**
 * pullRefresh用のブロックです
 */
@property (nonatomic,copy) void(^pullRefreshBlock)();

/**
 * いいね！を押された時のブロックです
 */
@property (nonatomic,copy) void(^tapLikesBlock)(TLBAccount *account);

/**
 * cellをタップされた時のブロックです
 */
@property (nonatomic,copy) void(^tapDetailBlock)(TLBAccount *account);

/**
 * データをセットします
 * @param dataArray ユーザ情報の配列
 * @param page 取得したページ
 * @param maxCount APIから帰ってきた最大件数
 */
- (void)setData:(NSArray *)dataArray page:(NSInteger)page maxCount:(NSInteger)maxCount;

/**
 * 最大件数を返します
 */
- (NSInteger )maxCount;

/**
 * データソースを返します
 */
- (NSArray *)datasource;

/**
 * 現在表示されているアカウントまでスクロールさせる
 * __異性詳細との動機を取るためのメソッド__
 */
- (void)scrollAccount:(TLBAccount *)account;

/**
 * ページングが有効か否かを返します
 */
- (BOOL)isPagingEnabled;

@end
