//
//  AboutUsViewController.m
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/27/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MySingleton.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController


//========== IBOUTLETS ==========//

@synthesize mainScrollView;
@synthesize mainView;
@synthesize navigationBarView;
@synthesize lblNavigationTitle;
@synthesize imgback;
@synthesize btnBack;
@synthesize imgShare;
@synthesize ShareView;
@synthesize lblShareTitle;
@synthesize btnShare;
@synthesize lblPoweredByTitle;
@synthesize lblPoweredByValue;
@synthesize txtView;
@synthesize maintxtView;
@synthesize mainPoweredView;



#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialView];
    [self setNavigationBar];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
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

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    lblNavigationTitle.textColor =[UIColor whiteColor];
    lblNavigationTitle.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UI Setup Method
-(void)setUpInitialView
{
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    ShareView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    lblShareTitle.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblShareTitle.textColor =[UIColor whiteColor];
    lblNavigationTitle.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    lblPoweredByTitle.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    lblPoweredByValue.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
    
    UITapGestureRecognizer *lblPoweredByTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblPoweredByTapped:)];
    
    lblPoweredByTapRecognizer.delegate = self;
    
    lblPoweredByTitle.userInteractionEnabled = true;
    [lblPoweredByTitle addGestureRecognizer:lblPoweredByTapRecognizer];
    
    lblPoweredByValue.userInteractionEnabled = true;
    [lblPoweredByValue addGestureRecognizer:lblPoweredByTapRecognizer];
    
    
    txtView.font=[MySingleton sharedManager].themeFontSixteenSizeMedium;
    txtView.text=@"                                                                                                                               Trying to figure out how to look confident, cool and collected while being totally prepared for whatever Mother Nature plans to throw at you today? Not to worry! “Season Wear” features style ideas coordinated to the weather wherever you are. Season Wear provides forecast up to 7 days and help you select your clothes for the entire week based on the weather going to be in your area.";

    txtView.backgroundColor=[MySingleton sharedManager].lightOrange3ColorCode;
    txtView.textColor=[UIColor blackColor];
    txtView.userInteractionEnabled = false;
    
    maintxtView.backgroundColor=[MySingleton sharedManager].darkOrange4ColorCode;
    mainPoweredView.backgroundColor=[MySingleton sharedManager].darkOrange3ColorCode;
}


#pragma mark - Other Methods
-(IBAction)btnShareClicked:(id)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"Download Season Wear today and figure out how to look confident, cool and collected while being totally prepared for whatever Mother Nature plans to throw at you. Season Wear features style ideas coordinated to the weather wherever you are. Download Now http://itunes.apple.com/app/id1219972902"];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:textToShare, nil] applicationActivities:nil];
    [activityVC setValue:[NSString stringWithFormat:@"Hey, I am using Season Wear"] forKey:@"subject"];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}


- (void)lblPoweredByTapped:(UITapGestureRecognizer*)sender
{
    NSURL *myURL = [[NSURL alloc]initWithString:@"http://innovativeiteration.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL])
    {
        [[UIApplication sharedApplication] openURL:myURL];
    }
}

@end
