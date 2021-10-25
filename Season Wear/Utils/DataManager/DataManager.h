//
//  DataManager.h
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "CommonUtility.h"
#import "ASIFormDataRequest.h"


@interface DataManager : NSObject
{
    // The delegate - Will be notified of various changes of state via the DataManagerDelegate
    
    NSNumber  *isNetworkAvailable;
    AppDelegate *appDelegate;
}

@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSDictionary *dictSettings;
@property(nonatomic,retain) NSString *strUserLocationLatitude;
@property(nonatomic,retain) NSString *strUserLocationLongitude;
@property(nonatomic,retain) NSString *strSelectedLocationLatitude;
@property(nonatomic,retain) NSString *strSelectedLocationLongitude;
@property(nonatomic,retain) NSString *strSelectedLocationName;
@property(nonatomic,retain) NSMutableArray *arrayWeatherDeatils;
#pragma mark - Server communication

//FUNCTION TO CHECK IF INTERNET CONNECTION IS AVAILABLE OR NOT
-(BOOL)isNetworkAvailable;

//FUNCTION TO SHOW ERROR ALERT
-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription;



//FUNCTION FOR getting weather details
-(void)getWeatherDetails:(NSString *)strlatitude withLongitude:(NSString *)strlongitude;


@end
