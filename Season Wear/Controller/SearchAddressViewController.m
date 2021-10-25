//
//  SearchAddressViewController.m
//  Finder
//
//  Created by Pratik Gujarati on 21/01/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "SearchAddressViewController.h"
#import "MySingleton.h"
#import "NYAlertViewController.h"
#import "PlaceTableViewCell.h"
#import "HomeViewController.h"
#import "SearchViewHeader.h"
#import "HomeViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <Season_Wear-Swift.h>

@import GooglePlaces;
@import UIKit;

@interface SearchAddressViewController ()
{
    AppDelegate *appDelegate;
    

}

@end

@implementation SearchAddressViewController

//TO ANIMATE VIEW UP ON KEYBOARD SHOW
//@synthesize activeTextField;
//@synthesize keyboardShown;
//@synthesize viewMoved;

//static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
// const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

//========== IBOUTLETS ==========//

@synthesize mainScrollView;
@synthesize navigationBarView;
@synthesize lblNavigationTitle;
@synthesize mainContainerView;
@synthesize txtSearchLocationContainerView;
@synthesize txtSearchLocation;
@synthesize btnCancel;
@synthesize imgback;
@synthesize lblInstruction;
@synthesize lblInstructionHeightConstraint;
@synthesize btnBack;
@synthesize mainAutoCompleteTableView;

//========== OTHER VARIABLES ==========//

@synthesize autoCompleteLocationArray;
@synthesize currentLocationName;
@synthesize strLatitude;
@synthesize strLongitude;
@synthesize isFromHome;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    [self setupInitialView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotificationEventObserver];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
}

-(void)removeNotificationEventObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    self.view.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    lblNavigationTitle.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UI Setup Method

- (void)setupInitialView
{
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    /*
    if (isFromHome) {
        btnBack.hidden = false;
        imgback.hidden = false;
    }
    else {
        btnBack.hidden = true;
        imgback.hidden = true;
    }
    */
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    txtSearchLocation.delegate = self;
    txtSearchLocation.textAlignment = NSTextAlignmentLeft;
    txtSearchLocation.placeholder = @"Search Location";
    [txtSearchLocation setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtSearchLocation setReturnKeyType:UIReturnKeySearch];
    
    lblInstruction.text = @"Start typing your desired location name in the textfield above and we will help you in finding your location.";
    
    mainAutoCompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainAutoCompleteTableView.backgroundColor = [UIColor clearColor];
    mainAutoCompleteTableView.delegate = self;
    mainAutoCompleteTableView.dataSource = self;
    
    _placesClient = [GMSPlacesClient sharedClient];
    
    autoCompleteLocationArray = [[NSMutableArray alloc] init];
    
    mainAutoCompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainAutoCompleteTableView.backgroundColor = [UIColor clearColor];
    mainAutoCompleteTableView.delegate = self;
    mainAutoCompleteTableView.dataSource = self;
    
    // Set bounds to inner-west Sydney Australia.
//    CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(-33.843366, 151.134002);
//    CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);
    
    // Set up the autocomplete filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
//    filter.locationRestriction =
//            GMSPlaceRectangularLocationOption(neBoundsCorner, swBoundsCorner);
    
    // Create the fetcher.
//    _fetcher = [[GMSAutocompleteFetcher alloc] init];
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithFilter:filter];
    _fetcher.delegate = self;
    
    btnCancel.titleLabel.font = [MySingleton sharedManager].themeFontFourteenSizeMedium;
    txtSearchLocation.font=[MySingleton sharedManager].themeFontFourteenSizeMedium;
    

    txtSearchLocationContainerView.backgroundColor=[MySingleton sharedManager].lightOrange1ColorCode;

}
-(IBAction)btnCancelClicked:(id)sender
{
    [self.view endEditing:YES];
    btnCancel.hidden = TRUE;
    /*
    CGRect txtSearchLocationFrame = txtSearchLocation.frame;
    txtSearchLocationFrame.size.width = (btnCancel.frame.origin.x + btnCancel.frame.size.width) - txtSearchLocation.frame.origin.x;
    txtSearchLocation.frame = txtSearchLocationFrame;
    */
    
    txtSearchLocation.text = @"";
    mainAutoCompleteTableView.hidden = true;
    lblInstruction.hidden = false;
    //lblInstructionHeightConstraint.active = false;
    lblInstructionHeightConstraint.constant = 50;
}

- (void)btnSearchClicked
{
    [self.view endEditing:YES];
    
    HomeViewController *viewController;
    
    /*
    if([MySingleton sharedManager].screenHeight == 480)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone4" bundle:nil];
    }
    else if([MySingleton sharedManager].screenHeight == 568)
    {
        viewController = [[HomeViewController alloc] init];
    }
    else if([MySingleton sharedManager].screenHeight == 667)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController-iPhone6" bundle:nil];
    }
    else if([MySingleton sharedManager].screenHeight == 736)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController-iPhone6Plus" bundle:nil];
    }
    else if([MySingleton sharedManager].screenHeight >= 812)
    {
        viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController-iPhone10" bundle:nil];
    }
    */
    if(isFromHome){
        [self.navigationController popViewControllerAnimated:true];
    }else{
        viewController = [[HomeViewController alloc] init];
        viewController.isFromSelectLocationVC = true;
        [self.navigationController pushViewController:viewController animated:NO];
    }
   
}
#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtSearchLocation)
    {
        [textField setText:[NSString string]];
        
        btnCancel.hidden = FALSE;
        
        NSLog(@"btnCancel.frame.origin.x : %f",btnCancel.frame.origin.x);
        
        /*
        CGRect txtSearchLocationFrame = txtSearchLocation.frame;
        txtSearchLocationFrame.size.width = (btnCancel.frame.origin.x - 5) - txtSearchLocation.frame.origin.x;
        txtSearchLocation.frame = txtSearchLocationFrame;
        */
    }
    
    //self.activeTextField = textField;
    
    if([MySingleton sharedManager].screenHeight == 480)
    {
        [MySingleton sharedManager].keyboardSize = CGSizeMake(320, 175);
    }
    else if ([MySingleton sharedManager].screenHeight == 568)
    {
        [MySingleton sharedManager].keyboardSize = CGSizeMake(320, 175);
    }
    else if ([MySingleton sharedManager].screenHeight == 667)
    {
        [MySingleton sharedManager].keyboardSize = CGSizeMake(375, 190);
    }
    else if ([MySingleton sharedManager].screenHeight == 736)
    {
        [MySingleton sharedManager].keyboardSize = CGSizeMake(414, 195);
    }
    
    //CGRect textFieldRect  = [self.view.window convertRect:self.activeTextField.bounds fromView:self.activeTextField];
    //CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    //CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    //CGFloat numerator =	midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    //CGFloat denominator = 	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)	* viewRect.size.height;
    //CGFloat heightFraction = numerator / denominator;
    /*
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    */
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //animatedDistance = floor([MySingleton sharedManager].keyboardSize.height * heightFraction+40);
    }
    
    //CGRect viewFrame = self.view.frame;
    //viewFrame.origin.y -= animatedDistance;
    
    /*
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    */
    
    //viewMoved = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtSearchLocation)
    {
        btnCancel.hidden = TRUE;
        
        /*
        CGRect txtSearchLocationFrame = txtSearchLocation.frame;
        txtSearchLocationFrame.size.width = (btnCancel.frame.origin.x + btnCancel.frame.size.width) - txtSearchLocation.frame.origin.x;
        txtSearchLocation.frame = txtSearchLocationFrame;
        */
    }
    
    //self.activeTextField = nil;
    
    if ( viewMoved )
    {
        //CGRect viewFrame = self.view.frame;
        //viewFrame.origin.y += animatedDistance;
        
        /*
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        */
        
        viewMoved = NO;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == txtSearchLocation)
    {
        btnCancel.hidden = TRUE;
        
        /*
        CGRect txtSearchLocationFrame = txtSearchLocation.frame;
        txtSearchLocationFrame.size.width = (btnCancel.frame.origin.x + btnCancel.frame.size.width) - txtSearchLocation.frame.origin.x;
        txtSearchLocation.frame = txtSearchLocationFrame;
        */
        
        autoCompleteLocationArray = nil;
        [mainAutoCompleteTableView reloadData];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtSearchLocation)
    {
        [_fetcher sourceTextHasChanged:textField.text];
    }
    
    return YES;
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Called.");
    
    [appDelegate dismissGlobalHUD];
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = [MySingleton sharedManager].strLocationDisabledErrorTitle;
    alertViewController.message = [MySingleton sharedManager].strLocationDisabledErrorMessageForSearchAddressScreen;
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.buttonColor = [MySingleton sharedManager].darkOrange4ColorCode;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        [alertViewController dismissViewControllerAnimated:YES completion:nil];
                                    }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations Called.");
    
    currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil)
    {
        strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        [locationManager stopUpdatingLocation];
        //[self getLocationAddress:strLatitude withLongitude:strLongitude];
        [self getLocationAddress:strLatitude withLongitude:strLongitude withLocationCoordinates:currentLocation];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = [MySingleton sharedManager].strLocationDisabledErrorTitle;
        alertViewController.message = [MySingleton sharedManager].strLocationDisabledErrorMessageForSearchAddressScreen;
        
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions
{
    autoCompleteLocationArray = [predictions mutableCopy];
    mainAutoCompleteTableView.hidden = false;
    lblInstruction.hidden = true;
    lblInstructionHeightConstraint.active = true;
    lblInstructionHeightConstraint.constant = 0.0;
    [mainAutoCompleteTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    NSString *strError = [NSString stringWithFormat:@"%@", error.localizedDescription];
    NSLog(@"strError : %@",strError);
}

#pragma mark - Function for getting current Address
-(void)getLocationAddress:(NSString *)strLocationLatitude withLongitude:(NSString *)strLocationLongitude
  withLocationCoordinates:(CLLocation *)currentLocation
{
    @try
    {
        [locationManager stopUpdatingLocation];
        
        /*
        NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",strLocationLatitude,strLocationLongitude];
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
        
        if(jsonAry.count > 1)
        {
            add = [jsonAry objectAtIndex:1];
            
            NSString *fulladdress = [add objectForKey:@"formatted_address"];
            self.selectedLocationName = fulladdress;
            
        }
        else
        {
            [appDelegate dismissGlobalHUD];
            
        }
        */
        
        [self getAddressFromLocation:currentLocation completionBlock:^(NSString * address) {
                if(address) {
                    //_address = address;
                    //printf("%s", address);
                    
                    //NSString *fulladdress = [add objectForKey:@"formatted_address"];
                    self.selectedLocationName = [NSString stringWithFormat:@"%@",address];
                }
                else {
                    //self.selectedLocationName = @"";
                    [appDelegate dismissGlobalHUD];
                }
            }];
        
    }
    @catch (NSException *exception)
    {
        [appDelegate dismissGlobalHUD];
        
    }
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
#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SearchViewHeader *searchViewHeader;
    
    searchViewHeader = [[SearchViewHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        
    [searchViewHeader.btnCourrentLocation addTarget:self action:@selector(btnUseCurrentLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return searchViewHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
       return autoCompleteLocationArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 60;
    
    GMSAutocompletePrediction *prediction = [autoCompleteLocationArray objectAtIndex:indexPath.row];
    
    NSString *placePrimaryTextString = [prediction.attributedPrimaryText string];
    
    UILabel *lblMain = [[UILabel alloc] initWithFrame:CGRectMake(60,5,([MySingleton sharedManager].screenWidth - 70),25)];
    lblMain.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
    lblMain.numberOfLines = 0;
    lblMain.text = placePrimaryTextString;
    [lblMain sizeToFit];
    
    CGRect lblMainTextRect = [lblMain.text boundingRectWithSize:lblMain.frame.size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:lblMain.font}
                                                        context:nil];
    
    CGSize lblMainSize = lblMainTextRect.size;
    
    CGFloat lblMainHeight = lblMainSize.height;
    
    NSString *placeSecondaryTextString = [prediction.attributedSecondaryText string];
    if(placeSecondaryTextString == nil || placeSecondaryTextString.length <= 0)
    {
        placeSecondaryTextString = placePrimaryTextString;
    }
    
    UILabel *lblSub = [[UILabel alloc] initWithFrame:CGRectMake(60,(lblMain.frame.origin.y + lblMainHeight + 5),([MySingleton sharedManager].screenWidth - 70),20)];
    lblSub.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    lblSub.numberOfLines = 0;
    lblSub.text = placeSecondaryTextString;
    [lblSub sizeToFit];
    
    CGRect lblSubTextRect = [lblSub.text boundingRectWithSize:lblSub.frame.size
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:lblSub.font}
                                                      context:nil];
    
    CGSize lblSubSize = lblSubTextRect.size;
    
    CGFloat lblSubHeight = lblSubSize.height;
    
    return lblSub.frame.origin.y + lblSubHeight + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    PlaceTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell = [[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    
    if(indexPath.row <= autoCompleteLocationArray.count)
    {
        GMSAutocompletePrediction *prediction = [autoCompleteLocationArray objectAtIndex:indexPath.row];
        
        NSString *placePrimaryTextString = [prediction.attributedPrimaryText string];
        
        NSString *placeSecondaryTextString = [prediction.attributedSecondaryText string];
        if(placeSecondaryTextString == nil || placeSecondaryTextString.length <= 0)
        {
            placeSecondaryTextString = placePrimaryTextString;
        }
        
        cell.lblMain.text = placePrimaryTextString;
        [cell.lblMain sizeToFit];
        
        cell.lblSub.text =placeSecondaryTextString;
        [cell.lblSub sizeToFit];
        
        CGRect lblMainTextRect = [cell.lblMain.text boundingRectWithSize:cell.lblMain.frame.size
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:cell.lblMain.font}
                                                                 context:nil];
        CGSize lblMainSize = lblMainTextRect.size;
        
        CGFloat lblMainHeight = lblMainSize.height;
        
        CGRect lblSubTextRect = [cell.lblSub.text boundingRectWithSize:cell.lblSub.frame.size
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:cell.lblSub.font}
                                                               context:nil];
        
        CGSize lblSubSize = lblSubTextRect.size;
        
        CGFloat lblSubHeight = lblSubSize.height;
        
        
        CGRect lblMainFrame = cell.lblMain.frame;
        lblMainFrame.size.height = lblMainHeight;
        cell.lblMain.frame = lblMainFrame;
        
        CGRect lblSubFrame = cell.lblSub.frame;
        lblSubFrame.origin.y = cell.lblMain.frame.origin.y + lblMainHeight + 5;
        lblSubFrame.size.height = lblSubHeight;
        cell.lblSub.frame = lblSubFrame;
        
        CGRect vwContainerFrame = cell.vwContainer.frame;
        vwContainerFrame.size.height = cell.lblSub.frame.origin.y + lblSubHeight + 5;
        cell.vwContainer.frame = vwContainerFrame;
        
        CGRect seperatorFrame = cell.seperator.frame;
        seperatorFrame.origin.y = cell.vwContainer.frame.size.height - 1;
        cell.seperator.frame = seperatorFrame;
        
        cell.lblMain.textColor=[MySingleton sharedManager].darkOrange4ColorCode;
        cell.lblSub.textColor=[UIColor darkGrayColor];

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        PlaceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *city = [NSString stringWithFormat:@"%@,%@",cell.lblMain.text,cell.lblSub.text];
        CLLocationCoordinate2D center;
      //  center=[self getLocationFromAddressString:city];
    
    [self.view endEditing:YES];
    
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:city completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(!error)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"%f",placemark.location.coordinate.latitude);
             NSLog(@"%f",placemark.location.coordinate.longitude);
            
             double  latFrom=placemark.location.coordinate.latitude;
             double  lonFrom=placemark.location.coordinate.longitude;
         
             [MySingleton sharedManager].dataManager.strSelectedLocationLatitude=[NSString   stringWithFormat:@"%f",latFrom];
             [MySingleton sharedManager].dataManager.strSelectedLocationLongitude=[NSString stringWithFormat:@"%f",lonFrom];
             [MySingleton sharedManager].dataManager.strSelectedLocationName=city;
             [MySingleton sharedManager].boolIsWebServiceCalledOnce=TRUE;
         
             
             
             if (self.isFromHome) {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else {
                 HomeViewController *viewController;
                 
                 viewController = [[HomeViewController alloc] init];
                 [self.navigationController pushViewController:viewController animated:YES];
             }
             
             //latitude = placemark.location.coordinate.latitude;
             //longitude = placemark.location.coordinate.longitude;
             NSLog(@"%@",[NSString stringWithFormat:@"%@",[placemark description]]);
             [appDelegate dismissGlobalHUD];
         }
         else
         {
             [appDelegate dismissGlobalHUD];
             NSLog(@"There was a forward geocoding error\n%@",[error localizedDescription]);
         }
     }
     ];
    
    
       

}

#pragma mark - UITableViewController GET LAT AND LONG FROM CITY NAME

//-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr
//{
//    double latitude = 0, longitude = 0;
//
//    CLGeocoder* geocoder = [CLGeocoder new];
//    [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if(!error)
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"%f",placemark.location.coordinate.latitude);
//             NSLog(@"%f",placemark.location.coordinate.longitude);
//
//             //latitude = placemark.location.coordinate.latitude;
//             //longitude = placemark.location.coordinate.longitude;
//             NSLog(@"%@",[NSString stringWithFormat:@"%@",[placemark description]]);
//         }
//         else
//         {
//             NSLog(@"There was a forward geocoding error\n%@",[error localizedDescription]);
//         }
//     }
//     ];
//
//    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=AIzaSyClwl--g3YGvvxdPKS_4pjWA7ziLsjfXYA", esc_addr];
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//    if (result) {
//        NSScanner *scanner = [NSScanner scannerWithString:result];
//        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
//            [scanner scanDouble:&latitude];
//            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
//                [scanner scanDouble:&longitude];
//            }
//        }
//    }
//
//    CLLocationCoordinate2D center;
//    center.latitude=latitude;
//    center.longitude = longitude;
//    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
//    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
//
//
//    return center;
//
//}

#pragma mark - Other Methods

-(IBAction)btnUseCurrentLocationClicked:(id)sender
{
    @try
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
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
    
        double latinew = locationManager.location.coordinate.latitude;
        double longinew = locationManager.location.coordinate.longitude;
    
        NSString *latitudeforqry = [[NSNumber numberWithFloat:latinew] stringValue];
        NSString *longitudeforqry = [[NSNumber numberWithFloat:longinew] stringValue];

        NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",latitudeforqry,longitudeforqry];
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
        
        [self getAddressFromLocation:locationManager.location completionBlock:^(NSString * address) {
                if(address) {
                    //_address = address;
                    //printf("%s", address);
                    
                    //NSString *fulladdress = [add objectForKey:@"formatted_address"];
                    //self.selectedLocationName = [NSString stringWithFormat:@"%@",address];
                    
                    HomeViewController *objHome = [[HomeViewController alloc]init];
                    objHome.isFromSelectLocationVC = true;
                    objHome.lblLocation.text=[NSString stringWithFormat:@"%@",address];
                    
                    [MySingleton sharedManager].dataManager.strSelectedLocationLatitude=[NSString   stringWithFormat:@"%f",latinew];
                    [MySingleton sharedManager].dataManager.strSelectedLocationLongitude=[NSString stringWithFormat:@"%f",longinew];
                    [MySingleton sharedManager].dataManager.strSelectedLocationName=address;
                    [MySingleton sharedManager].boolIsWebServiceCalledOnce=TRUE;
                    
                    [self btnSearchClicked];
                    
                }
                else {
                    //self.selectedLocationName = @"";
                    [appDelegate dismissGlobalHUD];
                }
            }];
        
        
        if(jsonAry.count > 1)
        {
        /*
            add = [jsonAry objectAtIndex:1];
        
            NSString *fulladdress = [add objectForKey:@"formatted_address"];
            HomeViewController *objHome = [[HomeViewController alloc]init];
            objHome.lblLocation.text=[NSString stringWithFormat:@"%@",fulladdress];
            
            [self btnSearchClicked];
        */
            
        }
        
        else
        {
            [appDelegate dismissGlobalHUD];
            
        }
    }
        @catch (NSException *exception) {
            NSLog(@"Exception in getting current loacation in my account%@",exception);
}
}
@end
