//
//  AppDelegate.m
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/20/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "AppDelegate.h"
#import "MySingleton.h"
#import <IQKeyboardManager.h>

@import GooglePlaces;
@import Firebase;

@interface AppDelegate()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //AIzaSyABRYT7DtLIqORXXSvzAun4rce3MI_3fks firebase
    //AIzaSyCyJNITXBW_v2m-ocOzyV2yiGnWRa54ozs old
    // AIzaSyCJEhmyF8sR9TCL_pVchxhNK-YAGXVPBro
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyClwl--g3YGvvxdPKS_4pjWA7ziLsjfXYA"];
    [FIRApp configure];
    
    //IQkeyboard manager
    IQKeyboardManager.sharedManager.enable = true;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    /*
    if([MySingleton sharedManager].screenHeight == 480)
    {
        self.splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iPhone4" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 568)
    {
        self.splashVC = [[SplashViewController alloc] init];
    }
    else if ([MySingleton sharedManager].screenHeight == 667)
    {
        self.splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iPhone6" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 736)
    {
        self.splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iPhone6Plus" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 812)
    {
        self.splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iPhone10" bundle:nil];
    }
    */ //n
    
    self.splashVC = [[SplashViewController alloc] init];
    self.navC = [[UINavigationController alloc]initWithRootViewController:self.splashVC];
    self.window.rootViewController = self.navC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Other Methods

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [self dismissGlobalHUD];
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = title;
    hud.dimBackground = YES;
    
    return hud;
}

-(void)dismissGlobalHUD
{
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

//=========================FUNCTION TO SHOW THE HHAlertView ========================//

-(void)showErrorAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:ok];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:NO completion:nil];
    
}

@end
