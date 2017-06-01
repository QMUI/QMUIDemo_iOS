//
//  QDFontViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/5/29.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDFontViewController.h"

@implementation QDFontViewController

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"默认", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                               @"UIFontMake", @"",
                               @"UIFontItalicMake", @"",
                               @"UIFontBoldMake", @"",
                               @"UIFontLightMake", @"",
                               nil],
                       @"动态字体", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                 @"UIDynamicFontMake", @"",
                                 @"UIDynamicFontBoldMake", @"",
                                 @"UIDynamicFontLightMake", @"",
                                 nil],
                       nil];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
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
        font = UIFontMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontItalicMake"]) {
        font = UIFontItalicMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontBoldMake"]) {
        font = UIFontBoldMake(pointSize);
    } else if ([keyName isEqualToString:@"UIFontLightMake"]) {
        font = UIFontLightMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontMake"]) {
        font = UIDynamicFontMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontBoldMake"]) {
        font = UIDynamicFontBoldMake(pointSize);
    } else if ([keyName isEqualToString:@"UIDynamicFontLightMake"]) {
        font = UIDynamicFontLightMake(pointSize);
    }
    cell.textLabel.font = font;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        NSString *path = IS_SIMULATOR ? @"设置-通用-辅助功能-Larger Text" : @"设置-显示与亮度-文字大小";
        return [NSString stringWithFormat:@"请到“%@”里修改文字大小再观察当前界面的变化", path];
    }
    return nil;
}

@end
