//
//  Grid.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __GridWorld__Grid__
#define __GridWorld__Grid__

#include <iostream>
#include <vector>
#include "GridCell.h"

using namespace std;

class Grid {
	int mNumberOfRows;
	int mNumberOfCols;
	vector<GridCell> mGridCells;
	
	public:
		Grid();
		Grid(int numberOfRows, int numberOfCols, vector<GridCell> gridCells);
		~Grid();
	
		// number of rows
		int numberOfRows();
	
		// number of cols
		int numberOfCols();
	
		// cell for row, col
		GridCell & gridCellForRowAndCol(int row, int col);
	
		// sort in row major order
		void sort();
	
		// print
		void print();
};

#endif /* defined(__GridWorld__Grid__) */
