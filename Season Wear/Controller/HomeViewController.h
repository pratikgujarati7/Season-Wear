//
//  HomeViewController.h
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/20/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface HomeViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,UITextViewDelegate>
{
    
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}



//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UIView *mainView;
@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UISwitch *btnSwitch;
@property (nonatomic,retain) IBOutlet UISwitch *btnChangeToF;
@property (nonatomic,retain) IBOutlet UITextView *lblLocation;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;
@property (nonatomic,retain) IBOutlet UIButton *btnSearch;
@property (nonatomic,retain) IBOutlet UILabel *lblmen;
@property (nonatomic,retain) IBOutlet UILabel *lbwomen;
@property (nonatomic,retain) IBOutlet UIButton *btnEye;
@property (nonatomic,retain) IBOutlet UIImageView *imgEye;
@property (nonatomic,retain) IBOutlet UILabel *lblLocationDisabledInstruction;
@property (nonatomic,retain) IBOutlet UIView *locationDisabledContainerView;

//========== OTHER VARIABLES ==========//
@property (nonatomic, retain) NSMutableArray *dataRows;
@property (nonatomic,retain) NSString *currentLocationName;
@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;

@property (nonatomic, assign) BOOL isFromSelectLocationVC;

@end
