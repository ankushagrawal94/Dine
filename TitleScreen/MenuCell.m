//
//  MenuCell.m
//  TitleScreen
//
//  Created by Josh Anatalio on 5/4/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (UIImageView *)backgroundImage{
    
    if(!_backgroundImage)
    {
        //_backgroundImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        
    }
    return _backgroundImage;
}
-(UILabel *)foodNameLabel{
    if(!_foodNameLabel)
    {
        
        _foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 20)];
        _foodNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [_foodNameLabel setFont:[UIFont fontWithName:@"Euphemia UCAS" size:12]];
        //_foodNameLabel.text = @"Cheeseburger"; // just for testing purposes
        
        _foodNameLabel.textColor = [UIColor whiteColor];
    }
    return _foodNameLabel;
}

-(UILabel *)priceLabel{
    if(!_priceLabel)
    {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-20, self.contentView.frame.size.width-1, 20)];
        _priceLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        [_priceLabel setFont:[UIFont fontWithName:@"Euphemia UCAS" size:12]];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        // _priceLabel.text = @"$11.99    "; // just for testing purposes
        
        _priceLabel.textColor = [UIColor whiteColor];
        
    }
    
    return _priceLabel;
}




- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backgroundImage];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.foodNameLabel];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end