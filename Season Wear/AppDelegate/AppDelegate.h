//
//  AppDelegate.h
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/20/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SplashViewController *splashVC;
@property (strong, nonatomic) UINavigationController *navC;


-(void)showErrorAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail;

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
-(void)dismissGlobalHUD;


@end

