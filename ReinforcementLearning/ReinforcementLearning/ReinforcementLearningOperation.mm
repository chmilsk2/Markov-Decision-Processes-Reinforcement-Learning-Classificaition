//
//  ReinforcementLearningOperation.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "ReinforcementLearningOperation.h"
#import "Direction.h"

@implementation ReinforcementLearningOperation {
	Grid mGrid;
	BlackBox mBlackBox;
	double mDiscountFactor;
	int mT;
}

- (id)initWithGrid:(Grid)grid t:(int)t discountFactor:(double)discountFactor blackBox:(BlackBox)blackBox {
	self = [super init];
	
	if (self) {
		mGrid = grid;
		mBlackBox = blackBox;
		mDiscountFactor = discountFactor;
		mT = t;
	}
	
	return self;
}

- (void)main {
	[self reinforcementLearning];
	
	[self didFinish];
}

#pragma mark - Reinforcement learning

/** Learn the grid policy using reinforcement learning
 
 Q = blah

 */

- (void)reinforcementLearning {
	// agent is initially in start state
	GridCell cell = mGrid.startCell();
	
	// performs 1 trial, a trial ends when the agent reaches a terminal state
	// t is incremented after each step and does NOT reset after a trial completes
	while (cell.type() != GridCellType::GridCellTypeTerminal) {
		Direction intendedAction = [self qLearningAgent];
		
		// next state
		cell = [self nextStateForIntendedAction:intendedAction currentState:cell];
		
		mT++;
	}
}

- (Direction)qLearningAgent {
	return DirectionRight;
}

- (GridCell)nextStateForIntendedAction:(Direction)intendedAction currentState:(GridCell)currentState {
	int currentRow = currentState.coordinate().x;
	int currentCol = currentState.coordinate().y;
	
	GridCell nextState = currentState;
	
	Direction actualAction = (Direction)mBlackBox.actionForIntendedAction((BlackBoxDirection)intendedAction);
	
	if (actualAction == DirectionUp) {
		nextState = mGrid.gridCellForRowAndCol(currentRow-1, currentCol);
	}
	
	else if (actualAction == DirectionDown) {
		nextState = mGrid.gridCellForRowAndCol(currentRow+1, currentCol);
	}
	
	else if (actualAction == DirectionLeft) {
		nextState = mGrid.gridCellForRowAndCol(currentRow, currentCol-1);
	}
	
	else if (actualAction == DirectionRight) {
		nextState = mGrid.gridCellForRowAndCol(currentRow, currentCol+1);
	}
	
	if (nextState.type() == GridCellType::GridCellTypeWall) {
		nextState = currentState;
	}
	
	return nextState;
}

- (void)didFinish {
	if (self.reinforcementLearningCompletionBlock) {
		self.reinforcementLearningCompletionBlock(mGrid, mT);
	}
}

@end
