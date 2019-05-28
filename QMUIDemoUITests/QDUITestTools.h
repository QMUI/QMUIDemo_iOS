//
//  QDUITestTools.h
//  QMUIDemoUITests
//
//  Created by MoLice on 2019/M/17.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit/QMUIKit.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

CG_INLINE BOOL
CGFloatAboutEqualWithEpsilon(CGFloat f1, CGFloat f2, CGFloat epsilon) {
    return ABS(f1 - f2) <= epsilon;
}

CG_INLINE BOOL
CGFloatAboutEqualToFloat(CGFloat f1, CGFloat f2) {
    return CGFloatAboutEqualWithEpsilon(f1, f2, PixelOne);
}

CG_INLINE BOOL
CGPointAboutEqualToPoint(CGPoint p1, CGPoint p2) {
    return CGFloatAboutEqualToFloat(p1.x, p2.x) && CGFloatAboutEqualToFloat(p1.y, p2.y);
}

CG_INLINE BOOL
CGSizeAboutEqualToSize(CGSize s1, CGSize s2) {
    return CGFloatAboutEqualToFloat(s1.width, s2.width) && CGFloatAboutEqualToFloat(s1.height, s2.height);
}

CG_INLINE BOOL
CGRectAboutEqualToRect(CGRect r1, CGRect r2) {
    return CGPointAboutEqualToPoint(r1.origin, r2.origin) && CGSizeAboutEqualToSize(r1.size, r2.size);
}

@interface QDUITestTools : NSObject

@end

@interface XCUIElement (QDUITest)

/// 判断当前元素是否正处于键盘聚焦编辑状态
@property(nonatomic, assign, readonly) BOOL qd_hasKeyboardFocus;

/// 清空输入框已输入的文字
- (void)qd_clearText;
@end

typedef NS_ENUM(NSUInteger, QDUITestMenuItem) {
    QDUITestMenuItemSelect,
    QDUITestMenuItemSelectAll,
    QDUITestMenuItemPaste,
    QDUITestMenuItemCut,
    QDUITestMenuItemCopy,
    QDUITestMenuItemReplace,
    QDUITestMenuItemLookUp,
    QDUITestMenuItemShare
};

@interface XCUIApplication (QDUITest)

- (void)qd_tapMenuItem:(QDUITestMenuItem)menuItem;
- (XCUIElement *)qd_rootViewOfControllerTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
