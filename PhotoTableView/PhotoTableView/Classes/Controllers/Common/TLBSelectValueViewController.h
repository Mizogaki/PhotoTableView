//
//  TLBSelectValueViewController.h
//  Twincue
//
//  Created by mizogaki masahito on 7/29/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBViewController.h"
#import "TLBEnum.h"

@protocol TLBSelectValueViewControllerDelegate;

@interface TLBSelectValueViewController : TLBViewController

/** delegate */
@property (nonatomic, weak) id<TLBSelectValueViewControllerDelegate> delegate;
/** 選択されているデータのDictionary */
@property (nonatomic,readonly) NSDictionary *selectData;

/**
 * 現在選択されているデータをセットします
 */
- (void)selectData:(NSDictionary *)selectData;

@end

@protocol TLBSelectValueViewControllerDelegate <NSObject>
@required
/**
 * 選択した値を通知するdelgate
 * @param selectValue 選択した値
 * @param dictionary 選択される前の値
 */
- (void)selectValue:(id)selectValue beforeData:(NSDictionary *)dictionary;

@end
