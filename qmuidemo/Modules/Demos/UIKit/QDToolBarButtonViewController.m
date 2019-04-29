//
//  QDToolBarButtonViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/10/13.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDToolBarButtonViewController.h"

@interface QDToolBarButtonViewController ()

@end

@implementation QDToolBarButtonViewController

- (void)initDataSource {
    self.dataSource = @[@"普通工具栏按钮",
                        @"图标工具栏按钮"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    if ([title isEqualToString:@"普通工具栏按钮"]) {
        UIBarButtonItem *item1 = [QMUIToolbarButton barButtonItemWithType:QMUIToolbarButtonTypeNormal title:@"转发" target:self action:NULL];
        UIBarButtonItem *item2 = [QMUIToolbarButton barButtonItemWithType:QMUIToolbarButtonTypeNormal title:@"回复" target:self action:NULL];
        UIBarButtonItem *item3 = [QMUIToolbarButton barButtonItemWithType:QMUIToolbarButtonTypeRed title:@"删除" target:self action:NULL];
        self.toolbarItems = @[item1, flexibleItem, item2, flexibleItem, item3];
    } else if ([title isEqualToString:@"图标工具栏按钮"]) {
        UIImage *image1 = [UIImage qmui_imageWithStrokeColor:UIColorWhite size:CGSizeMake(18, 18) lineWidth:2 cornerRadius:4];
        UIImage *image2 = [UIImage qmui_imageWithStrokeColor:UIColorWhite size:CGSizeMake(18, 18) lineWidth:2 cornerRadius:4];
        UIImage *image3 = [UIImage qmui_imageWithStrokeColor:UIColorWhite size:CGSizeMake(18, 18) lineWidth:2 cornerRadius:4];
        // item有默认的tintColor，不受图片颜色的影响。如果需要自定义tintColor，需要设置item的titnColor属性
        UIBarButtonItem *item1 = [QMUIToolbarButton barButtonItemWithImage:image1 target:self action:NULL];
        UIBarButtonItem *item2 = [QMUIToolbarButton barButtonItemWithImage:image2 target:self action:NULL];
        item2.tintColor = UIColorTheme2;
        UIBarButtonItem *item3 = [QMUIToolbarButton barButtonItemWithImage:image3 target:self action:NULL];
        item3.tintColor = UIColorTheme3;
        self.toolbarItems = @[item1, flexibleItem, item2, flexibleItem, item3];
    }
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.tableView qmui_clearsSelection];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

@end
