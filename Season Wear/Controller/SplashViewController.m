//
//  SplashViewController.m
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/20/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "MySingleton.h"
#import <Season_Wear-Swift.h>
#import "SearchAddressViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController


//========== IBOUTLETS ==========//
@synthesize mainScrollView;
@synthesize mainImg;
@synthesize lblSeasonWeare;
@synthesize mainView;


#pragma mark - View Controller Delegate Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setup Method
-(void)setUpInitialView
{
    lblSeasonWeare.font = [MySingleton sharedManager].themeFontThirtyEightSizeMedium;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
                  [self redirectToHomeViewController];
  
        
    });
    
}

-(void)redirectToHomeViewController
{
    //HomeViewController *viewController;
    
    /*
    if([MySingleton sharedManager].screenHeight == 480)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone4" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 568)
    {
        viewController = [[HomeViewController alloc] init];
    }
    else if ([MySingleton sharedManager].screenHeight == 667)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController-iPhone6" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 736)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController-iPhone6Plus" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight >= 812)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone10" bundle:nil];
    }
    */
    
    /*
    viewController = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    */
    
    /*
    SearchAddressViewController *viewController;
    
    viewController = [[SearchAddressViewController alloc] init];
    viewController.isFromHome = false;
    [self.navigationController pushViewController:viewController animated:YES];
    */
    
    SelectLocationVC *vc;
    vc = [[SelectLocationVC alloc] init];
    [self.navigationController pushViewController:vc animated:false];

}


@end
