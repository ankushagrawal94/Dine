//
//  AppDelegate.m
//  TitleScreen
//
//  Created by Josh Anatalio on 4/30/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "AppDelegate.h"
#import "BBBadgeBarButtonItem.h"
#import <Parse/Parse.h>
#import <AdSupport/AdSupport.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Dine Bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xFF3A2D)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
     
     
     
    [Parse setApplicationId:@"79o1Y0q30MHbZh5ITPc9lkXGIzrKNpAj1o5WpVe8"
                  clientKey:@"zGNeeDLnebZtbKGNmxGTBqtgNwm2rMySH6pxTOil"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    self.flag = true;
    NSLog(@"View did load");
    NSUUID* ident = [[UIDevice currentDevice].identifierForVendor init];
    //const char *name = propety_
    NSLog(@"%@", ident);
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //Put your UUID here!
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"test"];
    [_locationManager startMonitoringForRegion:_beaconRegion];
   
    PFQuery *query = [PFQuery queryWithClassName:@"Q"];
    [query whereKey:@"uuid" equalTo:self.UUID];
    [[query getFirstObject] deleteInBackground];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/* **********************************************************************
   **********************************************************************
   **********************************************************************/

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion");
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    NSLog(@"started ranging beacons in reigon");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion");
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
   /* UIAlertView *test = [[UIAlertView alloc] init];
    test = [test initWithTitle:@"TEST" message:@"MESSAGE" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"other title", nil];
    [test show];
    NSLog(@"sent alert");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Inside beacon";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    */
    //Since we only have one iBeacon we can call our function here, for example send data to our database that we are inside the beacon
    
    /*
     //Set your column online as 1 since we are inside the beacon
     PFQuery *query = [PFQuery queryWithClassName:@"online"];
     [query whereKey:@"username" equalTo:[PFUser currentUser].username];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
     if (!error) {
     // Found UserStats
     [userStats setObject:@1 forKey:@"online"];
     
     // Save
     [userStats saveInBackground];
     } else {
     // Did not find any UserStats for the current user
     NSLog(@"Error: %@", error);
     }
     }];*/
    
    NSLog(@"Entered didEnterReigon");
    
}

//Usually takes 10-20 seconds before it notices the region change, probably  to avoid spam
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //[_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    self.ibeaconstatusLabel.text = @"Outside beacon!";
    
    /*//Set your column online as 0 since we are outside the beacon
     PFQuery *query = [PFQuery queryWithClassName:@"online"];
     [query whereKey:@"username" equalTo:[PFUser currentUser].username];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
     if (!error) {
     // Found UserStats
     [userStats setObject:@0 forKey:@"online"];
     
     // Save
     [userStats saveInBackground];
     } else {
     // Did not find any UserStats for the current user
     NSLog(@"Error: %@", error);
     }
     }];*/
    
    NSLog(@"DidExit");
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    //NSLog(@"REACHED");
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    if (beacon.proximity == CLProximityUnknown) {
        
        self.ibeaconstatusLabel.text = @"Connected!";
        self.statusLabel.text = @"Unknown Proximity";
        //NSLog(@"Proximity Unknown");
        
    } else if (beacon.proximity == CLProximityImmediate) {
        
        self.statusLabel.text = @"Immediate";
        self.ibeaconstatusLabel.text = @"Connected!";
        //NSLog(@"Proximity Immediate");
        
    } else if (beacon.proximity == CLProximityNear) {
        
        self.statusLabel.text = @"Near";
        self.ibeaconstatusLabel.text = @"Connected!";
        
        //[query whereKey:@"Q" equalTo:category];
        //PFObject *objToDelete = [query getFirstObject];
        //[objToDelete deleteInBackground];
        
        if(self.flag)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Q"];
            [query whereKey:@"uuid" equalTo:self.UUID];
            [[query getFirstObject] deleteInBackground];
            
            UIAlertView *addedToQ = [[UIAlertView alloc] initWithTitle:@"Waitlist" message:@"Do you want to be added to the waiting list?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"YES", nil];
            //addedToQ = [addedToQ initWithTitle:@"Queue" message:@"Do you want to be added to the queue" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"YES!", nil];
            [addedToQ show];
            NSLog(@"Alert view launched and object going to be added");
            self.flag = false;
        }
        //NSLog(@"Proximity Near");
        
    } else if (beacon.proximity == CLProximityFar) {
        
        self.statusLabel.text = @"Far";
        self.ibeaconstatusLabel.text = @"Connected!";
        //NSLog(@"Proximity Far");
        
    }
    //NSLog(@"didRangeBeacons");
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"inside clicked button at index \n \n \n \n \n \n");
    if(buttonIndex == 0)
    {
        //cancel button
        NSLog(@"cancel button \n");
        //self.flag = true;

    }
    if(buttonIndex == 1)
    {
        //YES button
        NSLog(@"YES button \n");
        PFObject* object = [PFObject objectWithClassName:@"Q"];
        object[@"uuid"] = self.UUID;
        [object saveInBackground];
        self.flag = false;
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"did fail with error");
}


@end
