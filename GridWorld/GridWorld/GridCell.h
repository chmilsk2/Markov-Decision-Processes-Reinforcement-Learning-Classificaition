//
//  GridCell.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __GridWorld__GridCell__
#define __GridWorld__GridCell__

#include <iostream>

using namespace std;

enum class GridCellType {
	GridCellTypeWall,
	GridCellTypeNonterminal,
	GridCellTypeStart,
	GridCellTypeTerminal
};

typedef struct {
	float x;
	float y;
} Coordinate;

class GridCell {
	GridCellType mType;
	Coordinate mCoordinate;
	float mReward;
	
	public:
		GridCell();
		GridCell(GridCellType type, Coordinate coordinate, double reward);
		~GridCell();
	
		// type
		GridCellType type();
	
		// coordinate
		Coordinate coordinate();
	
		// reward
		float reward();
	
		// print
		void print();
};

#endif /* defined(__GridWorld__GridCell__) */
