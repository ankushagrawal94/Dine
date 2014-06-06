//
//  ImageListViewController.m
//  HIMYMdb
//
//  Created by Angelique De Castro on 5/29/14.
//  Copyright (c) 2014 ifearcompilererrors. All rights reserved.
//

#import "ImageListViewController.h"
#import <Parse/Parse.h>

@interface ImageListViewController ()

@end

@implementation ImageListViewController{
    NSMutableArray *array;
    int i;
}



- (NSMutableArray *)queryForPics:(NSString *) category {
    //NSMutableArray *picArray = [[NSMutableArray alloc] init];
    array = [[NSMutableArray alloc] init];
    //[picArray addObject:@"TEST"];
    NSLog(@"inside query for pics");
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    //[query whereKey:@"category" equalTo:category];
    //[query whereKey:@"Username" equalTo:@"Ankush Agrawal"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     */
    // [query orderByAscending:@"menuItemName"];
    NSArray *objects = [query findObjects];
    for (PFObject *obj in objects) {
        PFFile *imageFile = [obj objectForKey:@"pics"];
        NSData *data = [imageFile getData];
        UIImage *image = [UIImage imageWithData:data];
        [array addObject:image];
        NSLog(@"Added object");
        NSLog(@"array has this many elements: %d", [array count]);
        
        /*
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
         if(!error) {
         UIImage *image = [UIImage imageWithData:data];
         [array addObject:image];
         NSLog(@"Added object");
         NSLog(@"array has this many elements: %d", [array count]);
         }
         else
         NSLog(@"errored");
         }];*/
    }
    /*[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
     if(!error) {
     NSLog(@"inside findobjects");
     
     for (PFObject *obj in objects) {
     PFFile *imageFile = [obj objectForKey:@"pics"];
     [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
     if(!error) {
     UIImage *image = [UIImage imageWithData:data];
     [array addObject:image];
     NSLog(@"Added object");
     NSLog(@"array has this many elements: %d", [array count]);
     }
     else
     NSLog(@"errored");
     }];
     }
     }
     else
     NSLog(@"%@", error);
     }
     ];*/
    NSLog(@"End of method. Num Elements: %d", [array count]);
    return array;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSArrat *array alloc]
    //NSArray *array = [[NSArray alloc] init];
    //[self queryForPics:@"Beverage"];
    //NSArray *array = [self queryForPics:@"Beverage"];
    //array = [[NSMutableArray alloc]initWithObjects:@"BJs.png",@"Bluefin.png",@"CPK.png",@"Cottage.png",@"DBar.png",@"Eureka.png",@"ExtraordinaryDesserts.png", @"MignonPho.png",@"SabELee.png",@"Tajima.png",@"Snooze.png",@"TGIF.png", nil];
    NSLog(@"Inside View did load");
    // NSMutableArray *test = [self queryForShakeItems:@"13.00" Calories:@5000 category:@"Entree"];
    // [self addToPlateQuery:@"achuang94" ItemName:@"Grilled Chicken Pasta"];
    // [self deletePlateItem:@"achuang94" ItemName:@"Grilled Chicken Pasta"];
    // [self addToPlateQuery:@"achuang94" ItemName:@"Dr Pepper"];
    
    NSArray *testarray = [self queryForPlateItemNames:@"achuang94"];
    NSArray *testarray2 = [self queryForPlateItemPrices:@"achuang94"];
    NSLog(testarray[0]);
    NSLog(testarray2[0]);
    
    NSArray *testarray3 = [self queryForPlateItemPics:@"achuang94"];
    NSLog(@"yay");
}


// - (NSMutableArray *)queryForShakeItems:(NSString *)maxPrice Calories:(NSNumber *)maxCalories category: (NSString *) category Vegetarian: (BOOL) vegetarian Gluten: (BOOL) glutenfree {
- (NSMutableArray *)queryForShakeItems:(NSString *)maxPrice Calories:(NSNumber *)maxCalories category: (NSString *) category {
    NSLog(@"Inside queryForShakeItems");
    NSMutableArray *shakeItems = [[NSMutableArray alloc] init];
    NSMutableArray *menuItem = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    [query whereKey:@"course" equalTo:category];
    [query whereKey:@"menuItemPrice" lessThanOrEqualTo:maxPrice];
    [query whereKey:@"calories" lessThanOrEqualTo:maxCalories];
    
    /* if(vegetarian == TRUE) {
     [query whereKey:@"vegetarian" equalTo:(id)TRUE];
     } */
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    [query orderByAscending:@"menuItemPrice"];
    
    NSArray *objects = [query findObjects];
    for (int i = 0; i < [objects count]; i++) {
        // Clear menuItem array to fill next menu item
        [menuItem removeAllObjects];
        
        NSString *name = [objects[i] objectForKey:@"menuItemName"];
        NSString *price = [objects[i] objectForKey:@"menuItemPrice"];
        NSNumber *caloriesCount = [objects[i] objectForKey:@"calories"];
        
        // Add desired information into an array for each menu item
        [menuItem addObject:name];
        [menuItem addObject:price];
        [menuItem addObject:caloriesCount];
        
        // Add information for individual menu item into final array to return
        [shakeItems addObject:menuItem];
        
        // NSLog(name);
        // NSLog(price);
        // NSLog([caloriesCount stringValue]);
    }
    
    return shakeItems;
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
            NSLog(queryPrice);
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View Methods
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [array count];
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"inside cellforItemAtIndex");
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    
    //UIImageView *pic = (UIImageView *)[cell viewWithTag:69];
    UIImage *string = [array objectAtIndex:indexPath.row];
    
    if(string){
        //NSLog(string);
        //cell.backgroundImage.image =  [UIImage imageNamed:string];
        cell.backgroundImage.image = string;
    }
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *searchTerm = array[indexPath.section];
    //UIImage *photo = [UIImage imageNamed:searchTerm];
    UIImage *photo = searchTerm;
    // 2
    CGSize retval = photo.size.width > 0 ? photo.size : CGSizeMake(100, 100);
    retval.height += 0; retval.width += 0; return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}
/*
 #pragma mark - UICollectionView Datasource
 // 1
 - (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 NSString *searchTerm = self.searches[section];
 return [self.searchResults[searchTerm] count];
 }
 // 2
 - (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
 return [self.searches count];
 }
 // 3
 - (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
 cell.backgroundColor = [UIColor whiteColor];
 return cell;
 }
 // 4
 /*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

@end
