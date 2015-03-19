//
//  TLBOnlyViewPage.h
//  Twincue
//
//  Created by mizogaki masahito on 7/8/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBOnlyPageView:UIView

#pragma mark - Setting OnlyView Page
/**
 @param:imageName イメージファイル名
 @Param:pageFrame ページサイズ
 */
-(id)initWithImageName:(NSString *)imageName frame:(CGRect)pageFrame;

@end
