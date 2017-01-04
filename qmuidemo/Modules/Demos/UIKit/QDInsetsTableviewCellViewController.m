//
//  QDInsetsTableviewCellViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDInsetsTableviewCellViewController.h"

@implementation QDInsetsTableviewCellViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"普通cell";
    } else if (section == 1) {
        return @"使用imageEdgeInsets";
    } else if (section == 2) {
        return @"使用textLabelEdgeInsets";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifierNormal = @"cellNormal";
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNormal];
        if (!cell) {
            cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifierNormal];
        }
        cell.imageView.image = [UIImage qmui_imageWithStrokeColor:UIColorRed size:CGSizeMake(16, 16) lineWidth:2 cornerRadius:8];
        cell.textLabel.text = @"QMUITableViewCell";
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [cell updateCellAppearanceWithIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *identifierImageInsets = @"cellImageInsets";
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierImageInsets];
        if (!cell) {
            cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifierImageInsets];
        }
        cell.imageView.image = [UIImage qmui_imageWithStrokeColor:UIColorBlue size:CGSizeMake(16, 16) lineWidth:2 cornerRadius:8];
        cell.textLabel.text = @"QMUITableViewCell";
        cell.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [cell updateCellAppearanceWithIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *identifierTitleLabelInsets = @"cellTitleLabelInsets";
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTitleLabelInsets];
        if (!cell) {
            cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifierTitleLabelInsets];
        }
        cell.imageView.image = [UIImage qmui_imageWithStrokeColor:UIColorGreen size:CGSizeMake(16, 16) lineWidth:2 cornerRadius:8];
        cell.textLabel.text = @"QMUITableViewCell";
        cell.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [cell updateCellAppearanceWithIndexPath:indexPath];
        return cell;
    }
    return nil;
}

@end
