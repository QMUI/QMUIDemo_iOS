//
//  QDUIHelper.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDUIHelper.h"

@implementation QDUIHelper

+ (void)forceInterfaceOrientationPortrait {
    [QMUIHelper rotateToDeviceOrientation:UIDeviceOrientationPortrait];
}

@end


@implementation QDUIHelper (QMUIMoreOperationAppearance)

+ (void)customMoreOperationAppearance {
    // 如果需要统一修改全局的 QMUIMoreOperationController 样式，在这里修改 appearance 的值即可
    [QMUIMoreOperationController appearance].cancelButtonTitleColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
}

@end


@implementation QDUIHelper (QMUIAlertControllerAppearance)

+ (void)customAlertControllerAppearance {
    // 如果需要统一修改全局的 QMUIAlertController 样式，在这里修改 appearance 的值即可
}

@end

@implementation QDUIHelper (QMUIDialogViewControllerAppearance)

+ (void)customDialogViewControllerAppearance {
    // 如果需要统一修改全局的 QMUIDialogViewController 样式，在这里修改 appearance 的值即可
    QMUIDialogViewController *appearance = [QMUIDialogViewController appearance];
    
    NSMutableDictionary<NSString *, id> *buttonTitleAttributes = [appearance.buttonTitleAttributes mutableCopy];
    buttonTitleAttributes[NSForegroundColorAttributeName] = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    appearance.buttonTitleAttributes = [buttonTitleAttributes copy];
    
    appearance.buttonHighlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor colorWithAlphaComponent:.25];
}

@end


@implementation QDUIHelper (QMUIEmotionView)

+ (void)customEmotionViewAppearance {
    [QMUIEmotionView appearance].emotionSize = CGSizeMake(24, 24);
    [QMUIEmotionView appearance].minimumEmotionHorizontalSpacing = 14;
    [QMUIEmotionView appearance].sendButtonBackgroundColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
}

@end


@implementation QDUIHelper (UITabBarItem)

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
    return tabBarItem;
}

@end


@implementation QDUIHelper (Button)

+ (QMUIButton *)generateDarkFilledButton {
    QMUIButton *button = [[QMUIButton alloc] qmui_initWithSize:CGSizeMake(200, 40)];
    button.adjustsButtonWhenHighlighted = YES;
    button.titleLabel.font = UIFontBoldMake(14);
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.backgroundColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    button.highlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor qmui_transitionToColor:UIColorBlack progress:.15];// 高亮时的背景色
    button.layer.cornerRadius = 4;
    return button;
}

+ (QMUIButton *)generateLightBorderedButton {
    QMUIButton *button = [[QMUIButton alloc] qmui_initWithSize:CGSizeMake(200, 40)];
    button.titleLabel.font = UIFontBoldMake(14);
    [button setTitleColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor forState:UIControlStateNormal];
    button.backgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor qmui_transitionToColor:UIColorWhite progress:.9];
    button.highlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor qmui_transitionToColor:UIColorWhite progress:.75];// 高亮时的背景色
    button.layer.borderColor = [button.backgroundColor qmui_transitionToColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor progress:.5].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4;
    button.highlightedBorderColor = [button.backgroundColor qmui_transitionToColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor progress:.9];// 高亮时的边框颜色
    return button;
}

@end


@implementation QDUIHelper (Emotion)

NSString *const QMUIEmotionString = @"01-[微笑];02-[开心];03-[生气];04-[委屈];05-[亲亲];06-[坏笑];07-[鄙视];08-[啊]";

static NSArray<QMUIEmotion *> *QMUIEmotionArray;

+ (NSArray<QMUIEmotion *> *)qmuiEmotions {
    if (QMUIEmotionArray) {
        return QMUIEmotionArray;
    }
    
    NSMutableArray<QMUIEmotion *> *emotions = [[NSMutableArray alloc] init];
    NSArray<NSString *> *emotionStringArray = [QMUIEmotionString componentsSeparatedByString:@";"];
    for (NSString *emotionString in emotionStringArray) {
        NSArray<NSString *> *emotionItem = [emotionString componentsSeparatedByString:@"-"];
        NSString *identifier = [NSString stringWithFormat:@"emotion_%@", emotionItem.firstObject];
        QMUIEmotion *emotion = [QMUIEmotion emotionWithIdentifier:identifier displayName:emotionItem.lastObject];
        [emotions addObject:emotion];
    }
    
    QMUIEmotionArray = [NSArray arrayWithArray:emotions];
    [self asyncLoadImages:emotions];
    return QMUIEmotionArray;
}

// 在子线程预加载
+ (void)asyncLoadImages:(NSArray<QMUIEmotion *> *)emotions {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (QMUIEmotion *e in emotions) {
            e.image = [UIImageMake(e.identifier) qmui_imageWithBlendColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor];
        }
    });
}

+ (void)updateEmotionImages {
    [self asyncLoadImages:[self qmuiEmotions]];
}

@end


@implementation QDUIHelper (SavePhoto)

+ (void)showAlertWhenSavedPhotoFailureByPermissionDenied {
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"无法保存" message:@"你未开启“允许 QMUI 访问照片”选项" preferredStyle:QMUIAlertControllerStyleAlert];
    
    QMUIAlertAction *settingAction = [QMUIAlertAction actionWithTitle:@"去设置" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        NSURL *url = [[NSURL alloc] initWithString:@"prefs:root=Privacy&path=PHOTOS"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alertController addAction:settingAction];
    
    QMUIAlertAction *okAction = [QMUIAlertAction actionWithTitle:@"我知道了" style:QMUIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    
    [alertController showWithAnimated:YES];
}

@end


@implementation QDUIHelper (Calculate)

+ (NSString *)humanReadableFileSize:(long long)size {
    NSString * strSize = nil;
    if (size >= 1048576.0) {
        strSize = [NSString stringWithFormat:@"%.2fM", size / 1048576.0f];
    } else if (size >= 1024.0) {
        strSize = [NSString stringWithFormat:@"%.2fK", size / 1024.0f];
    } else {
        strSize = [NSString stringWithFormat:@"%.2fB", size / 1.0f];
    }
    return strSize;
}

@end


@implementation QDUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color {
    CGSize size = CGSizeMake(4, 88);// iPhone X，navigationBar 背景图 88，所以直接用 88 的图，其他手机会取这张图在 y 轴上的 0-64 部分的图片
    UIImage *resultImage = nil;
    color = color ? color : UIColorClear;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (CFArrayRef)@[(id)color.CGColor, (id)[color qmui_colorWithAlphaAddedToWhite:.86].CGColor], NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, size.height), kCGGradientDrawsBeforeStartLocation);
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    return [resultImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
}

@end


@implementation NSString (Code)

- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *, NSRange))block {
    NSString *pattern = @"\\[?[A-Za-z0-9_.]+\\s?[A-Za-z0-9_:.]+\\]?";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.length > 0) {
            if (block) {
                block([self substringWithRange:result.range], result.range);
            }
        }
    }];
}

@end
