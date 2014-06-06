//
//  CategoryTableViewController.m
//  HIMYMdb
//
//  Created by Angelique De Castro on 4/29/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import "NewMyPlateViewController.h"
#import <Parse/Parse.h>
#import "MenuPictureViewController.h"
#import "ViewController.h"

@interface NewMyPlateViewController ()

@end

@implementation NewMyPlateViewController

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
        //self.title = @"Categories";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
     
        //self.totalCost = 0;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:(BOOL)animated];
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
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"menuItemName"];
    
    return query;
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


- (NSMutableArray *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [object objectForKey:@"category"];
    NSString *cellText = cell.textLabel.text;
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];
    [menuItemArray addObject:cellText];
    return menuItemArray;
}



/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        PFObject *objectToDel = [self.objects objectAtIndex:indexPath.row];
        [objectToDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             UIAlertView *Alert = [[UIAlertView alloc]  initWithTitle:@"Item Was Deleted" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             
         }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     [super tableView:tableView didSelectRowAtIndexPath:indexPath];
     NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];
     PFObject* listObject = [self.objects objectAtIndex:selectedItem.row];
     
     
     //NSString* contactName = [listObject objectForKey:@"RelatedUsername"];
     //NSLog(listName2);
     ProfileListViewController *profileListView = [ProfileListViewController new];
     profileListView.contactName = contactName;
     [self.navigationController pushViewController:profileListView animated:YES];
     */
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];
    PFObject* listObject = [self.objects objectAtIndex:selectedItem.row];
    
    NSString* menuItem = [listObject objectForKey:@"category"];
    //NSString* contactName = [listObject objectForKey:@"RelatedUsername"];
    //NSLog(listName2);
    //MenuPictureViewController *imageMenuVC = [[MenuPictureViewController alloc] init];
    MenuPictureViewController *imageMenuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuPictureVCID"];
    //CategoryMenuItemViewController *menuItemView = [CategoryMenuItemViewController new];
    imageMenuVC.fromList = menuItem;
    [self.navigationController pushViewController:imageMenuVC animated:YES];
    
}


@end