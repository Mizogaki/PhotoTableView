//
//  TableViewCell.h
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UILabel *initialLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (assign,nonatomic) BOOL cellFlag;



@end
