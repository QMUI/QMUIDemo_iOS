//
//  QMUIConfigurationTemplate.m
//  qmui
//
//  Created by QQMail on 15/3/29.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QMUIConfigurationTemplate.h"
#import <QMUIKit/QMUIKit.h>

@implementation QMUIConfigurationTemplate

+ (void)setupConfigurationTemplate {
    
    // === 修改配置值 === //
    
    #pragma mark - Global Color
    
    //- QMUICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];                                  // UIColorClear
    //- QMUICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];                                  // UIColorWhite
    //- QMUICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];                                  // UIColorBlack
    //- QMUICMI.grayColor = UIColorMake(179, 179, 179);                             // UIColorGray
    //- QMUICMI.grayDarkenColor = UIColorMake(163, 163, 163);                       // UIColorGrayDarken
    //- QMUICMI.grayLightenColor = UIColorMake(198, 198, 198);                      // UIColorGrayLighten
    QMUICMI.redColor = UIColorMake(250, 58, 58);                                // UIColorRed
    //- QMUICMI.greenColor = UIColorMake(79, 214, 79);                              // UIColorGreen
    QMUICMI.blueColor = UIColorMake(49, 189, 243);                              // UIColorBlue
    //- QMUICMI.yellowColor = UIColorMake(255, 252, 233);                           // UIColorYellow
    
    //- QMUICMI.linkColor = UIColorMake(56, 116, 171);                              // UIColorLink : 文字连接颜色
    //- QMUICMI.disabledColor = UIColorGray;                                        // UIColorDisabled : 全局disabled的颜色
    //- QMUICMI.backgroundColor = UIColorMake(246, 246, 246);                       // UIColorForBackground : 全局背景色，用于viewController的背景色
    //- QMUICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);                 // UIColorMask : 深色的mask遮罩
    //- QMUICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);           // UIColorMaskWhite : 浅色的mask遮罩
    QMUICMI.separatorColor = UIColorMake(222, 224, 226);                        // UIColorSeparator : 全局分割线的颜色
    //- QMUICMI.separatorDashedColor = UIColorMake(17, 17, 17);                     // UIColorSeparatorDashed : 虚线的颜色
    QMUICMI.placeholderColor = UIColorGray8;                      // UIColorPlaceholder，全局的输入框的placeholder颜色
    
    // UIColorTestRed/UIColorTestGreen/UIColorTestBlue  =  测试用的颜色
    //- QMUICMI.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
    //- QMUICMI.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
    //- QMUICMI.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
    
    
#pragma mark - UIControl
    
    //- QMUICMI.controlHighlightedAlpha = 0.5f;                                                 // UIControlHighlightedAlpha : 全局的highlighted alpha值
    //- QMUICMI.controlDisabledAlpha = 0.5f;                                                    // UIControlDisabledAlpha : 全局的disabled alpha值
    
#pragma mark - UIButton
    //- QMUICMI.buttonHighlightedAlpha = UIControlHighlightedAlpha;                             // ButtonHighlightedAlpha : 按钮的highlighted alpha值
    //- QMUICMI.buttonDisabledAlpha = UIControlDisabledAlpha;                                   // ButtonDisabledAlpha : 按钮的disabled alpha值
    QMUICMI.buttonTintColor = UIColorBlue;                                                  // ButtonTintColor : 按钮默认的tintColor
    
    QMUICMI.ghostButtonColorBlue = UIColorBlue;                                             // GhostButtonColorBlue
    QMUICMI.ghostButtonColorRed = UIColorRed;                                               // GhostButtonColorRed
    //- QMUICMI.ghostButtonColorGreen = UIColorGreen;                                           // GhostButtonColorGreen
    //- QMUICMI.ghostButtonColorGray = UIColorGray;                                             // GhostButtonColorGray
    //- QMUICMI.ghostButtonColorWhite = UIColorWhite;                                           // GhostButtonColorWhite
    
    QMUICMI.fillButtonColorBlue = UIColorBlue;                                             // FillButtonColorBlue
    QMUICMI.fillButtonColorRed = UIColorRed;                                               // FillButtonColorRed
    //- QMUICMI.fillButtonColorGreen = UIColorGreen;                                           // FillButtonColorGreen
    //- QMUICMI.fillButtonColorGray = UIColorGray;                                             // FillButtonColorGray
    //- QMUICMI.fillButtonColorWhite = UIColorWhite;
    
    
#pragma mark - TextField & TextView
    QMUICMI.textFieldTintColor = UIColorBlue;                                               // TextFieldTintColor : 全局UITextField、UITextView的tintColor
    //- QMUICMI.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);                             // TextFieldTextInsets : QMUITextField的内边距
    
#pragma mark - NavigationBar
    
    //- QMUICMI.navBarHighlightedAlpha = 0.2f;                                          // NavBarHighlightedAlpha
    //- QMUICMI.navBarDisabledAlpha = 0.2f;                                             // NavBarDisabledAlpha
    //- QMUICMI.navBarButtonFont = UIFontMake(17);                                      // NavBarButtonFont
    //- QMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                              // NavBarButtonFontBold
    QMUICMI.navBarBackgroundImage = [UIImageMake(@"navigationbar_background") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];                                            // NavBarBackgroundImage
    QMUICMI.navBarShadowImage = [UIImage new];                                                // NavBarShadowImage
    //- QMUICMI.navBarBarTintColor = nil;                                               // NavBarBarTintColor
    QMUICMI.navBarTintColor = UIColorWhite;                                         // NavBarTintColor
    QMUICMI.navBarTitleColor = NavBarTintColor;                                     // NavBarTitleColor
    //- QMUICMI.navBarTitleFont = UIFontBoldMake(17);                                   // NavBarTitleFont
    //- QMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;                 // NavBarBarBackButtonTitlePositionAdjustment
    QMUICMI.navBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];    // NavBarBackIndicatorImage
    QMUICMI.navBarCloseButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage
    
    //- QMUICMI.navBarLoadingMarginRight = 3;                                           // NavBarLoadingMarginRight
    //- QMUICMI.navBarAccessoryViewMarginLeft = 5;                                      // NavBarAccessoryViewMarginLeft
    //- QMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;    // NavBarActivityIndicatorViewStyle
    //- QMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];     // NavBarAccessoryViewTypeDisclosureIndicatorImage
    
#pragma mark - TabBar
    
    QMUICMI.tabBarBackgroundImage = [UIImage qmui_imageWithColor:UIColorMake(249, 249, 249)];                                                            // TabBarBackgroundImage
    //- QMUICMI.tabBarBarTintColor = nil;    // TabBarBarTintColor
    QMUICMI.tabBarShadowImageColor = UIColorSeparator;                                    // TabBarShadowImageColor
    QMUICMI.tabBarTintColor = UIColorMake(4, 189, 231);                                            // TabBarTintColor
    QMUICMI.tabBarItemTitleColor = UIColorGray6;                                      // TabBarItemTitleColor
    QMUICMI.tabBarItemTitleColorSelected = TabBarTintColor;                                         // TabBarItemTitleColorSelected
    
#pragma mark - Toolbar
    
    //- QMUICMI.toolBarHighlightedAlpha = 0.4f;                                                                         // ToolBarHighlightedAlpha
    //- QMUICMI.toolBarDisabledAlpha = 0.4f;                                                                            // ToolBarDisabledAlpha
    QMUICMI.toolBarTintColor = UIColorBlue;                                                                         // ToolBarTintColor
    //- QMUICMI.toolBarTintColorHighlighted = [ToolBarTintColor colorWithAlphaComponent:ToolBarHighlightedAlpha];       // ToolBarTintColorHighlighted
    //- QMUICMI.toolBarTintColorDisabled = [ToolBarTintColor colorWithAlphaComponent:ToolBarDisabledAlpha];             // ToolBarTintColorDisabled
    //- QMUICMI.toolBarBackgroundImage = nil;                                                                           // ToolBarBackgroundImage
    //- QMUICMI.toolBarBarTintColor = nil;                                                                              // ToolBarBarTintColor
    //- QMUICMI.toolBarShadowImageColor = UIColorMake(178, 178, 178);                                                   // ToolBarShadowImageColor
    //- QMUICMI.toolBarButtonFont = UIFontMake(17);                                                                     // ToolBarButtonFont
    
#pragma mark - SearchBar
    
    //- QMUICMI.searchBarTextFieldBackground = UIColorWhite;                            // SearchBarTextFieldBackground
    //- QMUICMI.searchBarTextFieldBorderColor = UIColorMake(205, 208, 210);             // SearchBarTextFieldBorderColor
    //- QMUICMI.searchBarBottomBorderColor = UIColorMake(205, 208, 210);                // SearchBarBottomBorderColor
    //- QMUICMI.searchBarBarTintColor = UIColorMake(247, 247, 247);                     // SearchBarBarTintColor
    QMUICMI.searchBarTintColor = UIColorBlue;                                       // SearchBarTintColor
    //- QMUICMI.searchBarTextColor = UIColorBlack;                                      // SearchBarTextColor
    QMUICMI.searchBarPlaceholderColor = UIColorPlaceholder;                         // SearchBarPlaceholderColor
    //- QMUICMI.searchBarSearchIconImage = nil;                                         // SearchBarSearchIconImage
    //- QMUICMI.searchBarClearIconImage = nil;                                          // SearchBarClearIconImage
    //- QMUICMI.searchBarTextFieldCornerRadius = 2.0;                                   // SearchBarTextFieldCornerRadius
    
#pragma mark - TableView / TableViewCell
    
    //- QMUICMI.tableViewBackgroundColor = UIColorWhite;                                    // TableViewBackgroundColor
    //- QMUICMI.tableViewGroupedBackgroundColor = UIColorForBackground;                     // TableViewGroupedBackgroundColor
    //- QMUICMI.tableSectionIndexColor = UIColorGrayDarken;                                 // TableSectionIndexColor
    //- QMUICMI.tableSectionIndexBackgroundColor = UIColorClear;                            // TableSectionIndexBackgroundColor
    //- QMUICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;                    // TableSectionIndexTrackingBackgroundColor
    QMUICMI.tableViewSeparatorColor = UIColorSeparator;                                 // TableViewSeparatorColor
    
    QMUICMI.tableViewCellNormalHeight = 56;                                             // TableViewCellNormalHeight
    QMUICMI.tableViewCellTitleLabelColor = UIColorGray3;                                                // TableViewCellTitleLabelColor
    QMUICMI.tableViewCellDetailLabelColor = UIColorGray5;                                                // TableViewCellDetailLabelColor
    //- QMUICMI.tableViewCellContentDefaultPaddingLeft = 15;                                                // TableViewCellContentDefaultPaddingLeft
    //- QMUICMI.tableViewCellContentDefaultPaddingRight = 10;                                               // TableViewCellContentDefaultPaddingRight
    //- QMUICMI.tableViewCellBackgroundColor = UIColorWhite;                                // TableViewCellBackgroundColor
    QMUICMI.tableViewCellSelectedBackgroundColor = UIColorMake(238, 239, 241);;          // TableViewCellSelectedBackgroundColor
    //- QMUICMI.tableViewCellWarningBackgroundColor = UIColorYellow;                        // TableViewCellWarningBackgroundColor
    QMUICMI.tableViewCellDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(173, 180, 190)];       // TableViewCellDisclosureIndicatorImage
    QMUICMI.tableViewCellCheckmarkImage = [UIImage qmui_imageWithShape:QMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:UIColorBlue];     // TableViewCellCheckmarkImage
    
    //- QMUICMI.tableViewSectionHeaderBackgroundColor = UIColorMake(244, 244, 244);                         // TableViewSectionHeaderBackgroundColor
    //- QMUICMI.tableViewSectionFooterBackgroundColor = UIColorMake(244, 244, 244);                         // TableViewSectionFooterBackgroundColor
    //- QMUICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);                                            // TableViewSectionHeaderFont
    //- QMUICMI.tableViewSectionFooterFont = UIFontBoldMake(12);                                            // TableViewSectionFooterFont
    //- QMUICMI.tableViewSectionHeaderTextColor = UIColorGrayDarken;                                        // TableViewSectionHeaderTextColor
    //- QMUICMI.tableViewSectionFooterTextColor = UIColorGray;                                              // TableViewSectionFooterTextColor
    //- QMUICMI.tableViewSectionHeaderHeight = 20;                                                          // TableViewSectionHeaderHeight
    //- QMUICMI.tableViewSectionFooterHeight = 0;                                                           // TableViewSectionFooterHeight
    //- QMUICMI.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionHeaderContentInset
    //- QMUICMI.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionFooterContentInset
    
    //- QMUICMI.tableViewGroupedSectionHeaderFont = UIFontMake(12);                                         // TableViewGroupedSectionHeaderFont
    //- QMUICMI.tableViewGroupedSectionFooterFont = UIFontMake(12);                                         // TableViewGroupedSectionFooterFont
    //- QMUICMI.tableViewGroupedSectionHeaderTextColor = UIColorGrayDarken;                                 // TableViewGroupedSectionHeaderTextColor
    //- QMUICMI.tableViewGroupedSectionFooterTextColor = UIColorGray;                                       // TableViewGroupedSectionFooterTextColor
    //- QMUICMI.tableViewGroupedSectionHeaderHeight = 15;                                                   // TableViewGroupedSectionHeaderHeight
    //- QMUICMI.tableViewGroupedSectionFooterHeight = 1;                                                    // TableViewGroupedSectionFooterHeight
    QMUICMI.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, PreferredVarForDevices(20, 15, 15, 15), 8, PreferredVarForDevices(20, 15, 15, 15));                // TableViewGroupedSectionHeaderContentInset
    //- QMUICMI.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);                 // TableViewGroupedSectionFooterContentInset
    
#pragma mark - UIWindowLevel
    //- QMUICMI.windowLevelQMUIAlertView = UIWindowLevelAlert - 4.0;                    // UIWindowLevelQMUIAlertView
    //- QMUICMI.windowLevelQMUIImagePreviewView = UIWindowLevelStatusBar + 1.0;              // UIWindowLevelQMUIImagePreviewView
    
#pragma mark - Others
    
    QMUICMI.supportedOrientationMask = UIInterfaceOrientationMaskAll;  // SupportedOrientationMask : 默认支持的横竖屏方向
    QMUICMI.statusbarStyleLightInitially = YES;          // StatusbarStyleLightInitially : 默认的状态栏内容是否使用白色，默认为NO，也即黑色
    //- QMUICMI.needsBackBarButtonItemTitle = NO;           // NeedsBackBarButtonItemTitle : 全局是否需要返回按钮的title，不需要则只显示一个返回image
    //- QMUICMI.hidesBottomBarWhenPushedInitially = YES;    // HidesBottomBarWhenPushedInitially : QMUICommonViewController.hidesBottomBarWhenPushed的初始值，默认为YES
}

@end
