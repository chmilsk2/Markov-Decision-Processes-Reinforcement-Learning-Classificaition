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
	GridCellDirectionUp,
	GridCellDirectionDown,
	GridCellDirectionLeft,
	GridCellDirectionRight
};

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
	int mNumberOfQValues;
	GridCellType mType;
	Coordinate mCoordinate;
	vector<double> mQValues;
	int mFrequency;
	double mReward;
	GridCellDirection mPolicy;
	
	
public:
	GridCell();
	GridCell(GridCellType type, Coordinate coordinate, double reward);
	~GridCell();
	
	// number of q values
	int numberOfQValues();
	
	// type
	GridCellType type();
	
	// coordinate
	Coordinate coordinate();
	
	// reward
	double reward();
	
	// frequency
	int frequency();
	
	// increment frequency
	void incrementFrequency();
	
	// q value
	double qValueForGridCellDirection(GridCellDirection gridCellDirection);
	
	// policy
	GridCellDirection policy();
	
	// print
	void print();
};

#endif /* defined(__GridWorld__GridCell__) */
