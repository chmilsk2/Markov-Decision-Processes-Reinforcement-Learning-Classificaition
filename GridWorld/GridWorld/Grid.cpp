//
//  Grid.cpp
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
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

void Grid::setUtilityForRowAndCol(int row, int col, double utility) {
	gridCellForRowAndCol(row, col).setUtility(utility);
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

void Grid::resetUtilities() {
	for (int row = 0; row < numberOfRows(); row++) {
		for (int col = 0 ; col < numberOfCols(); col++) {
			gridCellForRowAndCol(row, col).resetUtility();
		}
	}
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