//
//  PopUpViewController.m
//  TitleScreen
//
//  Created by Josh Anatalio on 5/19/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "PopUpViewController.h"
#import "MZFormSheetController.h"
#import "Bolts.h"
#import <AdSupport/AdSupport.h>
#import <Parse/Parse.h>

@interface PopUpViewController ()
@property NSString *UUID;

@end

@implementation PopUpViewController


- (IBAction)venmoPressed:(id)sender {
    BFAppLink *links = [BFAppLink appLinkWithSourceURL:[NSURL URLWithString:@"venmo://friend"] targets:nil webURL:[NSURL URLWithString:@"venmo://friend"]];
    [BFAppLinkNavigation navigateToAppLink: links error:nil];
    
}
- (IBAction)addToPlateButton:(id)sender {
    self.UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [self addToPlateQuery:self.UUID ItemName:self.foodNameString];
    
}


- (void)addToPlateQuery: (NSString *) userID ItemName: (NSString *) menuItem {
    
    NSLog(@"Inside add to plate query");
    
    __block PFFile *queryPic;
    __block NSString *queryPrice;
    
    PFObject *plateCell = [PFObject objectWithClassName:@"MyPlate"];
    plateCell[@"menuItemName"] = menuItem;
    plateCell[@"userid"] = userID;
    
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    [query whereKey:@"menuItemName" equalTo:menuItem];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            
            queryPic = object[@"pics"];
            queryPrice = object[@"menuItemPrice"];
            plateCell[@"menuItemPrice"] = queryPrice;
            plateCell[@"pics"] = queryPic;
            
            // Add menu item to MyPlate table/database
            [plateCell saveInBackground];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.foodPic)
    {
        NSLog(@"Food pic is null");
    }
    self.itemPictureImageView.image = self.foodPic;
    self.foodNameLabel.text = self.foodNameString;
    self.priceLabel.text = self.priceString;
    self.foodDescriptionLabel.text = self.foodDescriptionString;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}
- (IBAction)okButtonPressed:(id)sender {
    
}
/*
-(UILabel *)foodNameLabel{
    if(!_foodNameLabel)
    {
        
        _foodNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [_foodNameLabel setFont:[UIFont fontWithName:@"Euphemia UCAS" size:12]];
        
        _foodNameLabel.textColor = [UIColor blackColor];
    }
    
    return _foodNameLabel;
}
*/

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar; // your own visibility code
}

@end
