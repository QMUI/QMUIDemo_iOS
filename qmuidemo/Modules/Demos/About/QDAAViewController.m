//
//  QDAAViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/7/12.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDAAViewController.h"

@interface QDAAViewController ()

@property(nonatomic, copy) void (^textFieldConfigurationHandler)(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer);
@property(nonatomic, strong) QMUIFillButton *addPeopleButton;

/// 优惠金额
@property(nonatomic, weak) QMUITextField *discountPayField;

/// 实付金额
@property(nonatomic, weak) QMUITextField *actuallyPayField;

/// 其中运费
@property(nonatomic, weak) QMUITextField *freightPayField;
@end

@implementation QDAAViewController

- (void)didInitialize {
    [super didInitialize];
    self.title = @"拼单计算器";
    self.textFieldMargins = UIEdgeInsetsMake(8, 16, 6, 16);
    self.textFieldSeparatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    self.textFieldConfigurationHandler = ^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        titleLabel.font = UIFontMake(12);
        titleLabel.textColor = UIColorGray1;
        textField.placeholder = @"输入原价";
        textField.font = UIFontMake(12);
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    };
    
    [self addTextFieldWithTitle:@"团友1" configurationHandler:self.textFieldConfigurationHandler];
    [self addTextFieldWithTitle:@"团友2" configurationHandler:self.textFieldConfigurationHandler];
    [self addTextFieldWithTitle:@"团友3" configurationHandler:self.textFieldConfigurationHandler];
    [self addTextFieldWithTitle:@"团友4" configurationHandler:self.textFieldConfigurationHandler];
    [self addTextFieldWithTitle:@"团友5" configurationHandler:self.textFieldConfigurationHandler];
    [self addTextFieldWithTitle:@"优惠金额" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        weakSelf.textFieldConfigurationHandler(titleLabel, textField, separatorLayer);
        textField.placeholder = @"减免的那部分";
    }];
    [self addTextFieldWithTitle:@"实付金额" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        weakSelf.textFieldConfigurationHandler(titleLabel, textField, separatorLayer);
        textField.placeholder = @"最终全单实际支付金额";
    }];
    [self addTextFieldWithTitle:@"其中运费" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        weakSelf.textFieldConfigurationHandler(titleLabel, textField, separatorLayer);
        textField.placeholder = @"运费将按每人消费比例分配";
    }];
    [self addCancelButtonWithText:@"关闭" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    [self addSubmitButtonWithText:@"计算" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
        [weakSelf calculatePrice];
    }];
}

- (void)calculatePrice {
    NSArray<QMUITextField *> *textFields = self.textFields;
    double total = textFields[textFields.count - 2].text.doubleValue;
    double discountMoney = textFields[textFields.count - 3].text.doubleValue;
    double freight = textFields.lastObject.text.doubleValue;
    double discount = (total - freight) / (total - freight + discountMoney);// 除运费外的折扣比例
    
    double (^aaMoneyCounter)(double aaOriginalPrice) = ^double(double aaOriginalPrice) {
        return aaOriginalPrice * discount + freight * (aaOriginalPrice / (total + discountMoney - freight));
    };
    
    NSMutableArray<NSNumber *> *aaMoney = [[NSMutableArray alloc] init];
    NSMutableString *aaMoneyString = [[NSMutableString alloc] initWithString:@"拼单账单"];
    double checkResult = 0;
    for (NSInteger i = 0; i < textFields.count - 3; i++) {
        double result = aaMoneyCounter(textFields[i].text.doubleValue);
        checkResult += result;
        [aaMoney addObject:@(result)];
        [aaMoneyString appendFormat:@"\n团友%@: %.1f", @(i), result];
    }
    NSAssert(fabs(checkResult - total) < 1, @"每个人的拼单金额加起来与实付金额差得有点多，实付金额：%.1f，拼单结果总额：%.1f", total, checkResult);
    [QMUITips showWithText:aaMoneyString.copy inView:self.view hideAfterDelay:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray<QMUITextField *> *textFields = self.textFields;
    textFields[0].text = @"17.9";
    textFields[1].text = @"16.8";
    textFields[2].text = @"29.9";
    textFields[3].text = @"49.9";
    textFields[4].text = @"71.6";
    textFields[5].text = @"20";
    textFields[6].text = @"166.6";
    textFields[7].text = @"0";
}

@end
