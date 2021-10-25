//
//  PlaceTableViewCell.h
//  Google Maps Demo
//
//  Created by Pratik Gujarati on 20/08/16.
//  Copyright © 2016 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewCell : UITableViewCell
{
    UIView *vwContainer;
    UIImageView *imageViewMain;
    UILabel *lblMain;
    UILabel *lblSub;
    UIView *seperator;
}

@property (nonatomic, retain) UIView *vwContainer;

@property (nonatomic, retain) UIImageView *imageViewMain;

@property (nonatomic, retain) UILabel *lblMain;
@property (nonatomic, retain) UILabel *lblSub;

@property (nonatomic, retain) UIView *seperator;


@end
