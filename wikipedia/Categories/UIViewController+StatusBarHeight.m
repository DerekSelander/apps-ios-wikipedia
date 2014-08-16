//  Created by Monte Hurd on 5/27/14.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "UIViewController+StatusBarHeight.h"

@implementation UIViewController (StatusBarHeight)

-(CGFloat)getStatusBarHeight
{
    CGFloat width = CGRectGetWidth([[UIApplication sharedApplication] statusBarFrame]);
    CGFloat height = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    return width < height ? width : height;
}

@end
