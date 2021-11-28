//
//  QMUIInteractiveDebugPanelItem.m
//  qmuidemo
//
//  Created by QMUI Team on 2020/5/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QMUIInteractiveDebugPanelItem.h"

@interface QMUIInteractiveDebugPanelItem ()

@property(nonatomic, strong, readwrite) UILabel *titleLabel;
@end

@interface QMUIInteractiveDebugPanelTextItem : QMUIInteractiveDebugPanelItem <QMUITextFieldDelegate>

@property(nonatomic, strong) QMUITextField *textField;
@end

@interface QMUIInteractiveDebugPanelNumbericItem : QMUIInteractiveDebugPanelTextItem
@end

@interface QMUIInteractiveDebugPanelColorItem : QMUIInteractiveDebugPanelNumbericItem
@end

@interface QMUIInteractiveDebugPanelBoolItem : QMUIInteractiveDebugPanelItem

@property(nonatomic, strong) UISwitch *switcher;
@end

@interface QMUIInteractiveDebugPanelEnumItem : QMUIInteractiveDebugPanelItem

@property(nonatomic, strong) UISegmentedControl *segmentedControl;

- (instancetype)initWithItems:(NSArray<NSString *> *)items;
@end

@implementation QMUIInteractiveDebugPanelItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColor.blackColor];
        self.height = 44;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

+ (instancetype)itemWithTitle:(NSString *)title actionView:(__kindof UIView *)actionView valueGetter:(void (^)(__kindof UIView * _Nonnull))valueGetter valueSetter:(void (^)(__kindof UIView * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelItem *item = QMUIInteractiveDebugPanelItem.new;
    item.title = title;
    item.actionView = actionView;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

+ (instancetype)textItemWithTitle:(NSString *)title valueGetter:(void (^)(QMUITextField * _Nonnull))valueGetter valueSetter:(void (^)(QMUITextField * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelTextItem *item = QMUIInteractiveDebugPanelTextItem.new;
    item.title = title;
    item.actionView = item.textField;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

+ (instancetype)numbericItemWithTitle:(NSString *)title valueGetter:(void (^)(QMUITextField * _Nonnull))valueGetter valueSetter:(void (^)(QMUITextField * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelNumbericItem *item = QMUIInteractiveDebugPanelNumbericItem.new;
    item.title = title;
    item.actionView = item.textField;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

+ (instancetype)colorItemWithTitle:(NSString *)title valueGetter:(void (^)(QMUITextField * _Nonnull))valueGetter valueSetter:(void (^)(QMUITextField * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelColorItem *item = QMUIInteractiveDebugPanelColorItem.new;
    item.title = title;
    item.actionView = item.textField;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

+ (instancetype)boolItemWithTitle:(NSString *)title valueGetter:(void (^)(UISwitch * _Nonnull))valueGetter valueSetter:(void (^)(UISwitch * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelBoolItem *item = QMUIInteractiveDebugPanelBoolItem.new;
    item.title = title;
    item.actionView = item.switcher;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

+ (instancetype)enumItemWithTitle:(NSString *)title items:(NSArray<NSString *> *)items valueGetter:(void (^)(UISegmentedControl * _Nonnull))valueGetter valueSetter:(void (^)(UISegmentedControl * _Nonnull))valueSetter {
    QMUIInteractiveDebugPanelEnumItem *item = [[QMUIInteractiveDebugPanelEnumItem alloc] initWithItems:items];
    item.title = title;
    item.actionView = item.segmentedControl;
    item.valueGetter = valueGetter;
    item.valueSetter = valueSetter;
    return item;
}

@end

@implementation QMUIInteractiveDebugPanelTextItem

- (QMUITextField *)textField {
    if (!_textField) {
        _textField = [[QMUITextField alloc] qmui_initWithSize:CGSizeMake(160, 38)];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont fontWithName:@"Menlo" size:14];
        _textField.textColor = UIColor.blackColor;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.qmui_borderWidth = PixelOne;
        _textField.qmui_borderPosition = QMUIViewBorderPositionBottom;
        _textField.qmui_borderColor = [UIColorBlack colorWithAlphaComponent:.3];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(handleTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)handleTextFieldChanged:(QMUITextField *)textField {
    if (!textField.isFirstResponder) return;
    if (self.valueSetter) self.valueSetter(textField);
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end

@implementation QMUIInteractiveDebugPanelNumbericItem

- (QMUITextField *)textField {
    QMUITextField *textField = [super textField];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    return textField;
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 删除文字
    if (range.length > 0 && string.length <= 0) {
        return YES;
    }
    
    return !![string qmui_stringMatchedByPattern:@"[-\\d\\.]"];// 模拟器里，通过电脑键盘输入“点”，输出的可能是中文的句号
}

@end

@implementation QMUIInteractiveDebugPanelColorItem

- (QMUITextField *)textField {
    QMUITextField *textField = [super textField];
    textField.placeholder = @"255,255,255,1.0";
    return textField;
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 删除文字
    if (range.length > 0 && string.length <= 0) {
        return YES;
    }
    
    return !![string qmui_stringMatchedByPattern:@"[\\d\\s\\,\\.]+"];
}

@end

@implementation QMUIInteractiveDebugPanelBoolItem

- (UISwitch *)switcher {
    if (!_switcher) {
        _switcher = [[UISwitch alloc] init];
        _switcher.layer.anchorPoint = CGPointMake(.5, .5);
        _switcher.transform = CGAffineTransformMakeScale(.7, .7);
        [_switcher addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _switcher;
}

- (void)handleSwitchEvent:(UISwitch *)switcher {
    if (self.valueSetter) self.valueSetter(switcher);
}

@end

@implementation QMUIInteractiveDebugPanelEnumItem

- (instancetype)initWithItems:(NSArray<NSString *> *)items {
    if (self = [super init]) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        _segmentedControl.frame = CGRectSetWidth(_segmentedControl.frame, 240);// 统一按照最长的来就行啦
        _segmentedControl.transform = CGAffineTransformMakeScale(.8, .8);
        [_segmentedControl addTarget:self action:@selector(handleSegmentedControlEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)handleSegmentedControlEvent:(UISegmentedControl *)segmentedControl {
    if (self.valueSetter) self.valueSetter(segmentedControl);
}

@end
