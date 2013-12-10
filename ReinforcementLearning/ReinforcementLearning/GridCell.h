//
//  GridCell.h
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __GridWorld__GridCell__
#define __GridWorld__GridCell__

#include <iostream>
#include <vector>

using namespace std;

enum class GridCellDirection {
	GridCellDirectionUp = 0,
	GridCellDirectionDown = 1,
	GridCellDirectionLeft = 2,
	GridCellDirectionRight = 3
};

enum class GridCellType {
	GridCellTypeWall = 0,
	GridCellTypeNonterminal = 1,
	GridCellTypeStart = 2,
	GridCellTypeTerminal = 3
};

typedef struct {
	double x;
	double y;
} Coordinate;

class GridCell {
	GridCellType mType;
	Coordinate mCoordinate;
	double mReward;
	GridCellDirection mPolicy;
	
public:
	GridCell();
	GridCell(GridCellType type, Coordinate coordinate, double reward);
	~GridCell();
	
	// type
	GridCellType type();
	
	// coordinate
	Coordinate coordinate();
	
	// reward
	double reward();

	// policy
	GridCellDirection policy();
	
	// print
	void print();
};

#endif /* defined(__GridWorld__GridCell__) */
