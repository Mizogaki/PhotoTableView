//
//  LageCollectionViewCell.h
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LageCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *initialLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;

@end
