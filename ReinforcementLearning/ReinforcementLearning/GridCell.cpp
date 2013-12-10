//
//  GridCell.cpp
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "GridCell.h"

GridCell::GridCell() {}

GridCell::GridCell(GridCellType type, Coordinate coordinate, double reward):mType(type), mCoordinate(coordinate), mReward(reward) {
	// initialize policy to up direction
	mPolicy = GridCellDirection::GridCellDirectionUp;
};

GridCell::~GridCell() {};

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
	cout << "policy: " << policyDirection << endl;
	cout << "---" << endl;
}