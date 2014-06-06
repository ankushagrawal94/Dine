//
//  ViewController.m
//  TitleScreen
//
//  Created by Josh Anatalio on 4/30/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "ViewController.h"
#import "MenuPictureViewController.h"
#import "MenuViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "PopUpViewController.h"
#import "MZCustomTransition.h"
#import <MZFormSheetController.h>
#import <MZFormSheetSegue.h>
#import <Parse/Parse.h>
#import <AdSupport/AdSupport.h>
#import "ShakeViewController.h"
#import "CategoryTableViewController.h"
#import "MyPlateViewController.h"
#import "NewMyPlateViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController
@synthesize dataArray;
@synthesize picNames;
//static int queueCount = 1;

- (IBAction)leadToTab:(id)sender {
    CategoryTableViewController *textMenuVC = [[CategoryTableViewController alloc] init];
    ShakeViewController *shakerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"shakeVCID"];
    MyPlateViewController *myPlateVC = [[MyPlateViewController alloc] init];
    //NewMyPlateViewController *myPlateVC = [[NewMyPlateViewController alloc] init];
    UINavigationController *tab1 = [[UINavigationController alloc] initWithRootViewController:textMenuVC];
    //UINavigationController *tab2 = [[UINavigationController alloc] initWithRootViewController:imageMenuVC];
    UINavigationController *tab3 = [[UINavigationController alloc] initWithRootViewController:shakerVC];
    UINavigationController *tab4 = [[UINavigationController alloc] initWithRootViewController:myPlateVC];

    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray* controllers = [NSArray arrayWithObjects:tab1, /*tab2, */tab3, tab4, nil];
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    tabBarController.viewControllers = controllers;
    UITabBarItem *tab1Item = [[[tabBarController tabBar] items] objectAtIndex:0];
    /*UITabBarItem *tab2Item = [[[tabBarController tabBar] items] objectAtIndex:0];
    [tab2Item setTitle:@"Picture Menu"];
    */UITabBarItem *tab3Item = [[[tabBarController tabBar] items] objectAtIndex:1];
    UITabBarItem *tab4Item = [[[tabBarController tabBar] items] objectAtIndex:2];
    
    //Change tint color
    tabBarController.tabBar.translucent = FALSE;
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    //Set red bar for the controller
    UITabBar *tab = [tabBarController tabBar];
    [tab setBackgroundImage:[UIImage imageNamed:@"TabBar.png"]];
    
    //Set images for each button
    tab1Item.image = [[UIImage imageNamed:@"GridWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab1Item.selectedImage = [UIImage imageNamed:@"GridWhite.png"];
    tab3Item.image = [[UIImage imageNamed:@"ShakeWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab3Item.selectedImage = [UIImage imageNamed:@"ShakeWhite.png"];
    tab4Item.image = [[UIImage imageNamed:@"PlateWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab4Item.selectedImage = [UIImage imageNamed:@"PlateWhite.png"];
    
    //[tab3Item setImage:[UIImage imageNamed:@"Shake.png"]];
    
    //[self.navigationController pushViewController:tabBarController animated:YES];
    tabBarController.tabBar.hidden = NO;
    [self presentViewController:tabBarController animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorWithRed:234.0 green:234.0 blue:234.0 alpha:1.0];
    
    self.UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedBar.png"]];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 624)];
    scroller.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    // Instantiante NSMutableArray for data
    dataArray = [[NSMutableArray alloc]initWithObjects:@"Cheeseburger",@"Hamburger", @"Hot Dog", nil];
    picNames = [[NSMutableArray alloc]initWithObjects:@"BJs.png",@"Bluefin.png",@"CPK.png",@"Cottage.png",@"DBar.png",@"Eureka.png",@"ExtraordinaryDesserts.png", @"MignonPho.png",@"SabELee.png",@"Tajima.png",@"Snooze.png",@"TGIF.png", nil];
    int i = 0;
    for(UIButton *b in self.restaurantButtons)
    {
        NSString *string = picNames[i];
        if(string != nil)
        {
            [b setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
            [b setTitle:@"" forState:UIControlStateNormal];
            i++;
        }
        
    }
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:self action:@selector(barButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"QueueButton.png"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.shouldHideBadgeAtZero = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Q"];
    [query orderByAscending:@"updatedAt"];
    NSArray *objects = [query findObjects];
    int positionInQueue = 0;
    int index = 0;
    for (PFObject *obj in objects) {
        if([obj[@"uuid"] isEqualToString: self.UUID])
        {
            positionInQueue = index;
            barButton.badgeValue = [NSString stringWithFormat:@"%d", positionInQueue];
            NSLog(@"Position in queue set to index %d", index);
        }
        NSLog(@"queue has this many elements: %lu", (unsigned long)[objects count]);
        index++;
    }
    
    
    barButton.badgeOriginX = 13;
    barButton.badgeOriginY = -9;
    barButton.badgeBGColor = [UIColor whiteColor];
    barButton.badgeTextColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.leftBarButtonItem = barButton;
    
    NSLog(@"Exited view did load");
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)barButtonItemPressed:(UIButton *)sender
{
    
    // [self performSegueWithIdentifier:@"PopUpTest" sender:image];
    
    PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"queuepop"];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.presentedFormSheetSize = CGSizeMake(300, 75);
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTop;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTopInset;
    // formSheet.landscapeTopInset = 50;
    // formSheet.portraitTopInset = 100;
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        PopUpViewController *navController = (PopUpViewController *)weakFormSheet.presentedFSViewController;
        // navController = image;
        
        /*if ([navController.topViewController isKindOfClass:[MZModalViewController class]]) {
         MZModalViewController *mzvc = (MZModalViewController *)navController.topViewController;
         mzvc.showStatusBar = NO;
         }*/
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    /*
     formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
     // Passing data
     UINavigationController *navController = (UINavigationController *)presentedFSViewController;
     navController.topViewController.title = @"PASSING DATA";
     };*/
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
    //********* BAR BUTTON CODE *************//
    NSLog(@"Bar button item pressed");
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    //queueCount++;
    //NSString *hi = [NSString stringWithFormat:@"%d", queueCount];
    //barButton.badgeValue = hi;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Q"];
    [query orderByAscending:@"updatedAt"];
    //[query whereKey:@"Q" equalTo:category];
    NSArray *objects = [query findObjects];
    int positionInQueue = 0;
    int index = 0;
    for (PFObject *obj in objects) {
        if([obj[@"uuid"] isEqualToString:self.UUID])
        {
            positionInQueue = index+1;
        }
        index++;
    }
    NSLog(@"queue has this many elements: %lu", (unsigned long)[objects count]);
    barButton.badgeValue = [NSString stringWithFormat:@"%d", positionInQueue];
    NSLog(@"BADGE VALUES BEING SET TO: %d \n\n\n", positionInQueue);
    vc.messageLabel.text = [NSString stringWithFormat:@"You are number %d on the waitlist", positionInQueue];
    barButton.shouldAnimateBadge = NO;
    barButton.shouldHideBadgeAtZero = NO;
}


/* This method is used to remove the keyboard when you tap anywhere on the screen */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Tried to hide search bar");
    [self.searchBar resignFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
