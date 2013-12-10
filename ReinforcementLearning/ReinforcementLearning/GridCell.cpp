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
	// terminal states should always have reward as the utility, all other states start out with 0 as the utility
	mUtility = defaultUtilityForTypeWithReward(type, reward);
}

GridCell::~GridCell() {};

GridCellType GridCell::type() {
	return mType;
}

Coordinate GridCell::coordinate() {
	return mCoordinate;
}

double GridCell::reward() {
	return mReward;
}

double GridCell::utility() {
	return mUtility;
}

void GridCell::setUtility(double utility) {
	mUtility = utility;
}

void GridCell::resetUtility() {
	mUtility = defaultUtilityForTypeWithReward(type(), reward());
}

void GridCell::print() {
	string gridCellType;
	
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
	
	cout << "--- grid cell ---" << endl;
	cout << "type: " << gridCellType << endl;
	cout << "coordinate: (" << coordinate().x  << ", " << coordinate().y << ")" << endl;
	cout << "reward: " << reward() << endl;
	cout << "utility: " << utility() << endl;
	cout << "---" << endl;
}

#pragma mark - Private

double GridCell::defaultUtilityForTypeWithReward(GridCellType type, double reward) {
	double utility = 0;
	
	if (type == GridCellType::GridCellTypeTerminal) {
		utility = reward;
	}
	
	return utility;
}
