//
//  QDInterceptBackButtonEventViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDInterceptBackButtonEventViewController.h"

@interface QDInterceptBackButtonEventViewController () <QMUITextViewDelegate, UINavigationControllerBackButtonHandlerProtocol>

@property(nonatomic, strong) QMUITextView *textView;
@property(nonatomic, strong) UILabel *textCountLabel;

@end

@implementation QDInterceptBackButtonEventViewController

#pragma mark - Lift Circle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    _textView = [[QMUITextView alloc] init];
    self.textView.placeholder = @"请输入个人简介...";
    self.textView.font = UIFontMake(15);
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    self.textView.textContainerInset = UIEdgeInsetsMake(8, 6, 8, 6);
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    _textCountLabel = [[UILabel alloc] init];
    self.textCountLabel.font = UIFontMake(14);
    self.textCountLabel.numberOfLines = 0;
    self.textCountLabel.textColor = UIColorGrayDarken;
    self.textCountLabel.text = @"请在下方输入内容，并点击返回按钮或者手势返回：";
    [self.textCountLabel sizeToFit];
    [self.view addSubview:self.textCountLabel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat inset = 12;
    CGFloat contentWidht = CGRectGetWidth(self.view.bounds) - 2 * inset;
    CGSize labelSize = [self.textCountLabel sizeThatFits:CGSizeMake(contentWidht, CGFLOAT_MAX)];
    self.textCountLabel.frame = CGRectMake(inset, self.qmui_navigationBarMaxYInViewCoordinator + 20, contentWidht, labelSize.height);
    self.textView.frame = CGRectMake(inset, CGRectGetMaxY(self.textCountLabel.frame) + 10, CGRectGetWidth(self.view.bounds) - 2 * inset, 100);
}

#pragma mark - Tool

- (NSString *)localText {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"LocalText"];
}

- (void)setLocalText:(NSString *)text {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:text forKey:@"LocalText"];
    [userDefaults synchronize];
}

#pragma mark - UINavigationControllerBackButtonHandlerProtocol

- (BOOL)shouldHoldBackButtonEvent {
    return YES;
}

- (BOOL)canPopViewController {
    // 这里不要做一些费时的操作，否则可能会卡顿。
    if (self.textView.text.length > 0) {
        [self.textView resignFirstResponder];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"是否返回？" message:@"返回后输入框的数据将不会自动保存" preferredStyle:QMUIAlertControllerStyleAlert];
        QMUIAlertAction *backActioin = [QMUIAlertAction actionWithTitle:@"返回" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        QMUIAlertAction *continueAction = [QMUIAlertAction actionWithTitle:@"继续编辑" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            [self.textView becomeFirstResponder];
        }];
        [alertController addAction:backActioin];
        [alertController addAction:continueAction];
        [alertController showWithAnimated:YES];
        return NO;
    } else {
        return YES;
    }
}

@end
