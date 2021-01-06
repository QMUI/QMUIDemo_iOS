//
//  QMUIDemoUITests.m
//  QMUIDemoUITests
//
//  Created by MoLice on 2019/M/16.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QDUITestTools.h"
#import <QMUIKit/QMUIKit.h>

@interface QMUIDemoUITests : XCTestCase

@property(nonatomic, strong) XCUIApplication *app;
@end

@implementation QMUIDemoUITests

- (void)setUp {
    
    self.app = [[XCUIApplication alloc] init];
    self.app.launchEnvironment = @{@"isUITest": @YES};// 给业务代码通过 NSProcessInfo.processInfo.environment[@"isUITest"] 来判断当前是否正在运行 UITest
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = YES;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [self.app launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testUIKit {
    [self _testQMUITextView];
    [self _testQMUINavigationController];
}

- (void)_testQMUITextView {
    [self tapGridButton:@"QMUITextView"];
    
    XCUIElement *textView = self.app.textViews.firstMatch;
    NSUInteger keyboardCount = self.app.keyboards.count;
    NSString *placeholder = textView.placeholderValue;
    
    [textView tap];
    keyboardCount++;
    XCTAssertTrue(self.app.keyboards.count == keyboardCount);
    
    // 输入文字则 placeholder 消失，清空文字则 placeholder 出现
    XCTAssertTrue(textView.staticTexts[placeholder].exists);
    [textView typeText:@"text"];
    XCTAssertFalse(textView.staticTexts[placeholder].exists);
    [textView qd_clearText];
    XCTAssertTrue(textView.staticTexts[placeholder].exists);
    
    // 选择、复制、粘贴等 menu 操作
    [textView typeText:@"string to be copied"];
    XCTAssertFalse(self.app.menuItems.count);
    [textView pressForDuration:1];
    sleep(1.5);
    XCTAssertTrue([[self.app menuItems] count]);
    [self.app qd_tapMenuItem:QDUITestMenuItemSelectAll];
    sleep(1.5);
    [self.app qd_tapMenuItem:QDUITestMenuItemCopy];
    sleep(1.5);
    NSLog(@"UIPasteboard.generalPasteboard.string = %@", UIPasteboard.generalPasteboard.string);
    XCTAssertEqualObjects(UIPasteboard.generalPasteboard.string, textView.value);// typeText: 在 iOS 10 下会被输入法的自动联想影响，实际输入并不是这个，所以直接取 textView 当前的文字来比较才最稳妥
    
    // 文字高度自适应
    [self.app.keys[@"delete"] tap];
    CGFloat height = CGRectGetHeight(textView.frame);
    [textView typeText:@"这是很长一段文字，触发高度变化。这是很长一段文字，触发高度变化。这是很长一段文字，触发高度变化。这是很长一段文字，触发高度变化。这是很长一段文字，触发高度变化。这是很长一段文字，触发高度变化。"];
    XCTAssertTrue(CGRectGetHeight(textView.frame) > height);
    
    // 输入超过一定字符就无法再输入
    [textView typeText:@"0123456789"];
    XCTAssertTrue([((NSString *)textView.value) hasSuffix:@"3"]);// 前面一长串文字个数为96，所以后面输入3后理应就无法再输入了
    
    sleep(2);// 等待 QMUITips 消失才能点击 textView
    
    // 粘贴过来的一大段文字也要自动截断
    [textView tap];
    sleep(1.5);
    [self.app qd_tapMenuItem:QDUITestMenuItemSelectAll];
    [self.app.keys[@"delete"] tap];
    NSString *pasteString = @"这是一段粘贴过来的长文本，末尾理应会被截断。这是一段粘贴过来的长文本，末尾理应会被截断。这是一段粘贴过来的长文本，末尾理应会被截断。这是一段粘贴过来的长文本，末尾理应会被截断。这是一段粘贴过来的长文本，末尾理应会被截断。";
    [textView typeText:pasteString];
    XCTAssertTrue(((NSString *)textView.value).length < pasteString.length);
    
    /*
     TODO: molice
     1. 用户手动输入文字、程序 setText:，max length 都要能正常工作
     2. 即将输入的文字被完全拦截、部分截断，都应该触发 textViewDidChange: 这个 delegate
     3. 输入的文字被拦截一部分后刚好换行了，此时应该触发 textView:newHeightAfterTextChanged: https://github.com/Tencent/QMUI_iOS/issues/1120
     */
    
    sleep(1);
    
    // 点击空白降下键盘
    [[self.app qd_rootViewOfControllerTitle:@"QMUITextView"] tap];
    keyboardCount--;
    XCTAssertTrue(self.app.keyboards.count == keyboardCount);
}

- (void)_testQMUINavigationController {
    [self tapGridButton:@"QMUINavigationController"];
    [self.app.tables.cells.staticTexts[@"拦截系统navBar返回按钮事件"] tap];
    [self.app.textViews.firstMatch typeText:@"text"];
    
    [self.app.navigationBars.firstMatch.buttons.firstMatch tap];
    XCTAssertTrue(self.app.staticTexts[@"是否返回？"].exists);
    [self.app.buttons[@"继续编辑"] tap];
    XCTAssertTrue(self.app.textViews.firstMatch.qd_hasKeyboardFocus);
    
    [self.app.navigationBars.firstMatch.buttons.firstMatch tap];
    XCTAssertTrue(self.app.staticTexts[@"是否返回？"].exists);
    [self.app.buttons[@"返回"] tap];
    XCTAssertFalse(self.app.navigationBars[@"拦截系统navBar返回按钮事件"].exists);
}

- (void)tapGridButton:(NSString *)gridButtonString {
    XCUIElement *navigationBar = self.app.navigationBars.firstMatch;
    XCUIElementQuery *navigationButtons = navigationBar.buttons;
    XCUIElement *backButton = [navigationButtons elementBoundByIndex:0];
    while (![navigationBar.identifier isEqualToString:@"QMUIKit"]) {
        [backButton tap];
    }
    [self.app.scrollViews.otherElements.buttons[gridButtonString] tap];
    XCTAssertTrue(self.app.navigationBars[gridButtonString].exists);
}

@end
