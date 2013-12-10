//
//  ReinforcementLearningOperation.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "ReinforcementLearningOperation.h"

@implementation ReinforcementLearningOperation {
	Grid mGrid;
}

- (id)initWithGrid:(Grid)grid {
	self = [super init];
	
	if (self) {
		mGrid = grid;
	}
	
	return self;
}

- (void)main {
	[self reinforcementLearning];
	
	[self didFinish];
}

#pragma mark - Reinforcement learning

- (void)reinforcementLearning {
	
}

- (void)didFinish {
	if (self.reinforcementLearningCompletionBlock) {
		self.reinforcementLearningCompletionBlock(mGrid);
	}
}

@end
