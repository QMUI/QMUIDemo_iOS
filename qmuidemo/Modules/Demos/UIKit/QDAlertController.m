//
//  QDAlertController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/7/20.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDAlertController.h"

static NSString * const kSectionTitleForAlert = @"Alert";
static NSString * const kSectionTitleForActionSheet = @"ActionSheet";
static NSString * const kSectionTitleForSystem = @"系统原生 UIAlertController 对比";

@interface QDAlertController ()
@end

@implementation QDAlertController

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       kSectionTitleForAlert, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                               @"显示一个 alert 弹窗", @"",
                                               @"支持 alert 背景磨砂", @"使用 mainVisualEffectView 指定整个弹窗的磨砂",
                                               @"支持自定义 alert 样式", @"支持以 UIAppearance 方式设置全局统一样式",
                                               @"支持添加输入框", @"升起弹窗时会自动聚焦第一个输入框，也可自定义布局",
                                               @"支持自定义内容", @"可以将一个 UIView 作为 QMUIAlertController 的 contentView",
                                               nil],
                       kSectionTitleForActionSheet, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                     @"显示一个 actionSheet 菜单", @"",
                                                     @"支持 actionSheet 背景磨砂", @"可分别为取消按钮和其他按钮指定不同的磨砂",
                                                     @"支持自定义 actionSheet 样式", @"支持以 UIAppearance 方式设置全局统一样式",
                                                     nil],
                       kSectionTitleForSystem, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                @"显示一个系统的 alert 弹窗", @"",
                                                @"显示一个系统的 actionSheet 菜单", @"",
                                                nil],
                       nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    
    if ([title isEqualToString:@"显示一个 alert 弹窗"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:NULL];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持 alert 背景磨砂"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:NULL];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.qmui_foregroundColor = UIColorMakeWithRGBA(255, 255, 255, .7);// 一般用默认值就行，不用主动去改，这里只是为了展示用法
        alertController.mainVisualEffectView = visualEffectView;
        alertController.alertHeaderBackgroundColor = nil;// 当你需要磨砂的时候请自行去掉这几个背景色，不然这些背景色会盖住磨砂
        alertController.alertButtonBackgroundColor = nil;
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义 alert 样式"]) {
        // 底部按钮
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDefault handler:NULL];
        [action2.button setImage:[[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(18, 18) resizingMode:QMUIImageResizingModeScaleToFill] qmui_imageWithTintColor:UIColor.qd_tintColor] forState:UIControlStateNormal];
        action2.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        
        // 弹窗
        QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
        NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
        titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
        alertController.alertTitleAttributes = titleAttributs;
        NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertMessageAttributes];
        messageAttributs[NSForegroundColorAttributeName] = UIColorMakeWithRGBA(255, 255, 255, 0.75);
        alertController.alertMessageAttributes = messageAttributs;
        alertController.alertHeaderBackgroundColor = UIColor.qd_tintColor;
        alertController.alertSeparatorColor = alertController.alertButtonBackgroundColor;
        alertController.alertTitleMessageSpacing = 7;
        
        NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
        buttonAttributes[NSForegroundColorAttributeName] = alertController.alertHeaderBackgroundColor;
        alertController.alertButtonAttributes = buttonAttributes;
        
        NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertCancelButtonAttributes];
        cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
        alertController.alertCancelButtonAttributes = cancelButtonAttributes;
        
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持添加输入框"]) {
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"请输入个人信息" message:@"两项填写一项即可" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:NULL]];
        [alertController addCancelAction];
        [alertController addTextFieldWithConfigurationHandler:^(QMUITextField * _Nonnull textField) {
            textField.placeholder = @"姓";
        }];
        [alertController addTextFieldWithConfigurationHandler:^(QMUITextField * _Nonnull textField) {
            textField.placeholder = @"名";
        }];
        
        // 输入框的布局默认是贴在一起的，默认不需要修改，这里只是展示可以通过这个 block 自行调整。
        alertController.alertTextFieldMarginBlock = ^UIEdgeInsets(__kindof QMUIAlertController * _Nonnull aAlertController, NSInteger aTextFieldIndex) {
            UIEdgeInsets margin = UIEdgeInsetsZero;
            if (aTextFieldIndex == aAlertController.textFields.count - 1) {
                margin = UIEdgeInsetsSetBottom(margin, 16);
            } else {
                margin = UIEdgeInsetsSetBottom(margin, 4);
            }
            return margin;
        };
        
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义内容"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:NULL];
        UIView *customView = [self animationView];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"正在加载" message:@"加载结束之前请勿取消" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addCustomView:customView];
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"显示一个 actionSheet 菜单"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"置灰按钮" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        action3.enabled = NO;
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持 actionSheet 背景磨砂"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.qmui_foregroundColor = UIColorMakeWithRGBA(255, 255, 255, .6);// 一般用默认值就行，不用主动去改，这里只是为了展示用法
        alertController.mainVisualEffectView = visualEffectView;// 这个负责上半部分的磨砂
        
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.qmui_foregroundColor = UIColorMakeWithRGBA(255, 255, 255, .6);// 一般用默认值就行，不用主动去改，这里只是为了展示用法
        alertController.cancelButtonVisualEffectView = visualEffectView;// 这个负责取消按钮的磨砂
        alertController.sheetHeaderBackgroundColor = nil;
        alertController.sheetButtonBackgroundColor = nil;
        [alertController showWithAnimated:YES];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义 actionSheet 样式"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDefault handler:NULL];
        [action2.button setImage:[[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(22, 22) resizingMode:QMUIImageResizingModeScaleToFill] qmui_imageWithTintColor:UIColor.qd_tintColor] forState:UIControlStateNormal];
        action2.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
        NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetTitleAttributes];
        titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
        alertController.sheetTitleAttributes = titleAttributs;
        NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetMessageAttributes];
        messageAttributs[NSForegroundColorAttributeName] = UIColorWhite;
        alertController.sheetMessageAttributes = messageAttributs;
        alertController.sheetHeaderBackgroundColor = UIColor.qd_tintColor;
        alertController.sheetSeparatorColor = alertController.sheetButtonBackgroundColor;
        
        NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetButtonAttributes];
        buttonAttributes[NSForegroundColorAttributeName] = alertController.sheetHeaderBackgroundColor;
        alertController.sheetButtonAttributes = buttonAttributes;
        
        NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetCancelButtonAttributes];
        cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
        alertController.sheetCancelButtonAttributes = buttonAttributes;
        
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
        return;
    }
    
    // 展示系统的效果
    if (!NSClassFromString(@"UIAlertController")) {
        [QMUITips showInfo:@"iOS 版本过低，不支持 UIAlertController" inView:self.view hideAfterDelay:2];
        return;
    }
    
    
    if ([title isEqualToString:@"显示一个系统的 alert 弹窗"]) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除?" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([title isEqualToString:@"显示一个系统的 actionSheet 菜单"]) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:action2];
        [alertController addAction:action1];
        if (IS_IPAD) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
            CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
            CGRect cellRectInSelfView = [self.view convertRect:cellRect fromView:self.tableView];
            alertController.popoverPresentationController.sourceView = self.view;
            alertController.popoverPresentationController.sourceRect = cellRectInSelfView;
        }
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
}

- (UIView *)animationView {
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 30)];
    
    UIView  *shapeView1= [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView1.backgroundColor = UIColorGreen;
    shapeView1.layer.cornerRadius = 8;
    [animationView addSubview:shapeView1];
    
    UIView *shapeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView2.backgroundColor = UIColorRed;
    shapeView2.layer.cornerRadius = 8;
    [animationView addSubview:shapeView2];
    
    UIView *shapeView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView3.backgroundColor = UIColorBlue;
    shapeView3.layer.cornerRadius = 8;
    [animationView addSubview:shapeView3];
    
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.values = @[ @-5, @0, @10, @40, @70, @80, @75 ];
    positionAnimation.keyTimes = @[ @0, @(5 / 90.0), @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @(85 / 90.0), @1 ];
    positionAnimation.additive = YES;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.values = @[ @.7, @.9, @1, @.9, @.7 ];
    scaleAnimation.keyTimes = @[ @0, @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @1 ];
    
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.values = @[ @0, @1, @1, @1, @0 ];
    alphaAnimation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAnimation, scaleAnimation, alphaAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount = HUGE_VALF;
    group.duration = 1.3;
    
    [shapeView1.layer addAnimation:group forKey:@"basic1"];
    group.timeOffset = .43;
    [shapeView2.layer addAnimation:group forKey:@"basic2"];
    group.timeOffset = .86;
    [shapeView3.layer addAnimation:group forKey:@"basic3"];
    
    return animationView;
}

@end
