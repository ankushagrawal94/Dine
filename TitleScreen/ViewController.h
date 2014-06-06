//
//  ViewController.h
//  TitleScreen
//
//  Created by Josh Anatalio on 4/30/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIScrollView *scroller;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *restaurantButtons;

@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) NSMutableArray *picNames;
@property NSString* UUID;
@property BOOL flag;
@end
