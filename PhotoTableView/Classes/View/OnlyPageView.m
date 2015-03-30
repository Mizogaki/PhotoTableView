//
//  OnlyPageView.m
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//


#import "OnlyPageView.h"


@implementation OnlyPageView

 -(id)initWithImageName:(NSString *)imageName frame:(CGRect)pageFrame{
     
	self = [self initWithFrame:pageFrame];
	CGRect imageFrame = CGRectMake(0, 0, pageFrame.size.width, pageFrame.size.height);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
	imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
	return self;
}

@end
