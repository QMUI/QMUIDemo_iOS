//
//  QDTableViewCellInsetsViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellInsetsViewController.h"

@implementation QDTableViewCellInsetsViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"普通 cell";
    } else if (section == 1) {
        return @"使用 imageEdgeInsets";
    } else if (section == 2) {
        return @"使用 textLabelEdgeInsets";
    } else if (section == 3) {
        return @"使用 detailTextLabelEdgeInsets";
    } else if (section == 4) {
        return @"使用 accessoryEdgeInsets";
    }
    return nil;
}

- (UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.imageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(16, 16) lineWidth:2 tintColor:[QDCommonUI randomThemeColor]];
        cell.textLabel.text = NSStringFromClass([QMUITableViewCell class]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [self qmui_tableView:tableView cellWithIdentifier:@"cell"];
    
    // reset
    cell.imageEdgeInsets = UIEdgeInsetsZero;
    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = nil;
    } else if (indexPath.section == 1) {
        cell.detailTextLabel.text = @"imageEdgeInsets";
        cell.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    } else if (indexPath.section == 2) {
        cell.detailTextLabel.text = @"textLabelEdgeInsets";
        cell.textLabelEdgeInsets = UIEdgeInsetsMake(-6, 30, 0, 0);
    } else if (indexPath.section == 3) {
        cell.detailTextLabel.text = @"detailTextLabelEdgeInsets";
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(6, 30, 0, 0);
    } else if (indexPath.section == 4) {
        cell.detailTextLabel.text = @"accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets";
        cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewCellNormalHeight + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
