 //
//  GridViewController.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridViewController.h"
#import "ReinforcementLearningOperation.h"
#import "Grid.h"
#import "GridCell.h"
#import "GridView.h"
#import "GridCellView.h"
#import <vector>

using namespace std;

#define GRID_MAX_NUMBER_OF_TRIALS 10
#define GRID_MAX_FREQUENCY 1
#define GRID_EXPLORATION_CONSTANT 30
#define GRID_DISCOUNT_FACTOR .99
#define GRID_INTENDED_OUTCOME_PROBABILITIY .80
#define GRID_UNINTENDED_OUTCOME_PROBABILITIY .10
#define GRID_REINFORCEMENT_NAV_ITEM_TITLE @"Reinforcement Learning"
#define GRID_STEP_BUTTON_TITLE @"Step"
#define GRID_RESET_BUTTON_TITLE @"Reset"
#define GRID_GRID_FILE_NAME @"Assignment4GridWorld1"

@implementation GridViewController {
	Grid mGrid;
	BlackBox mBlackBox;
	int mT;
	GridView *_gridView;
	UIBarButtonItem *_stepButton;
	UIBarButtonItem *_resetButton;
	NSOperationQueue *_queue;
	NSUInteger _numberOfTrials;
}

- (id)init
{
    self = [super init];
	
    if (self) {
		mBlackBox = BlackBox(GRID_INTENDED_OUTCOME_PROBABILITIY, GRID_UNINTENDED_OUTCOME_PROBABILITIY);
        _queue = [[NSOperationQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
		_numberOfTrials = 0;
		mT = 0;
	}
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNav];
	mGrid = [self parseGrid];
	mGrid.sort();
	[self showGrid];
	[self showQValues];
	[self showPolicies];
}

#pragma mark - Navigation setup

- (void)setUpNav {
	[self.navigationItem setTitle:GRID_REINFORCEMENT_NAV_ITEM_TITLE];
	[self.navigationItem setRightBarButtonItems:@[self.stepButton, self.resetButton]];
}

#pragma mark - Show grid

- (void)showGrid {
	[self.view addSubview:self.gridView];
	[self.gridView addCellViews];
	
	[self.gridView setNeedsLayout];
}

#pragma mark - Show q values
	
- (void)showQValues {
	[_gridView showQValues];
}

- (void)showPolicies {
	[_gridView showPolicies];
}

#pragma mark - Parse grid

- (Grid)parseGrid {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:GRID_GRID_FILE_NAME ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
	NSError *error;
	NSDictionary *gridDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	if (gridDict) {
		NSNumber *numberOfRows = [gridDict objectForKey:@"numberOfRows"];
		NSNumber *numberOfCols = [gridDict objectForKey:@"numberOfCols"];
		
		NSArray *features = [gridDict objectForKey:@"features"];
		
		vector<GridCell> cells;
		
		int startStateRow = 0;
		int startStateCol = 0;
		
		for (NSDictionary *feature in features) {
			NSString *type = [feature objectForKey:@"type"];
			
			NSString *wall = @"Wall";
			NSString *nonTerminal = @"Nonterminal";
			NSString *start = @"Start";
			NSString *terminal = @"Terminal";
			
			vector<GridCell> newCells;
			
			GridCellType gridCellType;
			
			BOOL isStartState = NO;
			
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
				isStartState = YES;
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
				
				if (isStartState) {
					startStateRow = point.x;
					startStateCol = point.y;
				}
				
				GridCell newCell(gridCellType, point, reward);
				newCells.push_back(newCell);
			}
			
			for (auto it : newCells) {
				cells.push_back(it);
			}
		}
		
		return Grid(numberOfRows.intValue, numberOfCols.intValue, cells, startStateRow, startStateCol);
	}
	
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
		[av show];
		
		return Grid();
	}
}

#pragma mark - Step button

- (UIBarButtonItem *)stepButton {
	if (!_stepButton) {
		_stepButton = [[UIBarButtonItem alloc] initWithTitle:GRID_STEP_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(stepButtonTouched)];
	}
	
	return _stepButton;
}

#pragma mark - Step button touched

- (void)stepButtonTouched {
	NSLog(@"step button touched");
	
	[self reinforcementLearning];
}

#pragma mark - Reset button

- (UIBarButtonItem *)resetButton {
	if (!_resetButton) {
		_resetButton = [[UIBarButtonItem alloc] initWithTitle:GRID_RESET_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonTouched)];
	}
	
	return _resetButton;
}

#pragma mark - Reset button touched

- (void)resetButtonTouched {
	NSLog(@"reset button touched");
	
	// reset all q values (this will directly affect the utility values)
	
	[self showQValues];
	[self showPolicies];
}

#pragma mark - Reinforcement learning

- (void)reinforcementLearning {
	if (_numberOfTrials < GRID_MAX_NUMBER_OF_TRIALS) {
		int startRow = (rand()%mGrid.numberOfRows());
		int startCol = (rand()%mGrid.numberOfCols());
		
		GridCell startGridCell = mGrid.gridCellForRowAndCol(startRow, startCol);
		
		while (startGridCell.type() == GridCellType::GridCellTypeWall || startGridCell.type() == GridCellType::GridCellTypeTerminal) {
			startRow = (rand()%mGrid.numberOfRows());
			startCol = (rand()%mGrid.numberOfCols());
			
			startGridCell = mGrid.gridCellForRowAndCol(startRow, startCol);
		}
		
		mGrid.setAgentRowAndCol(startRow, startCol);
		
		ReinforcementLearningOperation *reinforcementLearningOperation = [[ReinforcementLearningOperation alloc] initWithGrid:mGrid t:mT discountFactor:GRID_DISCOUNT_FACTOR maxFrequency:GRID_MAX_FREQUENCY explorationConstant:GRID_EXPLORATION_CONSTANT blackBox:mBlackBox];
		
		reinforcementLearningOperation.reinforcementLearningCompletionBlock = ^(Grid grid, int t) {
			mGrid = grid;
			mT = t;
			
			_numberOfTrials++;
			
			if (_numberOfTrials == GRID_MAX_NUMBER_OF_TRIALS) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self showQValues];
					[self showPolicies];
				});
			}
			
			else {
				[self reinforcementLearning];
			}
		};
		
		[_queue addOperation:reinforcementLearningOperation];
	}
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

- (double)qValueForDirection:(Direction)direction atRow:(int)row col:(int)col {
	double qValue = mGrid.qValueForRowColAndDirection(row, col, (GridCellDirection)direction);
	
	return qValue;
}

- (BOOL)isDiscoveredForRow:(int)row col:(int)col {
	BOOL isDiscovered = NO;
	
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	bool cellIsDiscovered = cell.isDiscovered();
	
	if (cellIsDiscovered) {
		isDiscovered = YES;
	}
	
	return isDiscovered;
}

- (int)numberOfQValues {
	return mGrid.numberOfQValuesPerCell();
}

- (PolicyViewType)shownPolicyViewTypeForRow:(int)row col:(int)col {
	PolicyViewType maxPolicyViewType;
	double maxQValue = -DBL_MAX;
	double qValue = -DBL_MAX;
	
	qValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionUp);
	maxQValue = qValue;
	maxPolicyViewType = PolicyViewTypeUp;
	
	qValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionDown);
	
	if (qValue > maxQValue) {
		maxQValue = qValue;
		maxPolicyViewType = PolicyViewTypeDown;
	}
	
	qValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionLeft);
	
	if (qValue > maxQValue) {
		maxQValue = qValue;
		maxPolicyViewType = PolicyViewTypeLeft;
	}
	
	qValue = mGrid.qValueForRowColAndDirection(row, col, GridCellDirection::GridCellDirectionRight);
	
	if (qValue > maxQValue) {
		maxPolicyViewType = PolicyViewTypeRight;
	}
	
	return maxPolicyViewType;
}

- (CGPoint)agentCoordinate {
	GridCell agentCell = mGrid.agentCell();
	
	CGPoint agentCoordinate = CGPointMake(agentCell.coordinate().x, agentCell.coordinate().y);
	
	return agentCoordinate;
}

- (void)setQValueText:(NSString *)text forRow:(int)row col:(int)col direction:(Direction)direction {
	[self.gridView setQValueText:text forRow:row col:col direction:direction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

