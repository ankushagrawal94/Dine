//
//  ShakeViewController.h
//  TitleScreen
//
//  Created by Alex C Tsang on 5/25/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UISlider *calSlider;
@property (weak, nonatomic) IBOutlet UIButton *entreeButton;
@property (weak, nonatomic) IBOutlet UIButton *appetizerButton;
@property (weak, nonatomic) IBOutlet UIButton *dessertButton;
@property (weak, nonatomic) IBOutlet UIButton *drinkButton;
@property (weak, nonatomic) IBOutlet UIButton *vegetarianButton;
@property (weak, nonatomic) IBOutlet UIButton *glutenFreeButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *sketchCover;
@property (weak, nonatomic) IBOutlet UILabel *testPri;
@property (weak, nonatomic) IBOutlet UILabel *testCal;
@property (weak, nonatomic) IBOutlet UILabel *numMeal;
@property (weak, nonatomic) IBOutlet UILabel *priceMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *calMinLabel;


- (IBAction)priceChange:(id)sender;
- (IBAction)calorieChange:(id)sender;
- (IBAction)entreeTapped:(UIButton *)sender;
- (IBAction)appetizerTapped:(UIButton *)sender;
- (IBAction)beverageTapped:(UIButton *)sender;
- (IBAction)dessertTapped:(UIButton *)sender;
- (IBAction)vegTapped:(UIButton *)sender;
- (IBAction)gfTapped:(UIButton *)sender;

@end
