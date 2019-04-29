//
//  QDTableViewCellAccessoryTypeViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/6/19.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellAccessoryTypeViewController.h"

@interface QDTableViewCellAccessoryTypeViewController ()

@property(nonatomic, copy) NSArray<NSString *> *dataSource;
@end

@implementation QDTableViewCellAccessoryTypeViewController

- (void)didInitialize {
    [super didInitialize];
    self.dataSource = @[@"UITableViewCellAccessoryNone",
                        @"UITableViewCellAccessoryDisclosureIndicator",
                        @"UITableViewCellAccessoryDetailDisclosureButton",
                        @"UITableViewCellAccessoryCheckmark",
                        @"UITableViewCellAccessoryDetailButton"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = (UITableViewCellAccessoryType)indexPath.row;
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [QMUITips showWithText:[NSString stringWithFormat:@"点击了第 %@ 行的按钮", @(indexPath.row)] inView:self.view hideAfterDelay:1.2];
}

@end
