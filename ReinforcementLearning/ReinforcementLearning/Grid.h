//
//  Grid.h
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __GridWorld__Grid__
#define __GridWorld__Grid__

#include <iostream>
#include <vector>
#include "GridCell.h"
#include <map>

using namespace std;

class Grid {
	int mNumberOfRows;
	int mNumberOfCols;
	vector<GridCell> mGridCells;
	int mStartCellRow;
	int mStartCellCol;
	map<int, int> mFrequencyMap;
	map<int, double> mQValueMap;
	int mNumberOfQValues;
	int mAgentRow;
	int mAgentCol;
	
public:
	Grid();
	Grid(int numberOfRows, int numberOfCols, vector<GridCell> gridCells, int startStateRow, int startStateCol);
	~Grid();
	
	// number of rows
	int numberOfRows();
	
	// number of cols
	int numberOfCols();
	
	// cell for row, col
	GridCell & gridCellForRowAndCol(int row, int col);
	
	// start cell
	GridCell & startCell();
	
	void setStartCellRowAndCol(int row, int col);
	
	// agent coordinate
	GridCell & agentCell();
	
	void setAgentRowAndCol(int row, int col);
	
	// q value map
	double qValueForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection);
	
	void setQValueForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection, double qValue);
	
	// frequency map
	int frequencyForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection);
	
	void setFrequencyForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection, int frequency);
	
	// number of q values per cell
	int numberOfQValuesPerCell();
	
	// sort in row major order
	void sort();
	
	// print
	void print();
	
private:
	int mapOffsetForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection);
};

#endif /* defined(__GridWorld__Grid__) */
