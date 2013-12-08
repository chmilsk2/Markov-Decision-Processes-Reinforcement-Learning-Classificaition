//
//  GridViewController.m
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridViewController.h"
#import "Grid.h"
#import "GridCell.h"
#import <vector>

using namespace std;

#define GRID_WORLD_NAV_ITEM_TITLE @"Grid World"
#define GRID_WORLD_SOLVE_BUTTON_TITLE @"Solve"
#define GRID_WORLD_GRID_FILE_NAME @"Assignment4GridWorld1"

@implementation GridViewController {
	Grid mGrid;
	GridView *_gridView;
	UIBarButtonItem *_solveButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNav];
	mGrid = [self parseGrid];
	mGrid.sort();
	[self showGrid];
}

#pragma mark - Navigation setup

- (void)setUpNav {
	[self.navigationItem setTitle:GRID_WORLD_NAV_ITEM_TITLE];
	[self.navigationItem setRightBarButtonItem:self.solveButton];
}

#pragma mark - Show grid

- (void)showGrid {
	[self.view addSubview:self.gridView];
	[self.gridView addCellViews];
	
	[self.gridView setNeedsLayout];
}

#pragma mark - Parse grid

- (Grid)parseGrid {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:GRID_WORLD_GRID_FILE_NAME ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
	NSError *error;
	NSDictionary *gridDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	if (gridDict) {
		NSNumber *numberOfRows = [gridDict objectForKey:@"numberOfRows"];
		NSNumber *numberOfCols = [gridDict objectForKey:@"numberOfCols"];
		
		NSArray *features = [gridDict objectForKey:@"features"];
		
		vector<GridCell> cells;
		
		for (NSDictionary *feature in features) {
			NSString *type = [feature objectForKey:@"type"];
			
			NSString *wall = @"Wall";
			NSString *nonTerminal = @"Nonterminal";
			NSString *start = @"Start";
			NSString *terminal = @"Terminal";
				
			vector<GridCell> newCells;
					
			GridCellType gridCellType;
			
			id coordinates = [feature objectForKey:@"coordinates"];
			id coordinatesAndRewards = [feature objectForKey:@"coordinatesAndRewards"];
			
			id newCoordinates;
			
			if ([type isEqualToString:wall]) {
				gridCellType = GridCellType::GridCellTypeWall;
				newCoordinates = coordinates;
			}
			
			else if ([type isEqualToString:nonTerminal]) {
				gridCellType = GridCellType::GridCellTypeNonterminal;
				newCoordinates = coordinatesAndRewards;
			}
			
			else if ([type isEqualToString:start]) {
				gridCellType = GridCellType::GridCellTypeStart;
				newCoordinates = coordinatesAndRewards;
			}
			
			else if ([type isEqualToString:terminal]) {
				gridCellType = GridCellType::GridCellTypeTerminal;
				newCoordinates = coordinatesAndRewards;
			}
			
			for (id newCoordinate in newCoordinates) {
				NSUInteger index = 0;
				
				Coordinate point;
				double reward = 0;
				
				for (id value in newCoordinate) {
					double newValue = ((NSNumber *)value).doubleValue;
					
					if (index == 0) {
						point.x = newValue;
					}
					
					else if (index == 1) {
						point.y = newValue;
					}
					
					else if (index == 2) {
						reward = newValue;
					}
					
					index++;
				}
				
				GridCell newCell(gridCellType, point, reward);
				newCells.push_back(newCell);
			}
			
			for (auto it : newCells) {
				cells.push_back(it);
			}
		}
	
		return Grid(numberOfRows.intValue, numberOfCols.intValue, cells);
	}
	
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
		[av show];
		
		return Grid();
	}
}

#pragma mark - Solve button 

- (UIBarButtonItem *)solveButton {
	if (!_solveButton) {
		_solveButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_SOLVE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(solveButtonTouched)];
	}
	
	return _solveButton;
}

#pragma mark - Solve button touched

- (void)solveButtonTouched {
	NSLog(@"solve button touched");
	[self valueIteration];
}

#pragma mark - Value iteration

/** Determine the grid policy using value iteration
 
 uPrime(s) = reward(s) + discountFactor * max(P(s'|s,a)*uPrime(s'))
 
 @param intendedOutcomeProbability probability of heading in the intended direction: .8
 @param unintendedOutcomeProbability probability of heading in the unintended direction, right angle to intended direction in this case: .1
 @param discountFactor discount factor: .9
 @param u vector for utility of state in s, initialized to 0
 @param uPrime vector for utility of state s', initialized to 0
 */

- (void)valueIteration {
	int numberOfRows = mGrid.numberOfRows();
	int numberOfCols = mGrid.numberOfCols();
	
	int size = numberOfRows*numberOfCols;

	double intededOutcomeProbability = .8;
	double unintendedOutcomeProbability = .1;
	
	double discountFactor = .99;
	
	vector<double> u(size);
	
	// initialize u for terminal states, terminal states will always have the same utility values
	for (int row = 0; row < numberOfRows; row++) {
		for (int col = 0; col < numberOfCols; col++) {
			GridCell sCell = mGrid.gridCellForRowAndCol(row, col);
			
			GridCellType sType = sCell.type();
			
			if (sType == GridCellType::GridCellTypeTerminal) {
				int sOffset = row*numberOfCols + col;
				
				u[sOffset] = sCell.reward();
			}
		}
	}
	
	for (int i = 0; i < 50; i++) {
		for (int row = 0; row < numberOfRows; row++) {
			for (int col = 0; col < numberOfCols; col++) {
				// if a wall or terminal state, then skip
				GridCell sCell = mGrid.gridCellForRowAndCol(row, col);
				
				GridCellType sType = sCell.type();
				
				if (sType != GridCellType::GridCellTypeWall && sType != GridCellType::GridCellTypeTerminal) {
					// reward of current state s
					double reward = mGrid.gridCellForRowAndCol(row, col).reward();
					
					int sOffset = row*numberOfCols + col;
					
					// compute utilities
					double upUtility = [self utilityUsingU:u forToRow:row-1 toCol:col fromRow:row fromCol:col];
					double downUtility = [self utilityUsingU:u forToRow:row+1 toCol:col fromRow:row fromCol:col];
					double leftUtility = [self utilityUsingU:u forToRow:row toCol:col-1 fromRow:row fromCol:col];
					double rightUtility = [self utilityUsingU:u forToRow:row toCol:col+1 fromRow:row fromCol:col];
					
					double maxValue = [self maxValueUsingU:u upUtility:upUtility downUtility:downUtility leftUtility:leftUtility rightUtility:rightUtility intendedOutcomeProbability:intededOutcomeProbability unintendedOutcomeProbability:unintendedOutcomeProbability];
					
					u[sOffset] = reward + discountFactor*maxValue;
					
					[_gridView setUtilityLabelText:[NSString stringWithFormat:@"%f", u[sOffset]] forGridCellAtRow:row col:col];
				}
			}
		}
	}
}

#pragma mark - Utilities

- (double)utilityUsingU:(vector<double> &)u forToRow:(int)toRow toCol:(int)toCol fromRow:(int)fromRow fromCol:(int)fromCol {
	// figure out the action that maximizes the utility to s'
	int numberOfCols = mGrid.numberOfCols();
	int sOffset = fromRow*numberOfCols + fromCol;
	
	GridCell sPrimeCell = mGrid.gridCellForRowAndCol(toRow, toCol);
	int sPrimeOffset = toRow*numberOfCols + toCol;
	
	// compute utilities
	double utility = u[sPrimeOffset];
	
	// if s' is a wall, then s' = s
	if (sPrimeCell.type() == GridCellType::GridCellTypeWall) {
		utility = u[sOffset];
	}
	
	return utility;
}

#pragma mark - Max Value

- (double)maxValueUsingU:(vector<double> &)u upUtility:(double)upUtility downUtility:(double)downUtility leftUtility:(double)leftUtility rightUtility:(double)rightUtility intendedOutcomeProbability:(double)intendedOutcomeProbability unintendedOutcomeProbability:(double)unintendedOutcomeProbability {
	// maximize the utility
	double maxValue = -DBL_MAX;
	
	// try going up
	double upValue = intendedOutcomeProbability*upUtility + unintendedOutcomeProbability*leftUtility + unintendedOutcomeProbability*rightUtility;
	
	if (upValue > maxValue) {
		maxValue = upValue;
	}
	
	// try going down
	double downValue = intendedOutcomeProbability*downUtility + unintendedOutcomeProbability*leftUtility
	+ unintendedOutcomeProbability*rightUtility;
	
	if (downValue > maxValue) {
		maxValue = downValue;
	}
	
	// try going left
	double leftValue = intendedOutcomeProbability*leftUtility + unintendedOutcomeProbability*upUtility + unintendedOutcomeProbability*rightUtility;
	
	if (leftValue > maxValue) {
		maxValue = leftValue;
	}
	
	// try going right
	double rightValue = intendedOutcomeProbability*rightUtility + unintendedOutcomeProbability*upUtility
	+ unintendedOutcomeProbability*downUtility;
	
	if (rightValue > maxValue) {
		maxValue = rightValue;
	}
	
	return maxValue;
}

#pragma mark - Grid view

- (GridView *)gridView {
	if (!_gridView) {
		_gridView = [[GridView alloc] initWithFrame:CGRectZero];
		[_gridView setDelegate:self];
	}
	
	return _gridView;
}

#pragma mark - Grid view delegate

- (CGFloat)screenWidth {
	return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
	return [UIScreen mainScreen].bounds.size.height;
}

- (NSUInteger)numberOfGridRows {
	return mGrid.numberOfRows();
}

- (NSUInteger)numberOfGridCols {
	return mGrid.numberOfCols();
}

- (GridCellViewType)gridCellViewTypeForRow:(int)row col:(int)col {	
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	GridCellViewType gridCellViewType = GridCellViewTypeWall;
	
	if (cell.type() == GridCellType::GridCellTypeWall) {
		gridCellViewType = GridCellViewTypeWall;
	}
	
	else if (cell.type() == GridCellType::GridCellTypeNonterminal) {
		gridCellViewType = GridCellViewTypeNonterminal;
	}
	
	else if (cell.type() == GridCellType::GridCellTypeStart) {
		gridCellViewType = GridCellViewTypeStart;
	}
	
	else if (cell.type() == GridCellType::GridCellTypeTerminal) {
		gridCellViewType = GridCellViewTypeTerminal;
	}
	
	return gridCellViewType;
}

- (double)rewardForRow:(int)row col:(int)col {
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	return cell.reward();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
