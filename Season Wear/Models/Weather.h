//
//  Weather.h
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/21/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject


@property(nonatomic,retain) NSString *strMaxTempFarenhit;
@property(nonatomic,retain) NSString *strMinTempFarenhit;
@property(nonatomic,retain) NSString *strMaxTempCelsius;
@property(nonatomic,retain) NSString *strMinTempCelsius;
@property(nonatomic,retain) NSString *strDay;
@property(nonatomic,retain) NSString *strSummary;
@property(nonatomic,retain) NSString *strIcon;

@end
