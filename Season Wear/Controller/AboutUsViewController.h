//
//  AboutUsViewController.h
//  Season Weare
//
//  Created by INNOVATIVE ITERATION 2 on 3/27/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>


//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UIView *mainView;
@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIImageView *imgback;
@property (nonatomic,retain) IBOutlet UIView *ShareView;
@property (nonatomic,retain) IBOutlet UIImageView *imgShare;
@property (nonatomic,retain) IBOutlet UILabel *lblShareTitle;
@property (nonatomic,retain) IBOutlet UIButton *btnShare;
@property (nonatomic,retain) IBOutlet UILabel *lblPoweredByTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblPoweredByValue;
@property (nonatomic,retain) IBOutlet UITextView *txtView;
@property (nonatomic,retain) IBOutlet UIView *maintxtView;
@property (nonatomic,retain) IBOutlet UIView *mainPoweredView;


@end
