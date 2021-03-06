//  Created by Brion on 10/27/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "AppDelegate.h"
#import "URLCache.h"
#import "NSDate-Utilities.h"
#import "WikipediaAppUtils.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the shared url cache to our custom NSURLCache which re-routes images to
    // our article cache.
//TODO: update the app to occasionally check total size of our article cache and if its file exceeded some threshold size prune its image entries
// (probably by Image.lastDateAccessed)
    URLCache *urlCache = [[URLCache alloc] initWithMemoryCapacity: 1024 * 1024 * 8
                                                     diskCapacity: 1024 * 1024 * 25
                                                         diskPath: nil];
    [NSURLCache setSharedURLCache:urlCache];

    [WikipediaAppUtils copyAssetsFolderToAppDataDocuments];
    [self registerStandardUserDefaults];
    [self systemWideStyleOverrides];

    // Enables Alignment Rect highlighting for debugging
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UIViewShowAlignmentRects"];
    //[[NSUserDefaults standardUserDefaults] synchronize];

    // Override point for customization after application launch.

    //[self printAllNotificationsToConsole];

    return YES;
}

-(void)printAllNotificationsToConsole
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName: nil
                        object: nil
                         queue: nil
                    usingBlock: ^(NSNotification *notification) {
                        NSLog(@"NOTIFICATION %@ -> %@", notification.name, notification.userInfo);
                    }];
}

-(void)registerStandardUserDefaults
{
    NSString *systemLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang = [WikipediaAppUtils wikiLangForSystemLang:systemLang];
    if (lang == nil) {
        // Should not happen.
        NSLog(@"Could not map system language %@ to wiki language; falling back to en", systemLang);
        lang = @"en";
    }
    
    NSString *langName = [WikipediaAppUtils domainNameForCode:lang];
    if (langName == nil) {
        // Should not happen, hopefully.
        NSLog(@"Could not get localized name of language %@", lang);
        langName = lang;
    }

    NSString *mainPage = [WikipediaAppUtils mainArticleTitleForCode:lang];
    if (mainPage == nil) {
        // Also should not happen, hopefully.
        NSLog(@"Could not get main page of language %@", lang);
        mainPage = @"Main Page";
    }
    
    // Register default default values.
    // See: http://stackoverflow.com/a/5397647/135557
    NSDictionary *userDefaultsDefaults = @{
        @"CurrentArticleTitle": mainPage,
        @"CurrentArticleDomain": lang,
        @"Domain": lang,
        @"DomainName": langName,
        @"DomainMainArticleTitle": mainPage,
        @"Site": @"wikipedia.org",
        @"ZeroWarnWhenLeaving" : @YES,
        @"ZeroOnDialogShownOnce" : @NO,
        @"FakeZeroOn" : @NO,
        @"ShowOnboarding" : @YES,
        @"LastHousekeepingDate" : [NSDate date], //[NSDate dateWithDaysBeforeNow:10]
        @"SendUsageReports": @YES
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
}

-(void)systemWideStyleOverrides
{
    // Minimize flicker of search result table cells being recycled as they
    // pass completely beneath translucent nav bars
    [[UIApplication sharedApplication] delegate].window.backgroundColor = [UIColor whiteColor];

/*
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
        // Pre iOS 7:
        CGRect rect = CGRectMake(0, 0, 10, 10);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        [[UIColor clearColor] setFill];
        UIRectFill(rect);
        UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
        [[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
*/
    
    [[UIButton appearance] setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];

    // Make buttons look the same on iOS 6 & 7.
    [[UIButton appearance] setBackgroundImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
    [[UIButton appearance] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
