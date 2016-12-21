//
//  QDStaticTableViewController.m
//  qmuidemo
//
//  Created by MoLice on 15/5/3.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDStaticTableViewController.h"

@interface QDStaticTableViewController ()

@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation QDStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObjectsFromArray:@[
                                           // section0
                                           @[[QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:0
                                                                                                          image:nil
                                                                                                           text:@"标题1"
                                                                                                     detailText:nil
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeNone
                                                                                                         target:nil
                                                                                                         action:NULL],
                                             [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:1
                                                                                                          image:nil
                                                                                                           text:@"标题2"
                                                                                                     detailText:nil
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeNone
                                                                                                         target:nil
                                                                                                         action:NULL],],
                                           // section1
                                           @[[QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:2
                                                                                                          style:UITableViewCellStyleSubtitle
                                                                                                          image:nil
                                                                                                           text:@"标题1"
                                                                                                     detailText:@"副标题1"
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeNone
                                                                                           accessoryValueObject:nil
                                                                                                         target:nil
                                                                                                         action:NULL],],
                                           
                                           // section2
                                           @[[QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:3
                                                                                                          style:UITableViewCellStyleValue1
                                                                                                          image:nil
                                                                                                           text:@"标题1"
                                                                                                     detailText:nil
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator
                                                                                           accessoryValueObject:nil
                                                                                                         target:nil
                                                                                                         action:NULL],
                                             [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:4
                                                                                                          style:UITableViewCellStyleValue1
                                                                                                          image:nil
                                                                                                           text:@"标题2"
                                                                                                     detailText:nil
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeCheckmark
                                                                                           accessoryValueObject:nil
                                                                                                         target:nil
                                                                                                         action:NULL],
                                             [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:5
                                                                                                          style:UITableViewCellStyleValue1
                                                                                                          image:nil
                                                                                                           text:@"标题3"
                                                                                                     detailText:nil
                                                                                                  accessoryType:QMUIStaticTableViewCellAccessoryTypeSwitch
                                                                                           accessoryValueObject:@YES
                                                                                                         target:nil
                                                                                                         action:NULL],],
                                           ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self.dataSource objectAtIndex:section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QMUIHelper staticTableView:tableView cellForRowAtIndexPath:indexPath withDataSource:self.dataSource];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
