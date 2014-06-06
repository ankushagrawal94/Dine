//
//  CategoryMenuItemViewController.h
//  HIMYMdb
//
//  Created by Angelique De Castro on 5/4/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import <Parse/Parse.h>
//#import "ImageListViewController.h"

@interface CategoryMenuItemViewController : PFQueryTableViewController

@property (nonatomic, strong) NSString *fromList;
//@property (nonatomic, strong) ImageListViewController *myplate;
//@property (nonatomic, strong) PFQueryTableViewController *myplate;

- (void)addToPlateQuery: (NSString *) userID ItemName: (NSString *) menuItem;
- (void)deletePlateItem: (NSString *) userID ItemName: (NSString *) menuItem;


@end
