//
//  ValueIterationOperation.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/8/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"

typedef void(^ValueIterationHandler)(NSArray *utilities, Grid grid);

@interface ValueIterationOperation : NSOperation

@property (copy) ValueIterationHandler valueIterationCompletionBlock;

- (id)initWithGrid:(Grid)grid discountFactor:(double)discountFactor intendedOutcomeProbabilitiy:(double)intendedOutcomeProbability unIntendedOutcomeProbabilitiy:(double)unIntendedOutcomeProbability;

@end
