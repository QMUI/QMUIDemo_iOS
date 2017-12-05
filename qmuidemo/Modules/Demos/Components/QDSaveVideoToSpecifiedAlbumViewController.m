//
//  QDSaveVideoToSpecifiedAlbumViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/6/10.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDSaveVideoToSpecifiedAlbumViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface QDSaveVideoToSpecifiedAlbumViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,copy) NSString *videoPath;
@end

@implementation QDSaveVideoToSpecifiedAlbumViewController {
    QMUIButton *_takeVideoButton;
    UIImagePickerController *_pickerController;
    QMUIAlertController *_actionSheet;
    
    NSMutableArray *_albumsArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _albumsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"保存视频到指定相册";
}

- (void)initSubviews {
    [super initSubviews];
    _takeVideoButton = [QDUIHelper generateLightBorderedButton];
    [_takeVideoButton setTitle:@"拍摄视频" forState:UIControlStateNormal];
    [_takeVideoButton addTarget:self action:@selector(handleTakeVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takeVideoButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _takeVideoButton.frame = CGRectSetXY(_takeVideoButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(_takeVideoButton.frame)), CGFloatGetCenter(CGRectGetHeight(self.view.bounds), CGRectGetHeight(_takeVideoButton.frame)));
}

- (void)saveVideoToAlbumWithMediaInfo:(NSDictionary *)info {
    if (!_actionSheet) {
        _actionSheet = [QMUIAlertController alertControllerWithTitle:@"保存到指定相册" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        
        // 显示空相册，不显示智能相册
        [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:QMUIAlbumContentTypeAll showEmptyAlbum:YES showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
            if (resultAssetsGroup) {
                [_albumsArray addObject:resultAssetsGroup];
                __weak typeof(self) weakSelf = self;
                QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:[resultAssetsGroup name] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(weakSelf.videoPath)) {
                        QMUISaveVideoAtPathToSavedPhotosAlbumWithAlbumAssetsGroup(weakSelf.videoPath, resultAssetsGroup, ^(QMUIAsset *asset, NSError *error) {
                            [QMUITips showSucceed:[NSString stringWithFormat:@"已保存到相册-%@", [resultAssetsGroup name]] inView:self.navigationController.view hideAfterDelay:2];
                        });
                    } else {
                        [QMUITips showError:@"保存失败，视频格式不符合当前设备要求" inView:self.view hideAfterDelay:2];
                    }
                }];
                [_actionSheet addAction:action];
            } else {
                // group 为 nil，即遍历相册完毕
                QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
                [_actionSheet addAction:cancelAction];
            }
        }];
    }
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    self.videoPath = [videoURL path];
    [_actionSheet showWithAnimated:YES];
}

- (void)handleTakeVideoButtonClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_pickerController) {
            _pickerController = [[UIImagePickerController alloc] init];
            _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];;
            _pickerController.delegate = self;
        }
        
        [self presentViewController:_pickerController animated:YES completion:^(void) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [QMUITips showError:@"检测不到该设备中有可使用的摄像头" inView:self.view hideAfterDelay:2];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
            [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
                // requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，因此涉及 UI 相关的操作需要手工放置到主流程执行。
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == QMUIAssetAuthorizationStatusAuthorized) {
                        [self saveVideoToAlbumWithMediaInfo:info];
                    } else {
                        [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
                    }
                });
            }];
        } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized) {
            [QDUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
        } else {
            [self saveVideoToAlbumWithMediaInfo:info];
        }
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}

@end
