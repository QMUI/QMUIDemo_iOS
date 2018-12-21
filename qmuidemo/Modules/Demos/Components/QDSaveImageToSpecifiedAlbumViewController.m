//
//  QDSaveImageToSpecifiedAlbumViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/9.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDSaveImageToSpecifiedAlbumViewController.h"
#import "QDUIHelper.h"

#define TestImageSize CGSizeMake(160, 160)

@interface QDSaveImageToSpecifiedAlbumViewController ()

@property(nonatomic, strong) QMUIButton *changeImageButton;
@property(nonatomic, strong) QMUIButton *saveButton;
@property(nonatomic, strong) QMUIAlertController *alertController;
@property(nonatomic, strong) UIImageView *testImageView;
@property(nonatomic, copy) NSArray *textArray;
@property(nonatomic, strong) NSMutableArray *albumsArray;

@end

@implementation QDSaveImageToSpecifiedAlbumViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.textArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
        self.albumsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.testImageView = [[UIImageView alloc] init];
    [self.testImageView setImage:[self randomImage]];
    [self.view addSubview:self.testImageView];
    
    // 普通按钮
    self.changeImageButton = [QDUIHelper generateLightBorderedButton];
    [self.changeImageButton setTitle:@"更换随机图片" forState:UIControlStateNormal];
    [self.changeImageButton addTarget:self action:@selector(handleGeneratedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeImageButton];
    
    // 边框按钮
    self.saveButton = [QDUIHelper generateDarkFilledButton];
    [self.saveButton setTitle:@"保存图片到指定相册" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(handleSaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
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
    
    self.testImageView.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), TestImageSize.width), contentMinY + 60, TestImageSize.width, TestImageSize.height);
    self.changeImageButton.frame = CGRectSetXY(self.changeImageButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.changeImageButton.frame)), CGRectGetMaxY(self.testImageView.frame) + 50);
    self.saveButton.frame = CGRectSetY(self.changeImageButton.frame, CGRectGetMaxY(self.changeImageButton.frame) + 30);
}

- (UIImage *)imageFromText:(NSString *)text textColor:(UIColor *)textColor {
    UIFont *font = UIFontMake(95);
    NSDictionary *fontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    CGSize size = [text sizeWithAttributes:fontAttributes];
    
    return [UIImage qmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:fontAttributes];
    }];
}

- (NSString *)randomText {
    NSInteger index = arc4random() % [self.textArray count];
    NSString *text = [self.textArray objectAtIndex:index];
    return text;
}

- (UIImage *)randomImage {
    UIImage *resultImage = [self imageFromText:[self randomText] textColor:UIColorWhite];
    UIImage *resultBackgroundImage = [UIImage qmui_imageWithShape:QMUIImageShapeOval size:CGSizeMake(TestImageSize.width, TestImageSize.height) tintColor:[QDCommonUI randomThemeColor]];
    resultImage = [resultBackgroundImage qmui_imageWithImageAbove:resultImage atPoint:CGPointMake(CGFloatGetCenter(resultBackgroundImage.size.width, resultImage.size.width), CGFloatGetCenter(resultBackgroundImage.size.height, resultImage.size.height))];
    return resultImage;
}

- (void)handleGeneratedButtonClick:(id)sender {
    [self.testImageView setImage:[self randomImage]];
}

- (void)saveImageToAlbum {
    if (!self.alertController) {
        self.alertController = [QMUIAlertController alertControllerWithTitle:@"保存到指定相册" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        // 显示空相册，不显示智能相册
        [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:QMUIAlbumContentTypeAll showEmptyAlbum:YES showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
            if (resultAssetsGroup) {
                [self.albumsArray addObject:resultAssetsGroup];
                QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:[resultAssetsGroup name] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    QMUIImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(self.testImageView.image, resultAssetsGroup, ^(QMUIAsset *asset, NSError *error) {
                        if (asset) {
                            [QMUITips showSucceed:[NSString stringWithFormat:@"已保存到相册-%@", [resultAssetsGroup name]] inView:self.navigationController.view hideAfterDelay:2];
                        }
                    });
                }];
                [self.alertController addAction:action];
            } else {
                QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
                [self.alertController addAction:cancelAction];
            }
        }];
    }
    [self.alertController showWithAnimated:YES];
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
