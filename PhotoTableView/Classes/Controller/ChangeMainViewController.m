//
//  ChangeMainViewController.m
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "ChangeMainViewController.h"
#import "OnlyPageView.h"
#import "TableViewCell.h"

#define USER_DATA_INITIAL @"initial"
#define USER_DATA_AGE @"age"
#define USER_DATA_INTRODUSTION @"introduction"
#define USER_DATA_IMAGES @"userImages"


@interface ChangeMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *onlyTableView;

@end

@implementation ChangeMainViewController

- (void)viewWillLayoutSubviews {
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    TableViewCell *customCell = [self.onlyTableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    
    NSMutableArray *imageArray = [@[@"Untitled 18",@"Untitled 17",@"Untitled 18",
                                    @"Untitled 17",@"Untitled 18",@"Untitled 17",
                                    @"Untitled 18",@"Untitled 17",@"Untitled 18",] mutableCopy];
    
    
    NSDictionary* dummyUserDataDictionary = @{USER_DATA_INITIAL:@"UNITY-CHAN!",
                                              USER_DATA_AGE:@"??",
                                              USER_DATA_INTRODUSTION:@"Sample Sample Sample",
                                              USER_DATA_IMAGES:imageArray,
                                              };
    customCell.initialLabel.text = dummyUserDataDictionary[USER_DATA_INITIAL];
    customCell.ageLable.text = dummyUserDataDictionary[USER_DATA_AGE];
    customCell.introductionLabel.text = dummyUserDataDictionary[USER_DATA_INTRODUSTION];
    customCell.pageScrollView.contentSize =
    CGSizeMake((customCell.pageScrollView.frame.size.width * imageArray.count),customCell.pageScrollView.frame.size.height);
    
    if (customCell.cellFlag == NO){
        for(int i = 0; i < imageArray.count; i++) {
            
            NSString *pageImageName = imageArray[i];
            CGRect pageFrame = CGRectMake((([UIScreen mainScreen].bounds.size.width - 36) * i),
                                          0,
                                          ([UIScreen mainScreen].bounds.size.width - 36),
                                          customCell.pageScrollView.frame.size.height);
            
            OnlyPageView *ovp = [[OnlyPageView alloc]initWithImageName:pageImageName
                                                                 frame:pageFrame];
            [customCell.pageScrollView addSubview:ovp];
        }
        customCell.cellFlag = YES;
    }
    cell = customCell;
    return cell;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 487;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
