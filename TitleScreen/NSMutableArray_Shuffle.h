//
//  NSMutableArray_Shuffle.h
//  TitleScreen
//
//  Created by Alex C Tsang on 5/25/14.
//  Copyright (c) 2014 JoshAnatalio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

@implementation NSMutableArray (Shuffling)
- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
