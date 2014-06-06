//
//  CategoryMenuItemViewController.m
//  HIMYMdb
//
//  Created by Angelique De Castro on 5/4/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import "CategoryMenuItemViewController.h"
//#import "ImageListViewController.h"
#import "MenuCell.h"
#import <Parse/Parse.h>

@interface CategoryMenuItemViewController ()



@end

@implementation CategoryMenuItemViewController

static int i = 0;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"BJMenu";
        
        // The key of the PFObject to display in the label of the default cell style
        self.imageKey = @"category";
        
        // The title for this table in the Navigation Controller.
        //self.title = @"BJ's";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"category" equalTo:self.fromList];
    //[query whereKey:@"Username" equalTo:@"Ankush Agrawal"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query whereKey:@"category" equalTo:self.fromList];
    
    [query orderByAscending:@"menuItemName"];
    
    return query;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    // PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    //NSArray *tableview = [query findObjects];
    
    //NSArray *pic = [self queryForPlateItemPics:@"achuang94"];
    //NSArray *name = [self queryForPlateItemNames:@"menuItemName"];
    //NSArray *price = [self queryForPlateItemPrices:@"menuItemPrice"];
    //cell.imageView.image = pic[i];


    cell.textLabel.text = [object objectForKey:@"menuItemName"];
    //cell.imageView.image = [UIImage imageNamed:@"ClassicBurger.jpg"];
    cell.detailTextLabel.text = [object objectForKey:@"menuItemPrice"];
    //cell.detailTextLabel.text = [object objectForKey:@"menuItemPrice"];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    /*if( i == [pic count]-1)
        i = 0;
    else
        i++;
    */
    return cell;
}


- (NSMutableArray *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [object objectForKey:@"category"];
    NSString *cellText = cell.textLabel.text;
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];
    [menuItemArray addObject:cellText];
    return menuItemArray;
}


#pragma mark - Table view data source



#pragma mark - Table view delegate


// checkmarks

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
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

// To be used in conjunction with queryforPlateItemPrices (must be called consecutively or the arrays
// values won't match up with each other
- (NSArray *)queryForPlateItemNames: (NSString *) userID {
    
    NSMutableArray *plateItemNames = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query whereKey:@"userid" equalTo:userID];
    
    NSArray *objects = [query findObjects];
    
    for (PFObject *obj in objects) {
        [plateItemNames addObject:obj[@"menuItemName"]];
    }
    
    return plateItemNames;
}

// To be used in conjunction with queryforPlateItemNames (must be called consecutively or the arrays
// values won't match up with each other
- (NSArray *)queryForPlateItemPrices: (NSString *) userID {
    
    NSMutableArray *plateItemPrices = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query whereKey:@"userid" equalTo:userID];
    
    NSArray *objects = [query findObjects];
    
    for (PFObject *obj in objects) {
        [plateItemPrices addObject:obj[@"menuItemPrice"]];
    }
    
    return plateItemPrices;
}

// To be used in conjunction with queryforPlateItem queries (must be called consecutively or the arrays
// values won't match up with each other
// Returns an array of UIImages
- (NSArray *)queryForPlateItemPics: (NSString *) userID {
    
    NSMutableArray *plateItemPics = [[NSMutableArray alloc] init];
    __block PFFile *itemPic;
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query whereKey:@"userid" equalTo:userID];
    
    NSArray *objects = [query findObjects];
    
    for (PFObject *obj in objects) {
        itemPic = obj[@"pics"];
        NSData *data = [itemPic getData];
        UIImage *image = [UIImage imageWithData:data];
        // picture file is now a UIImage
        [plateItemPics addObject:image];
    }
    
    return plateItemPics;
}

@end
