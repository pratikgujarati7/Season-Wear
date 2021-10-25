//
//  SearchViewHeader.m
//  Season Wear
//
//  Created by Viraj Patel on 06/04/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "SearchViewHeader.h"
#import "MySingleton.h"

@implementation SearchViewHeader


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //=======ADD BACKGROUND VIEW=======//
        self.vwContainer = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        self.vwContainer.backgroundColor =  [MySingleton sharedManager].darkGreyColorCode;
        
        //=======ADD INNER CONTAINER VIEW=======//
        self.vwInnerContainer = [[UIView alloc]initWithFrame:CGRectMake(0,5,self.vwContainer.frame.size.width,self.vwContainer.frame.size.height-10)];
        self.vwInnerContainer.backgroundColor =  [UIColor whiteColor];
        
        //=======ADD MAIN IMAGE VIEW=======//
        self.imageViewMain = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        self.imageViewMain.image = [UIImage imageNamed:@"locationBtn.png"];
        [self.vwInnerContainer addSubview:self.imageViewMain];
        
        //========ADD MAIN TEXT LABEL INTO BOX========//
        self.lblMain = [[UILabel alloc] initWithFrame:CGRectMake(60,5,self.vwInnerContainer.frame.size.width - 70,self.vwInnerContainer.frame.size.height - 10)];
        self.lblMain.textColor = [UIColor blackColor];
        self.lblMain.text = @"Select Current Location";
        self.lblMain.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
        [self.vwInnerContainer addSubview:self.lblMain];
        
        //======== ADD Button ========//
        self.btnCourrentLocation=[[UIButton alloc] initWithFrame:CGRectMake(0,0,self.vwInnerContainer.frame.size.width,self.vwInnerContainer.frame.size.height)];
        [self.vwInnerContainer addSubview:self.btnCourrentLocation];
        
        [self.vwContainer addSubview:self.vwInnerContainer];
        
        [self addSubview:self.vwContainer];
        self.backgroundColor = [UIColor clearColor];

        
    }
    return self;
}

@end
