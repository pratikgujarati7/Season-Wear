//
//  PlaceTableViewCell.m
//  Google Maps Demo
//
//  Created by Pratik Gujarati on 20/08/16.
//  Copyright © 2016 innovativeiteration. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "MySingleton.h"

#define CellBigHeight 60


@implementation PlaceTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [self setSelectedBackgroundView:bgColorView];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        float cellHeight = CellBigHeight;
        float cellWidth = [MySingleton sharedManager].screenWidth;
        
        //=======ADD BACKGROUND VIEW=======//
        self.vwContainer = [[UIView alloc]initWithFrame:CGRectMake(0,0,cellWidth,cellHeight)];
        self.vwContainer.backgroundColor =  [UIColor whiteColor];
        
        //=======ADD MAIN IMAGE VIEW=======//
        self.imageViewMain = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        self.imageViewMain.image = [UIImage imageNamed:@"locationBtn.png"];
        [self.vwContainer addSubview:self.imageViewMain];
        
        //========ADD MAIN TEXT LABEL INTO BOX========//
        self.lblMain = [[UILabel alloc] initWithFrame:CGRectMake(60,5,self.vwContainer.frame.size.width - 70,25)];
        self.lblMain.textColor = [UIColor blackColor];
        self.lblMain.numberOfLines = 0;
        self.lblMain.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        [self.vwContainer addSubview:self.lblMain];
        
        //========ADD SUB TEXT LABEL INTO BOX========//
        self.lblSub = [[UILabel alloc] initWithFrame:CGRectMake(60,(self.lblMain.frame.origin.y + self.lblMain.frame.size.height + 5),self.vwContainer.frame.size.width - 70,20)];
        self.lblSub.textColor = [UIColor blackColor];
        self.lblSub.numberOfLines = 0;
        self.lblSub.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        [self.vwContainer addSubview:self.lblSub];
        
        //========ADD SEPERATOR INTO BOX ========//
        self.seperator =[[UIView alloc]initWithFrame:CGRectMake(0,self.vwContainer.frame.size.height-1,cellWidth,0.5)];
        self.seperator.backgroundColor = [UIColor lightGrayColor];
        [self.vwContainer addSubview:self.seperator];
        
        [self addSubview:self.vwContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}




@end
