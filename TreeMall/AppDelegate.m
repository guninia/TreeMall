//
//  AppDelegate.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AppDelegate.h"
#import "Definition.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import "TMInfoManager.h"
#import "ViewController.h"
#import <Google/Analytics.h>
@import Firebase;

@interface AppDelegate () {
    NSNumber * trackId;
}

- (void)handlerOfResetRootViewControllerNotification:(NSNotification *)notification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configure Google services: %@", configureError);
    
    // optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // reportuncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    // Uncaught Exception for GA at here        // For Firebase, there's a script needed to be setup
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    
    // adopt Firebase
    [FIRApp configure];

    // Check latest version
    if ([self checkLatestVersion] == NO) {
        [self updateApp];
        return YES;
    }

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:20.0], NSFontAttributeName,
      nil]];
    [[UINavigationBar appearance] setBarTintColor:TMMainColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIBarButtonItem appearanceWhenContainedIn:([UINavigationBar class]), nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBar appearance] setBarTintColor:TMMainColor];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefault_IntroduceShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_HasBeenLaunched] == NO)
    {
        [[TMInfoManager sharedManager] logoutUser];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:UserDefault_HasBeenLaunched];
    }
    
    // Prepare API connection
    [[TMInfoManager sharedManager] retrieveToken:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfResetRootViewControllerNotification:) name:PostNotificationName_ResetRootViewController object:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[TMInfoManager sharedManager] saveToArchive];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
//    NSLog(@"self.window.rootViewController[%@]", [[self.window.rootViewController class] description]);
//    ViewController *viewController = (ViewController *)(self.window.rootViewController);
//    [viewController checkToShowIntroduce];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Notification Handler

- (void)handlerOfResetRootViewControllerNotification:(NSNotification *)notification
{
    __weak AppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        viewController.initialized = YES;
        [viewController hideLaunchScreenLoadingViewAnimated:NO];
        [[TMInfoManager sharedManager] retrieveToken:nil];
        weakSelf.window.rootViewController = viewController;
    });
}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    [[TMInfoManager sharedManager] sendPushToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    if (error.code == 3010)
    {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    }
    else
    {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

#pragma mark - URL Delegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    if (handled == NO)
    {
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    if (handled == NO)
    {
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return handled;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TreeMall"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Force app update

- (BOOL)checkLatestVersion {
    
    BOOL isLatestVersion = YES;
    BOOL unfunctional = YES;
    NSString * errorMsg = @"urlUnfunctional";
    NSString * currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * latestVersion = nil;
    NSString * bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * urlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", bundleId];
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * data = nil;
    
    if (url)
        data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    
    if (data) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSArray * results = [dictionary objectForKey:@"results"];
            
            if (results && [results count] > 0) {
                unfunctional = NO;
                for (id key in results) {
                    latestVersion = [key valueForKey:@"version"];
                    trackId = [key valueForKey:@"trackId"];
                }
                // Compare versions
                if (![latestVersion isEqualToString:currentVersion])
                    isLatestVersion = NO;
                
            } else {
                // Case that cannot find matched app.
                errorMsg = @"cannotFindMatchedApp";
            }
        }
    }
    
    if (unfunctional) {
        id<GAITracker> gaTracker = [GAI sharedInstance].defaultTracker;
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:@"checkLatestVersion"
                          action:errorMsg
                          label:nil
                          value:nil] build]];
    }
    
    return isLatestVersion;
}

- (void)updateApp {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"為提升優質購物體驗，\n請更新至最新版本" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SKStoreProductViewController * iTunesVC = [[SKStoreProductViewController alloc] init];
        iTunesVC.delegate = self;
        NSDictionary * parameter = @{SKStoreProductParameterITunesItemIdentifier: trackId};
        [iTunesVC loadProductWithParameters:parameter completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (result) {
                UIViewController * vc = self.window.rootViewController;
                [vc presentViewController:iTunesVC animated:YES completion:nil];
            }
        }];
    }];
    
    [alertController addAction:confirm];
    UIWindow * alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self updateApp];
}


@end
