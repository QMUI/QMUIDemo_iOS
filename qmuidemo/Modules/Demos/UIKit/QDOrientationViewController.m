//
//  QDOrientationViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/6/23.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDOrientationViewController.h"

const NSInteger kIdentifierForDoneCell = 999;

@interface QDOrientationViewController ()

@property(nonatomic, strong) QMUILabel *orientationLabel;
@end

@implementation QDOrientationViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[
  // section 0
  @[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = UIInterfaceOrientationMaskPortrait;
        d.text = @"UIInterfaceOrientationMaskPortrait";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkEvent:);
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
        d;
    }),
    ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = UIInterfaceOrientationMaskLandscapeLeft;
        d.text = @"UIInterfaceOrientationMaskLandscapeLeft";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkEvent:);
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
        d;
    }),
    ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = UIInterfaceOrientationMaskLandscapeRight;
        d.text = @"UIInterfaceOrientationMaskLandscapeRight";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkEvent:);
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
        d;
    }),
    ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = UIInterfaceOrientationMaskPortraitUpsideDown;
        d.text = @"UIInterfaceOrientationMaskPortraitUpsideDown";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkEvent:);
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
        d;
    })],
  
  // section 1
  @[
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = kIdentifierForDoneCell;
        d.text = @"完成方向选择，进入该界面";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleDoneCellEvent:);
        d;
    })]]];
    
    self.orientationLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray7];
    self.orientationLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前界面支持的方向：\n%@", [self descriptionStringWithOrientationMask:self.supportedOrientationMask]] attributes:@{NSFontAttributeName: UIFontMake(14), NSForegroundColorAttributeName: UIColorGray7, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    self.orientationLabel.numberOfLines = 2;
    self.orientationLabel.contentEdgeInsets = UIEdgeInsetsMake(24, 24, 24, 24);
    [self.orientationLabel sizeToFit];
    self.tableView.tableFooterView = self.orientationLabel;
}

#pragma mark - <QMUITableViewDataSource,  QMUITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    QMUIStaticTableViewCellData *cellData = [tableView.qmui_staticCellDataSource cellDataAtIndexPath:indexPath];
    if (cellData.identifier == kIdentifierForDoneCell) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"请为下一个界面选择支持的设备方向";
    }
    return nil;
}

#pragma mark - Event

- (void)handleCheckmarkEvent:(QMUIStaticTableViewCellData *)cellData {
    QMUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellData.indexPath];
    if (cellData.accessoryType == QMUIStaticTableViewCellAccessoryTypeCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
    }
    [self.tableView deselectRowAtIndexPath:cellData.indexPath animated:YES];
}

- (void)handleDoneCellEvent:(QMUIStaticTableViewCellData *)cellData {
    UIInterfaceOrientationMask mask = 0;
    for (QMUIStaticTableViewCellData *cellData in self.tableView.qmui_staticCellDataSource.cellDataSections.firstObject) {
        if (cellData.accessoryType == QMUIStaticTableViewCellAccessoryTypeCheckmark) {
            mask |= cellData.identifier;
        }
    }
    
    QDOrientationViewController *viewController = [[QDOrientationViewController alloc] init];
    
    // QMUICommonViewController 提供属性 supportedOrientationMask 用于控制界面所支持的显示方向，在 UIViewController (QMUI) 里会自动根据下一个要显示的界面去旋转设备的方向
    viewController.supportedOrientationMask = mask;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Tools

- (NSString *)descriptionStringWithOrientationMask:(UIInterfaceOrientationMask)mask {
    NSMutableString *string = [[NSMutableString alloc] init];
    if ((mask & UIInterfaceOrientationMaskPortrait) == UIInterfaceOrientationMaskPortrait) {
        [string appendString:@"Portrait"];
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeLeft) == UIInterfaceOrientationMaskLandscapeLeft) {
        if (string.length > 0) [string appendString:@" | "];
        [string appendString:@"Left"];
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeRight) == UIInterfaceOrientationMaskLandscapeRight) {
        if (string.length > 0) [string appendString:@" | "];
        [string appendString:@"Right"];
    }
    if ((mask & UIInterfaceOrientationMaskPortraitUpsideDown) == UIInterfaceOrientationMaskPortraitUpsideDown) {
        if (string.length > 0) [string appendString:@" | "];
        [string appendString:@"PortraitUpsideDown"];
    }
    return [string copy];
}

@end
