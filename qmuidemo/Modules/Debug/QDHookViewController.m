//
//  QDHookViewController.m
//  qmuidemo
//
//  Created by ziezheng on 2020/6/12.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDHookViewController.h"
#import "Aspects.h"
#import "Aspects.h"
#import "NSObject+QMUIHook.h"

@interface QDObjectA : NSObject
@property(nonatomic, strong) NSString *name;
@end

@implementation QDObjectA

- (void)func {
    NSLog(@"QDObjectA func invoke!");
}

- (void)setName:(NSString *)name {
    _name = name.copy;
    NSLog(@"QDObjectA setName invoke! name = %@", name);
    
    
}


@end

@interface QDObjectB : QDObjectA

@end

@implementation QDObjectB


- (void)func {
    [super func];
    NSLog(@"QDObjectB func invoke!");
}



@end


@interface QDHookViewController ()

@end

@implementation QDHookViewController


#define aspectBefore(obj, sel, block) [obj aspect_hookSelector:sel withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) { \
    block;\
} error:nil];\

#define aspectAfter(obj, sel, block) [obj aspect_hookSelector:sel withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) { \
    block;\
} error:nil];\

#define qmuiBefore(obj, sel, block) [obj qmui_hookSelector:sel beforeBlock:^(QMUIHookContext * _Nonnull context) {\
    block;\
}];\

#define qmuiAfter(obj, sel, block) [obj qmui_hookSelector:sel afterBlock:^(QMUIHookContext * _Nonnull context) {\
    block;\
}];\

- (void)baseSample1 {
    
    QDObjectB *obj1 = [QDObjectB new];
    qmuiBefore(obj1, @selector(setName:), NSLog(@"🎈qmui before !"))
    qmuiAfter(obj1, @selector(setName:), NSLog(@"🎈qmui after !"))
    obj1.name = @"obj1 !";
    
    QDObjectB *obj2 = [QDObjectB new];
    obj2.name = @"obj2 !";
}

- (void)sampleKVO {
    NSLog(@"🎈 %@", NSStringFromSelector(_cmd));
    // KVO hook 移除 KVO
    QDObjectB *obj1 = [QDObjectB new];
    qmuiBefore(obj1, @selector(setName:), NSLog(@"🎈qmui before !"))
    qmuiAfter(obj1, @selector(setName:), NSLog(@"🎈qmui after !"))

    obj1.name = @"before KVO";
    [obj1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    obj1.name = @"after KVO";
    [obj1 removeObserver:self forKeyPath:@"name"];
    obj1.name = @"remove KVO";
    
    
    // KVO hook 移除 KVO
    QDObjectB *obj2 = [QDObjectB new];
    [obj2 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    qmuiBefore(obj2, @selector(setName:), NSLog(@"🎈qmui before !"))
    qmuiAfter(obj2, @selector(setName:), NSLog(@"🎈qmui after !"))
    obj2.name = @"after KVO 2";
    [obj2 removeObserver:self forKeyPath:@"name"];
    obj2.name = @"remove KVO 2";

}

- (void)aspectSample1 {
    
    QDObjectA *obj = [QDObjectA new];
    qmuiBefore(obj, @selector(setName:), NSLog(@"🎈qmui before !"))
    aspectBefore(obj, @selector(setName:), NSLog(@"aspect before !"))
    qmuiAfter(obj, @selector(setName:), NSLog(@"🎈qmui after !"))
    aspectAfter(obj, @selector(setName:), NSLog(@"aspect after !"))
    obj.name = @"aspectSample1";
//    [obj performSelector:@selector(aaa)];
}

- (void)sampleAspect {

    
}

typedef NSString * (^BlockA)(int a);

typedef struct QDStruct {
    CGRect aRect;
    BOOL aBool;
} QDStruct;

- (void)func {
    NSLog(@"func!");
}

- (id)func:(CGFloat)frame {
    return nil;
}

- (NSString *)str {
    return @"xxxx";
}

- (void)setA:(NSObject *)a {
    NSLog(@"setA - %@", a);
}

- (NSString *)stringBy:(NSString *)aString {
    return [@"stringBy" stringByAppendingString:aString];
}

- (void)test {
    

    
     [self aspect_hookSelector:@selector(stringBy:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __unsafe_unretained NSString *ori = nil;
            [[aspectInfo originalInvocation] getReturnValue:&ori];
            NSLog(@"");

        } error:nil];
        
        [self qmui_hookSelector:@selector(stringBy:) afterBlock:^(QMUIHookContext * _Nonnull context) {
            NSLog(@"🎈 stringBy:");
    //            __unsafe_unretained NSString *arg = nil;
    //            [context getReturnValue:&arg];
    //
    //            NSString *replace = @"haha";
    //        [context setReturnValue:&replace];
    //        [replace description];

        }];
    
    NSString *news = [self stringBy:@"aaaa"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self baseSample1];
    [self sampleKVO];
//    [self aspectSample1];
//    [self test];
    return;
    
    [self qmui_hookSelector:@selector(func) beforeBlock:^(QMUIHookContext * _Nonnull context) {
        NSLog(@"🎈 func! before");
    }];
    
    [self qmui_hookSelector:@selector(func) afterBlock:^(QMUIHookContext * _Nonnull context) {
        NSLog(@"🎈 func! after");
    }];
    
    [self func];
    
    [self qmui_hookSelector:@selector(setBool:) afterBlock:^(QMUIHookContext * _Nonnull context) {
        NSLog(@"🎈 setBool! after");
    }];
    [self setBool:YES];
    
    [self qmui_hookSelector:@selector(setA:) beforeBlock:^(QMUIHookContext * _Nonnull context) {
        NSString *ori = nil;
//        [context getReturnValue:&ori];
//        
//        NSString *aaa = nil;
//        [context getArgument:&aaa atIndex:2];
//        aaa = @"ddddd";
//        [context setArgument:&aaa atIndex:2];
//        
//        NSString *replace = @"zie";
//        [context setReturnValue:&replace];
//        [replace description];
    }];
    
//    [self qmui_hookSelector:@selector(str) afterBlock:^(QMUIHookContext * _Nonnull context) {
//        NSString *replace = @"zie";
//        [context setReturnValue:&replace];
//        [replace description];
//    }];
    
    NSString  *sss = [self str];

    
//
   
    
    
    NSString *news = [self stringBy:@"aaaa"];
    
    
    [self setA:@"bbbc"];
    NSLog(@"%@", sss);
    
}



- (void)setBool:(BOOL)frame {
    NSLog(@"succ!");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"🎁KVO  : %@",newValue);
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//
//- (void)sampleALL {
//     QDObjectA *objB = [QDObjectA new];
//
//   // [objB addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
//
//
//    [objB aspect_hookSelector:@selector(func) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//        NSInvocation *originalInvocation =  aspectInfo.originalInvocation;
//        NSLog(@"aspect invoke!");
//
//    } error:nil];
//
//    [objB func];
//
//
//    [objB qmui_hookSelector:@selector(setName:) afterBlock:^{
//
//    }];
//
//
//
//  //  [objB removeObserver:self forKeyPath:@"name"];
//
//
//
//
//    objB.name = @"111";
//
//    QDObjectA *objB2 = [QDObjectA new];
//    objB2.name = @"222";
//
////    [objB performSelector:@selector(sel)];
//
////    [objB func];
//}

@end
