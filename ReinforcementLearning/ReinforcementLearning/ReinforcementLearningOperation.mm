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
	int mMaxFrequency;
	int mExplorationConstant;
	int mT;
	GridCell mTerminalCell;
}

- (id)initWithGrid:(Grid)grid t:(int)t discountFactor:(double)discountFactor maxFrequency:(int)maxFrequency explorationConstant:(int)explorationConstant blackBox:(BlackBox)blackBox {
	self = [super init];
	
	if (self) {
		mGrid = grid;
		mBlackBox = blackBox;
		mDiscountFactor = discountFactor;
		mMaxFrequency = maxFrequency;
		mExplorationConstant = explorationConstant;
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
 
 Q[s,a] = Q[s,a] + alpha*(N[s,a])*(r + discountFactor*max(Q[s',a') - Q[s,a]
 s, a, r <= s', argmax f(Q[s',a'], N[s',a']),r'
 
 */

- (void)reinforcementLearning {
	// agent is initially in start state
	GridCell cell = mGrid.agentCell();
	
	// performs 1 trial, a trial ends when the agent reaches a terminal state
	// t is incremented after each step and does NOT reset after a trial completes
	while (cell.type() != GridCellType::GridCellTypeTerminal) {
		// from the current state s, select an action a based on the exploration function
		int row = cell.coordinate().x;
		int col = cell.coordinate().y;
		
		// once you land on s', you discover the reward associated with that state
		double reward = cell.reward();
		
		Direction intendedAction = [self exploreFromRow:row col:col];
		
		// get the actual action returned from the transition model (encapsulated by the black box object) that the agent is unaware of
		Direction actualAction = [self actualActionForIntendedAction:intendedAction];
		
		// get the successor state s'
		cell = [self nextStateForActualAction:actualAction currentState:cell];
		
		// learning rate
		double alpha = [self learningRate];
		
		// perform the TD update
		double maxNextPossibleQValue = [self maxNextPossibleQValueFromRow:cell.coordinate().x col:cell.coordinate().y];
		int frequency = mGrid.frequencyForRowColAndDirection(row, col, (GridCellDirection)actualAction);
		
		// update q value
		double qValue = mGrid.qValueForRowColAndDirection(row, col, (GridCellDirection)actualAction);
		
		qValue += alpha*(reward + mDiscountFactor*maxNextPossibleQValue - qValue);
		mGrid.setQValueForRowColAndDirection(row, col, (GridCellDirection)actualAction, qValue);

		// update frequency
		frequency++;
		mGrid.setFrequencyForRowColAndDirection(row, col, (GridCellDirection)actualAction, frequency);
		
		mT++;
	}
	
	// set q value for terminal state (since no actions can be taken in the terminal state, the q value should be the same for all actions
	mTerminalCell = cell;
	double terminalStateReward = mTerminalCell.reward();
	double terminalQValue = terminalStateReward;
	mGrid.setQValueForRowColAndDirection(mTerminalCell.coordinate().x, mTerminalCell.coordinate().y, GridCellDirection::GridCellDirectionUp, terminalQValue);
	mGrid.setQValueForRowColAndDirection(mTerminalCell.coordinate().x, mTerminalCell.coordinate().y, GridCellDirection::GridCellDirectionDown, terminalQValue);
	mGrid.setQValueForRowColAndDirection(mTerminalCell.coordinate().x, mTerminalCell.coordinate().y, GridCellDirection::GridCellDirectionLeft, terminalQValue);
	mGrid.setQValueForRowColAndDirection(mTerminalCell.coordinate().x, mTerminalCell.coordinate().y, GridCellDirection::GridCellDirectionRight, terminalQValue);
}

- (Direction)exploreFromRow:(int)row col:(int)col {
	Direction directionToTryToExplore;
	Direction directionToExplore;
	double maxExplorationValue = -DBL_MAX;
	double explorationValue;
	
	// try up direction
	directionToTryToExplore = DirectionUp;
	explorationValue = [self explorationValueForRow:row col:col direction:directionToTryToExplore];
	
	maxExplorationValue = explorationValue;
	directionToExplore = directionToTryToExplore;
	
	// try down direction
	directionToTryToExplore = DirectionDown;
	explorationValue = [self explorationValueForRow:row col:col direction:directionToTryToExplore];
	
	if (explorationValue > maxExplorationValue) {
		maxExplorationValue = explorationValue;
		directionToExplore = directionToTryToExplore;
	}
	
	// try left direction
	directionToTryToExplore = DirectionLeft;
	explorationValue = [self explorationValueForRow:row col:col direction:directionToTryToExplore];
	
	if (explorationValue > maxExplorationValue) {
		maxExplorationValue = explorationValue;
		directionToExplore = directionToTryToExplore;
	}
	
	// try right direction
	directionToTryToExplore = DirectionRight;
	explorationValue = [self explorationValueForRow:row col:col direction:directionToTryToExplore];
	
	if (explorationValue > maxExplorationValue) {
		maxExplorationValue = explorationValue;
		directionToExplore = directionToTryToExplore;
	}
	
	return directionToExplore;
}

- (double)explorationValueForRow:(int)row col:(int)col direction:(Direction)direction {
	// using exploration function: f(u,n) = u + k/N
	// k is some fixed constant
	// where N is the number of times taken action a from s
	
	double explorationValue;
	
	int numberOfTimesTakenActionAFromS = mGrid.frequencyForRowColAndDirection(row, col, (GridCellDirection)direction);
	
	explorationValue = mGrid.qValueForRowColAndDirection(row, col, (GridCellDirection)direction);
	 
	if (numberOfTimesTakenActionAFromS > 0 && numberOfTimesTakenActionAFromS <= mMaxFrequency) {
		explorationValue += (double)mExplorationConstant/(double)numberOfTimesTakenActionAFromS;
	}
	
	return explorationValue;
}

- (double)learningRate {
	double alpha = 60.0/(59.0 + mT);
	
	return alpha;
}
				
- (Direction)actualActionForIntendedAction:(Direction)intendedAction {
	Direction actualAction = (Direction)mBlackBox.actionForIntendedAction((BlackBoxDirection)intendedAction);
	
	return actualAction;
}

- (GridCell)nextStateForActualAction:(Direction)actualAction currentState:(GridCell)currentState {
	int currentRow = currentState.coordinate().x;
	int currentCol = currentState.coordinate().y;
	
	GridCell nextState = currentState;
	
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

- (double)maxNextPossibleQValueFromRow:(int)row col:(int)col {
	double maxNextPossibleQValue = -DBL_MAX;
	double nextPossibleQValue;
	
	// try up
	Direction directionToTry = DirectionUp;
	nextPossibleQValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection(directionToTry));
	maxNextPossibleQValue = nextPossibleQValue;
	
	// try down
	directionToTry = DirectionDown;
	nextPossibleQValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection(directionToTry));
	
	if (nextPossibleQValue > maxNextPossibleQValue) {
		maxNextPossibleQValue = nextPossibleQValue;
	}
	
	// try left
	directionToTry = DirectionLeft;
	nextPossibleQValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection(directionToTry));
	
	if (nextPossibleQValue > maxNextPossibleQValue) {
		maxNextPossibleQValue = nextPossibleQValue;
	}
	
	// try right
	directionToTry = DirectionRight;
	nextPossibleQValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection(directionToTry));
	
	if (nextPossibleQValue > maxNextPossibleQValue) {
		maxNextPossibleQValue = nextPossibleQValue;
	}
	
	return maxNextPossibleQValue;
}

- (void)didFinish {
	if (self.reinforcementLearningCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.reinforcementLearningCompletionBlock(mGrid, mT);
		});
	}
}

@end
