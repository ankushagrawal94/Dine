//
//  shakeMeal.m
//  SliderTest
//
//  Created by Elle T Nguyen-khoa on 5/13/14.
//  Copyright (c) 2014 HIMYM. All rights reserved.
//

#import "ShakeMeal.h"



@implementation ShakeMeal


- (id) init;
{
	_mealItem = nil;
	_price = 0;
	_calorie = 0;
    return self;
}


- (NSString *) getName {
    if (self == nil)
        return nil;
    return self.mealItem;
}

-(double) getPrice {
    if (self == nil)
        return 0;
    return self.price;
}

- (int) getCalorie {
    if (self == nil)
        return 0;
    return self.calorie;
}
@end
