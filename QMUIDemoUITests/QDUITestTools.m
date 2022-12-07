//
//  QDUITestTools.m
//  QMUIDemoUITests
//
//  Created by MoLice on 2019/M/17.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDUITestTools.h"

@implementation QDUITestTools

@end

@implementation XCUIElement (QDUITest)

- (BOOL)qd_hasKeyboardFocus {
    // https://stackoverflow.com/a/35915719/4250833
    if ([self isKindOfClass:[UIView class]] && QMUICMIActivated && !IgnoreKVCAccessProhibited) {
        BeginIgnoreUIKVCAccessProhibited
        id value = [self valueForKey:@"hasKeyboardFocus"];
        EndIgnoreUIKVCAccessProhibited
        return value;
    }
    return [self valueForKey:@"hasKeyboardFocus"];
}

- (void)qd_clearText {
    if ([self.value isKindOfClass:[NSString class]]) {
        while (((NSString *)self.value).length > 0 && ![self.value isEqualToString:self.placeholderValue]) {
            [self typeText:XCUIKeyboardKeyDelete];
        }
    }
}

@end

@implementation XCUIApplication (QDUITest)

- (void)qd_tapMenuItem:(QDUITestMenuItem)menuItem {
    if (!self.menuItems.count) return;
    NSArray<NSArray<NSString *> *> *items = @[@[@"选择", @"Select"],
                                              @[@"全选", @"Select All"],
                                              @[@"粘贴", @"Paste"],
                                              @[@"剪切", @"Cut"],
                                              @[@"拷贝", @"Copy"],
                                              @[@"替换", @"Replace…"],
                                              @[@"查找", @"Look Up"],
                                              @[@"分享", @"Share…"],
                                              ];
    NSArray<NSString *> *titles = items[menuItem];
    for (NSString *title in titles) {
        if (self.menuItems[title].exists) {
            [self.menuItems[title] tap];
            break;
        }
    }
}

- (XCUIElement *)qd_rootViewOfControllerTitle:(NSString *)title {
    return self.otherElements[[NSString stringWithFormat:@"viewController-%@", title]];
}

@end
