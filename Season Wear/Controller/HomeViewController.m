//
//  HomeViewController.m
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/20/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "HomeViewController.h"
#import "MySingleton.h"
#import "HomeTableViewCell.h"
#import "AppDelegate.h"
#import "Weather.h"
#import "SearchAddressViewController.h"
#import "AboutUsViewController.h"
#import "MHGallery.h"
#import <Season_Wear-Swift.h>

@interface HomeViewController ()
{
    AppDelegate *appDelegate;
   
}

@end

@implementation HomeViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;
@synthesize mainView;
@synthesize navigationBarView;
@synthesize lblNavigationTitle;
@synthesize btnSwitch;
@synthesize btnChangeToF;
@synthesize lblLocation;
@synthesize mainTableView;
@synthesize btnSearch;
@synthesize lblmen;
@synthesize lbwomen;
@synthesize btnEye;
@synthesize lblLocationDisabledInstruction;
@synthesize locationDisabledContainerView;

//========== OTHER VARIABLES ==========//


@synthesize currentLocationName;
@synthesize strLatitude;
@synthesize strLongitude;
@synthesize isFromSelectLocationVC;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialView];
    [self setNavigationBar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNotificationEvent];
    

    if([MySingleton sharedManager].boolIsWebServiceCalledOnce==TRUE)
    {
        locationDisabledContainerView.hidden = true;
        lblLocation.text = [MySingleton sharedManager].dataManager.strSelectedLocationName;
       [MySingleton sharedManager].boolIsWebServiceCalledOnce=false;
        [[MySingleton sharedManager].dataManager getWeatherDetails:[MySingleton sharedManager].dataManager.strSelectedLocationLatitude withLongitude:[MySingleton sharedManager].dataManager.strSelectedLocationLongitude];
        
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotificationEventObserver];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotWeatherDetailsEvent) name:@"gotWeatherDetailsEvent" object:nil];
}

-(void)removeNotificationEventObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)gotWeatherDetailsEvent
{
  
    self.dataRows = [MySingleton sharedManager].dataManager.arrayWeatherDeatils;
    NSLog(@"datarows %@",self.dataRows);
    NSLog(@"datarows %lu",(unsigned long)self.dataRows.count);

    [mainTableView reloadData];
    
}


#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    self.view.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    lblNavigationTitle.textColor =[UIColor whiteColor];
    lblNavigationTitle.font = [MySingleton sharedManager].themeFontEighteenSizeBold;

}

- (IBAction)btnBackTapped:(id)sender {
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIFont *lblLocationDisabledInstructionFont, *lblLocationDisabledInstructionBoldFont, *lblPleaseSelectAtleastOneCategoryFont, *txtFieldFont;
    
    if([MySingleton sharedManager].screenHeight == 480)
    {
        lblLocationDisabledInstructionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblLocationDisabledInstructionBoldFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        lblPleaseSelectAtleastOneCategoryFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 568)
    {
        lblLocationDisabledInstructionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblLocationDisabledInstructionBoldFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        lblPleaseSelectAtleastOneCategoryFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 667)
    {
        lblLocationDisabledInstructionFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        lblLocationDisabledInstructionBoldFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        lblPleaseSelectAtleastOneCategoryFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    else
    {
        lblLocationDisabledInstructionFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblLocationDisabledInstructionBoldFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblPleaseSelectAtleastOneCategoryFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
    }

    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [mainTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [mainTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell_iPhone6Plus" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [mainTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell_iPhone6" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    if (isFromSelectLocationVC) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startMonitoringSignificantLocationChanges];
        locationManager.delegate = self;
         #ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER)
        {
            // Use one or the other, not both. Depending on what you put in info.plist
            [locationManager requestWhenInUseAuthorization];
        }
        #endif
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    
    
    
    [MySingleton sharedManager].dataManager.arrayWeatherDeatils = [[NSMutableArray alloc]init];
    self.dataRows =[[NSMutableArray alloc]init];

    btnSwitch.tag=1;
    btnChangeToF.tag=1;
    [btnSwitch addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    [btnChangeToF addTarget:self
                  action:@selector(stateChangedFarenhite:) forControlEvents:UIControlEventValueChanged];

    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];

    btnSwitch.onTintColor=[MySingleton sharedManager].lightOrange1ColorCode;
    btnChangeToF.onTintColor=[MySingleton sharedManager].lightOrange1ColorCode;
    lblLocation.backgroundColor=[MySingleton sharedManager].lightOrange1ColorCode;
    lblmen.font=[MySingleton sharedManager].themeFontSixteenSizeMedium;
    lbwomen.font=[MySingleton sharedManager].themeFontSixteenSizeMedium;
    
    
    lblLocation.font=[MySingleton sharedManager].themeFontSixteenSizeMedium;
    lblLocation.delegate=self;
    lblLocation.text = @"";

    [btnEye addTarget:self action:@selector(btnEyeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    lblLocationDisabledInstruction.textColor = [MySingleton sharedManager].darkGreyColorCode;
    lblLocationDisabledInstruction.font = lblLocationDisabledInstructionFont;
    NSString *strLocationDisabledInstruction = [NSString stringWithFormat:@"We were unable to fetch your location as your location services is disabled. \n\nFollow these steps to use our app to its full extent. \n\n1. Go to Settings > Privacy and enable Location Services. \n\n2. Or you can enter your location manually by using Settings in our app."];
    NSMutableAttributedString *strAttrLocationDisabledInstruction = [[NSMutableAttributedString alloc] initWithString:strLocationDisabledInstruction attributes: nil];
    NSRange rangeOfFollowTheseSteps = [strLocationDisabledInstruction rangeOfString:@"Follow these steps to use our app to its full extent."];
    [strAttrLocationDisabledInstruction addAttribute:NSFontAttributeName value:lblLocationDisabledInstructionBoldFont range:rangeOfFollowTheseSteps];
    lblLocationDisabledInstruction.attributedText = strAttrLocationDisabledInstruction;
    
    if (isFromSelectLocationVC) {
        if ([CLLocationManager locationServicesEnabled])
        {
            locationDisabledContainerView.hidden = true;
            
            if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
            {
                [appDelegate dismissGlobalHUD];
                
                locationDisabledContainerView.hidden = false;
            }
        }
        else
        {
            [appDelegate dismissGlobalHUD];
            
            locationDisabledContainerView.hidden = false;
        }
    }
    
    lblLocationDisabledInstruction.textAlignment = NSTextAlignmentCenter;
    
    [lblLocationDisabledInstruction setNumberOfLines:0];
    [lblLocationDisabledInstruction sizeToFit];
    
    CGRect myFrame = lblLocationDisabledInstruction.frame;
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 300, myFrame.size.height);
    lblLocationDisabledInstruction.frame = myFrame;
    
    /*
    if([MySingleton sharedManager].boolIsWebServiceCalledOnce==TRUE)
    {
        locationDisabledContainerView.hidden = true;
        lblLocation.text=[MySingleton sharedManager].dataManager.strSelectedLocationName;
       [MySingleton sharedManager].boolIsWebServiceCalledOnce=false;
        [[MySingleton sharedManager].dataManager getWeatherDetails:[MySingleton sharedManager].dataManager.strSelectedLocationLatitude withLongitude:[MySingleton sharedManager].dataManager.strSelectedLocationLongitude];
        
    }
    */
    
}


#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataRows.count > 0)
    {
        return self.dataRows.count;
    }
    
    return 0;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        return 350;
    }
    
    return UITableViewAutomaticDimension ;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if(cell != nil)
    {
        NSArray *nib;
        
        /*
        if([MySingleton sharedManager].screenHeight == 480 || [MySingleton sharedManager].screenHeight == 568)
        {
            nib = [[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            nib = [[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell_iPhone6" owner:self options:nil];
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            nib = [[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell_iPhone6Plus" owner:self options:nil];
        }
        */
        
        nib = [[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if(self.dataRows.count>0)
    {
        Weather *objWeather =[self.dataRows objectAtIndex:indexPath.row];
        cell.lblView1.backgroundColor = [MySingleton sharedManager].darkOrange2ColorCode;
        cell.lblView2.backgroundColor = [MySingleton sharedManager].lightOrange1ColorCode;
        cell.lblDay.textColor=[MySingleton sharedManager].darkOrange4ColorCode;
        cell.lblDate.textColor=[MySingleton sharedManager].darkGreyColorCode;
        cell.separatorView.backgroundColor = [MySingleton sharedManager].lightOrange4ColorCode;
        cell.lblMaxTemp.textColor=[UIColor blackColor];
        cell.lblMinTemp.textColor=[UIColor blackColor];
        if(btnSwitch.tag==1)
        {
            if([objWeather.strIcon isEqualToString:@"clear-day"])
            {
                
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"clear_day_men_1.jpg", @"clear_day_men_2.jpeg", nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"clear_day.png"];
                
            }
            
            else if([objWeather.strIcon isEqualToString:@"snow"])
            {
                
                
                cell.imgCloth.image= [UIImage imageNamed:@"snow_men_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"snow.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"partly-cloudy-day"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"partly_cloudy_day_men_1.jpg", @"partly_cloudy_day_men_2.jpeg", nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"partly_cloudy_day.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"partly-cloudy-night"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"partly_cloudy_night_men_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"partly_cloudy_night.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"rain"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"rain_men_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"rain.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"clear-night"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"clear-night_man_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"clear_night.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"sleet"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"sleet_men_2.jpg", @"sleet_men_1.jpg", @"sleet_men_3.jpg",@"sleet_men_4.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"sleet.png"];
            }
            else if([objWeather.strIcon isEqualToString:@"wind"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"wind_men_1.jpg", @"wind_men_2.jpg", @"wind_men_4.jpg",@"wind_men_3.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"wind.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"fog"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"fog_men_1.jpg", @"fog_men_2.jpg", nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"fog.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"cloudy"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"cloudy_men_1.jpg", @"cloudy_men_2.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"cloudy.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"hail"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"hail_men_1.jpg", @"hail_men_2.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                cell.imgWeather.image= [UIImage imageNamed:@"hail.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"thunderstorm"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"thunderstorm_men_1.jpg", @"thunderstorm_men_2.jpg",@"thunderstorm_men_3.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"thunderstorm.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"tornado"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"tornado_men_1.jpg", @"tornado_men_2.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"tornado.png"];
                
            }
        }
        else
        {
            if([objWeather.strIcon isEqualToString:@"clear-day"])
            {
                
                cell.imgCloth.image= [UIImage imageNamed:@"clear_day_women_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"clear_day.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"snow"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"snow_women_1.png", @"snow_women_2.png",@"snow_women_3.jpg",@"snow_women_4.jpg",@"snow_women_5.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"snow.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"partly-cloudy-day"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"partly_cloudy_day_women_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"partly_cloudy_day.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"partly-cloudy-night"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"partly_cloudy_night_women_1.jpg", @"partly_cloudy_night_women_2.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                cell.imgWeather.image= [UIImage imageNamed:@"partly_cloudy_night.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"rain"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"rain_women_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"rain.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"clear-night"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"clear_night_women_1.jpg", @"clear_night_women_2.jpg",@"clear_night_women_3.jpeg",@"clear_night_women_4.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"clear_night.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"sleet"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"sleet_women_1.png", @"sleet_women_2.png",@"sleet_women_3.png",@"sleet_women_4.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"sleet.png"];
            }
            else if([objWeather.strIcon isEqualToString:@"wind"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"wind_women_1.png", @"wind_women_2.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"wind.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"fog"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"fog_women_1.png", @"fog_women_2.jpg",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"fog.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"cloudy"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"cloudy_women_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"cloudy.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"hail"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"hail_women_1.png", @"hail_women_2.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                
                cell.imgWeather.image= [UIImage imageNamed:@"hail.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"thunderstorm"])
            {
                cell.imgCloth.image= [UIImage imageNamed:@"thunderstorm_women_1.jpg"];
                cell.imgWeather.image= [UIImage imageNamed:@"thunderstorm.png"];
                
            }
            else if([objWeather.strIcon isEqualToString:@"tornado"])
            {
                NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"tornado_women_1.jpg", @"tornado_women_2.png",nil];
                
                cell.imgCloth.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
                cell.imgWeather.image= [UIImage imageNamed:@"tornado.png"];
                
            }
        }
        if(btnChangeToF.tag==1)
        {
            cell.lblMaxTemp.text = objWeather.strMaxTempFarenhit;
            cell.lblMinTemp.text = objWeather.strMinTempFarenhit;

        }
        else
        {
            cell.lblMaxTemp.text = objWeather.strMaxTempCelsius;
            cell.lblMinTemp.text = objWeather.strMinTempCelsius;
            
            
        }
        
        NSString *epochTime = objWeather.strDay;
        NSTimeInterval seconds = [epochTime doubleValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EE"];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd MMM,yy"];
        cell.lblDay.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:epochNSDate]];
        cell.lblDate.text=[NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:epochNSDate]];
        cell.lblSmallInfo.text=objWeather.strIcon;
        cell.lblLargeInfo.text=objWeather.strSummary;
        NSString *uppercase = [cell.lblDay.text uppercaseString];
        cell.lblDay.text =  uppercase;
        cell.lblLargeInfo.font=[MySingleton sharedManager].themeFontFourteenSizeMedium;
        cell.lblSmallInfo.font=[MySingleton sharedManager].themeFontSixteenSizeBold;
        cell.lblDay.font=[MySingleton sharedManager].themeFontFourteenSizeBold;
        cell.lblDate.font=[MySingleton sharedManager].themeFontFourteenSizeBold;
        cell.lblMaxTemp.font=[MySingleton sharedManager].themeFontTwelveSizeBold;
        cell.lblMinTemp.font=[MySingleton sharedManager].themeFontTwelveSizeBold;
        
        cell.separatorView.backgroundColor= [MySingleton sharedManager].darkOrange2ColorCode;

        
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MHGalleryItem *image1 = [MHGalleryItem itemWithImage:cell.imgCloth.image];
        NSArray *galleryData = @[image1];
        
        MHGalleryController *gallery = [[MHGalleryController alloc]initWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
        
        gallery.galleryItems = galleryData;
        
        __weak MHGalleryController *blockGallery = gallery;
        gallery.finishedCallback = ^(NSUInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockGallery dismissViewControllerAnimated:YES completion:nil];
            });
            
        };
        [self presentMHGalleryController:gallery animated:YES completion:nil];
    });
    

}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Called.");
    
    //locationDisabledContainerView.hidden = false;
    
    [appDelegate dismissGlobalHUD];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations Called.");
    
    locationDisabledContainerView.hidden = true;
    
    currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil)
    {
        strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        [MySingleton sharedManager].dataManager.strUserLocationLatitude = strLatitude;
        [MySingleton sharedManager].dataManager.strUserLocationLongitude = strLongitude;
        locationManager=nil;
        [locationManager stopUpdatingLocation];
        
        NSLog(@"latitude %@",strLatitude);
        NSLog(@"latitude %@",strLongitude);
        
        //[self getLocationAddress:strLatitude withLongitude:strLongitude];
        
        [self getLocationAddress:strLatitude withLongitude:strLongitude withLocationCoordinates:currentLocation];
        
    }
    else
    {
        [appDelegate dismissGlobalHUD];
      
    }
}

#pragma mark - Function for getting current Address

-(void)getLocationAddress:(NSString *)strLocationLatitude withLongitude:(NSString *)strLocationLongitude withLocationCoordinates:(CLLocation *)currentLocation
{
    /*
    //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDKazlyps6XrQDHQ6ERu7g3hy2XLRKFfrA"
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true&key=AIzaSyABRYT7DtLIqORXXSvzAun4rce3MI_3fks",strLocationLatitude,strLocationLongitude];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *jsonResponse=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *jsonAry = [dict objectForKey:@"results"];
    NSDictionary *add ;
    */
    
    //[[MySingleton sharedManager].dataManager getWeatherDetails:strLatitude withLongitude:strLongitude]; // Testing purpose only. It should be in conditional block. //n
    
    /*
    if(jsonAry.count > 1)
    {
        add = [jsonAry objectAtIndex:1];
        
        NSString *fulladdress = [add objectForKey:@"formatted_address"];
        lblLocation.text=[NSString stringWithFormat:@"%@",fulladdress];
        
        [[MySingleton sharedManager].dataManager getWeatherDetails:strLatitude withLongitude:strLongitude];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
    }
    */
    
    //CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:strLocationLatitude longitude:strLocationLongitude];

    [self getAddressFromLocation:currentLocation completionBlock:^(NSString * address) {
            if(address) {
                //_address = address;
                //printf("%s", address);
                
                //NSString *fulladdress = [add objectForKey:@"formatted_address"];
                lblLocation.text=[NSString stringWithFormat:@"%@",address];
                
                [[MySingleton sharedManager].dataManager getWeatherDetails:strLatitude withLongitude:strLongitude];
            }
            else {
                lblLocation.text=@"";
                [appDelegate dismissGlobalHUD];
            }
        }];
}

// ===== Start
typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location completionBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;

    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", placemark.name, placemark.locality, placemark.postalCode, placemark.administrativeArea, placemark.country];
             
             completionBlock(address);
         }
     }];
}

// ===== End

#pragma mark - Other Methods

- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        btnSwitch.tag=0;

    } else
    {
        btnSwitch.tag=1;

    }
    [mainTableView reloadData];

}

- (void)stateChangedFarenhite:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        btnChangeToF.tag=0;
        
    }
    else
    {
        btnChangeToF.tag=1;
        
    }
    [mainTableView reloadData];
    
}
- (void)btnSearchClicked
{
    SearchAddressViewController *viewController ;
    
    /*
    if([MySingleton sharedManager].screenHeight == 480)
    {
       viewController = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController_iPhone4" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 568)
    {
       viewController = [[SearchAddressViewController alloc] init];
    }
    else if ([MySingleton sharedManager].screenHeight == 667)
    {
        viewController = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController_iPhone6" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 736)
    {
        viewController = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController_iPhone6Plus" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight >= 812)
    {
        viewController = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController_iPhone10" bundle:nil];
    }
    */
    
    viewController = [[SearchAddressViewController alloc] init];
    viewController.isFromHome = true;
    [self.navigationController pushViewController:viewController animated:YES];
    //[MySingleton sharedManager].boolIsWebServiceCalledOnce = TRUE;
}

- (void)btnEyeClicked
{
    AboutUsViewController *viewController ;
    
    /*
    if([MySingleton sharedManager].screenHeight == 480)
    {
        viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPhone4" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 568)
    {
        viewController = [[AboutUsViewController alloc] init];
    }
    else if ([MySingleton sharedManager].screenHeight == 667)
    {
        viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPhone6" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight == 736)
    {
        viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPhone6Plus" bundle:nil];
    }
    else if ([MySingleton sharedManager].screenHeight >= 812)
    {
        viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPhone10" bundle:nil];
    }
    */
    
    viewController = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}




@end
