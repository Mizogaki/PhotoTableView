//
//  TLBSearchListBaseViewController.m
//  Twincue
//
//  Created by Sasho on 2014/07/29.
//  Copyright (c) 2014年 teamLab Inc. All rights reserved.
//

#import "TLBSearchListBaseViewController.h"

@interface TLBSearchListBaseViewController ()

@end

@implementation TLBSearchListBaseViewController

// サブクラスでいろいろゴニョるので、なにもしない（まず呼ばれない想定）
- (void)setData:(NSArray *)dataArray page:(NSInteger)page maxCount:(NSInteger)maxCount {
    
}

- (NSInteger )maxCount {
    return 0;
}

- (NSArray *)datasource {
    return nil;
}

- (void)scrollAccount:(TLBAccount *)account {
    
}

- (BOOL)isPagingEnabled {
    return NO;
}

@end
