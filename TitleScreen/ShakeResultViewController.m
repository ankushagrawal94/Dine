//
//  ShakeResultViewController.m
//  TitleScreen
//
//  Created by Aaron Chuang on 5/18/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//
#import "ShakeResultViewController.h"
#import "ShakeMeal.h"
#import <Parse/Parse.h>
#import <AdSupport/AdSupport.h>
#import <QuartzCore/QuartzCore.h>
@interface ShakeResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *Beverage;
@property (weak, nonatomic) IBOutlet UIImageView *Appetizer;
@property (weak, nonatomic) IBOutlet UILabel *AppetizerPrice;
@property (weak, nonatomic) IBOutlet UILabel *DessertPrice;
@property (weak, nonatomic) IBOutlet UILabel *BeveragePrice;
@property (weak, nonatomic) IBOutlet UILabel *MealCalories;
@property (weak, nonatomic) IBOutlet UILabel *MealPrice;
@property (weak, nonatomic) IBOutlet UIButton *AddBeverageToPlate;
@property (weak, nonatomic) IBOutlet UILabel *BeverageName;
@property (weak, nonatomic) IBOutlet UIButton *AddDessertToPlate;
@property (weak, nonatomic) IBOutlet UILabel *DessertName;
@property (weak, nonatomic) IBOutlet UIImageView *Dessert;
@property (weak, nonatomic) IBOutlet UIButton *AddEntreeToPlate;
@property (weak, nonatomic) IBOutlet UILabel *EntreePrice;
@property (weak, nonatomic) IBOutlet UILabel *EntreeName;
@property (weak, nonatomic) IBOutlet UIImageView *Entree;
@property (weak, nonatomic) IBOutlet UIButton *AddAppetizerToPlate;
@property (weak, nonatomic) IBOutlet UILabel *AppetizerName;
@property NSString *UUID;
@end
@implementation ShakeResultViewController
int comboCount = 0;
int counter = 0;
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    roundedView.clipsToBounds = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    counter = 0;
    __block PFFile *appetizerPic;
    __block PFFile *entreePic;
    __block PFFile *dessertPic;
    __block PFFile *beveragePic;
    
    // Resize UIImageView to be a circle
    [self setRoundedView:_Appetizer toDiameter:100.0];
    [self setRoundedView:_Entree toDiameter:100.0];
    [self setRoundedView:_Dessert toDiameter:100.0];
    [self setRoundedView:_Beverage toDiameter:100.0];
    self.AddAppetizerToPlate.hidden = YES;
    self.AddBeverageToPlate.hidden = YES;
    self.AddDessertToPlate.hidden = YES;
    self.AddEntreeToPlate.hidden = YES;
    
    comboCount = [_comboArray count];
    if(comboCount > counter) {
        if(self.comboArray[counter][0] != [NSNull null]) {
            PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
            [query whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][0]).mealItem];
            //[query whereKey:@"menuItemName" equalTo:@"Angus Beef Sliders"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!object) {
                    NSLog(@"The getFirstObject request failed.");
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    appetizerPic = object[@"pics"];
                    
                    // Grab image from PFfile object and set it to view
                    [appetizerPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            // image can now be set on a UIImageView
                            [self.Appetizer setImage:image];
                        }
                    }];
                }
            }];
            // Do any additional setup after loading the view.
            self.AppetizerName.text = ((ShakeMeal*)self.comboArray[counter][0]).mealItem;
            [self.AppetizerName setFont:[UIFont systemFontOfSize:12]];
            self.AppetizerName.textAlignment = NSTextAlignmentCenter;
            self.AppetizerPrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][0]).price];
            [self.AppetizerPrice setFont:[UIFont systemFontOfSize:12]];
            self.AddAppetizerToPlate.hidden = NO;
        }
        else {
            self.AppetizerName.text = nil;
            [self.AppetizerName setFont:[UIFont systemFontOfSize:12]];
            self.AppetizerName.textAlignment = NSTextAlignmentCenter;
            self.AppetizerPrice.text = nil;
            [self.AppetizerPrice setFont:[UIFont systemFontOfSize:12]];
        }
        
        if(self.comboArray[counter][1] != [NSNull null]) {
            PFQuery *query1 = [PFQuery queryWithClassName:@"BJMenu"];
            [query1 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][1]).mealItem];
            [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!object) {
                    NSLog(@"The getFirstObject request failed.");
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    entreePic = object[@"pics"];
                    
                    // Grab image from PFfile object and set it to view
                    [entreePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            // image can now be set on a UIImageView
                            [self.Entree setImage:image];
                        }
                    }];
                }
            }];
            self.EntreeName.text = ((ShakeMeal*)self.comboArray[counter][1]).mealItem;
            [self.EntreeName setFont:[UIFont systemFontOfSize:12]];
            self.EntreeName.textAlignment = NSTextAlignmentCenter;
            self.EntreePrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][1]).price];
            [self.EntreePrice setFont:[UIFont systemFontOfSize:12]];
            self.AddEntreeToPlate.hidden = NO;
        }
        else {
            self.EntreeName.text = nil;
            [self.EntreeName setFont:[UIFont systemFontOfSize:12]];
            self.EntreeName.textAlignment = NSTextAlignmentCenter;
            self.EntreePrice.text = nil;
            [self.EntreePrice setFont:[UIFont systemFontOfSize:12]];
        }
        
        if(self.comboArray[counter][2] != [NSNull null]) {
            PFQuery *query2 = [PFQuery queryWithClassName:@"BJMenu"];
            [query2 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][2]).mealItem];
            [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!object) {
                    NSLog(@"The getFirstObject request failed.");
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    dessertPic = object[@"pics"];
                    
                    // Grab image from PFfile object and set it to view
                    [dessertPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            // image can now be set on a UIImageView
                            [self.Dessert setImage:image];
                        }
                    }];
                }
            }];
            self.DessertName.text = ((ShakeMeal*)self.comboArray[counter][2]).mealItem;
            [self.DessertName setFont:[UIFont systemFontOfSize:12]];
            self.DessertName.textAlignment = NSTextAlignmentCenter;
            self.DessertPrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][2]).price];
            [self.DessertPrice setFont:[UIFont systemFontOfSize:12]];
            self.AddDessertToPlate.hidden = NO;
        }
        else {
            self.DessertName.text = nil;
            [self.DessertName setFont:[UIFont systemFontOfSize:12]];
            self.DessertName.textAlignment = NSTextAlignmentCenter;
            self.DessertPrice.text = nil;
            [self.DessertPrice setFont:[UIFont systemFontOfSize:12]];
        }
        
        if(self.comboArray[counter][3] != [NSNull null]) {
            PFQuery *query3 = [PFQuery queryWithClassName:@"BJMenu"];
            [query3 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][3]).mealItem];
            [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!object) {
                    NSLog(@"The getFirstObject request failed.");
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    beveragePic = object[@"pics"];
                    
                    // Grab image from PFfile object and set it to view
                    [beveragePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            // image can now be set on a UIImageView
                            [self.Beverage setImage:image];
                        }
                    }];
                }
            }];
            self.BeverageName.text = ((ShakeMeal*)self.comboArray[counter][3]).mealItem;
            [self.BeverageName setFont:[UIFont systemFontOfSize:12]];
            self.BeverageName.textAlignment = NSTextAlignmentCenter;
            self.BeveragePrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][3]).price];
            [self.BeveragePrice setFont:[UIFont systemFontOfSize:12]];
            self.AddBeverageToPlate.hidden = NO;
        }
        else {
            self.BeverageName.text = nil;
            [self.BeverageName setFont:[UIFont systemFontOfSize:12]];
            self.BeverageName.textAlignment = NSTextAlignmentCenter;
            self.BeveragePrice.text = nil;
            [self.BeveragePrice setFont:[UIFont systemFontOfSize:12]];
        }
        
        NSNumber *comboPrice = self.comboArray[counter][4];
        double price = [comboPrice doubleValue];
        self.MealPrice.text = [NSString stringWithFormat:@"Total Price: $%.2f",price];
        [self.MealPrice setFont:[UIFont systemFontOfSize:14]];
        self.MealPrice.textAlignment = NSTextAlignmentCenter;
        self.MealCalories.text = [NSString stringWithFormat:@"Total Calories: %@",self.comboArray[counter][5]];
        [self.MealCalories setFont:[UIFont systemFontOfSize:14]];
        self.MealCalories.textAlignment = NSTextAlignmentCenter;
        
        counter++;
    }
    // findOjbectWithName -- parsing for picture
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {
        __block PFFile *appetizerPic;
        __block PFFile *entreePic;
        __block PFFile *dessertPic;
        __block PFFile *beveragePic;
        comboCount = [_comboArray count];
        if(comboCount > counter) {
            if(self.comboArray[counter][0] != [NSNull null]) {
                PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
                [query whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][0]).mealItem];
                //[query whereKey:@"menuItemName" equalTo:@"Angus Beef Sliders"];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!object) {
                        NSLog(@"The getFirstObject request failed.");
                    } else {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved the object.");
                        appetizerPic = object[@"pics"];
                        
                        // Grab image from PFfile object and set it to view
                        [appetizerPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                // image can now be set on a UIImageView
                                [self.Appetizer setImage:image];
                            }
                        }];
                    }
                }];
                // Do any additional setup after loading the view.
                self.AppetizerName.text = ((ShakeMeal*)self.comboArray[counter][0]).mealItem;
                [self.AppetizerName setFont:[UIFont systemFontOfSize:12]];
                self.AppetizerName.textAlignment = NSTextAlignmentCenter;
                self.AppetizerPrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][0]).price];
                [self.AppetizerPrice setFont:[UIFont systemFontOfSize:12]];
            }
            else {
                self.AppetizerName.text = nil;
                [self.AppetizerName setFont:[UIFont systemFontOfSize:12]];
                self.AppetizerName.textAlignment = NSTextAlignmentCenter;
                self.AppetizerPrice.text = nil;
                [self.AppetizerPrice setFont:[UIFont systemFontOfSize:12]];
            }
            
            if(self.comboArray[counter][1] != [NSNull null]) {
                PFQuery *query1 = [PFQuery queryWithClassName:@"BJMenu"];
                [query1 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][1]).mealItem];
                [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!object) {
                        NSLog(@"The getFirstObject request failed.");
                    } else {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved the object.");
                        entreePic = object[@"pics"];
                        
                        // Grab image from PFfile object and set it to view
                        [entreePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                // image can now be set on a UIImageView
                                [self.Entree setImage:image];
                            }
                        }];
                    }
                }];
                self.EntreeName.text = ((ShakeMeal*)self.comboArray[counter][1]).mealItem;
                [self.EntreeName setFont:[UIFont systemFontOfSize:12]];
                self.EntreeName.textAlignment = NSTextAlignmentCenter;
                self.EntreePrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][1]).price];
                [self.EntreePrice setFont:[UIFont systemFontOfSize:12]];
            }
            else {
                self.EntreeName.text = nil;
                [self.EntreeName setFont:[UIFont systemFontOfSize:12]];
                self.EntreeName.textAlignment = NSTextAlignmentCenter;
                self.EntreePrice.text = nil;
                [self.EntreePrice setFont:[UIFont systemFontOfSize:12]];
            }
            
            if(self.comboArray[counter][2] != [NSNull null]) {
                PFQuery *query2 = [PFQuery queryWithClassName:@"BJMenu"];
                [query2 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][2]).mealItem];
                [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!object) {
                        NSLog(@"The getFirstObject request failed.");
                    } else {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved the object.");
                        dessertPic = object[@"pics"];
                        
                        // Grab image from PFfile object and set it to view
                        [dessertPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                // image can now be set on a UIImageView
                                [self.Dessert setImage:image];
                            }
                        }];
                    }
                }];
                self.DessertName.text = ((ShakeMeal*)self.comboArray[counter][2]).mealItem;
                [self.DessertName setFont:[UIFont systemFontOfSize:12]];
                self.DessertName.textAlignment = NSTextAlignmentCenter;
                self.DessertPrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][2]).price];
                [self.DessertPrice setFont:[UIFont systemFontOfSize:12]];
            }
            else {
                self.DessertName.text = nil;
                [self.DessertName setFont:[UIFont systemFontOfSize:12]];
                self.DessertName.textAlignment = NSTextAlignmentCenter;
                self.DessertPrice.text = nil;
                [self.DessertPrice setFont:[UIFont systemFontOfSize:12]];
            }
            
            if(self.comboArray[counter][3] != [NSNull null]) {
                PFQuery *query3 = [PFQuery queryWithClassName:@"BJMenu"];
                [query3 whereKey:@"menuItemName" equalTo:((ShakeMeal*)self.comboArray[counter][3]).mealItem];
                [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!object) {
                        NSLog(@"The getFirstObject request failed.");
                    } else {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved the object.");
                        beveragePic = object[@"pics"];
                        
                        // Grab image from PFfile object and set it to view
                        [beveragePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                // image can now be set on a UIImageView
                                [self.Beverage setImage:image];
                            }
                        }];
                    }
                }];
                self.BeverageName.text = ((ShakeMeal*)self.comboArray[counter][3]).mealItem;
                [self.BeverageName setFont:[UIFont systemFontOfSize:12]];
                self.BeverageName.textAlignment = NSTextAlignmentCenter;
                self.BeveragePrice.text = [NSString stringWithFormat:@"$%.2f",((ShakeMeal*)self.comboArray[counter][3]).price];
                [self.BeveragePrice setFont:[UIFont systemFontOfSize:12]];
            }
            else {
                self.BeverageName.text = nil;
                [self.BeverageName setFont:[UIFont systemFontOfSize:12]];
                self.BeverageName.textAlignment = NSTextAlignmentCenter;
                self.BeveragePrice.text = nil;
                [self.BeveragePrice setFont:[UIFont systemFontOfSize:12]];
            }
            
            NSNumber *comboPrice = self.comboArray[counter][4];
            double price = [comboPrice doubleValue];
            self.MealPrice.text = [NSString stringWithFormat:@"Total Price: $%.2f",price];
            [self.MealPrice setFont:[UIFont systemFontOfSize:14]];
            self.MealPrice.textAlignment = NSTextAlignmentCenter;
            self.MealCalories.text = [NSString stringWithFormat:@"Total Calories: %@",self.comboArray[counter][5]];
            [self.MealCalories setFont:[UIFont systemFontOfSize:14]];
            self.MealCalories.textAlignment = NSTextAlignmentCenter;
            
            counter++;
        }
    }
}
- (BOOL) canBecomeFirstResponder
{
    return YES;
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
- (void)deletePlateItem: (NSString *) userID ItemName: (NSString *) menuItem {
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query whereKey:@"menuItemName" equalTo:menuItem];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            
            // Delete the object from the table
            [object deleteInBackground];
        }
    }];
}
- (IBAction)EditPlateFromButton1:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    /*if(sender.selected == YES) {*/
    NSLog(@"button is selected!");
    [self addToPlateQuery:self.UUID ItemName: self.AppetizerName.text];
    //UIImage *selected = [UIImage imageNamed:@"AddToPlate.png"];
    //[sender setImage:selected forState:UIControlStateNormal];
    /*}
     else {
     NSLog(@"button is deselected!");
     [self deletePlateItem:self.UUID ItemName: self.AppetizerName.text];
     UIImage *unselected = [UIImage imageNamed:@"AddToPlateUnselect.png"];
     [sender setImage:unselected forState:UIControlStateNormal];
     }*/
    //UIImage *unselected = [UIImage imageNamed:@"AddToPlateUnselect.png"];
    //[sender setImage:unselected forState:UIControlStateNormal];
}
- (IBAction)EditPlateFromButton2:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addToPlateQuery:self.UUID ItemName: self.EntreeName.text];
}
- (IBAction)EditPlateFromButton3:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addToPlateQuery:self.UUID ItemName: self.DessertName.text];
}
- (IBAction)EditPlateFromButton4:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addToPlateQuery:self.UUID ItemName: self.BeverageName.text];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end