//
//  ShakeViewController.m
//  TitleScreen
//
//  Created by Alex C Tsang on 5/25/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//
#import "ShakeViewController.h"
#import "ShakeResultViewController.h"
#import "NSMutableArray_Shuffle.h"
#import "ShakeMeal.h"
#import <Parse/Parse.h>
#import "MenuPictureViewController.h"
@interface ShakeViewController ()
@end
BOOL entreeFlag = 0;        // initial user input
BOOL appetizerFlag = 0;
BOOL beverageFlag = 0;
BOOL dessertFlag = 0;
BOOL vegetarianFlag = 0;
BOOL glutenfreeFlag = 0;
int fieldChecked = 0;       // make sure at least one checked
int minComboPrice = 0;      // process query and get these values
int MAXCOMBOPRICE = 150;
int minComboCalories = 0;
int MAXCOMBOCALORIES = 5000;
int minEntreePrice = 0;
int minAppetizerPrice = 0;
int minDessertPrice = 0;
int minBeveragePrice = 0;
int minEntreeCal = 0;
int minAppetizerCal = 0;
int minDessertCal = 0;
int minBeverageCal = 0;
int priceMax = 150;           // The max price the user chooses
int calorieMax = 5000;         // The max calories the user chooses
int arrayCount = 0;
NSMutableArray * entreeArray = nil;
NSMutableArray * appetizerArray = nil;
NSMutableArray * beverageArray = nil;
NSMutableArray * dessertArray = nil;
NSMutableArray * comboArray = nil;
@implementation ShakeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor blackColor];
    entreeFlag = 0;        // initial user input
    appetizerFlag = 0;
    beverageFlag = 0;
    dessertFlag = 0;
    vegetarianFlag = 0;
    glutenfreeFlag = 0;
    
    fieldChecked = 0;       // make sure at least one checked
    
    minComboPrice = 0;      // process query and get these values
    MAXCOMBOPRICE = 150;
    minComboCalories = 0;
    MAXCOMBOCALORIES = 5000;
    
    minEntreePrice = 0;
    minAppetizerPrice = 0;
    minDessertPrice = 0;
    minBeveragePrice = 0;
    minEntreeCal = 0;
    minAppetizerCal = 0;
    minDessertCal = 0;
    minBeverageCal = 0;
    
    priceMax = 150;           // The max price the user chooses
    calorieMax = 5000;         // The max calories the user chooses
    arrayCount = 0;
    
    entreeArray = nil;
    appetizerArray = nil;
    beverageArray = nil;
    dessertArray = nil;
    comboArray = nil;
    
    [self.view setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
    [self.sketchCover setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
    self.priceSlider.minimumValue = minComboPrice;
    self.priceSlider.maximumValue = MAXCOMBOPRICE;
    
    self.calSlider.minimumValue = minComboCalories;
    self.calSlider.maximumValue = MAXCOMBOCALORIES;
    
    self.priceSlider.value = MAXCOMBOPRICE;
    self.calSlider.value = MAXCOMBOCALORIES;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%d", MAXCOMBOPRICE];
    self.calLabel.text = [NSString stringWithFormat:@"%d", MAXCOMBOCALORIES];
    
    UIImage *slideBtImg = [UIImage imageNamed:@"DollarSign.png"];
    [self.priceSlider setThumbImage:slideBtImg forState:UIControlStateNormal];
    
    UIImage *slideBtImg2 = [UIImage imageNamed:@"CalorieSign.png"];
    [self.calSlider setThumbImage:slideBtImg2 forState:UIControlStateNormal];
    
}
/*x
 - (IBAction)nextButton:(id)sender
 {
 int price = 0;
 int calories = 0;
 
 // Checks to find minimum price of combo
 if (entreeArray != nil) {
 price = price + (int)[[entreeArray objectAtIndex:0]objectAtIndex:1];
 }
 if (appetizerArray != nil) {
 price = price + (int)[[appetizerArray objectAtIndex:0]objectAtIndex:1];
 }
 if (beverageArray != nil) {
 price = price + (int)[[beverageArray objectAtIndex:0]objectAtIndex:1];
 }
 if (dessertArray != nil) {
 price = price + (int)[[dessertArray objectAtIndex:0]objectAtIndex:1];
 }
 
 // Checks to find minimum calories of combo
 calories = calories + findMin(entreeArray) + findMin(appetizerArray) + findMin(beverageArray) + findMin(dessertArray);
 
 minComboPrice = price;
 minComboCalories = calories;
 
 self.priceSlider.minimumValue = minComboPrice;
 self.calSlider.minimumValue = minComboCalories;
 
 }*/
- (NSMutableArray *)queryForShakeItems:(NSNumber *)maxPrice Calories:(NSNumber *)maxCalories category: (NSString *) category
                            Vegetarian: (BOOL) vegetarian Gluten: (BOOL) glutenFree {
    NSLog(@"Inside queryForShakeItems");
    NSMutableArray *shakeItems = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    [query whereKey:@"course" equalTo:category];
    [query whereKey:@"roundedMenuItemPrice" lessThanOrEqualTo:maxPrice];
    [query whereKey:@"calories" lessThanOrEqualTo:maxCalories];
    if(vegetarian == YES)
    {
        [query whereKey:@"vegetarian" equalTo:[NSNumber numberWithBool:YES]];
    }
    if(glutenFree == YES)
    {
        [query whereKey:@"gluttenFree" equalTo:[NSNumber numberWithBool:YES]];
    }
    [query orderByAscending:@"roundedMenuItemPrice"];
    
    
    NSArray *objects = [query findObjects];
    
    for (NSInteger i = 0; i < [objects count]; i++) {
        NSString *name = [objects[i] objectForKey:@"menuItemName"];
        NSString *price = [objects[i] objectForKey:@"menuItemPrice"];
        NSNumber *caloriesCount = [objects[i] objectForKey:@"calories"];
        
        ShakeMeal *item = [[ShakeMeal alloc] init];
        item.mealItem = name;
        double iPrice = [price doubleValue];
        item.price = iPrice;
        int iCal = [caloriesCount integerValue];
        item.calorie = iCal;
        
        [shakeItems addObject:item];
        
    }
    return shakeItems;
}
- (NSMutableArray *)Price:(NSNumber *)maxPrice Calories:(NSNumber *)maxCalories category: (NSString *) category
               Vegetarian: (BOOL) vegetarian Gluten: (BOOL) glutenFree {
    NSLog(@"Inside queryForShakeItems");
    NSMutableArray *shakeItems = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    [query whereKey:@"course" equalTo:category];
    [query whereKey:@"roundedMenuItemPrice" lessThanOrEqualTo:maxPrice];
    [query whereKey:@"calories" lessThanOrEqualTo:maxCalories];
    if(vegetarian)
    {
        [query whereKey:@"vegetarian" equalTo:[NSNumber numberWithBool:YES]];
    }
    if(glutenFree)
    {
        [query whereKey:@"gluttenFree" equalTo:[NSNumber numberWithBool:YES]];
    }
    [query orderByAscending:@"calories"];
    
    NSArray *objects = [query findObjects];
    if ([objects count] != 0)
    {
        NSString *name = [objects[0] objectForKey:@"menuItemName"];
        NSString *price = [objects[0] objectForKey:@"menuItemPrice"];
        NSNumber *caloriesCount = [objects[0] objectForKey:@"calories"];
        
        ShakeMeal *item = [[ShakeMeal alloc] init];
        item.mealItem = name;
        double iPrice = [price doubleValue];
        item.price = iPrice;
        int iCal = [caloriesCount integerValue];
        item.calorie = iCal;
        [shakeItems addObject:item];
    }
    
    return shakeItems;
}
/*- (NSMutableArray *)queryForShakeItems:(NSString *)maxPrice Calories:(NSNumber *)maxCalories category: (NSString *) category {
 NSMutableArray *shakeItems = [[NSMutableArray alloc] init];
 //NSMutableArray *menuItem = [[NSMutableArray alloc] init];
 
 PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
 [query whereKey:@"course" equalTo:category];
 [query whereKey:@"menuItemPrice" lessThanOrEqualTo:maxPrice];
 [query whereKey:@"calories" lessThanOrEqualTo:maxCalories];
 //[query whereKey:@"Username" equalTo:@"Ankush Agrawal"];
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 
 [query orderByAscending:@"menuItemPrice"];
 
 //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
 [query findObjects(){
 //if(!error) {
 for (int i = 0; i < [objects count]; i++) {
 NSString *name = [objects[i] objectForKey:@"menuItemName"];
 NSString *price = [objects[i] objectForKey:@"menuItemPrice"];
 NSNumber *caloriesCount = [objects[i] objectForKey:@"calories"];
 
 ShakeMeal *item = [[ShakeMeal alloc] init];
 item.mealItem = name;
 double iPrice = [price doubleValue];
 item.price = iPrice;
 int iCal = [caloriesCount integerValue];
 item.calorie = iCal;
 
 [shakeItems addObject:item];
 
 
 // Add desired information into an array for each menu item
 [menuItem addObject:name];
 [menuItem addObject:price];
 [menuItem addObject:caloriesCount];
 
 // Add information for individual menu item into final array to return
 [shakeItems addObject:menuItem];
 
 // Clear menuItem array to fill next menu item
 [menuItem removeAllObjects];
 
 }
 }
 //}
 ];
 return shakeItems;
 }*/
/* Function to find minimum price in our array
 int findMin(NSMutableArray* array)
 {
 int min = 0;
 for (int i = 0; i<(sizeof array); i++)
 {
 int value = (int)[[array objectAtIndex:i]objectAtIndex:2];
 if (min > value)
 {
 min = value;
 }
 }
 return min;
 }*/
// Functions for fake test data
void initEntree() {
    entreeArray = [[NSMutableArray alloc] initWithCapacity: 3];
    ShakeMeal *entree1 = [[ShakeMeal alloc] init];
    entree1.mealItem = @"Bacon Burger";
    entree1.price = 12.99;
	entree1.calorie = 1200;
    ShakeMeal *entree2 = [[ShakeMeal alloc] init];
	entree2.mealItem = @"Super Salad";
	entree2.price = 7.99;
	entree2.calorie = 500;
    ShakeMeal *entree3 = [[ShakeMeal alloc] init];
	entree3.mealItem = @"Meatball and Pasta";
	entree3.price = 9.99;
	entree3.calorie = 800;
	entreeArray[0] = entree2;
	entreeArray[1] = entree3;
	entreeArray[2] = entree1;
}
void initAppetizer() {
    appetizerArray = [[NSMutableArray alloc] initWithCapacity: 3];
	ShakeMeal *appetizer1 = [[ShakeMeal alloc] init];
	appetizer1.mealItem = @"Sweet Potato Fries";
	appetizer1.price = 5.99;
	appetizer1.calorie = 700;
	ShakeMeal *appetizer2 = [[ShakeMeal alloc] init];
	appetizer2.mealItem = @"Ahi Poke";
	appetizer2.price = 8.99;
	appetizer2.calorie = 500;
	ShakeMeal *appetizer3 = [[ShakeMeal alloc] init];
	appetizer3.mealItem = @"Onion Rings";
	appetizer3.price = 6.99;
	appetizer3.calorie = 1000;
    appetizerArray[0] = appetizer1;
	appetizerArray[1] = appetizer3;
	appetizerArray[2] = appetizer2;
}
void initBeverage() {
    beverageArray = [[NSMutableArray alloc] initWithCapacity: 2];
	ShakeMeal *beverage1 = [[ShakeMeal alloc] init];
	beverage1.mealItem = @"Soda";
	beverage1.price = 1.99;
	beverage1.calorie = 100;
	ShakeMeal *beverage2 = [[ShakeMeal alloc] init];
	beverage2.mealItem = @"Root beer";
	beverage2.price = 2.99;
	beverage2.calorie = 300;
	beverageArray[0] = beverage1;
	beverageArray[1] = beverage2;
}
void initDessert() {
    dessertArray = [[NSMutableArray alloc] initWithCapacity: 2];
	ShakeMeal *dessert1 = [[ShakeMeal alloc] init];
	dessert1.mealItem = @"Ice Cream";
	dessert1.price = 2.99;
	dessert1.calorie = 500;
	ShakeMeal *dessert2 = [[ShakeMeal alloc] init];
	dessert2.mealItem = @"Pazookie";
	dessert2.price = 6.99;
	dessert2.calorie = 1000;
    dessertArray[0] = dessert1;
	dessertArray[1] = dessert2;
}
NSMutableArray* mealCreate(ShakeMeal* iOne, ShakeMeal* iTwo, ShakeMeal* iThree, ShakeMeal* iFour, double mPrice, int mCalorie) {
    
    NSNumber *mP;
    mP = [NSNumber numberWithDouble:mPrice];
    
    NSNumber *mC;
    mC = [NSNumber numberWithInt:mCalorie];
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: 6];
    
    if (iOne != nil)
        result[0] = iOne;
    else
        result[0] = [NSNull null];
    if (iTwo != nil)
        result[1] = iTwo;
    else
        result[1] = [NSNull null];
    if (iThree != nil)
        result[2] = iThree;
    else
        result[2] = [NSNull null];
    if (iFour != nil)
        result[3] = iFour;
    else
        result[3] = [NSNull null];
    //result[4] = mP;
    //result[5] = mC;
    [result addObject:mP];
    [result addObject:mC];
	return result;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(fieldChecked != 0 && event.type == UIEventSubtypeMotionShake)
    {
        //[self.view setBackgroundColor: [UIColor greenColor]];
        // Init course arrays with fake data
        //initAppetizer();
        //initBeverage();
        //initDessert();
        //initEntree();
        //NSString* maxPrice = [@(priceMax) stringValue];
        NSNumber* maxPrice = [NSNumber numberWithDouble:priceMax];
        NSNumber* maxCal = [NSNumber numberWithInt:calorieMax];
        //self.numMeal.text = [NSString stringWithFormat:@"%@", maxCal];
        
        appetizerArray = [self queryForShakeItems:maxPrice Calories:maxCal category:@"Appetizer" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
        entreeArray = [self queryForShakeItems:maxPrice Calories:maxCal category:@"Entree" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
        beverageArray = [self queryForShakeItems:maxPrice Calories:maxCal category:@"Beverage" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
        dessertArray = [self queryForShakeItems:maxPrice Calories:maxCal category:@"Dessert" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
        
        //self.numMeal.text = [NSString stringWithFormat:@"%d", maxPrice];
        
        //Conditionals to see which arrays are used
        NSMutableArray *arrayOrder = [[NSMutableArray alloc] initWithCapacity: 4];
        int frontCounter = 0;
        
        
        if (appetizerFlag && appetizerArray!=nil)
        {
            arrayOrder[frontCounter] = appetizerArray;
            frontCounter++;
        }
        if (entreeFlag && entreeArray!=nil)
        {
            arrayOrder[frontCounter] = entreeArray;
            frontCounter++;
        }
        if (beverageFlag && beverageArray!=nil)
        {
            arrayOrder[frontCounter] = beverageArray;
            frontCounter++;
        }
        if (dessertFlag && dessertArray!=nil)
        {
            arrayOrder[frontCounter] = dessertArray;
            frontCounter++;
        }
        
        // pointer to a 2D array
        arrayCount = frontCounter;
        int i = 0;
        NSMutableArray *array1;
        NSMutableArray *array2;
        NSMutableArray *array3;
        NSMutableArray *array4;
        if (i<arrayCount)
        {
            array1 = arrayOrder[i];
            i++;
        }
        if (i<arrayCount)
        {
            array2 = arrayOrder[i];
            i++;
        }
        if (i<arrayCount)
        {
            array3 = arrayOrder[i];
            i++;
        }
        if (i<arrayCount)
        {
            array4 = arrayOrder[i];
            i++;
        }
        ShakeMeal *item1 = nil;
        ShakeMeal *item2 = nil;
        ShakeMeal *item3 = nil;
        ShakeMeal *item4 = nil;
        
        double comboPrice = 0;
        int comboCalorie = 0;
        comboArray = [[NSMutableArray alloc] init];
        // For loops
        for (int i=0; array1!=nil && i<[array1 count]; i++)
        {
            item1 = array1[i];
            for (int j=0; array2!=nil && j<[array2 count]; j++)
            {
                item2 = array2[j];
                for (int k=0; array3!=nil && k<[array3 count]; k++)
                {
                    item3 = array3[k];
                    for(int l=0; array4!=nil && l<[array4 count]; l++)
                    {
                        item4 = array4[l];
                        if (arrayCount==4 && (comboPrice=item1.getPrice+item2.getPrice+item3.getPrice+item4.getPrice)<=priceMax && (comboCalorie=item1.getCalorie+item2.getCalorie+item3.getCalorie+item4.getCalorie)<=calorieMax ) {
                            NSMutableArray *combo = mealCreate(item1, item2, item3, item4, comboPrice, comboCalorie);
                            [comboArray addObject:combo];
                        }
                    }// end loop 4
                    if (arrayCount==3 && (comboPrice=item1.getPrice+item2.getPrice+item3.getPrice)<=priceMax && (comboCalorie=item1.getCalorie+item2.getCalorie+item3.getCalorie)<=calorieMax ) {
                        NSMutableArray *combo = mealCreate(item1, item2, item3, item4, comboPrice, comboCalorie);
                        [comboArray addObject:combo];
                    }
                }// end loop 3
                if (arrayCount==2 && (comboPrice=item1.getPrice+item2.getPrice)<=priceMax && (comboCalorie=item1.getCalorie+item2.getCalorie)<=calorieMax ) {
                    NSMutableArray *combo = mealCreate(item1, item2, item3, item4, comboPrice, comboCalorie);
                    [comboArray addObject:combo];
                }
            }// end loop 2
            if (arrayCount==1 && (comboPrice=item1.getPrice)<=priceMax && (comboCalorie=item1.getCalorie)<=calorieMax ) {
                NSMutableArray *combo = mealCreate(item1, item2, item3, item4, comboPrice, comboCalorie);
                [comboArray addObject:combo];
            }
        }// end loop 1
        int comboNum = [comboArray count]; //Used for testing
        //int entreeNum = [entreeArray count];
        self.numMeal.text = [NSString stringWithFormat:@"%d", comboNum];//((ShakeMeal*)comboArray[0][0]).mealItem];
        
        [comboArray shuffle];
        //[self performSegueWithIdentifier:@"ShakeSegue" sender:self];
        ShakeResultViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shakeResultVCID"];
        destViewController.comboArray = comboArray;
        [self.navigationController pushViewController:destViewController animated:YES];
    }//end of if
}
- (BOOL) canBecomeFirstResponder
{
    return YES;
}
- (IBAction)priceChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.priceLabel.text = [NSString stringWithFormat:@"%d",val];
    priceMax = val;
    self.testPri.text = [NSString stringWithFormat:@"%d",priceMax];
    
}
- (IBAction)calorieChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.calLabel.text = [NSString stringWithFormat:@"%d",val];
    calorieMax = val;
    self.testCal.text = [NSString stringWithFormat:@"%d",calorieMax];
}
- (IBAction)entreeTapped:(id)sender
{
    entreeFlag = ( 1 + entreeFlag ) % 2;
    if( entreeFlag == 0 )
    {
        fieldChecked = fieldChecked - 1;
        UIImage *buttonImage = [UIImage imageNamed:@"EntreeOff.png"];
        [self.entreeButton setImage:buttonImage forState:UIControlStateNormal];
        minComboPrice = minComboPrice - minEntreePrice;
        minComboCalories = minComboCalories - minEntreeCal;
        self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
        self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
        self.priceSlider.minimumValue = minComboPrice;
        self.calSlider.minimumValue = minComboCalories;
        NSInteger pval = lround(self.priceSlider.value);
        self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
        NSInteger calval = lround(self.calSlider.value);
        self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
    }
    else
    {
        fieldChecked = fieldChecked + 1;
        UIImage *buttonImage = [UIImage imageNamed:@"Entree.png"];
        [self.entreeButton setImage:buttonImage forState:UIControlStateNormal];
        
        if(minEntreePrice == 0)
        {
            NSMutableArray *entreeTemp;
            NSMutableArray *entreeTemp2;
            NSNumber* price = [NSNumber numberWithDouble:MAXCOMBOPRICE];
            NSNumber* cal = [NSNumber numberWithInt:MAXCOMBOCALORIES];
            entreeTemp = [self queryForShakeItems:price Calories:cal category:@"Entree" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
            if([entreeTemp count] != 0) {
                ShakeMeal *meal = entreeTemp[0];
                minEntreePrice = meal.getPrice+1;  //Plus one for rounding up
                minComboPrice = minComboPrice + minEntreePrice;
                self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
                entreeTemp2 = [self Price:price Calories:cal category:@"Entree" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
                meal = entreeTemp2[0];
                minEntreeCal = meal.getCalorie;
                minComboCalories = minComboCalories + minEntreeCal;
                self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
                self.priceSlider.minimumValue = minComboPrice;
                self.calSlider.minimumValue = minComboCalories;
                NSInteger pval = lround(self.priceSlider.value);
                self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
                NSInteger calval = lround(self.calSlider.value);
                self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
            }
        }
        else
        {
            minComboPrice = minComboPrice + minEntreePrice;
            minComboCalories = minComboCalories + minEntreeCal;
            self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
            self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
            self.priceSlider.minimumValue = minComboPrice;
            self.calSlider.minimumValue = minComboCalories;
            NSInteger pval = lround(self.priceSlider.value);
            self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
            NSInteger calval = lround(self.calSlider.value);
            self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
        }
    }
    if( fieldChecked == 0 )
    {
        [self.sketchCover setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
        self.sketchCover.hidden = NO;
    }
    else
    {
        self.sketchCover.hidden = YES;
    }
}
- (IBAction)appetizerTapped:(id)sender
{
    appetizerFlag = ( 1 + appetizerFlag ) % 2;
    if( appetizerFlag == 0 )
    {
        fieldChecked = fieldChecked - 1;
        UIImage *buttonImage = [UIImage imageNamed:@"AppetizerOff.png"];
        [self.appetizerButton setImage:buttonImage forState:UIControlStateNormal];
        minComboPrice = minComboPrice - minAppetizerPrice;
        minComboCalories = minComboCalories - minAppetizerCal;
        self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
        self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
        self.priceSlider.minimumValue = minComboPrice;
        self.calSlider.minimumValue = minComboCalories;
        NSInteger pval = lround(self.priceSlider.value);
        self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
        NSInteger calval = lround(self.calSlider.value);
        self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
    }
    else
    {
        fieldChecked = fieldChecked + 1;
        UIImage *buttonImage = [UIImage imageNamed:@"Appetizer.png"];
        [self.appetizerButton setImage:buttonImage forState:UIControlStateNormal];
        if(minAppetizerPrice == 0)
        {
            NSMutableArray *appetizerTemp;
            NSMutableArray *appetizerTemp2;
            NSNumber* price = [NSNumber numberWithDouble:MAXCOMBOPRICE];
            NSNumber* cal = [NSNumber numberWithInt:MAXCOMBOCALORIES];
            appetizerTemp = [self queryForShakeItems:price Calories:cal category:@"Appetizer" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
            if ([appetizerTemp count] != 0) {
                ShakeMeal *meal = appetizerTemp[0];
                minAppetizerPrice = meal.getPrice+1;  //Plus one for rounding up
                minComboPrice = minComboPrice + minAppetizerPrice;
                self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
                appetizerTemp2 = [self Price:price Calories:cal category:@"Appetizer" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
                meal = appetizerTemp2[0];
                minAppetizerCal = meal.getCalorie;
                minComboCalories = minComboCalories + minAppetizerCal;
                self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
                self.priceSlider.minimumValue = minComboPrice;
                self.calSlider.minimumValue = minComboCalories;
                NSInteger pval = lround(self.priceSlider.value);
                self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
                NSInteger calval = lround(self.calSlider.value);
                self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
            }
        }
        else
        {
            minComboPrice = minComboPrice + minAppetizerPrice;
            minComboCalories = minComboCalories + minAppetizerCal;
            self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
            self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
            self.priceSlider.minimumValue = minComboPrice;
            self.calSlider.minimumValue = minComboCalories;
            NSInteger pval = lround(self.priceSlider.value);
            self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
            NSInteger calval = lround(self.calSlider.value);
            self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
        }
    }
    if( fieldChecked == 0 )
    {
        [self.sketchCover setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
        self.sketchCover.hidden = NO;
    }
    else
    {
        self.sketchCover.hidden = YES;
    }
}
- (IBAction)dessertTapped:(id)sender
{
    dessertFlag = ( 1 + dessertFlag ) % 2;
    
    if( dessertFlag == 0 )
    {
        fieldChecked = fieldChecked - 1;
        UIImage *buttonImage = [UIImage imageNamed:@"DessertOff.png"];
        [self.dessertButton setImage:buttonImage forState:UIControlStateNormal];
        minComboPrice = minComboPrice - minDessertPrice;
        minComboCalories = minComboCalories - minDessertCal;
        self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
        self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
        self.priceSlider.minimumValue = minComboPrice;
        self.calSlider.minimumValue = minComboCalories;
        NSInteger pval = lround(self.priceSlider.value);
        self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
        NSInteger calval = lround(self.calSlider.value);
        self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
    }
    else
    {
        fieldChecked = fieldChecked + 1;
        UIImage *buttonImage = [UIImage imageNamed:@"Dessert.png"];
        [self.dessertButton setImage:buttonImage forState:UIControlStateNormal];
        if(minDessertPrice == 0)
        {
            NSMutableArray *dessertTemp;
            NSMutableArray *dessertTemp2;
            NSNumber* price = [NSNumber numberWithDouble:MAXCOMBOPRICE];
            NSNumber* cal = [NSNumber numberWithInt:MAXCOMBOCALORIES];
            dessertTemp = [self queryForShakeItems:price Calories:cal category:@"Dessert" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
            if ([dessertTemp count] != 0)
            {
                ShakeMeal *meal = dessertTemp[0];
                minDessertPrice = meal.getPrice+1;  //Plus one for rounding up
                minComboPrice = minComboPrice + minDessertPrice;
                self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
                dessertTemp2 = [self Price:price Calories:cal category:@"Dessert" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
                meal = dessertTemp2[0];
                minDessertCal = meal.getCalorie;
                minComboCalories = minComboCalories + minDessertCal;
                self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
                self.priceSlider.minimumValue = minComboPrice;
                self.calSlider.minimumValue = minComboCalories;
                NSInteger pval = lround(self.priceSlider.value);
                self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
                NSInteger calval = lround(self.calSlider.value);
                self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
            }
        }
        else
        {
            minComboPrice = minComboPrice + minDessertPrice;
            minComboCalories = minComboCalories + minDessertCal;
            self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
            self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
            self.priceSlider.minimumValue = minComboPrice;
            self.calSlider.minimumValue = minComboCalories;
            NSInteger pval = lround(self.priceSlider.value);
            self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
            NSInteger calval = lround(self.calSlider.value);
            self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
        }
    }
    if( fieldChecked == 0 )
    {
        [self.sketchCover setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
        self.sketchCover.hidden = NO;
    }
    else
    {
        self.sketchCover.hidden = YES;
    }
}
- (IBAction)beverageTapped:(id)sender
{
    beverageFlag = ( 1 + beverageFlag ) % 2;
    if( beverageFlag == 0 )
    {
        fieldChecked = fieldChecked - 1;
        UIImage *buttonImage = [UIImage imageNamed:@"BeverageOff.png"];
        [self.drinkButton setImage:buttonImage forState:UIControlStateNormal];
        minComboPrice = minComboPrice - minBeveragePrice;
        minComboCalories = minComboCalories - minBeverageCal;
        self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
        self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
        self.priceSlider.minimumValue = minComboPrice;
        self.calSlider.minimumValue = minComboCalories;
        NSInteger pval = lround(self.priceSlider.value);
        self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
        NSInteger calval = lround(self.calSlider.value);
        self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
    }
    else
    {
        fieldChecked = fieldChecked + 1;
        UIImage *buttonImage = [UIImage imageNamed:@"Beverage.png"];
        [self.drinkButton setImage:buttonImage forState:UIControlStateNormal];
        if(minBeveragePrice == 0)
        {
            NSMutableArray *beverageTemp;
            NSMutableArray *beverageTemp2;
            NSNumber* price = [NSNumber numberWithDouble:MAXCOMBOPRICE];
            NSNumber* cal = [NSNumber numberWithInt:MAXCOMBOCALORIES];
            beverageTemp = [self queryForShakeItems:price Calories:cal category:@"Beverage" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
            if ([beverageTemp count] != 0)
            {
                ShakeMeal *meal = beverageTemp[0];
                minBeveragePrice = meal.getPrice+1;  //Plus one for rounding up
                minComboPrice = minComboPrice + minBeveragePrice;
                self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
                beverageTemp2 = [self Price:price Calories:cal category:@"Beverage" Vegetarian:vegetarianFlag Gluten:glutenfreeFlag];
                meal = beverageTemp2[0];
                minBeverageCal = meal.getCalorie;
                minComboCalories = minComboCalories + minBeverageCal;
                self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
                self.priceSlider.minimumValue = minComboPrice;
                self.calSlider.minimumValue = minComboCalories;
                NSInteger pval = lround(self.priceSlider.value);
                self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
                NSInteger calval = lround(self.calSlider.value);
                self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
            }
        }
        else
        {
            minComboPrice = minComboPrice + minBeveragePrice;
            minComboCalories = minComboCalories + minBeverageCal;
            self.calMinLabel.text = [NSString stringWithFormat:@"%d",minComboCalories];
            self.priceMinLabel.text = [NSString stringWithFormat:@"%d",minComboPrice];
            self.priceSlider.minimumValue = minComboPrice;
            self.calSlider.minimumValue = minComboCalories;
            NSInteger pval = lround(self.priceSlider.value);
            self.priceLabel.text = [NSString stringWithFormat:@"%d",pval];
            NSInteger calval = lround(self.calSlider.value);
            self.calLabel.text = [NSString stringWithFormat:@"%d",calval];
        }
        
    }
    if( fieldChecked == 0 )
    {
        [self.sketchCover setBackgroundColor: [self colorWithHexString:@"EAEAEA"]];
        self.sketchCover.hidden = NO;
    }
    else
    {
        self.sketchCover.hidden = YES;
    }
}
-(IBAction)vegTapped:(id)sender {
    vegetarianFlag = ( 1 + vegetarianFlag ) % 2;
    
    if( vegetarianFlag == 0 )
    {
        UIImage *buttonImage = [UIImage imageNamed:@"VegetarianOff.png"];
        [self.vegetarianButton setImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *buttonImage = [UIImage imageNamed:@"Vegetarian.png"];
        [self.vegetarianButton setImage:buttonImage forState:UIControlStateNormal];
    }
    
}
-(IBAction)gfTapped:(id)sender {
    glutenfreeFlag = ( 1 + glutenfreeFlag ) % 2;
    
    if( glutenfreeFlag == 0 )
    {
        UIImage *buttonImage = [UIImage imageNamed:@"GlutenfreeOff.png"];
        [self.glutenFreeButton setImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *buttonImage = [UIImage imageNamed:@"Glutenfree.png"];
        [self.glutenFreeButton setImage:buttonImage forState:UIControlStateNormal];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShakeSegue"]){
        ShakeResultViewController *destViewController = segue.destinationViewController;
        destViewController.comboArray = comboArray;
        NSNumber *count = [NSNumber numberWithInt:arrayCount];
        destViewController.arrayCount = count;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end