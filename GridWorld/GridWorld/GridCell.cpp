//
//  GridCell.cpp
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "GridCell.h"

GridCell::GridCell() {}

GridCell::GridCell(GridCellType type, Coordinate coordinate, double reward):mType(type), mCoordinate(coordinate), mReward(reward) {};

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