//
//  GridViewController.m
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridViewController.h"
#import "ValueIterationOperation.h"
#import "Grid.h"
#import "GridCell.h"
#import "GridView.h"
#import "GridCellView.h"
#import <vector>

using namespace std;

#define GRID_WORLD_DISCOUNT_FACTOR .99
#define GRID_WORLD_INTENDED_OUTCOME_PROBABILITIY .80
#define GRID_WORLD_UNINTENDED_OUTCOME_PROBABILITIY .10
#define GRID_WORLD_VALUE_ITERATION_NAV_ITEM_TITLE @"Value Iteration"
#define GRID_WORLD_REINFORCEMENT_LEARNING_NAV_ITEM_TITLE @"Reinforcement Learning"
#define GRID_WORLD_MENU_BUTTON_TITLE @"Menu"
#define GRID_WORLD_CONTINUE_BUTTON_TITLE @"Continue"
#define GRID_WORLD_AGENT_BUTTON_TITLE @"Agent"
#define GRID_WORLD_STEP_BUTTON_TITLE @"Step"
#define GRID_WORLD_RESET_BUTTON_TITLE @"Reset"
#define GRID_WORLD_GRID_FILE_NAME @"Assignment4GridWorld1"

@implementation GridViewController {
	Grid mGrid;
	GridView *_gridView;
	UIBarButtonItem *_menuButton;
	UIBarButtonItem *_agentButton;
	UIBarButtonItem *_stepButton;
	UIBarButtonItem *_continueButton;
	UIBarButtonItem *_resetButton;
	NSOperationQueue *_queue;
}

- (id)init
{
    self = [super init];
	
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
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
	[self showUtilities];
	[self showPolicies];
}

#pragma mark - Navigation setup

- (void)setUpNav {
	[self.navigationItem setTitle:GRID_WORLD_VALUE_ITERATION_NAV_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.menuButton];
	[self.navigationItem setRightBarButtonItems:@[self.stepButton, self.continueButton, self.agentButton, self.resetButton]];
}

#pragma mark - Show grid

- (void)showGrid {
	[self.view addSubview:self.gridView];
	[self.gridView addCellViews];
	
	[self.gridView setNeedsLayout];
}

#pragma mark - Show utilities

- (void)showUtilities {
	for (int row = 0; row < mGrid.numberOfRows(); row++) {
		for (int col = 0; col < mGrid.numberOfCols(); col++) {
			GridCell cell = mGrid.gridCellForRowAndCol(row, col);
			
			if (cell.type() != GridCellType::GridCellTypeWall) {
				[_gridView setUtilityLabelText:[NSString stringWithFormat:@"%f", cell.utility()] forGridCellAtRow:row col:col];
			}
		}
	}
}

- (void)showPolicies {
	for (int row = 0; row < mGrid.numberOfRows(); row++) {
		for (int col = 0; col < mGrid.numberOfCols(); col++) {
			GridCell cell = mGrid.gridCellForRowAndCol(row, col);
			
			[_gridView showPolicies];
		}
	}
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

#pragma mark - Menu button

- (UIBarButtonItem *)menuButton {
	if (!_menuButton) {
		_menuButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_MENU_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouched)];
	}
	
	return _menuButton;
}

#pragma mark - Menu button touched

- (void)menuButtonTouched {
	NSLog(@"menu button touched");
	
	MenuButtonViewController *menuButtonViewController = [[MenuButtonViewController alloc] init];
	[menuButtonViewController setDelegate:self];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuButtonViewController];
	
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Continue button

- (UIBarButtonItem *)continueButton {
	if (!_continueButton) {
		_continueButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_CONTINUE_BUTTON_TITLE
														   style:UIBarButtonItemStylePlain
														  target:self
														  action:@selector(continueButtonTouched)];
	}
	
	return _continueButton;
}

#pragma mark - Continue button touched

- (void)continueButtonTouched {
	NSLog(@"continue button touched");
}

#pragma mark - Agent button

- (UIBarButtonItem *)agentButton {
	if (!_agentButton) {
		_agentButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_AGENT_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(agentButtonTouched)];
	}
	
	return _agentButton;
}

#pragma mark - Agent button touched

- (void)agentButtonTouched {
	NSLog(@"agent button touched");
}

#pragma mark - Step button

- (UIBarButtonItem *)stepButton {
	if (!_stepButton) {
		_stepButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_STEP_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(stepButtonTouched)];
	}
	
	return _stepButton;
}

#pragma mark - Step button touched

- (void)stepButtonTouched {
	NSLog(@"step button touched");
	
	[self valueIteration];
}

#pragma mark - Reset button

- (UIBarButtonItem *)resetButton {
	if (!_resetButton) {
		_resetButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_RESET_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonTouched)];
	}
	
	return _resetButton;
}

#pragma mark - Reset button touched

- (void)resetButtonTouched {
	NSLog(@"reset button touched");
	
	mGrid.resetUtilities();
	
	[self showUtilities];
	[self showPolicies];
}

#pragma mark - Value iteration

- (void)valueIteration {
	ValueIterationOperation *valueIterationOperation = [[ValueIterationOperation alloc] initWithGrid:mGrid discountFactor:GRID_WORLD_DISCOUNT_FACTOR intendedOutcomeProbabilitiy:GRID_WORLD_INTENDED_OUTCOME_PROBABILITIY unIntendedOutcomeProbabilitiy:GRID_WORLD_UNINTENDED_OUTCOME_PROBABILITIY];
	
	valueIterationOperation.valueIterationCompletionBlock = ^(NSArray *utilities, Grid grid){
		mGrid = grid;
		
		[self showUtilities];
		[self showPolicies];
	};
	
	[_queue addOperation:valueIterationOperation];
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

- (PolicyViewType)shownPolicyViewTypeForRow:(int)row col:(int)col {
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	GridCell upCell = mGrid.gridCellForRowAndCol(row-1, col);
	GridCell downCell = mGrid.gridCellForRowAndCol(row+1, col);
	GridCell leftCell = mGrid.gridCellForRowAndCol(row, col-1);
	GridCell rightCell = mGrid.gridCellForRowAndCol(row, col+1);
	
	PolicyViewType maxPolicyViewType;
	double maxCellUtility = cell.utility();
	
	if (upCell.type() != GridCellType::GridCellTypeWall && upCell.utility() >= maxCellUtility) {
		maxPolicyViewType = PolicyViewTypeUp;
		maxCellUtility = upCell.utility();
	}
	
	if (downCell.type() != GridCellType::GridCellTypeWall && downCell.utility() >= maxCellUtility) {
		maxPolicyViewType = PolicyViewTypeDown;
		maxCellUtility = downCell.utility();
	}
	
	if (leftCell.type() != GridCellType::GridCellTypeWall && leftCell.utility() >= maxCellUtility) {
		maxPolicyViewType = PolicyViewTypeLeft;
		maxCellUtility = leftCell.utility();
	}
	
	if (rightCell.type() != GridCellType::GridCellTypeWall && rightCell.utility() >= maxCellUtility) {
		maxPolicyViewType = PolicyViewTypeRight;
		maxCellUtility = rightCell.utility();
	}
	
	// by default, show all initial policies pointing up
	if (maxCellUtility == 0 || (cell.utility() == 0 && (upCell.type() == GridCellType::GridCellTypeTerminal || downCell.type() == GridCellType::GridCellTypeTerminal ||
		leftCell.type() == GridCellType::GridCellTypeTerminal || rightCell.type() == GridCellType::GridCellTypeTerminal))) {
		maxPolicyViewType = PolicyViewTypeUp;
	}
	
	return maxPolicyViewType;
}

- (double)rewardForRow:(int)row col:(int)col {
	GridCell cell = mGrid.gridCellForRowAndCol(row, col);
	
	return cell.reward();
}

#pragma mark - Menu delegate 

- (void)didSelectAlgorithmType:(AlgorithmType)algorithmType {
	NSLog(@"did select algorithm type %lu", algorithmType);
	
	NSString *title;
	
	if (algorithmType == AlgorithmTypeValueIteration) {
		title = GRID_WORLD_VALUE_ITERATION_NAV_ITEM_TITLE;
	}
	
	else {
		title = GRID_WORLD_REINFORCEMENT_LEARNING_NAV_ITEM_TITLE;
	}
	
	[self.navigationItem setTitle:title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
