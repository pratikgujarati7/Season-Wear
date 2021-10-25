//
//  SearchAddressViewController.h
//  Finder
//
//  Created by Pratik Gujarati on 21/01/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SearchAddressViewController : UIViewController<UIScrollViewDelegate,  UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,GMSAutocompleteFetcherDelegate, CLLocationManagerDelegate>
{
    //TO ANIMATE VIEW UP ON KEYBOARD SHOW
    CGFloat animatedDistance;
    UITextField *activeTextField;
    BOOL keyboardShown;
    BOOL viewMoved;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    GMSPlacesClient *_placesClient;
}

//TO ANIMATE VIEW UP ON KEYBOARD SHOW
//@property (strong, nonatomic) UITextField *activeTextField;
//@property (nonatomic,assign) BOOL keyboardShown;
//@property (nonatomic,assign) BOOL viewMoved;

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *txtSearchLocationContainerView;
@property (nonatomic,retain) IBOutlet UITextField *txtSearchLocation;
@property (nonatomic,retain) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblInstructionHeightConstraint; //>= 50
@property (nonatomic,retain) IBOutlet UILabel *lblInstruction;
@property (nonatomic,retain) IBOutlet UITableView *mainAutoCompleteTableView;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIImageView *imgback;


//========== OTHER VARIABLES ==========//
@property (nonatomic,retain) NSMutableArray *autoCompleteLocationArray;

@property (nonatomic,retain) GMSAutocompleteFetcher* fetcher;

@property (nonatomic,retain) NSString *selectedLocationName;
@property (nonatomic,retain) NSString *strSelectedLocationLatitude;
@property (nonatomic,retain) NSString *strSelectedLocationLongitude;
@property (nonatomic,retain) NSString *currentLocationName;
@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;
@property (nonatomic, assign) BOOL isFromHome;

@end
