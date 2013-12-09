//
//  MenuButtonViewController.m
//  GridWorld
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "MenuButtonViewController.h"

// nav bar
#define GRID_WORLD_MENU_NAV_ITEM_TITLE @"Menu"
#define GRID_WORLD_MENU_DONE_BUTTON_TITLE @"Done"

// table
#define NUMBER_OF_SECTIONS 1
#define SECTION_HEIGHT 40.0f
#define ROW_HEIGHT 60.0f
#define ALGORITHM_TYPE_SECTION_TITLE @"Algorithm Type"
#define ALGORITHM_TYPE_VALUE_ITERATION_NAME @"Value Iteration"
#define ALGORITHM_TYPE_REINFORCEMENT_LEARNING_NAME @"Reinforcement Learning"

// table view cell
#define ALGORITHM_TYPE_CELL_IDENTIFIER @"AlgorithmTypeCellIdentifier"

@implementation MenuButtonViewController {
	NSArray *_selections;
	NSUInteger _selectedAlgorithmType;
	UIBarButtonItem *_doneButton;
}

- (id)init
{
    self = [super init];
	
    if (self) {
        _selections = @[@(AlgorithmTypeValueIteration), @(AlgorithmTypeReinforceMentLearning)];
		_selectedAlgorithmType = AlgorithmTypeValueIteration;
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpTable];
	[self setUpNav];
}

#pragma mark - Set up Table

- (void)setUpTable {
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ALGORITHM_TYPE_CELL_IDENTIFIER];
}

#pragma mark - Set up nav

- (void)setUpNav {
	[self.navigationItem setTitle:GRID_WORLD_MENU_NAV_ITEM_TITLE];
	[self.navigationItem setRightBarButtonItem:self.doneButton];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return NUMBER_OF_SECTIONS;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_selections count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ROW_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return ALGORITHM_TYPE_SECTION_TITLE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	// hide remaining visible empty cells
	return .01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ALGORITHM_TYPE_CELL_IDENTIFIER forIndexPath:indexPath];
	
	NSString *algorithmName;
	
	if (!indexPath.row) {
		algorithmName = ALGORITHM_TYPE_VALUE_ITERATION_NAME;
		
		if (_selectedAlgorithmType == AlgorithmTypeValueIteration) {
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		
		else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	
	else {
		algorithmName = ALGORITHM_TYPE_REINFORCEMENT_LEARNING_NAME;
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		if (_selectedAlgorithmType == AlgorithmTypeReinforceMentLearning) {
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		
		else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	
	[cell.textLabel setText:algorithmName];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!indexPath.row) {
		_selectedAlgorithmType = AlgorithmTypeValueIteration;
	}
	
	else {
		_selectedAlgorithmType = AlgorithmTypeReinforceMentLearning;
	}
	
	[self.tableView reloadData];
}

#pragma mark - Done button

- (UIBarButtonItem *)doneButton {
	if (!_doneButton) {
		_doneButton = [[UIBarButtonItem alloc] initWithTitle:GRID_WORLD_MENU_DONE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTouched)];
	}
	
	return _doneButton;
}

#pragma mark - Done button touched

- (void)doneButtonTouched {
	NSLog(@"done button touched");
	
	if ([self.delegate respondsToSelector:@selector(didSelectAlgorithmType:)]) {
		[self.delegate didSelectAlgorithmType:_selectedAlgorithmType];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
