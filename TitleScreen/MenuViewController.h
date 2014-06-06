//
//  MenuViewController.h
//  TitleScreen
//
//  Created by Josh Anatalio on 4/30/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MenuViewController : ViewController <UIApplicationDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) CLBeaconRegion *beaconRegion;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibeaconstatusLabel;

@end
