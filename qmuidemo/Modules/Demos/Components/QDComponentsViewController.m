//
//  QDComponentsViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDComponentsViewController.h"
#import "QDNavigationTitleViewController.h"
#import "QDEmptyViewController.h"
#import "QDGridViewController.h"
#import "QDStaticTableViewController.h"
#import "QDImagePickerExampleViewController.h"
#import "QDMoreOperationViewController.h"
#import "QDAssetsManagerViewController.h"
#import "QDImagePreviewExampleViewController.h"
#import "QDEmotionsViewController.h"
#import "QDPieProgressViewController.h"
#import "QDPopupContainerViewController.h"
#import "QDModalPresentationViewController.h"
#import "QDDialogViewController.h"
#import "QDFloatLayoutViewController.h"
#import "QDAboutViewController.h"
#import "QDToastListViewController.h"
#import "QDKeyboardViewController.h"
#import "QDMarqueeLabelViewController.h"
#import "QDCellKeyCacheViewController.h"
#import "QDMultipleDelegatesViewController.h"
#import "QDBadgeViewController.h"
#import "QDScrollAnimatorViewController.h"
#import "QDConsoleViewController.h"
#import "QDCollectionListViewController.h"
#import "QDThemeViewController.h"

@implementation QDComponentsViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"Components";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleAboutItemEvent)];
    AddAccessibilityLabel(self.navigationItem.rightBarButtonItem, @"打开关于界面");
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"QMUIModalPresentationViewController", UIImageMake(@"icon_grid_modal"),
                       @"QMUIDialogViewController", UIImageMake(@"icon_grid_dialog"),
                       @"QMUIMoreOperationController", UIImageMake(@"icon_grid_moreOperation"),
                       @"QMUINavigationTitleView", UIImageMake(@"icon_grid_titleView"),
                       @"QMUIEmptyView", UIImageMake(@"icon_grid_emptyView"),
                       @"QMUIToastView", UIImageMake(@"icon_grid_toast"),
                       @"QMUIEmotionView", UIImageMake(@"icon_grid_emotionView"),
                       @"QMUIGridView", UIImageMake(@"icon_grid_gridView"),
                       @"QMUIFloatLayoutView", UIImageMake(@"icon_grid_floatView"),
                       @"QMUIStaticTableView", UIImageMake(@"icon_grid_staticTableView"),
                       @"QMUICellKeyCache", UIImageMake(@"icon_grid_cellKeyCache"),
                       @"QMUIPickingImage", UIImageMake(@"icon_grid_pickingImage"),
                       @"QMUIAssetsManager", UIImageMake(@"icon_grid_assetsManager"),
                       @"QMUIImagePreviewView", UIImageMake(@"icon_grid_previewImage"),
                       @"QMUIPieProgressView", UIImageMake(@"icon_grid_pieProgressView"),
                       @"QMUIPopupContainerView", UIImageMake(@"icon_grid_popupView"),
                       @"QMUIKeyboardManager", UIImageMake(@"icon_grid_keyboard"),
                       @"QMUIMarqueeLabel", UIImageMake(@"icon_grid_marquee"),
                       @"QMUIMultipleDelegates", UIImageMake(@"icon_grid_multipleDelegates"),
                       @"QMUIBadge", UIImageMake(@"icon_grid_badge"),
                       @"QMUIScrollAnimator", UIImageMake(@"icon_grid_scrollAnimator"),
                       @"QMUIConsole", UIImageMake(@"icon_grid_console"),
                       @"QMUICollectionViewLayout", UIImageMake(@"icon_grid_collection"),
                       @"QMUITheme", UIImageMake(@"icon_grid_theme"),
                       nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"QMUINavigationTitleView"]) {
        viewController = [[QDNavigationTitleViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIEmptyView"]) {
        viewController = [[QDEmptyViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIToastView"]) {
        viewController = [[QDToastListViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIStaticTableView"]) {
        viewController = [[QDStaticTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    else if ([title isEqualToString:@"QMUICellKeyCache"]) {
        viewController = [[QDCellKeyCacheViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIImagePreviewView"]) {
        viewController = [[QDImagePreviewExampleViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIPickingImage"]) {
        viewController = [[QDImagePickerExampleViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIAssetsManager"]) {
        viewController = [[QDAssetsManagerViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIMoreOperationController"]) {
        viewController = [[QDMoreOperationViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIEmotionView"]) {
        viewController = [[QDEmotionsViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIGridView"]) {
        viewController = [[QDGridViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIFloatLayoutView"]) {
        viewController = [[QDFloatLayoutViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIPieProgressView"]) {
        viewController = [[QDPieProgressViewController alloc] init];    
    }
    else if ([title isEqualToString:@"QMUIPopupContainerView"]) {
        viewController = [[QDPopupContainerViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIModalPresentationViewController"]) {
        viewController = [[QDModalPresentationViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    else if ([title isEqualToString:@"QMUIDialogViewController"]) {
        viewController = [[QDDialogViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIKeyboardManager"]) {
        viewController = [[QDKeyboardViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIMarqueeLabel"]) {
        viewController = [[QDMarqueeLabelViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIMultipleDelegates"]) {
        viewController = [[QDMultipleDelegatesViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIBadge"]) {
        viewController = [[QDBadgeViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIScrollAnimator"]) {
        viewController = [[QDScrollAnimatorViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIConsole"]) {
        viewController = [[QDConsoleViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUICollectionViewLayout"]) {
        viewController = [[QDCollectionListViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUITheme"]) {
        viewController = [[QDThemeViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleAboutItemEvent {
    QDAboutViewController *viewController = [[QDAboutViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
