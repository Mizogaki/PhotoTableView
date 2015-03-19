//
//  TLBSelectValueViewController.m
//  Twincue
//
//  Created by mizogaki masahito on 7/29/14.
//  Copyright (c) 2014 teamLab Inc. All rights reserved.
//

#import "TLBSelectValueViewController.h"


@interface TLBSelectValueViewController ()

@end

@implementation TLBSelectValueViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Method
- (void)selectData:(NSDictionary *)selectData {
    _selectData = selectData;
    
    self.title = self.selectData[KEY_ACCOUNTS_ITEM_NAME];
}

@end
