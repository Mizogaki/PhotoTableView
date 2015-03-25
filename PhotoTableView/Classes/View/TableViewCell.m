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


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableArray *imageArray = [@[@"Untitled 18",
                                    @"Untitled 17",
                                    @"Untitled 18",
                                    @"Untitled 17",
                                    @"Untitled 18",
                                    @"Untitled 17"] mutableCopy];
    
    
    self.dummyUserDataDictionary = @{USER_DATA_INITIAL:@"UNITY-CHAN!",
                                     USER_DATA_AGE:@"??",
                                     USER_DATA_INTRODUSTION:@"Sample Sample Sample Sample",
                                     USER_DATA_IMAGES:imageArray,
                                     };
    
    self.pageControl.numberOfPages = imageArray.count;
    self.initialLabel.text  = self.dummyUserDataDictionary[USER_DATA_INITIAL];
    self.ageLable.text      = self.dummyUserDataDictionary[USER_DATA_AGE];
    self.introductionLabel.text = self.dummyUserDataDictionary[USER_DATA_INTRODUSTION];
    
    [self userProfileImageView:self.dummyUserDataDictionary[USER_DATA_IMAGES]];
}


- (void)userProfileImageView:(NSMutableArray*)imageArray{
    
    self.pageScrollView.contentSize =
    CGSizeMake((self.pageScrollView.frame.size.width * imageArray.count),self.pageScrollView.frame.size.height);
    
    for(int i = 0; i < imageArray.count; i++) {
        
        NSString *pageImageName = imageArray[i];
        
        CGRect pageFrame = CGRectMake((self.pageScrollView.frame.size.width * i),
                                      0,
                                      self.pageScrollView.frame.size.width,
                                      self.pageScrollView.frame.size.height);
        
        // TLBOnlyViewPageクラスで１ページ分のコンテンツを作る
        OnlyPageView *ovp = [[OnlyPageView alloc]initWithImageName:pageImageName
                                                             frame:pageFrame];
        [self.pageScrollView addSubview:ovp];
    }
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

