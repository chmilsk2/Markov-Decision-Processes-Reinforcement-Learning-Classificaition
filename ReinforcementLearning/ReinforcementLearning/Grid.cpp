//
//  Grid.cpp
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Grid.h"

Grid::Grid() {
	mNumberOfCols = 0;
	mNumberOfRows = 0;
}

Grid::Grid(int numberOfRows, int numberOfCols, vector<GridCell> gridCells):mNumberOfRows(numberOfRows), mNumberOfCols(numberOfCols), mGridCells(gridCells) {};

Grid::~Grid() {};

int Grid::numberOfRows() {
	return mNumberOfRows;
}

int Grid::numberOfCols() {
	return mNumberOfCols;
}

GridCell & Grid::gridCellForRowAndCol(int row, int col) {
	return mGridCells[row*mNumberOfCols + col];
}

void Grid::sort() {
	vector<GridCell> sortedGridCells(mNumberOfRows*mNumberOfCols);
	
	for (auto it : mGridCells) {
		int row = it.coordinate().x;
		int col = it.coordinate().y;
		
		int offset = row*numberOfCols() + col;
		
		sortedGridCells[offset] = it;
	}
	
	mGridCells = sortedGridCells;
	
	print();
}

void Grid::print() {
	cout << "--- grid ---" << endl;
	cout << "number of rows: " << numberOfRows() << endl;
	cout << "number of cols: " << numberOfCols() << endl;
	
	for (auto it : mGridCells) {
		it.print();
	}
	
	cout << "---" << endl;
}