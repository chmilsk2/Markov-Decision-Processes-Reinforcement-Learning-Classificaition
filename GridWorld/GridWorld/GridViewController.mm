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
				newCoordinates = coordinates;
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
					float newValue = ((NSNumber *)value).floatValue;
					
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

- (float)rewardForRow:(int)row col:(int)col {
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	return cell.reward();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
