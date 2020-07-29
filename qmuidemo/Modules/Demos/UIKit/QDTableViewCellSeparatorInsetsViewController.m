//
//  QDTableViewCellSeparatorInsetsViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/6/30.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDTableViewCellSeparatorInsetsViewController.h"

@implementation QDTableViewCellSeparatorInsetsViewController

#pragma mark - <QMUITableViewDelegate, QMUITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = UIFontMake(16);
        cell.textLabel.textColor = TableViewCellTitleLabelColor;
        cell.qmui_separatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull aTableView, __kindof UITableViewCell * _Nonnull aCell) {
            QMUITableViewCellPosition position = aCell.qmui_cellPosition;
            CGFloat defaultRight = 20;
            switch (aTableView.qmui_style) {
                case UITableViewStylePlain: {
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = CGRectGetMinX(frame);
                    CGFloat right = aCell.qmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.qmui_accessoryView.frame) : defaultRight;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
                case UITableViewStyleGrouped: {
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = (position & QMUITableViewCellPositionLastInSection) == QMUITableViewCellPositionLastInSection ? 0 : CGRectGetMinX(frame);
                    CGFloat right = aCell.qmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.qmui_accessoryView.frame) : defaultRight;
                    right = (position & QMUITableViewCellPositionLastInSection) == QMUITableViewCellPositionLastInSection ? 0 : right;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
                default: {
                    // InsetGrouped
                    if ((position & QMUITableViewCellPositionLastInSection) == QMUITableViewCellPositionLastInSection) {
                        return QMUITableViewCellSeparatorInsetsNone;
                    }
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = CGRectGetMinX(frame);
                    CGFloat right = aCell.qmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.qmui_accessoryView.frame) : defaultRight;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
            }
        };
        cell.qmui_topSeparatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull aTableView, __kindof UITableViewCell * _Nonnull aCell) {
            if (aTableView.qmui_style == UITableViewStyleGrouped && aCell.qmui_cellPosition & QMUITableViewCellPositionFirstInSection) {
                return UIEdgeInsetsZero;
            }
            return QMUITableViewCellSeparatorInsetsNone;
        };
    }
    
    NSString *text = nil;
    
    if (indexPath.section > 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        text = @"分隔线在 accessoryView 前截止";
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.imageView.image = [UIImage qmui_imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(30, 30) lineWidth:3 cornerRadius:6];
        text = @"分隔线在 imageView 之后开始";
    } else {
        cell.imageView.image = nil;
    }
    
    if (!text) {
        QMUITableViewCellPosition position = [tableView qmui_positionForRowAtIndexPath:indexPath];
        if ((position & QMUITableViewCellPositionSingleInSection) == QMUITableViewCellPositionSingleInSection) {
            text = @"section 单行的情况";
        } else if ((position & QMUITableViewCellPositionLastInSection) == QMUITableViewCellPositionLastInSection) {
            text = @"section 最后一行的情况";
        }
    }
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewCellNormalHeight;
}

@end
