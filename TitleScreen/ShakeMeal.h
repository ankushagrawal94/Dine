//
//  shakeMeal.h
//  SliderTest
//
//  Created by Elle T Nguyen-khoa on 5/13/14.
//  Copyright (c) 2014 HIMYM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeMeal : NSObject

@property (strong) NSString *mealItem;
@property (assign) double price;
@property (assign) int calorie;

- (NSString *) getName;
- (double) getPrice;
- (int) getCalorie;
- (id) init;

@end
