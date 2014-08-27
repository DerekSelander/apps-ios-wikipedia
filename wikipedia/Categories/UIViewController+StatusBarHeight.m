//  Created by Monte Hurd on 5/27/14.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "UIViewController+StatusBarHeight.h"

@implementation UIViewController (StatusBarHeight)

-(CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
       CGRectGetWidth([[UIApplication sharedApplication] statusBarFrame]);
    }
    
    return CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
}

@end
