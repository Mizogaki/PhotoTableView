//
//  ChangeSubViewController.m
//  PhotoTableView
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "ChangeSubViewController.h"
#import "SmallCollectionViewCell.h"
#import "LageCollectionViewCell.h"

#define LAGE_COLLECTION_CELL_WIDTH 294
#define LAGE_COLLECTION_CELL_HIGHT 350
#define MINI_COLLECTION_CELL_WIDTH 140
#define MINI_COLLECTION_CELL_HIGHT 165
#define COLLECTIONVIEW_INDEX 11


@interface ChangeSubViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChangeSubViewController

- (void)viewWillLayoutSubviews {
 
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 33;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = nil;
    if((indexPath.row + 1) % COLLECTIONVIEW_INDEX == 0){
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LageCollectionViewCell class]) forIndexPath:indexPath];
    }else{
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SmallCollectionViewCell class]) forIndexPath:indexPath];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if((indexPath.row + 1) % COLLECTIONVIEW_INDEX == 0){
        return CGSizeMake(LAGE_COLLECTION_CELL_WIDTH, LAGE_COLLECTION_CELL_HIGHT);
    }
    return CGSizeMake(MINI_COLLECTION_CELL_WIDTH, MINI_COLLECTION_CELL_HIGHT);
}

@end

