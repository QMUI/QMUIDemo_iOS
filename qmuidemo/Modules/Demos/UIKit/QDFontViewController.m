//
//  QDFontViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/29.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDFontViewController.h"

@implementation QDFontViewController

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"默认", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                               @"UIFontMake", @"默认字重",
                               @"UIFontLightMake", @"系统细体",
                               @"UIFontMediumMake", @"系统加粗",
                               @"UIFontBoldMake", @"系统加粗更粗",
                               nil],
                       @"斜体", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                               @"Regular-Italic", @"",
                               @"Light-Italic", @"",
                               @"Medium-Italic", @"",
                               @"Bold-Italic", @"",
                               nil],
                       @"动态字体", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                 @"UIDynamicFontMake", @"",
                                 @"UIDynamicFontLightMake", @"",
                                 @"UIDynamicFontMediumMake", @"",
                                 @"UIDynamicFontBoldMake", @"",
                                 nil],
                       nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"UIFont+QMUI";
}

- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {
    [super contentSizeCategoryDidChanged:notification];
    // QMUICommonTableViewController 默认会在这个方法里响应动态字体大小变化，并自动调用 [self.tableView reloadData]，所以使用者只需要保证在 cellForRow 里更新动态字体大小即可，不需要手动监听动态字体的变化。
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *keyName = [self keyNameAtIndexPath:indexPath];
    UIFont *font = nil;
    CGFloat pointSize = 15;
    if ([keyName isEqualToString:@"UIFontMake"]) {
        // 普通
        font = UIFontMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontBoldMake"]) {
        // 加粗
        font = UIFontBoldMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontLightMake"]) {
        // 细体
        font = UIFontLightMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontMediumMake"]) {
        // 中档加粗
        font = UIFontMediumMake(pointSize);
    } else if ([keyName isEqualToString:@"Regular-Italic"]) {
        // 普通斜体
        font = UIFontItalicMake(pointSize);
    } else if ([keyName isEqualToString:@"Bold-Italic"]) {
        // 更加粗斜体
        font = [UIFont qmui_systemFontOfSize:pointSize weight:QMUIFontWeightBold italic:YES];
    } else if ([keyName isEqualToString:@"Light-Italic"]) {
        // 细斜体
        font = [UIFont qmui_systemFontOfSize:pointSize weight:QMUIFontWeightLight italic:YES];
    } else if ([keyName isEqualToString:@"Medium-Italic"]) {
        // 加粗斜体
        font = [UIFont qmui_systemFontOfSize:pointSize weight:QMUIFontWeightMedium italic:YES];
    } else if ([keyName isEqualToString:@"UIDynamicFontMake"]) {
        // 普通动态字体
        font = UIDynamicFontMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontBoldMake"]) {
        // 更加粗动态字体
        font = UIDynamicFontBoldMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontLightMake"]) {
        // 细动态字体
        font = UIDynamicFontLightMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontMediumMake"]) {
        // 加粗动态字体
        font = UIDynamicFontMediumMake(pointSize);
    }
    cell.textLabel.font = font;
    cell.detailTextLabel.font = font;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        NSString *path = IS_SIMULATOR ? @"模拟器-设置-辅助功能-显示与文字大小-更大字体" : @"设置-显示与亮度-文字大小";
        return [NSString stringWithFormat:@"请到“%@”里修改文字大小再观察当前界面的变化", path];
    }
    return nil;
}

@end
