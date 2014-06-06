//
//  CategoryTableViewController.h
//  HIMYMdb
//
//  Created by Angelique De Castro on 4/29/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import <Parse/Parse.h>

@interface MyPlateViewController : PFQueryTableViewController
@property (nonatomic, strong) NSString *fromList;
@property double totalCost;
@property NSArray *items;
@end