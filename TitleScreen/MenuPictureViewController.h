//
//  MenuPictureViewController.h
//  TitleScreen
//
//  Created by Josh Anatalio on 5/11/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"


@interface MenuPictureViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *foodPictureArray;
@property NSMutableArray *foodNameArray;
@property NSMutableArray *foodPriceArray;
@property NSMutableArray *foodDescritonArray;
@property NSString* fromList;
@end
