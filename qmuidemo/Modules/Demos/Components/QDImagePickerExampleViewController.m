//
//  QDImagePickerExampleViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDImagePickerExampleViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSString * const kSectionTitleForAppearance = @"选图控件使用示例";
static NSString * const kSectionTitleForOverride = @"通过重载进行添加 subview 等较大型的改动";

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface QDImagePickerExampleViewController ()

@end

@implementation QDImagePickerExampleViewController {
    UIActivityIndicatorView *_indicatorView;
    QMUILabel *_tipLabel;
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       kSectionTitleForAppearance, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                    @"默认", @"选图控件包含相册列表，选图，预览大图三个界面",
                                                    @"自定义", @"修改选图界面列数，预览大图界面 TopBar 背景色",
                                                     nil],
                       kSectionTitleForOverride, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                  @"选择多张图片", @"模拟聊天发图，预览大图界面增加底部工具栏",
                                                  @"选择单张图片", @"模拟设置头像，预览大图界面右上角增加按钮",
                                                   nil],
                       nil];
}

- (void)initSubviews {
    [super initSubviews];
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray size:CGSizeMake(25, 25)];
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    [self.view addSubview:_indicatorView];
    
    _tipLabel = [[QMUILabel alloc] init];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    _tipLabel.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .65f);
    _tipLabel.textColor = UIColorWhite;
    _tipLabel.layer.cornerRadius = 4;
    _tipLabel.layer.masksToBounds = YES;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self authorizationPresentAlbumViewControllerWithTitle:title];
}

- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    // 请求访问照片库的权限，在 iOS8 或以上版本中可以利用这个方法弹出 Alert 询问用户是否授权
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            [self presentAlbumViewControllerWithTitle:title];
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
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
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];
    // 获取最近发送图片时使用过的相册
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    // 如果有最近使用过的相册，则直接进入该相册
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    
    /**
     *  requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，
     *  因此 UI 相关的操作强制放在主流程执行。
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController animated:YES completion:NULL];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _indicatorView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *title = [self keyNameAtIndexPath:indexPath];
    if ([title isEqualToString:@"选择单张图片"]) {
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        accessoryView.layer.borderColor = UIColorGray.CGColor;
        accessoryView.layer.borderWidth = PixelOne;
        accessoryView.contentMode = UIViewContentModeScaleAspectFill;
        accessoryView.clipsToBounds = YES;
        accessoryView.hidden = YES;
        cell.accessoryView = accessoryView;
    } else {
        cell.accessoryView = nil;
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
    // 显示 loading
    [self startLoading];
    // 使用 delay 模拟网络请求时长
    [self performSelector:@selector(showTipLabelWithText:) withObject:[NSString stringWithFormat:@"成功发送%lu张图片", (unsigned long)[imagesAssetArray count]] afterDelay:1.5];
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
            customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", (long)selectedCount];
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
    // 显示 loading
    [self startLoading];
    // 使用 delay 模拟网络请求时长
    NSString *succeedTip;
    if (imagePickerPreviewViewController.shouldUseOriginImage) {
        succeedTip = @"成功发送%lu张原图";
    } else {
        succeedTip = @"成功发送%lu张图片";
    }
    [self performSelector:@selector(showTipLabelWithText:) withObject:[NSString stringWithFormat:succeedTip, (unsigned long)[imagesAssetArray count]] afterDelay:1.5];
}

#pragma mark - <QDSingleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    // 显示 loading
    [self startLoading];
    [self performSelector:@selector(setAvatarWithAvatarImage:) withObject:[imageAsset previewImage] afterDelay:1.8];
}

#pragma mark - 业务方法

- (void)startLoading {
    if (![_indicatorView isAnimating]) {
        [_indicatorView startAnimating];
        [self.view bringSubviewToFront:_indicatorView];
    }
}

- (void)stopLoading {
    if ([_indicatorView isAnimating]) {
        [_indicatorView stopAnimating];
    }
}

- (void)showTipLabelWithText:(NSString *)text {
    [self stopLoading];
    _tipLabel.text = text;
    [_tipLabel sizeToFit];
    _tipLabel.frame = CGRectSetXY(_tipLabel.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(_tipLabel.frame)), CGFloatGetCenter(CGRectGetHeight(self.view.bounds), CGRectGetHeight(_tipLabel.frame)) - 20);
    _tipLabel.alpha = 0;
    _tipLabel.hidden = NO;
    [self.view bringSubviewToFront:_tipLabel];
    [UIView animateWithDuration:.25f
                     animations:^(void) {
                         _tipLabel.alpha = 1;
                     } completion:^(BOOL finished) {
                         NSTimeInterval delay = 1.0;
                         // 显示提示框1秒后自动隐藏提示框
                         [self performSelector:@selector(hideTipLabel) withObject:nil afterDelay:delay];
                     }];
}

- (void)hideTipLabel {
    [UIView animateWithDuration:.2f
                     animations:^(void) {
                         _tipLabel.alpha = 0;
                     } completion:^(BOOL finished) {
                         _tipLabel.hidden = YES;
                     }];
}

- (void)setAvatarWithAvatarImage:(UIImage *)avatarImage {
    [self stopLoading];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *accessoryImageView = (UIImageView *)cell.accessoryView;
    accessoryImageView.hidden = NO;
    [accessoryImageView setImage:avatarImage];
}

@end
