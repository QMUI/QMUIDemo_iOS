//
//  QDBackBarButtonViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/12/7.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDBackBarButtonViewController.h"
#import "QMUIBackBarButton.h"

/// 消息列表子界面的返回按钮要用圆形未读数来显示。
/// 必须继承自 QMUINavigationButton，QMUI 会帮你调整返回按钮的位置，让箭头与系统默认的返回按钮箭头对齐。
@interface QDBackBarButton : QMUINavigationButton

@property(nonatomic, copy) NSString *countString;
@end

@interface QDBackBarButtonViewController ()

@property(nonatomic, assign) NSInteger badgeOfPreviousViewController;
@property(nonatomic, strong) QDBackBarButton *backBarButton;
@end

@implementation QDBackBarButtonViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)initTableView {
    [super initTableView];
    __weak __typeof(self)weakSelf = self;
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[
        // section 0
        @[
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.style = UITableViewCellStyleSubtitle;
        d.text = @"显示自定义的 backBarButtonItem";
        d.detailText = @"与系统一致，设置在前一个界面，生效在下一个界面";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            // 为了方便演示，Demo 里会在当前界面设置前一个界面的 qmui_backBarButton，实际业务场景并不会这么写
            weakSelf.badgeOfPreviousViewController = 8;
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.style = UITableViewCellStyleSubtitle;
        d.text = @"动态更新 backBarButtonItem";
        d.detailText = @"子界面的返回按钮会实时更新";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            // 为了方便演示，Demo 里会在当前界面设置前一个界面的 qmui_backBarButton，实际业务场景并不会这么写
            weakSelf.badgeOfPreviousViewController = 100;
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.text = @"恢复为系统 backBarButtonItem";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            // 把 qmui_backBarButton 置为 nil 即可恢复系统的返回按钮
            weakSelf.qmui_previousViewController.navigationItem.qmui_backBarButton = nil;
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.text = @"同时显示 leftBarButtonItems 和返回按钮";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            weakSelf.navigationItem.leftItemsSupplementBackButton = YES;// 先让返回按钮能与 leftBarButtonItems 共存
            weakSelf.navigationItem.leftBarButtonItems = @[
                [UIBarButtonItem qmui_closeItemWithTarget:nil action:NULL],
            ];
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.text = @"只显示 leftBarButtonItems";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            weakSelf.navigationItem.leftItemsSupplementBackButton = NO;// 与系统用法一致，通过修改 leftItemsSupplementBackButton 为 NO 避免返回按钮与 leftBarButtonItems 同时显示
            weakSelf.navigationItem.leftBarButtonItems = @[
                [UIBarButtonItem qmui_closeItemWithTarget:nil action:NULL],
            ];
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.text = @"hidesBackButton";
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        d.accessorySwitchBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData, UISwitch * _Nonnull switcher) {
            weakSelf.navigationItem.hidesBackButton = switcher.on;
        };
        d;
    }),
            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.text = @"切换导航栏的显隐";
        d.detailText = @"导航栏不可见时也应能刷新 backBarButtonItem";
        d.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
            [weakSelf clearState];
            
            [weakSelf.navigationController setNavigationBarHidden:!weakSelf.navigationController.navigationBarHidden animated:YES];
        };
        d;
    }),
        ],
    ]];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.titleView.title = @"QMUIBackBarButton";
    self.titleView.subtitle = @"支持自定义 View 的 backBarButtonItem";
    self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
}

- (void)setBadgeOfPreviousViewController:(NSInteger)badgeOfPreviousViewController {
    _badgeOfPreviousViewController = badgeOfPreviousViewController;
    self.qmui_previousViewController.navigationItem.qmui_backBarButton = badgeOfPreviousViewController > 0 ? ({
        QDBackBarButton *backBarButton = QDBackBarButton.new;
        backBarButton.countString = badgeOfPreviousViewController > 99 ? @"99+" : [NSString qmui_stringWithNSInteger:badgeOfPreviousViewController];
        [backBarButton sizeToFit];
        backBarButton;
    }) : nil;
}

- (void)clearState {
    [self.tableView qmui_clearsSelection];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
}

@end

@interface QDBackBarButton ()

@property(nonatomic, strong) UIImageView *backIconImageView;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, assign) UIEdgeInsets countLabelPadding;
@property(nonatomic, assign) CGFloat spacingBetweenImageAndTitle;
@end

@implementation QDBackBarButton

- (instancetype)init {
    if (self = [self initWithType:QMUINavigationButtonTypeBack]) {
        self.backIconImageView = UIImageView.new;
        self.backIconImageView.image = [NavBarBackIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.backIconImageView sizeToFit];
        self.backIconImageView.tintColor = NavBarTintColor;
        [self addSubview:self.backIconImageView];
        
        self.countLabel = UILabel.new;
        self.countLabel.font = UIFontBoldMake(14);
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.clipsToBounds = YES;
        self.countLabel.textColor = self.backIconImageView.tintColor;
        self.countLabel.backgroundColor = [self.backIconImageView.tintColor colorWithAlphaComponent:.25];
        [self addSubview:self.countLabel];
        
        self.countLabelPadding = UIEdgeInsetsMake(4, 6, 4, 6);
        self.spacingBetweenImageAndTitle = 5;
        
        [self addTarget:self action:@selector(handlePopEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setCountString:(NSString *)countString {
    _countString = countString;
    self.countLabel.text = countString;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize countLabelSize = [self.countLabel sizeThatFits:CGSizeMax];
    countLabelSize.width = countLabelSize.width + UIEdgeInsetsGetHorizontalValue(self.countLabelPadding);
    countLabelSize.height = countLabelSize.height + UIEdgeInsetsGetVerticalValue(self.countLabelPadding);
    countLabelSize.width = MAX(countLabelSize.width, countLabelSize.height);
    CGFloat resultWidth = CGRectGetWidth(self.backIconImageView.frame) + self.spacingBetweenImageAndTitle + countLabelSize.width;
    CGFloat resultHeight = MAX(CGRectGetHeight(self.backIconImageView.frame), countLabelSize.height);
    
    return CGSizeMake(resultWidth, resultHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backIconImageView.qmui_left = 0;
    self.backIconImageView.qmui_top = CGFloatGetCenter(self.qmui_height, self.backIconImageView.qmui_height);
    CGSize countLabelSize = CGSizeMake(CGRectGetWidth(self.bounds) - self.backIconImageView.qmui_right - self.spacingBetweenImageAndTitle, [self.countLabel sizeThatFits:CGSizeMax].height + UIEdgeInsetsGetVerticalValue(self.countLabelPadding));
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.backIconImageView.frame) + self.spacingBetweenImageAndTitle, CGFloatGetCenter(self.qmui_height, countLabelSize.height), countLabelSize.width, countLabelSize.height);
    self.countLabel.layer.cornerRadius = countLabelSize.height / 2;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = highlighted ? UIControlHighlightedAlpha : 1;
}

- (void)handlePopEvent {
    UINavigationController *nav = (UINavigationController *)self.qmui_viewController;
    if ([self.qmui_viewController isKindOfClass:UINavigationController.class]) {
        
        // QMUIBackBarButton 的目的是为了尽量模仿系统原生的返回按钮，而系统返回按钮被点击时会询问 QMUI 这个 delegate，所以这里也要调用一下
        // 实际场景：例如 webView 点返回按钮会执行网页的后退操作而不是 nav 的 pop 操作
        BOOL shouldPop = YES;
        if ([nav.topViewController respondsToSelector:@selector(shouldPopViewControllerByBackButtonOrPopGesture:)]) {
            shouldPop = [nav.topViewController shouldPopViewControllerByBackButtonOrPopGesture:NO];
        }
        if (shouldPop) {
            [nav popViewControllerAnimated:YES];
        }
    }
}

@end
