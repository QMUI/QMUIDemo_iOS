//
//  QDUIViewQMUIViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDUIViewQMUIViewController.h"
#import "QDUIViewBorderViewController.h"
#import "QDUIViewDebugViewController.h"
#import "QDUIViewLayoutViewController.h"

@interface QDUIViewQMUIViewController ()

@property(nonatomic, strong) UIScrollView *contentScrollView;

@property(nonatomic, strong) UILabel *descriptionLabel1;
@property(nonatomic, strong) UILabel *descriptionLabel2;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *contentLabel1;
@property(nonatomic, strong) UILabel *contentLabel2;
@property(nonatomic, strong) UILabel *contentLabel3;

@end

@implementation QDUIViewQMUIViewController

- (void)initDataSource {
    self.dataSource = @[@"UIView (QMUI_Border)",
                        @"UIView (QMUI_Debug)",
                        @"UIView (QMUI_Layout)"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"UIView (QMUI_Border)"]) {
        viewController = [[QDUIViewBorderViewController alloc] init];
    } else if ([title isEqualToString:@"UIView (QMUI_Debug)"]) {
        viewController = [[QDUIViewDebugViewController alloc] init];
    } else if ([title isEqualToString:@"UIView (QMUI_Layout)"]) {
        viewController = [[QDUIViewLayoutViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
