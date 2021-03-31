//
//  QDCommonListViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/15.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonListViewController.h"

@implementation QDCommonListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self initDataSource];
    }
    return self;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceWithDetailText ? self.dataSourceWithDetailText.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    QMUITableViewCell *cell = nil;
    if (self.dataSourceWithDetailText) {
        identifier = @"subtitle";
    } else {
        identifier = @"normal";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if ([identifier isEqualToString:@"subtitle"]) {
            cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.detailTextLabel.numberOfLines = 0;
        } else {
            cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([identifier isEqualToString:@"subtitle"]) {
        NSString *keyName = self.dataSourceWithDetailText.allKeys[indexPath.row];
        cell.textLabel.text = keyName;
        cell.detailTextLabel.text = (NSString *)[self.dataSourceWithDetailText objectForKey:keyName];
    } else {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(13);
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceWithDetailText && ((NSString *)[self.dataSourceWithDetailText objectForKey:self.dataSourceWithDetailText.allKeys[indexPath.row]]).length) {
        return UITableViewAutomaticDimension;
    }
    return TableViewCellNormalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    if (self.dataSourceWithDetailText) {
        title = self.dataSourceWithDetailText.allKeys[indexPath.row];
    } else {
        title = [self.dataSource objectAtIndex:indexPath.row];
    }
    if (self.didSelectTitleBlock) {
        self.didSelectTitleBlock(title);
    }
    [self didSelectCellWithTitle:title];
}

@end

@implementation QDCommonListViewController (UISubclassingHooks)

- (void)initDataSource {
}

- (void)didSelectCellWithTitle:(NSString *)title {
}

@end
