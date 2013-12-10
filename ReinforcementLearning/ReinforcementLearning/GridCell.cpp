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
	mNumberOfQValues = NUMBER_OF_Q_VALUES;
	for (int i = 0; i < mNumberOfQValues; i++) {
		mQValues.push_back(0);
	}
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

double GridCell::reward() {
	return mReward;
}

double GridCell::qValueForGridCellDirection(GridCellDirection gridCellDirection) {
	int index = (int)gridCellDirection;
	
	return mQValues[index];
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
	cout << "---" << endl;
}