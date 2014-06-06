//  CategoryMenuItemViewController.m
//  HIMYMdb
//
//  Created by Angelique De Castro on 5/4/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import "MyPlateViewController.h"
#import "MenuCell.h"
#import <Parse/Parse.h>
#import "Bolts.h"
#import "PopUpViewController.h"
#import "MZNavigationViewController.h"
#import "MZCustomTransition.h"
#import <AdSupport/AdSupport.h>


@interface MyPlateViewController ()
@property NSString *UUID;
@end

@implementation MyPlateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"MyPlate";
        
        // The key of the PFObject to display in the label of the default cell style
        self.imageKey = @"menuItemName";
        
        // The title for this table in the Navigation Controller.
        //self.title = @"BJ's";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
        
        self.totalCost = 0;
        
        self.UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"VenmoNew.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(venmoClick)];
    
    self.items = [self queryForPlateItems:self.UUID];
    [self refreshControl];
    
}
-(IBAction)venmoClick
{
    NSLog(@"venmo clicked");
    
    BFAppLink *links = [BFAppLink appLinkWithSourceURL:[NSURL URLWithString:@"venmo://friend"] targets:nil webURL:[NSURL URLWithString:@"venmo://friend"]];
    [BFAppLinkNavigation navigateToAppLink: links error:nil];
    
    /*PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"venmoPopup"];
     
     vc.priceLabel.text = [NSString stringWithFormat:@"Price of Meal: $%f",self.totalCost];
     vc.tipLabel.text = [NSString stringWithFormat:@"Suggested Tip: $%f", self.totalCost*0.15];
     vc.totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: $%f", self.totalCost*1.15];
     MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
     
     */
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
    self.items = [self queryForPlateItems:self.UUID];
    NSLog(@"\n\n\n\n\n\n\n View will appear");
    [self loadObjects];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshControl];
    
    
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
// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //self.totalCost = self.totalCost + [self.items[1][indexPath.row] doubleValue];
    NSLog(@"cell");
    if( indexPath.row < [self.items[2] count])
    {
        NSLog(@"THERE ARE %ld ITEMS", (unsigned long)[self.items[2] count]);
        NSLog(@"THE INDEX PATH IS: %d", indexPath.row);
        NSLog(@"inside the if");
        //cell.textLabel.text = [NSString stringWithFormat:@"         %@", [object objectForKey:@"menuItemName"]];
        cell.textLabel.text = [NSString stringWithFormat:@"          %@", self.items[0][indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor redColor];
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"           $%@", [object objectForKey:@"menuItemPrice"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"           $%@", self.items[1][indexPath.row]];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 43)];
        [imgView setImage:self.items[2][indexPath.row]];
        [cell addSubview:imgView];
        /*if( i == [items[2] count] - 1)
         i = 0;
         else
         i++;*/
    }
    else
    {
        NSLog(@"ELSE");
        //cell.textLabel.text = @"             SEE MEEE";
        //i = 0;
    }
    
    
    return cell;
}
/*
 - (NSMutableArray *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 object:(PFObject *)object {
 return nil;
 }*/

- (PFQuery *)queryForTable {
    NSLog(@"QueryForTable called");
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByAscending:@"menuItemName"];
    [query whereKey:@"userid" equalTo:self.UUID];
    self.items = [self queryForPlateItems:self.UUID];
    //[self loadObjects];
    return query;
}

#pragma mark - Table view delegate

// checkmarks
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *menuItem = tableCell.textLabel.text;
    menuItem = [menuItem substringFromIndex:10];
    [self deletePlateItem:self.UUID ItemName:menuItem];
    //[self refreshControl];
    [self loadObjects];
    NSLog(@"Did select row at index path");
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
    
    NSLog(@"itemname is: %@", menuItem);
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query whereKey:@"menuItemName" equalTo:menuItem];
    
    /*[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
     if (!object) {
     NSLog(@"The getFirstObject request failed.");
     } else {
     // The find succeeded.
     NSLog(@"Successfully retrieved the object.");
     
     // Delete the object from the table
     [object deleteInBackground];
     }
     }];*/
    PFObject *object = [query getFirstObject];
    [object delete];
}

- (NSArray *)queryForPlateItems: (NSString *) userID {
    NSMutableArray *plateItemNames = [[NSMutableArray alloc] init];
    NSMutableArray *plateItemPrices = [[NSMutableArray alloc] init];
    NSMutableArray *plateItemPics = [[NSMutableArray alloc] init];
    NSMutableArray *plateItems = [[NSMutableArray alloc] init];
    __block PFFile *itemPic;
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    //[query orderByAscending:@"menuItemName"];
    [query whereKey:@"userid" equalTo:userID];
    NSArray *objects = [query findObjects];
    
    for (PFObject *obj in objects) {
        [plateItemNames addObject:obj[@"menuItemName"]];
        [plateItemPrices addObject:obj[@"menuItemPrice"]];
        itemPic = obj[@"pics"];
        NSData *data = [itemPic getData];
        UIImage *image = [UIImage imageWithData:data];
        // picture file is now a UIImage
        [plateItemPics addObject:image];
    }
    //[plateItemNames addObject:@"__Don't see me"];
    //[plateItemPrices addObject:@"__Don't see price"];
    //[plateItemPics addObject:[UIImage imageNamed:@"AddToPlate.png"]];
    [plateItems addObject:plateItemNames];
    [plateItems addObject:plateItemPrices];
    [plateItems addObject:plateItemPics];
    return plateItems;
}

// To be used in conjunction with queryforPlateItemPrices (must be called consecutively or the arrays
// values won't match up with each other
- (NSArray *)queryForPlateItemNames: (NSString *) userID {
    
    NSMutableArray *plateItemNames = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"MyPlate"];
    [query orderByAscending:@"menuItemName"];
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
    [query orderByAscending:@"menuItemName"];
    [query whereKey:@"userid" equalTo:userID];
    //[query orderByAscending:@"menuItemName"];
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