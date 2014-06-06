//
//  NewMyPlateViewController.h
//  TitleScreen
//
//  Created by Ankush Agrawal on 6/3/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <Parse/Parse.h>

@interface NewMyPlateViewController : PFQueryTableViewController
@property (nonatomic, strong) NSString *fromList;
@property double totalCost;
@property NSArray *items;
@end
