//
//  QMUIInteractiveDebugPanelViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/5/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QMUIInteractiveDebugPanelViewController.h"
#import "QMUIInteractiveDebugPanelItem.h"

@interface QMUIInteractiveDebugPanelViewController ()

@property(nonatomic, strong) NSMutableArray<QMUIInteractiveDebugPanelItem *> *items;
@property(nonatomic, assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat titleMarginBottom;
@end

@implementation QMUIInteractiveDebugPanelViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.items = NSMutableArray.new;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (self.isViewLoaded) {
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.padding = UIEdgeInsetsMake(20, 24, 24, 24);
    self.titleMarginBottom = 8;
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.layer.cornerRadius = 16;
    self.view.layer.borderWidth = PixelOne;
    self.view.layer.borderColor = [UIColorBlack colorWithAlphaComponent:.3].CGColor;
    __weak __typeof(self)weakSelf = self;
    self.view.qmui_hitTestBlock = ^__kindof UIView * _Nonnull(CGPoint point, UIEvent * _Nonnull event, __kindof UIView * _Nonnull originalView) {
        if (originalView == weakSelf.view) {
            // 键盘升起时点击面板的空白区域，会触发两次 hitTest，如果第一次就立马 endEditing，那么第二次进来时由于面板已经用 transform 唯一走了，所以 point 会认为在面板外面，于是 originalView 就是 nil，就会响应到 modalPresentationViewController 的 dimmingView 点击，然后导致面板消失，所以这里在 next runloop 再执行键盘降下的操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view endEditing:YES];
            });
        }
        return originalView;
    };
    
    _titleLabel = [[UILabel alloc] qmui_initWithFont:UIFontBoldMake(17) textColor:UIColor.blackColor];
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    [self.view addSubview:self.titleLabel];
    
    for (QMUIInteractiveDebugPanelItem *item in self.items) {
        [self addDebugItemViewAfterViewLoaded:item];
    }
    
    if (self.styleConfiguration) {
        self.styleConfiguration(self);
    }
}

- (void)addDebugItem:(QMUIInteractiveDebugPanelItem *)item {
    [self.items addObject:item];
    [self addDebugItemViewAfterViewLoaded:item];
}

- (void)removeDebugItem:(QMUIInteractiveDebugPanelItem *)item {
    [self.items removeObject:item];
    [item.titleLabel removeFromSuperview];
    [item.actionView removeFromSuperview];
    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}

- (void)insertDebugItem:(QMUIInteractiveDebugPanelItem *)item atIndex:(NSUInteger)index {
    [self.items insertObject:item atIndex:index];
    [self addDebugItemViewAfterViewLoaded:item];
}

- (void)removeDebugItemAtIndex:(NSUInteger)index {
    [self removeDebugItem:self.items[index]];
}

- (void)addDebugItemViewAfterViewLoaded:(QMUIInteractiveDebugPanelItem *)item {
    if (self.isViewLoaded) {
        [self.view addSubview:item.titleLabel];
        [self.view addSubview:item.actionView];
        if (item.valueGetter) item.valueGetter(item.actionView);
        [self.view setNeedsLayout];
    }
}

- (NSArray<QMUIInteractiveDebugPanelItem *> *)debugItems {
    return self.items.copy;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.titleLabel.qmui_left = self.padding.left;
    self.titleLabel.qmui_top = self.padding.top;
    
    CGFloat lastItemMaxY = self.titleLabel.qmui_bottom + self.titleMarginBottom;
    for (QMUIInteractiveDebugPanelItem *item in self.items) {
        item.titleLabel.qmui_left = self.padding.left;
        item.titleLabel.center = CGPointMake(item.titleLabel.center.x, lastItemMaxY + item.height / 2);
        item.actionView.center = CGPointMake(self.view.qmui_width - self.padding.right - CGRectGetWidth(item.actionView.frame) / 2, item.titleLabel.center.y);
        lastItemMaxY += item.height;
    }
}

- (void)presentInViewController:(UIViewController *)viewController {
    QMUIModalPresentationViewController *modal = [[QMUIModalPresentationViewController alloc] init];
    modal.contentViewController = self;
    modal.maximumContentViewWidth = 320;
    [viewController presentViewController:modal animated:YES completion:nil];
}

- (CGSize)contentSizeThatFits:(CGSize)size {
    return [self preferredContentSizeInModalPresentationViewController:self.qmui_modalPresentationViewController keyboardHeight:0 limitSize:size];
}

#pragma mark - <QMUIModalPresentationContentViewControllerProtocol>

- (CGSize)preferredContentSizeInModalPresentationViewController:(QMUIModalPresentationViewController *)controller keyboardHeight:(CGFloat)keyboardHeight limitSize:(CGSize)limitSize {
    return CGSizeMake(limitSize.width, UIEdgeInsetsGetVerticalValue(self.padding) + self.titleLabel.qmui_height + self.titleMarginBottom + ({
        CGFloat itemTotalHeight = 0;
        for (QMUIInteractiveDebugPanelItem *item in self.items) {
            itemTotalHeight += item.height;
        }
        itemTotalHeight;
    }));
}

@end
