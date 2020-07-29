//
//  NSObject+QMUIHook.h
//  qmuidemo
//
//  Created by ziezheng on 2020/6/12.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, QMUIHookOption) {
    QMUIHookOptionBefore  = 0,
    QMUIHookOptionAfter   = 1,
    QMUIHookOptionInstead = 2,
};

@interface QMUIHookContext : NSObject

@property(nonatomic, weak) NSObject *instance;

- (void)getReturnValue:(void *)retLoc;
- (void)setReturnValue:(void *)retLoc;

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;
- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

- (void)invoke;

@end

@interface QMUIHookToken : NSObject

@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id block;
//@property (nonatomic, strong) NSMethodSignature *blockSignature;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) QMUIHookOption  options;

@end

@interface NSObject (QMUIHook)

typedef void (^QMUIHookContextBlock)(QMUIHookContext *context);

- (QMUIHookToken *)qmui_hookSelector:(SEL)selector beforeBlock:(QMUIHookContextBlock)block;
- (QMUIHookToken *)qmui_hookSelector:(SEL)selector afterBlock:(QMUIHookContextBlock)block;
- (QMUIHookToken *)qmui_hookSelector:(SEL)selector insteadBlock:(QMUIHookContextBlock)block;

@end

NS_ASSUME_NONNULL_END
