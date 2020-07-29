//
//  QDNavigationController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDNavigationController.h"

@interface QDNavigationController ()

@end

@implementation QDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.qmui_backgroundView.tag = 1024;
}

@end
