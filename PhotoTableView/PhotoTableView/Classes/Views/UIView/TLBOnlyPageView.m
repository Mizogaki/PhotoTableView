//
//  TLBOnlyViewPage.m
//  Twincue
//
//  Created by mizogaki masahito on 7/8/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//


#import "TLBOnlyPageView.h"


@implementation TLBOnlyPageView


#pragma mark - Init Page

 -(id)initWithImageName:(NSString *)imageName frame:(CGRect)pageFrame{
	self = [self initWithFrame:pageFrame];
	CGRect imageFrame = CGRectMake(0, 0, pageFrame.size.width, pageFrame.size.height);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
	imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
	return self;
}

@end
