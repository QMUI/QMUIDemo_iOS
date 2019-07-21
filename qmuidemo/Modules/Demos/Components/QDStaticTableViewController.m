//
//  QDStaticTableViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/5/3.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDStaticTableViewController.h"

@interface QDStaticTableViewController ()

@end

@implementation QDStaticTableViewController

- (void)initTableView {
    [super initTableView];
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[
                                                      // section0
                                                      @[
                                                        // 一般情况下可以用 + 方法快速初始化一个 cellData
                                                        [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:0
                                                                                                                     image:nil
                                                                                                                      text:@"标题"
                                                                                                                detailText:nil
                                                                                                           didSelectTarget:nil
                                                                                                           didSelectAction:NULL
                                                                                                             accessoryType:QMUIStaticTableViewCellAccessoryTypeNone],
                                                        // 嫌参数列表太长也可以这么写，没赋值的属性则使用默认值
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 1;
                                                            d.style = UITableViewCellStyleSubtitle;
                                                            d.height = TableViewCellNormalHeight + 6;
                                                            d.text = @"标题";
                                                            d.detailText = @"副标题";
                                                            d;
                                                        })],
                                                      
                                                      // section1
                                                      @[
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 2;
                                                            d.text = @"箭头类型";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
                                                            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                                                            d;
                                                        }),
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 3;
                                                            d.text = @"按钮类型";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
                                                            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDetailButton;
                                                            d.accessoryTarget = self;
                                                            d.accessoryAction = @selector(handleAccessoryDetailButtonEvent:);
                                                            d;
                                                        }),
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 4;
                                                            d.text = @"按钮类型";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
                                                            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDetailDisclosureButton;
                                                            d.accessoryTarget = self;
                                                            d.accessoryAction = @selector(handleAccessoryDetailButtonEvent:);
                                                            d;
                                                        }),
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 5;
                                                            d.text = @"UISwitch 类型";
                                                            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
                                                            d.accessoryValueObject = @YES;// switch 类型的，可以通过传一个 NSNumber 对象给 accessoryValueObject 来指定这个 switch.on 的值
                                                            d.accessoryTarget = self;
                                                            d.accessoryAction = @selector(handleSwitchCellEvent:);
                                                            d;
                                                        })],
                                                      
                                                      // section2
                                                      @[
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 6;
                                                            d.text = @"选项 1";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleCheckmarkCellEvent:);
                                                            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
                                                            d;
                                                        }),
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 7;
                                                            d.text = @"选项 2";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleCheckmarkCellEvent:);
                                                            d;
                                                        }),
                                                        ({
                                                            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                                                            d.identifier = 8;
                                                            d.text = @"选项 3";
                                                            d.didSelectTarget = self;
                                                            d.didSelectAction = @selector(handleCheckmarkCellEvent:);
                                                            d;
                                                        })]
                                                      ]];
    
    // 把数据塞给 tableView 即可
    self.tableView.qmui_staticCellDataSource = dataSource;
}

- (void)handleDisclosureIndicatorCellEvent:(QMUIStaticTableViewCellData *)cellData {
    // cell 的点击事件，注意第一个参数的类型是 QMUIStaticTableViewCellData
    [QMUITips showWithText:[NSString stringWithFormat:@"点击了 %@", cellData.text] inView:self.view hideAfterDelay:1.2];
}

- (void)handleCheckmarkCellEvent:(QMUIStaticTableViewCellData *)cellData {
    // checkmark 类型的 cell 如果要实现单选，可以这么写
    
    if (cellData.accessoryType == QMUIStaticTableViewCellAccessoryTypeCheckmark) {
        // 选项没变化，直接结束
        return;
    }
    
    // 先取消之前的所有勾选
    for (QMUIStaticTableViewCellData *data in self.tableView.qmui_staticCellDataSource.cellDataSections[cellData.indexPath.section]) {
        data.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
    }
    
    // 再勾选当前点击的 cell
    cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
    
    // 注意：如果不需要考虑动画，则下面这两步不用这么麻烦，直接调用 [self.tableView reloadData] 即可
    
    // 刷新除了被点击的那个 cell 外的其他单选 cell
    NSMutableArray<NSIndexPath *> *indexPathsAnimated = [[NSMutableArray alloc] init];
    for (NSInteger i = 0, l = [self.tableView numberOfRowsInSection:cellData.indexPath.section]; i < l; i++) {
        if (i != cellData.indexPath.row) {
            [indexPathsAnimated addObject:[NSIndexPath indexPathForRow:i inSection:cellData.indexPath.section]];
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPathsAnimated withRowAnimation:UITableViewRowAnimationNone];
    
    // 直接拿到 cell 去修改 accessoryType，保证动画不受 reload 的影响
    QMUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellData.indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeCheckmark;
}

- (void)handleAccessoryDetailButtonEvent:(QMUIStaticTableViewCellData *)cellData {
    [QMUITips showWithText:@"点击了右边的按钮" inView:self.view hideAfterDelay:1.2];
}

- (void)handleSwitchCellEvent:(UISwitch *)switchControl {
    // UISwitch 的开关事件，注意第一个参数的类型是 UISwitch
    if (switchControl.on) {
        [QMUITips showSucceed:@"打开" inView:self.view hideAfterDelay:.8];
    } else {
        [QMUITips showError:@"关闭" inView:self.view hideAfterDelay:.8];
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 2 ? @"单选" : nil;
}

@end
