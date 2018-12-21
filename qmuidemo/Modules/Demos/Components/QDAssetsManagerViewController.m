//
//  QDAssetsManagerViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/9.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDAssetsManagerViewController.h"
#import "QDSaveImageToSpecifiedAlbumViewController.h"
#import "QDSaveVideoToSpecifiedAlbumViewController.h"

@interface QDAssetsManagerViewController ()

@end

@implementation QDAssetsManagerViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"保存图片到指定相册", @"生成随机图片并保存到指定的相册",
                                     @"保存视频到指定相册", @"拍摄一个视频并保存到指定的相册",
                                     nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    QMUICommonViewController *viewController;
    if ([title isEqualToString:@"保存图片到指定相册"]) {
        viewController = [[QDSaveImageToSpecifiedAlbumViewController alloc] init];
    } else if ([title isEqualToString:@"保存视频到指定相册"]) {
        viewController = [[QDSaveVideoToSpecifiedAlbumViewController alloc] init];
    }
    if (viewController) {
        viewController.title = title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
