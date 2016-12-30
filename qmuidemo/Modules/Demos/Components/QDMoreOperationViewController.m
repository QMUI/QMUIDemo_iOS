//
//  QDMoreOperationViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/18.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDMoreOperationViewController.h"

@interface QDMoreOperationViewController () <QMUIMoreOperationDelegate>

@end

@implementation QDMoreOperationViewController {
    QMUIMoreOperationController *_moreOperationController;
    NSInteger _index;
    BOOL _isSelected;
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"普通样式", @"点击“收藏”来修改此item的选中态",
                                     @"支持在某个位置插入一个item", @"在第一行的第一个位置插入“邮件”",
                                     @"根据不同的状态显示或隐藏item", @"把第二行的“举报”隐藏掉",
                                     @"修改控件主题色（夜间模式）", @"通过appearance在app启动时设置全局样式",
                                     nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    
    if ([title isEqualToString:@"普通样式"]) {
        _index = 0;
        [self showMoreOperationController];
    } else if ([title isEqualToString:@"支持在某个位置插入一个item"]) {
        _index = 1;
        [self showMoreOperationController];
    } else if ([title isEqualToString:@"根据不同的状态显示或隐藏item"]) {
        _index = 2;
        [self showMoreOperationController];
    } else if ([title isEqualToString:@"修改控件主题色（夜间模式）"]) {
        _index = 3;
        [self showMoreOperationController];
    }
}

- (void)showMoreOperationController {
    
    // 为了不用写那么多样式的reset，直接每次都重新init一个新的controller
    
    _moreOperationController = [[QMUIMoreOperationController alloc] init];
    _moreOperationController.delegate = self;
    
    [_moreOperationController addItemWithTitle:@"微信好友" image:UIImageMake(@"icon_moreOperation_shareFriend") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareWechat];
    
    [_moreOperationController addItemWithTitle:@"朋友圈" image:UIImageMake(@"icon_moreOperation_shareMoment") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareMoment];
    
    [_moreOperationController addItemWithTitle:@"新浪微博" image:UIImageMake(@"icon_moreOperation_shareWeibo") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareWeibo];
    
    [_moreOperationController addItemWithTitle:@"QQ空间" image:UIImageMake(@"icon_moreOperation_shareQzone") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareQzone];
    
    [_moreOperationController addItemWithTitle:@"浏览器打开" image:UIImageMake(@"icon_moreOperation_openInSafari") type:QMUIMoreOperationItemTypeNormal tag:MoreOperationTagSafari];
    
    [_moreOperationController addItemWithTitle:@"举报" image:UIImageMake(@"icon_moreOperation_report") type:QMUIMoreOperationItemTypeNormal tag:MoreOperationTagReport];
    
    [_moreOperationController addItemWithTitle:@"收藏" selectedTitle:@"取消收藏" image:UIImageMake(@"icon_moreOperation_collect") selectedImage:UIImageMake(@"icon_moreOperation_notCollect") type:QMUIMoreOperationItemTypeNormal tag:MoreOperationTagBookMark];
    QMUIMoreOperationItemView *collectItem = [_moreOperationController itemAtTag:MoreOperationTagBookMark];
    collectItem.selected = _isSelected;
    
    //////////////
    
    if (_index % 4 == 0) {
        
    } else if (_index % 4 == 1) {
        
        QMUIMoreOperationItemView *mailItem = [_moreOperationController itemAtTag:MoreOperationTagShareMail];
        if (!mailItem) {
            mailItem = [_moreOperationController createItemWithTitle:@"邮件" selectedTitle:nil image:UIImageMake(@"icon_moreOperation_shareChat") selectedImage:nil type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareMail];
            [_moreOperationController insertItem:mailItem toIndex:0];
        }
        
        _moreOperationController.cancelButtonMarginTop = [QMUIMoreOperationController appearance].contentEdgeMargin;
        
    } else if (_index % 4 == 2) {
        
        [_moreOperationController setItemHidden:YES tag:MoreOperationTagReport];
        
        _moreOperationController.contentEdgeMargin = 0;
        _moreOperationController.contentMaximumWidth = CGRectGetWidth(self.view.bounds);
        _moreOperationController.contentCornerRadius = 0;
        _moreOperationController.contentBackgroundColor = UIColorMake(246, 246, 246);
        _moreOperationController.cancelButtonHeight = 46;
        _moreOperationController.cancelButtonTitleColor = UIColorMake(34, 34, 34);
        _moreOperationController.cancelButtonFont = UIFontMake(16);
        _moreOperationController.cancelButtonSeparatorColor = UIColorClear;
        
    } else if (_index % 4 == 3) {
        
        _moreOperationController.contentBackgroundColor = UIColorMake(34, 34, 34);
        _moreOperationController.cancelButtonSeparatorColor = UIColorMake(51, 51, 51);
        _moreOperationController.cancelButtonBackgroundColor = UIColorMake(34, 34, 34);
        _moreOperationController.cancelButtonTitleColor = UIColorMake(102, 102, 102);
        _moreOperationController.itemTitleColor = UIColorMake(102, 102, 102);
        
        for (QMUIMoreOperationItemView *item in _moreOperationController.items) {
            item.alpha = 0.4;
        }
        
    }
    
    // 显示更多操作面板
    [_moreOperationController showFromBottom];
}

#pragma mark - <QMUIMoreOperationDelegate>

- (void)moreOperationController:(QMUIMoreOperationController *)moreOperationController didSelectItemAtTag:(NSInteger)tag {
    QMUIMoreOperationItemView *itemView = [moreOperationController itemAtTag:tag];
    NSString *tipString = itemView.titleLabel.text;
    switch (tag) {
        case MoreOperationTagShareWechat:
            break;
        case MoreOperationTagShareMoment:
            break;
        case MoreOperationTagShareWeibo:
            break;
        case MoreOperationTagShareQzone:
            break;
        case MoreOperationTagShareMail:
            break;
        case MoreOperationTagSafari:
            break;
        case MoreOperationTagReport:
            break;
        case MoreOperationTagBookMark:
            tipString = [itemView titleForState:_isSelected ? UIControlStateSelected : UIControlStateNormal];
            _isSelected = !_isSelected;
            break;
        default:
            break;
    }
    [QMUITips showWithText:tipString inView:self.view hideAfterDelay:0.5];
    [moreOperationController hideToBottom];
}

@end
