//
//  QDSaveImageToSpecifiedAlbumViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/6/9.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDSaveImageToSpecifiedAlbumViewController.h"
#import "QDUIHelper.h"

#define TestImageSize CGSizeMake(160, 160)

@implementation QDSaveImageToSpecifiedAlbumViewController {
    QMUIButton *_changeImageButton;
    QMUIButton *_saveButton;
    QMUIAlertController *_alertController;
    UIImageView *_testImageView;
    
    NSArray *_textArray;
    NSMutableArray *_albumsArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _textArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
        _albumsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    _testImageView = [[UIImageView alloc] init];
    [_testImageView setImage:[self randomImage]];
    [self.view addSubview:_testImageView];
    
    // 普通按钮
    _changeImageButton = [QDUIHelper generateLightBorderedButton];
    [_changeImageButton setTitle:@"更换随机图片" forState:UIControlStateNormal];
    [_changeImageButton addTarget:self action:@selector(handleGeneratedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeImageButton];
    
    // 边框按钮
    _saveButton = [QDUIHelper generateDarkFilledButton];
    [_saveButton setTitle:@"保存图片到指定相册" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(handleSaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = self.qmui_navigationBarMaxYInViewCoordinator;
    
    _testImageView.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), TestImageSize.width), contentMinY + 60, TestImageSize.width, TestImageSize.height);
    _changeImageButton.frame = CGRectSetXY(_changeImageButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(_changeImageButton.frame)), CGRectGetMaxY(_testImageView.frame) + 50);
    _saveButton.frame = CGRectSetY(_changeImageButton.frame, CGRectGetMaxY(_changeImageButton.frame) + 30);
}

- (UIImage *)imageFromText:(NSString *)text textColor:(UIColor *)textColor {
    UIFont *font = UIFontMake(95);
    NSDictionary *fontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    CGSize size = [text sizeWithAttributes:fontAttributes];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:fontAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)randomText {
    NSInteger index = arc4random() % [_textArray count];
    NSString *text = [_textArray objectAtIndex:index];
    return text;
}

- (UIImage *)randomImage {
    UIImage *resultImage = [self imageFromText:[self randomText] textColor:UIColorWhite];
    UIImage *resultBackgroundImage = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(TestImageSize.width, TestImageSize.height) tintColor:[QDCommonUI randomThemeColor]];
    resultImage = [resultBackgroundImage qmui_imageWithImageAbove:resultImage atPoint:CGPointMake(CGFloatGetCenter(resultBackgroundImage.size.width, resultImage.size.width), CGFloatGetCenter(resultBackgroundImage.size.height, resultImage.size.height))];
    return resultImage;
}

- (void)handleGeneratedButtonClick:(id)sender {
    [_testImageView setImage:[self randomImage]];
}

- (void)saveImageToAlbum {
    if (!_alertController) {
        _alertController = [QMUIAlertController alertControllerWithTitle:@"保存到指定相册" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        // 显示空相册，不显示智能相册
        [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:QMUIAlbumContentTypeAll showEmptyAlbum:YES showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
            if (resultAssetsGroup) {
                [_albumsArray addObject:resultAssetsGroup];
                QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:[resultAssetsGroup name] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                    QMUIImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(_testImageView.image, resultAssetsGroup, ^(QMUIAsset *asset, NSError *error) {
                        if (asset) {
                            [QMUITips showSucceed:[NSString stringWithFormat:@"已保存到相册-%@", [resultAssetsGroup name]] inView:self.navigationController.view hideAfterDelay:2];
                        }
                    });
                }];
                [_alertController addAction:action];
            } else {
                QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
                [_alertController addAction:cancelAction];
            }
        }];
    }
    [_alertController showWithAnimated:YES];
}

- (void)handleSaveButtonClick:(id)sender {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            // requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，因此涉及 UI 相关的操作需要手工放置到主流程执行。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == QMUIAssetAuthorizationStatusAuthorized) {
                    [self saveImageToAlbum];
                } else {
                    [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
                }
            });
        }];
    } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized) {
        [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
    } else {
        [self saveImageToAlbum];
    }
}

@end
