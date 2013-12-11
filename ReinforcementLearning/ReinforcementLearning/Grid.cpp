//
//  Grid.cpp
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Grid.h"
#include "float.h"

#define NUMBER_OF_Q_VALUES_PER_CELL 4

Grid::Grid() {
	mNumberOfCols = 0;
	mNumberOfRows = 0;
	mStartCellCol = 0;
	mStartCellRow = 0;
	mAgentCol = 0;
	mAgentRow = 0;
}

Grid::Grid(int numberOfRows, int numberOfCols, vector<GridCell> gridCells, int startStateRow, int startStateCol):mNumberOfRows(numberOfRows), mNumberOfCols(numberOfCols), mGridCells(gridCells), mStartCellRow(startStateRow), mStartCellCol(startStateCol) {
	mNumberOfQValues = NUMBER_OF_Q_VALUES_PER_CELL;
	mAgentRow = mStartCellRow;
	mAgentCol = mStartCellCol;
	
	for (int row = 0; row < numberOfRows; row++) {
		for (int col = 0; col < numberOfCols; col++) {
			for (int i = 0; i < NUMBER_OF_Q_VALUES_PER_CELL; i++) {
				GridCellDirection direction = GridCellDirection::GridCellDirectionUp;
				
				if (i == 1) {
					direction = GridCellDirection::GridCellDirectionDown;
				}
				
				else if (i == 2) {
					direction = GridCellDirection::GridCellDirectionLeft;
				}
				
				else if (i == 3) {
					direction = GridCellDirection::GridCellDirectionRight;
				}
				
				setQValueForRowColAndDirection(row, col, direction, 0);
				setFrequencyForRowColAndDirection(row, col, direction, 0);
			}
		}
	}
};

Grid::~Grid() {};

#pragma mark - Utilities

vector<double> Grid::utilities() {
	vector<double> utilities;
	
	for (int row = 1; row < numberOfRows() - 1; row++) {
		for (int col = 1; col < numberOfCols() - 1; col++) {
			double qValue = 0;
			double maxQValue = -DBL_MAX;
			
			for (int i = 0; i < NUMBER_OF_Q_VALUES_PER_CELL; i++) {
				if (i == 0) {
					qValue = qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionUp);
					
					if (qValue > maxQValue) {
						maxQValue = qValue;
					}
				}
				 
				else if (i == 1) {
					qValue = qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionDown);
					
					if (qValue > maxQValue) {
						maxQValue = qValue;
					}
				}
				
				else if (i == 2) {
					qValue = qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionLeft);
					
					if (qValue > maxQValue) {
						maxQValue = qValue;
					}
				}
				
				else if (i == 3) {
					qValue = qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionRight);
					
					if (qValue > maxQValue) {
						maxQValue = qValue;
					}
				}
			}
			
			utilities.push_back(maxQValue);
		}
	}
	
	return utilities;
}

int Grid::numberOfRows() {
	return mNumberOfRows;
}

int Grid::numberOfCols() {
	return mNumberOfCols;
}

GridCell & Grid::gridCellForRowAndCol(int row, int col) {
	return mGridCells[row*mNumberOfCols + col];
}

GridCell & Grid::startCell() {
	return mGridCells[mStartCellRow*mNumberOfCols + mStartCellCol];
}

void Grid::setStartCellRowAndCol(int row, int col) {
	mStartCellRow = row;
	mStartCellCol = col;
}

#pragma mark - Agent

GridCell & Grid::agentCell() {
	return mGridCells[mAgentRow*mNumberOfCols + mAgentCol];
}

void Grid::setAgentRowAndCol(int row, int col) {
	mAgentRow = row;
	mAgentCol = col;
}

#pragma mark - Q value map

double Grid::qValueForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection) {
	int offset = mapOffsetForRowColAndDirection(row, col, gridCellDirection);
	
	return mQValueMap[offset];
}

void Grid::setQValueForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection, double qValue) {
	int offset = mapOffsetForRowColAndDirection(row, col, gridCellDirection);
	
	mQValueMap[offset] = qValue;
}

#pragma mark - Frequency map

int Grid::frequencyForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection) {
	int offset = mapOffsetForRowColAndDirection(row, col, gridCellDirection);
	
	return mFrequencyMap[offset];
}

void Grid::setFrequencyForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection, int frequency) {
	int offset = mapOffsetForRowColAndDirection(row, col, gridCellDirection);
	
	mFrequencyMap[offset] = frequency;
}

#pragma mark - Number of q values per cell

int Grid::numberOfQValuesPerCell() {
	return mNumberOfQValues;
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

#pragma mark - Private

int Grid::mapOffsetForRowColAndDirection(int row, int col, GridCellDirection gridCellDirection) {
	int numberOfDirections = NUMBER_OF_Q_VALUES_PER_CELL;
	
	int offset = (row*numberOfCols() + col)*numberOfDirections + (int)gridCellDirection;
	
	return offset;
}

