//
//  TableViewCell.m
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "TableViewCell.h"
#import "OnlyPageView.h"
#import <QuartzCore/QuartzCore.h>

#define USER_DATA_INITIAL @"initial"
#define USER_DATA_AGE @"age"
#define USER_DATA_INTRODUSTION @"introduction"
#define USER_DATA_IMAGES @"userImages"


@interface TableViewCell()<UIScrollViewDelegate>

@end

@implementation TableViewCell


- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if (!self) {
        self.cellFlag = NO;
        return nil;
    }
    
    return self;
}


@end

