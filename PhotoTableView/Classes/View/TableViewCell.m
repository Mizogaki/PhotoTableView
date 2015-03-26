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
        return nil;
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.pageScrollView.frame.size.width;
    int pageNo = floor((self.pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNo;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    
    return NO;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}

- (void)prepareForReuse{
    
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state{
    
    [super didTransitionToState:state];
}

@end

