//
//  GridCell.cpp
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "GridCell.h"

#define NUMBER_OF_Q_VALUES 4

GridCell::GridCell() {}

GridCell::GridCell(GridCellType type, Coordinate coordinate, double reward):mType(type), mCoordinate(coordinate), mReward(reward) {
	// number of q values - this is the same for every cell
	mNumberOfQValues = NUMBER_OF_Q_VALUES;
	
	// initialize q values to 0
	for (int i = 0; i < mNumberOfQValues; i++) {
		mQValues.push_back(0);
	}
	
	// initialize frequency to 0
	mFrequency = 0;
	
	// initialize policy to up direction
	mPolicy = GridCellDirection::GridCellDirectionUp;
};

GridCell::~GridCell() {};

int GridCell::numberOfQValues() {
	return mNumberOfQValues;
}

GridCellType GridCell::type() {
	return mType;
}

Coordinate GridCell::coordinate() {
	return mCoordinate;
}

#pragma mark - Reward

double GridCell::reward() {
	return mReward;
}

#pragma mark - Frequency

int GridCell::frequency() {
	return mFrequency;
}

void GridCell::incrementFrequency() {
	mFrequency++;
}

#pragma mark - Q value

double GridCell::qValueForGridCellDirection(GridCellDirection gridCellDirection) {
	int index = (int)gridCellDirection;
	
	return mQValues[index];
}

void GridCell::print() {
	string gridCellType;
	string policyDirection;
	
	// cell type
	if (type() == GridCellType::GridCellTypeWall) {
		gridCellType = "Wall";
	}
	
	else if (type() == GridCellType::GridCellTypeNonterminal) {
		gridCellType = "Nonterminal";
	}
	
	else if (type() == GridCellType::GridCellTypeStart) {
		gridCellType = "Start";
	}
	
	else if (type() == GridCellType::GridCellTypeTerminal) {
		gridCellType = "Terminal";
	}
	
	// policy direction
	if (mPolicy == GridCellDirection::GridCellDirectionUp) {
		policyDirection = "Up";
	}
	
	else if (mPolicy == GridCellDirection::GridCellDirectionDown) {
		policyDirection = "Down";
	}
	
	else if (mPolicy == GridCellDirection::GridCellDirectionLeft) {
		policyDirection = "Left";
	}
	
	else if (mPolicy == GridCellDirection::GridCellDirectionRight) {
		policyDirection = "Right";
	}
	
	cout << "--- grid cell ---" << endl;
	cout << "type: " << gridCellType << endl;
	cout << "coordinate: (" << coordinate().x  << ", " << coordinate().y << ")" << endl;
	cout << "reward: " << reward() << endl;
	cout << "frequency: " << frequency() << endl;
	cout << "up Q value: " << mQValues[(int)GridCellDirection::GridCellDirectionUp] << endl;
	cout << "down Q value: " << mQValues[(int)GridCellDirection::GridCellDirectionDown] << endl;
	cout << "leftQ value: " << mQValues[(int)GridCellDirection::GridCellDirectionLeft] << endl;
	cout << "right Q value: " << mQValues[(int)GridCellDirection::GridCellDirectionRight] << endl;
	cout << "policy: " << policyDirection << endl;
	cout << "---" << endl;
}