//
//  MenuCell.h
//  TitleScreen
//
//  Created by Josh Anatalio on 5/4/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *foodNameLabel;
@property (nonatomic, strong) NSString *foodPictureName;
@end