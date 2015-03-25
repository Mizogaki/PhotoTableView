//
//  ViewController.m
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "ViewController.h"
#import "ChangeMainViewController.h"

@interface ViewController ()

@property BOOL containerViewFlag;

@property (weak, nonatomic) IBOutlet UIView	*subContainerView;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	self.containerViewFlag = NO;
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

- (IBAction)changeContainerView:(id)sender {
    
	if (self.containerViewFlag == YES) {
        
		self.subContainerView.hidden = YES;
		self.mainContainerView.hidden = NO;
		[self.view bringSubviewToFront:self.mainContainerView];
        self.containerViewFlag = NO;
	}else{
		self.subContainerView.hidden = NO;
		self.mainContainerView.hidden = YES;
		[self.view bringSubviewToFront:self.subContainerView];
		self.containerViewFlag = YES;
	}
}
@end
