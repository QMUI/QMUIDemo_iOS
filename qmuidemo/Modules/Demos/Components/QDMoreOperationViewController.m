//
//  QDMoreOperationViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/5/18.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDMoreOperationViewController.h"

@interface QDMoreOperationViewController () <QMUIMoreOperationControllerDelegate>

@end

@implementation QDMoreOperationViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"支持 item 多行显示", @"每个 item 可通过 selected 来切换不同状态",
                                     @"支持动态修改 item 位置", @"点击第二行 item 来修改第一行 item",
                                     @"支持修改皮肤样式（例如夜间模式）", @"通过 appearance 设置全局样式",
                                     nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    
    if ([title isEqualToString:@"支持 item 多行显示"]) {
        
        QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
        // 如果你的 item 是确定的，则可以直接通过 items 属性来显示，如果 item 需要经过一些判断才能确定下来，请看第二个示例
        moreOperationController.items = @[
                                          // 第一行
                                          @[
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];// 如果嫌每次都在 handler 里写 hideToBottom 烦，也可以直接把这句写到 moreOperationController:didSelectItemView: 里，它可与 handler 共存
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareWeibo") title:@"分享到微博" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareChat") title:@"分享到私信" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }]
                                              ],
                                          
                                          // 第二行
                                          @[
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_collect") selectedImage:UIImageMake(@"icon_moreOperation_notCollect") title:@"收藏" selectedTitle:@"取消收藏" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  itemView.selected = !itemView.selected;// 通过 selected 切换 itemView 的状态
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_report") title:@"反馈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_openInSafari") title:@"在Safari中打开" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                                  [moreOperationController hideToBottom];
                                              }]
                                              ],
                                          ];
        [moreOperationController showFromBottom];
        
    } else if ([title isEqualToString:@"支持动态修改 item 位置"]) {
        
        QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
        moreOperationController.items = @[
                                          // 第一行
                                          @[
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:NULL],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:NULL],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareWeibo") title:@"分享到微博" handler:NULL]
                                              ]
                                          ];
        // 动态给第二行插入一个 item
        [moreOperationController addItemView:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"添加" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
            
            // 动态添加 item
            NSInteger sectionToAdd = 0;
            if (itemView.indexPath.section == 0) {
                sectionToAdd = 1;
            }
            [moreOperationController addItemView:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:NULL] inSection:sectionToAdd];
            
        }] inSection:1];
        
        // 再给第二行插入一个 item
        [moreOperationController addItemView:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
            
            // 动态减少 item
            NSInteger sectionToRemove = 0;
            if (itemView.indexPath.section == 0) {
                sectionToRemove = 1;
            }
            if (moreOperationController.items.count > 1) {
                [moreOperationController removeItemViewAtIndexPath:[NSIndexPath indexPathForItem:moreOperationController.items[sectionToRemove].count - 1 inSection:sectionToRemove]];
            }
            
        }] inSection:1];
        moreOperationController.cancelButton.hidden = YES;// 通过控制 cancelButton.hidden 的值来控制取消按钮的显示、隐藏
        [moreOperationController showFromBottom];
        
    } else if ([title isEqualToString:@"支持修改皮肤样式（例如夜间模式）"]) {
        QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
        moreOperationController.delegate = self;
        moreOperationController.contentBackgroundColor = UIColorMake(34, 34, 34);
        moreOperationController.cancelButtonSeparatorColor = UIColorMake(51, 51, 51);
        moreOperationController.cancelButtonBackgroundColor = UIColorMake(34, 34, 34);
        moreOperationController.cancelButtonTitleColor = UIColorMake(102, 102, 102);
        moreOperationController.itemTitleColor = UIColorMake(102, 102, 102);
        moreOperationController.items = @[
                                          @[
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:NULL],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:NULL],
                                              [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareWeibo") title:@"分享到微博" handler:NULL]
                                              ]
                                          ];
        [moreOperationController.items qmui_enumerateNestedArrayWithBlock:^(QMUIMoreOperationItemView *itemView, BOOL *stop) {
            [itemView setImage:[[itemView imageForState:UIControlStateNormal] qmui_imageWithAlpha:.4] forState:UIControlStateNormal];
        }];
        [moreOperationController showFromBottom];
    }
}

#pragma mark - <QMUIMoreOperationControllerDelegate>

- (void)moreOperationController:(QMUIMoreOperationController *)moreOperationController didSelectItemView:(QMUIMoreOperationItemView *)itemView {
    [moreOperationController hideToBottom];
}

@end
