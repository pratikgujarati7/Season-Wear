//
//  SearchViewHeader.h
//  Season Wear
//
//  Created by Viraj Patel on 06/04/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewHeader : UIView
{
    UIView *vwContainer;
    UIImageView *imageViewMain;
    UILabel *lblMain;
    UIButton *btnCourrentLocation;
    UIView *seperator;
}

@property (nonatomic, retain) UIView *vwInnerContainer;
@property (nonatomic,retain) UIView *vwContainer;
@property (nonatomic, retain) UIImageView *imageViewMain;
@property (nonatomic,retain) UILabel *lblMain;
@property (nonatomic,retain) UIButton *btnCourrentLocation;
@property (nonatomic,retain) UIView *separatorView;

@end
