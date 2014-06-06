//
//  PopUpViewController.h
//  TitleScreen
//
//  Created by Josh Anatalio on 5/19/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController
@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, strong) UIImageView *itemPictureView;
@property (strong, nonatomic) IBOutlet UIImageView *itemPictureImageView;
@property (strong, nonatomic) UIImage *foodPic;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) NSString *foodNameString;
@property (strong, nonatomic) NSString *foodDescriptionString;
@property (strong, nonatomic) NSString *priceString;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *toVenmoButton;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@end
