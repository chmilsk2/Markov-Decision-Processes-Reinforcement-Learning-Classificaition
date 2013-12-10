//
//  ReinforcementLearningOperation.h
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "BlackBox.h"


typedef void(^ReinforcementLearningHandler)(Grid grid, int t);

@interface ReinforcementLearningOperation : NSOperation

- (id)initWithGrid:(Grid)grid t:(int)t discountFactor:(double)discountFactor maxFrequency:(int)maxFrequency explorationConstant:(int)explorationConstant blackBox:(BlackBox)blackBox;

@property (copy) ReinforcementLearningHandler reinforcementLearningCompletionBlock;

@end
