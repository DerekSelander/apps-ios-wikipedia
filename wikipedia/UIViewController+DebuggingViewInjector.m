//
//  UIViewController+DebuggingViewInjector.m
//  Wikipedia
//
//  Created by Derek Selander on 8/27/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//


#if DEBUG

#import <objc/runtime.h> // 1
#import "UIViewController+DebuggingViewInjector.h"

static char kWeakLinkViewControllerKey; // 1

@interface UIView ()
@property (nonatomic, weak) UIViewController *debugVC; // 2
@end

@implementation UIView (ViewControllerLinker)

- (void)setDebugVC:(UIViewController *)debugVC // 3
{
    objc_setAssociatedObject(self, &kWeakLinkViewControllerKey, debugVC, OBJC_ASSOCIATION_ASSIGN); // 4
}

- (UIViewController *)debugVC // 5
{
    return objc_getAssociatedObject(self, &kWeakLinkViewControllerKey); // 6
}

@end

@implementation UIViewController (DebuggingViewInjector)

+ (void)load { // 2
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 3
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad); // 4
        SEL swizzledSelector = @selector(customInjectionViewDidLoad); // 5
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector); // 6
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod); // 7
    });
}

- (void)customInjectionViewDidLoad // 8
{
    self.view.debugVC = self; // 9
    [self customInjectionViewDidLoad]; // 10
}

@end

#endif