//
//  MenuPictureViewController.m
//  TitleScreen
//
//  Created by Josh Anatalio on 5/11/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "MenuPictureViewController.h"
#import "MenuCell.h"
#import "PopUpViewController.h"
#import "MZCustomTransition.h"
#import <MZFormSheetController.h>
#import <MZFormSheetSegue.h>
#import <Parse/Parse.h>
#define CELL_COUNT 13
#define CELL_NAME @"MenuCell"


@interface MenuPictureViewController ()
@property (nonatomic, strong) NSMutableArray *cellSizes;

@end

@implementation MenuPictureViewController{
    NSMutableArray *foodPicArray;
    
}


- (NSMutableArray *)queryForPics:(NSString *) category {
    self.foodPictureArray = [[NSMutableArray alloc] init];
    self.foodNameArray = [[NSMutableArray alloc] init];
    self.foodPriceArray = [[NSMutableArray alloc] init];
    self.foodDescritonArray = [[NSMutableArray alloc] init];
    
    NSLog(@"inside query for pics");
    PFQuery *query = [PFQuery queryWithClassName:@"BJMenu"];
    query.limit = 30;
    [query whereKey:@"category" equalTo:category];
    NSArray *objects = [query findObjects];
    
    for (PFObject *obj in objects) {
        PFFile *imageFile = [obj objectForKey:@"pics"];
        NSData *data = [imageFile getData];
        UIImage *image = [UIImage imageWithData:data];
        NSString *name = [obj objectForKey:@"menuItemName"];
        NSString *price = [obj objectForKey:@"menuItemPrice"];
        NSString *description = [obj objectForKey:@"menuItemDescription"];
        [self.foodNameArray addObject:name];
        [self.foodPriceArray addObject:price];
        if(description)
            [self.foodDescritonArray addObject:description];
        [self.foodPictureArray addObject:image];
        NSLog(@"Added object");
        NSLog(@"array has this many elements: %d", [self.foodPictureArray count]);
    }
    
    
    
    NSLog(@"End of method. Num Elements: %d", [self.foodPictureArray count]);
    return self.foodPictureArray;
}


- (UICollectionView *)collectionView {
    if(!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init]; // make the view into a waterfal; layout
        /* do tall the specifications for header footer and spacing here */
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        // layout.footerHeight = 10;
        //layout.headerHeight = 15;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout]; // init the collection view with the bounds that were given above
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // not exactly sure what this does.
        _collectionView.dataSource = self; //this is the data source
        _collectionView.delegate = self; // this is the delegate
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[MenuCell class] forCellWithReuseIdentifier:CELL_NAME];
        
    }
    
    
    return _collectionView;
}

/* This method is used to populate the array of cell sizes. They are randomized to give the waterfall affect */

-(NSMutableArray *)cellSizes {
    if(!_cellSizes)
    {
        _cellSizes = [NSMutableArray array]; // make a new array
        
        for(NSInteger i = 0; i < CELL_COUNT; i++) //loop to add the sizes in
        {
            CGSize size = CGSizeMake(arc4random() % 30 + 50, arc4random() % 30 + 50);
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}

-(void) dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}


- (void)viewDidLoad
{
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    // foodPicArray = [[NSMutableArray alloc]initWithObjects:@"burger.jpg",@"BJs.png",@"Bluefin.png",@"CPK.png",@"Cottage.png",@"DBar.png",@"Eureka.png",@"ExtraordinaryDesserts.png", @"MignonPho.png",@"SabELee.png",@"Tajima.png",@"Snooze.png",@"TGIF.png", nil];
    /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    backButton.title = @"MOTHER FREAKING SHIT";
    self.navigationItem.backBarButtonItem = backButton;
    */[super viewDidLoad];
    [self queryForPics:self.fromList];
    self.view.backgroundColor = [UIColor blackColor];

	// Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    // self.view.backgroundColor = [UIColor blackColor];
    
}
/*- (IBAction)backButtonPressec:(id)sender {
    self.navigationItem.backBarButtonItem.title = @"";
    [self performSegueWithIdentifier:@"toMainSegue" sender:nil];
    
}*/


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"MOTHER" style:UIBarButtonItemStyleBordered target:nil action:nil];
    /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DollarSign.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    */
    //[self.navigationItem.backBarButtonItem delete:nil];
    //if(self.navigationItem.backBarButtonItem)
      //  NSLog(@"Exists inside view did appear");
    self.navigationItem.backBarButtonItem.title = @"";
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation: toInterfaceOrientation];
}

-(void) updateLayoutForOrientation:(UIInterfaceOrientation)orientation{
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.foodPictureArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    MenuCell *cell = (MenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_NAME forIndexPath:indexPath];;;
    //NSString *string = [self.array objectAtIndex:indexPath.row];
    
    /*if(string){
     // NSLog(string);
     cell.foodPictureName = string;
     cell.backgroundImage.image =  [UIImage imageNamed:string];
     }
     else
     {
     cell.backgroundImage.image = [UIImage imageNamed:@"BJ's"];
     
     }*/
    UIImage *cellImage = [self.foodPictureArray objectAtIndex:indexPath.row];
    // This is where we are setting the cells for collection view.
    if(cellImage){
        //NSLog(string);
        //cell.backgroundImage.image =  [UIImage imageNamed:string];
        cell.foodNameLabel.text = [self.foodNameArray objectAtIndex:indexPath.row];
        cell.backgroundImage.image = cellImage;
        NSString *tempString = [NSString stringWithFormat:@"$%@",[self.foodPriceArray objectAtIndex:indexPath.row]];
        cell.priceLabel.text = tempString;
    }
    
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //UIImage *image = [UIImage imageNamed:[foodPicArray objectAtIndex:indexPath.row]];
    UIImage *image = [self.foodPictureArray objectAtIndex:indexPath.row];
    NSString *foodName = [self.foodNameArray objectAtIndex:indexPath.row];
    NSString *foodDescription = [self.foodDescritonArray objectAtIndex:indexPath.row];
    NSString *priceTagString =  [NSString stringWithFormat:@"$%@",[self.foodPriceArray objectAtIndex:indexPath.row]];
    if(image)
    {
        NSLog(@"image is not null");
    }
    
    PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"popup"];
    
    vc.foodPic = image; // set the pop up image
    vc.foodNameString = foodName;
    vc.foodDescriptionString = foodDescription;
    vc.priceString = priceTagString;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:2.0];

    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    //formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PopUpTest"])
    {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        
        NSLog(@"tried to put the picture on the form sheet");
        formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
        formSheet.cornerRadius = 8.0;
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        };
        
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            
        };
               [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
        
        
        NSLog(@"tried to put the picture on the form sheet");
        //vc.pic = sender;
    }
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize nsize;
    UIImage *photo = self.foodPictureArray[indexPath.section];
    
    if(!photo)
    {
        nsize = CGSizeZero;
    }
    else{
        //CGSize newsize = CGRectMake(0, 0, photo.size.width*2, photo.size.height*2);
        nsize = CGSizeMake(photo.size.width, photo.size.height);
        NSLog(@"Photo size was set in sizeforItemAtIndexPath");
        
        
        
    }
    return nsize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
