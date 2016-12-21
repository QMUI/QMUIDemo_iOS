//
//  QDCommonTableViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@interface QDCommonTableViewController ()

@end

@implementation QDCommonTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.supportedOrientationMask = UIInterfaceOrientationMaskAll;
    }
    return self;
}

@end
