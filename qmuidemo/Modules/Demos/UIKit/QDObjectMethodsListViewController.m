//
//  QDObjectMethodsListViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/3/24.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDObjectMethodsListViewController.h"

@interface QDObjectMethodsListViewController ()

@property(nonatomic, strong) NSMutableArray<NSString *> *selectorNames;
@property(nonatomic, strong) UITextView *textView;
@end

@implementation QDObjectMethodsListViewController

- (instancetype)initWithClass:(Class)aClass {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.selectorNames = [[NSMutableArray alloc] init];
        
        [NSObject qmui_enumrateInstanceMethodsOfClass:aClass usingBlock:^(SEL selector) {
            [self.selectorNames addObject:[NSString stringWithFormat:@"- %@", NSStringFromSelector(selector)]];
        }];
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.textView = [[UITextView alloc] init];
    self.textView.textContainerInset = UIEdgeInsetsMake(20, 16, 20, 16);
    self.textView.editable = NO;
    self.textView.attributedText = [self attributedStringForTextView];
    [self.view addSubview:self.textView];
}

- (NSAttributedString *)attributedStringForTextView {
    NSDictionary<NSString *, id> *attributes = @{NSFontAttributeName: CodeFontMake(14), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.selectorNames componentsJoinedByString:@"\n"] attributes:attributes];
    return attributedString;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = CGRectInsetEdges(self.view.bounds, UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator, 0, 0, 0));
}

@end
