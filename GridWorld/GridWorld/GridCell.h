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
	double x;
	double y;
} Coordinate;

class GridCell {
	GridCellType mType;
	Coordinate mCoordinate;
	double mReward;
	double mUtility;
	
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
	
		// utility
		double utility();
	
		void setUtility(double utility);
	
		void resetUtility();
	
		// print
		void print();
	
	private:
		double defaultUtilityForTypeWithReward(GridCellType type, double reward);
};

#endif /* defined(__GridWorld__GridCell__) */
