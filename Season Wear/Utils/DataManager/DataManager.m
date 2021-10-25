 //
//  DataManager.m
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import "DataManager.h"
#import "MySingleton.h"
#import "Weather.h"
@implementation DataManager

-(id)init
{
    _dictSettings = [NSDictionary dictionaryWithContentsOfFile: [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"Settings.plist"]];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}

- (BOOL) isNetworkAvailable
{
    Reachability *reach = [Reachability reachabilityWithHostName:[_dictSettings objectForKey:@"AvailabilityHostToCheck"]];
    NetworkStatus status = [reach currentReachabilityStatus];
    isNetworkAvailable = [NSNumber numberWithBool:!(status == NotReachable)];
    reach = nil;
    return [isNetworkAvailable boolValue];
}

-(void)showInternetNotConnectedError
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"Please make sure that you are connected to the internet." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go to Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
        if (&UIApplicationOpenSettingsURLString != NULL) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alertController addAction:ok];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:NO completion:nil];
}

-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription
{
    if([errorTitle isEqualToString:@"Server Error"])
    {
        errorDescription = @"Server is not responding right now. Please try again after some time.";
    }
    else
    {
        errorDescription = errorDescription;
    }
    
    [appDelegate dismissGlobalHUD];
    
    [appDelegate showErrorAlertViewWithTitle:errorTitle withDetails:errorDescription];
}

- (void) connectionError:(ASIHTTPRequest*)request
{
    [appDelegate dismissGlobalHUD];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionErrorEvent" object:request];
    [self showInternetNotConnectedError];
}

#pragma mark - FUNCTION FOR GETTING WEATHER DETAILS

-(void)getWeatherDetails:(NSString *)strlatitude withLongitude:(NSString *)strlongitude
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSLog(@"%@",strlatitude);
        NSLog(@"%@",strlongitude);

        NSString *urlString = [NSString stringWithFormat:@"%@%@,%@",[_dictSettings objectForKey:@"ServerIP"],strlatitude,strlongitude];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
          request.requestMethod = @"GET";
        request.delegate = self;
        request.didFinishSelector = @selector(gotWeatherDetails:);
        request.didFailSelector = @selector(connectionError:);
        request.numberOfTimesToRetryOnTimeout = 0;
        request.shouldAttemptPersistentConnection = NO;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        request.timeOutSeconds = 60000;
        [request startAsynchronous];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

-(void)gotWeatherDetails:(ASIHTTPRequest *)request
{
    [appDelegate dismissGlobalHUD];
    if ([request error])
    {
        [self showErrorMessage:@"Server Error" withErrorContent:@""];
    }
    else
    {
        NSError *error;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
        
        if(error != nil)
        {
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }
        else
        {
            NSDictionary *dictDaily = [jsonResult objectForKey:@"daily"];
            
            NSMutableArray *arrayData = [dictDaily objectForKey:@"data"];
            NSLog(@"%@",arrayData);
            
            self.arrayWeatherDeatils = [[NSMutableArray alloc] init];
            
            for(int i=0;i<arrayData.count;i++)
            {
                Weather *objWeather =[[Weather alloc]init];
                
                NSDictionary *dict = [arrayData objectAtIndex:i];
                
                float temperatureMinInFarenhit = [[dict objectForKey:@"temperatureMin"] floatValue];
                int roundedTemperatureMinInFarenhit = lroundf(temperatureMinInFarenhit);
                objWeather.strMinTempFarenhit = [NSString stringWithFormat:@"%d",roundedTemperatureMinInFarenhit];
                
                
                float temperatureMinInCelsius = ([objWeather.strMinTempFarenhit floatValue] - 32) / 1.8;
                int roundedTemperatureMinInCelsius = lroundf(temperatureMinInCelsius);
                objWeather.strMinTempCelsius = [NSString stringWithFormat:@"%d",roundedTemperatureMinInCelsius];
                
                
                float temperatureMaxInFarenhit = [[dict objectForKey:@"temperatureMax"] floatValue];
                int roundedTemperatureMaxInFarenhit = lroundf(temperatureMaxInFarenhit);
                objWeather.strMaxTempFarenhit = [NSString stringWithFormat:@"%d",roundedTemperatureMaxInFarenhit];
                
                
                float temperatureMaxInCelsius = ([objWeather.strMaxTempFarenhit floatValue] - 32) / 1.8;
                int roundedTemperatureMaxInCelsius = lroundf(temperatureMaxInCelsius);
                objWeather.strMaxTempCelsius = [NSString stringWithFormat:@"%d",roundedTemperatureMaxInCelsius];
                
                objWeather.strSummary=[NSString stringWithFormat:@"%@", [dict objectForKey:@"summary"]];
                objWeather.strIcon=[NSString stringWithFormat:@"%@", [dict objectForKey:@"icon"]];
                objWeather.strDay=[NSString stringWithFormat:@"%@", [dict objectForKey:@"time"]];
                
                [self.arrayWeatherDeatils insertObject:objWeather atIndex:self.arrayWeatherDeatils.count];
                
            }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotWeatherDetailsEvent" object:request];

        }
    }
}






@end
