//
//  QDImagePickerExampleViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDImagePickerExampleViewController.h"
#import "QDNavigationController.h"

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@interface QDImagePickerExampleViewController ()

@property(nonatomic, strong) UIImage *selectedAvatarImage;

@end

@implementation QDImagePickerExampleViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"选图控件使用示例", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"默认", @"选图控件包含相册列表，选图，预览大图三个界面",
                                     @"自定义", @"修改选图界面列数，预览大图界面 TopBar 背景色",
                                     nil],
                       @"通过重载进行添加 subview 等较大型的改动", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                     @"选择多张图片", @"模拟聊天发图，预览大图界面增加底部工具栏",
                                                     @"选择单张图片", @"模拟设置头像，预览大图界面右上角增加按钮",
                                                     nil],
                       nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self authorizationPresentAlbumViewControllerWithTitle:title];
}

- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    if ([title isEqualToString:@"选择单张图片"]) {
        albumViewController.view.tag = SingleImagePickingTag;
    } else if ([title isEqualToString:@"选择多张图片"]) {
        albumViewController.view.tag = MultipleImagePickingTag;
    } else if ([title isEqualToString:@"调整界面"]) {
        albumViewController.view.tag = ModifiedImagePickingTag;
        albumViewController.albumTableViewCellHeight = 70;
    } else {
        albumViewController.view.tag = NormalImagePickingTag;
    }
    
    QDNavigationController *navigationController = [[QDNavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *title = [self keyNameAtIndexPath:indexPath];
    if ([title isEqualToString:@"选择单张图片"]) {
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        accessoryView.layer.borderColor = UIColorSeparator.CGColor;
        accessoryView.layer.borderWidth = PixelOne;
        accessoryView.contentMode = UIViewContentModeScaleAspectFill;
        accessoryView.clipsToBounds = YES;
        accessoryView.image = self.selectedAvatarImage;
        cell.accessoryView = accessoryView;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - <QMUIAlbumViewControllerDelegate>

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    if (albumViewController.view.tag == SingleImagePickingTag) {
        imagePickerViewController.allowsMultipleSelection = NO;
    }
    if (albumViewController.view.tag == ModifiedImagePickingTag) {
        imagePickerViewController.minimumImageWidth = 65;
    }
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    if (imagePickerViewController.view.tag == MultipleImagePickingTag) {
        QDMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDMultipleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.maximumSelectImageCount = MaxSelectedImageCount;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == SingleImagePickingTag) {
        QDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDSingleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == ModifiedImagePickingTag) {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        imagePickerPreviewViewController.toolBarBackgroundColor = UIColorMake(66, 66, 66);
        return imagePickerPreviewViewController;
    } else {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    }
}

#pragma mark - <QMUIImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    if (imagePickerPreviewViewController.view.tag == MultipleImagePickingTag) {
        // 在预览界面选择图片时，控制显示当前所选的图片，并且展示动画
        QDMultipleImagePickerPreviewViewController *customImagePickerPreviewViewController = (QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController;
        NSUInteger selectedCount = [imagePickerPreviewViewController.selectedImageAssetArray count];
        if (selectedCount > 0) {
            customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
            customImagePickerPreviewViewController.imageCountLabel.hidden = NO;
            [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:customImagePickerPreviewViewController.imageCountLabel];
        } else {
            customImagePickerPreviewViewController.imageCountLabel.hidden = YES;
        }
    }
}

#pragma mark - <QDMultipleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    // 显示 loading
    [self startLoading];
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGif, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        [self performSelector:@selector(setAvatarWithAvatarImage:) withObject:targetImage afterDelay:1.8];
    }];
}

#pragma mark - 业务方法

- (void)startLoading {
    [QMUITips showLoadingInView:self.view];
}

- (void)startLoadingWithText:(NSString *)text {
    [QMUITips showLoading:text inView:self.view];
}

- (void)stopLoading {
    [QMUITips hideAllToastInView:self.view animated:YES];
}

- (void)showTipLabelWithText:(NSString *)text {
    [self stopLoading];
    [QMUITips showWithText:text inView:self.view hideAfterDelay:1.0];
}

- (void)hideTipLabel {
    [QMUITips hideAllToastInView:self.view animated:YES];
}

- (void)sendImageWithImagesAssetArrayIfDownloadStatusSucceed:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    if ([QMUIImagePickerHelper imageAssetsDownloaded:imagesAssetArray]) {
        // 所有资源从 iCloud 下载成功，模拟发送图片到服务器
        // 显示发送中
        [self showTipLabelWithText:@"发送中"];
        // 使用 delay 模拟网络请求时长
        [self performSelector:@selector(showTipLabelWithText:) withObject:[NSString stringWithFormat:@"成功发送%@个资源", @([imagesAssetArray count])] afterDelay:1.5];
    }
}

- (void)sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    __weak __typeof(self)weakSelf = self;
    
    for (QMUIAsset *asset in imagesAssetArray) {
        [QMUIImagePickerHelper requestImageAssetIfNeeded:asset completion:^(QMUIAssetDownloadStatus downloadStatus, NSError *error) {
            if (downloadStatus == QMUIAssetDownloadStatusDownloading) {
                [weakSelf startLoadingWithText:@"从 iCloud 加载中"];
            } else if (downloadStatus == QMUIAssetDownloadStatusSucceed) {
                [weakSelf sendImageWithImagesAssetArrayIfDownloadStatusSucceed:imagesAssetArray];
            } else {
                [weakSelf showTipLabelWithText:@"iCloud 下载错误，请重新选图"];
            }
        }];
    }
}

- (void)setAvatarWithAvatarImage:(UIImage *)avatarImage {
    [self stopLoading];
    self.selectedAvatarImage = avatarImage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
