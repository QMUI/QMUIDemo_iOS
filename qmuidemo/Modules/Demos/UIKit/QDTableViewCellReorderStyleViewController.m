//
//  QDTableViewCellReorderStyleViewController.m
//  qmuidemo
//
//  Created by molice on 2022/12/8.
//  Copyright © 2022 QMUI Team. All rights reserved.
//

#import "QDTableViewCellReorderStyleViewController.h"

@interface QDTableViewCellReorderStyleViewController ()

@end

@implementation QDTableViewCellReorderStyleViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.editing = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell qmui_styledAsQMUITableViewCell];
        cell.qmui_configureReorderingStyleBlock = ^(__kindof UITableView * _Nonnull tableView, __kindof UITableViewCell * _Nonnull aCell, BOOL isReordering) {
            aCell.layer.qmui_shadow = isReordering ? [NSShadow qmui_shadowWithColor:[UIColorRed colorWithAlphaComponent:.3] shadowOffset:CGSizeMake(0, 4) shadowRadius:12] : nil;
        };
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section%@-row%@", @(indexPath.section), @(indexPath.row)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewCellNormalHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"section%@", @(section)];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

@end
