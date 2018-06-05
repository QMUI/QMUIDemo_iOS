//
//  QDCommonGroupListViewController.m
//  qmuidemo
//
//  Created by 李浩成 on 2016/10/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonGroupListViewController.h"

@implementation QDCommonGroupListViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];
    [self initDataSource];
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self orderedDictionaryInSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierNormal = @"cellNormal";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNormal];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierNormal];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *keyName = [self keyNameAtIndexPath:indexPath];
    cell.textLabel.text = keyName;
    cell.detailTextLabel.text = (NSString *)[[self orderedDictionaryInSection:indexPath.section] objectForKey:keyName];
    
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(13);
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = [self keyNameAtIndexPath:indexPath];
    [self didSelectCellWithTitle:keyName];
    [self.tableView qmui_clearsSelection];
}

#pragma mark - DataSource

- (NSString *)titleForSection:(NSInteger)section {
    return [[self.dataSource allKeys] objectAtIndex:section];
}

- (QMUIOrderedDictionary *)orderedDictionaryInSection:(NSInteger)section {
    return [self.dataSource objectForKey:[self titleForSection:section]];
}

- (NSString *)keyNameAtIndexPath:(NSIndexPath *)indexPath {
    return [[self orderedDictionaryInSection:indexPath.section] allKeys][indexPath.row];
}

@end


@implementation QDCommonGroupListViewController (UISubclassingHooks)

- (void)initDataSource {
}

- (void)didSelectCellWithTitle:(NSString *)title {
}

@end
