//
//  QDOrientationViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/6/23.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDOrientationViewController.h"

const NSInteger kIdentifierForNextCell = 997;
const NSInteger kIdentifierForCurrentCell = 998;
const NSInteger kIdentifierForCurrentSwitchCell = 999;

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
        d.identifier = kIdentifierForNextCell;
        d.text = @"打开符合上述方向的新界面";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleNextCellEvent:);
        d.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            cell.textLabel.textColor = UIColor.qd_tintColor;
        };
        d;
    }),
        ],
        
        // section 2
        @[
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = kIdentifierForCurrentCell;
        d.text = @"将已选方向设置到当前界面";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCurrentCellEvent:);
        d.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            cell.textLabel.textColor = UIColor.qd_tintColor;
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = kIdentifierForCurrentSwitchCell;
        d.text = @"自动恢复为全方向以测试物理旋转";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        d.accessoryValueObject = @YES;
        d.accessorySwitchBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData, UISwitch * _Nonnull switcher) {
            cellData.accessoryValueObject = @(switcher.on);
        };
        d;
    }),
        ],
        ]];
    
    self.orientationLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColor.qd_descriptionTextColor];
    self.orientationLabel.numberOfLines = 2;
    self.orientationLabel.contentEdgeInsets = UIEdgeInsetsMake(24, 24, 24, 24);
    [self updateCurrentOrientationDescription];
    self.tableView.tableFooterView = self.orientationLabel;
}

- (void)updateCurrentOrientationDescription {
    self.orientationLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前界面支持的方向：\n%@", [self descriptionStringWithOrientationMask:self.supportedOrientationMask]] attributes:@{NSFontAttributeName: UIFontMake(14), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat oldHeight = self.orientationLabel.qmui_height;
    self.orientationLabel.frame = CGRectMake(CGRectGetMinX(self.orientationLabel.frame), CGRectGetMinY(self.orientationLabel.frame), CGRectGetWidth(self.tableView.bounds), QMUIViewSelfSizingHeight);
    if (self.orientationLabel.qmui_height != oldHeight) {
        self.tableView.tableFooterView = nil;
        self.tableView.tableFooterView = self.orientationLabel;
    }
}

#pragma mark - <QMUITableViewDataSource,  QMUITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"选择支持的设备方向";
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

- (void)handleNextCellEvent:(QMUIStaticTableViewCellData *)cellData {
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

- (void)handleCurrentCellEvent:(QMUIStaticTableViewCellData *)cellData {
    [self.tableView deselectRowAtIndexPath:cellData.indexPath animated:YES];
    
    UIInterfaceOrientationMask mask = 0;
    for (QMUIStaticTableViewCellData *cellData in self.tableView.qmui_staticCellDataSource.cellDataSections.firstObject) {
        if (cellData.accessoryType == QMUIStaticTableViewCellAccessoryTypeCheckmark) {
            mask |= cellData.identifier;
        }
    }
    
    self.supportedOrientationMask = mask;
    [self updateCurrentOrientationDescription];
    [self qmui_setNeedsUpdateOfSupportedInterfaceOrientations];
    
    BOOL shouldResetToAll = ((NSNumber *)self.tableView.qmui_staticCellDataSource.cellDataSections[2][1].accessoryValueObject).boolValue;
    if (shouldResetToAll) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.supportedOrientationMask = UIInterfaceOrientationMaskAll;
            [self updateCurrentOrientationDescription];
            // 改为支持全部方向后要主动刷新一下，才能确保设备从横屏物理旋转为竖屏时能自动响应
            [self qmui_setNeedsUpdateOfSupportedInterfaceOrientations];

            [self.tableView.qmui_staticCellDataSource.cellDataSections[0] enumerateObjectsUsingBlock:^(QMUIStaticTableViewCellData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
            }];
            [self.tableView reloadData];
        });
    }
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
