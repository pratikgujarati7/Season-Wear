//
//  HomeTableViewCell.h
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/21/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UIView *vwContainer;
@property (nonatomic, retain) IBOutlet UIView *vwInnerContainer;
@property (nonatomic, retain) IBOutlet UIView *separatorView;
@property (nonatomic, retain) IBOutlet UILabel *lblMinTemp;
@property (nonatomic, retain) IBOutlet UILabel *lblMaxTemp;
@property (nonatomic, retain) IBOutlet UIImageView *imgCloth;
@property (nonatomic, retain) IBOutlet UIImageView *imgWeather;
@property (nonatomic, retain) IBOutlet UILabel *lblDay;
@property (nonatomic, retain) IBOutlet UILabel *lblSmallInfo;
@property (nonatomic, retain) IBOutlet UILabel *lblLargeInfo;
@property (nonatomic, retain) IBOutlet UIView *lblView1;
@property (nonatomic, retain) IBOutlet UIView *lblView2;
@property (nonatomic, retain) IBOutlet UIView *DayView;
@property (nonatomic, retain) IBOutlet UILabel *lblDate;

@end
