//
//  GridView.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridView.h"

#define GRID_WORLD_HORIZONATAL_MARGIN_LOWER_BOUND 60

@implementation GridView {
	NSArray *_gridCellViews;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setBackgroundColor:[UIColor lightGrayColor]];
	}
	
	return self;
}

- (void)addCellViews {
	NSUInteger numberOfRows = 0;
	NSUInteger numberOfCols = 0;
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridRows)]) {
		numberOfRows = [self.delegate numberOfGridRows];
	}
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridCols)]) {
		numberOfCols = [self.delegate numberOfGridCols];
	}
	
	NSMutableArray *gridCellViews = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < numberOfRows*numberOfCols; i++) {
		[gridCellViews addObject:[NSNull null]];
	}
	
	for (NSUInteger col = 0; col < numberOfCols; col++) {
		for (NSUInteger row = 0; row < numberOfRows; row++) {
			GridCellViewType cellViewType = GridCellViewTypeWall;
			
			NSString *text;
			
			double reward = 0;
			
			if ([self.delegate respondsToSelector:@selector(rewardForRow:col:)]) {
				reward = [self.delegate rewardForRow:(int)row col:(int)col];
			}
			
			if ([self.delegate respondsToSelector:@selector(gridCellViewTypeForRow:col:)]) {
				cellViewType = [self.delegate gridCellViewTypeForRow:(int)row col:(int)col];
			}
			
			UIColor *cellColor;
			
			if (cellViewType == GridCellViewTypeWall) {
				cellColor = [UIColor colorWithWhite:0.7 alpha:1.0];
			}
			
			else if (cellViewType == GridCellViewTypeNonterminal) {
				cellColor = [UIColor colorWithWhite:0.9 alpha:1.0];
			}
			
			else if (cellViewType == GridCellViewTypeStart) {
				cellColor = [UIColor colorWithWhite:0.8 alpha:1.0];
			}
			
			else if (cellViewType == GridCellViewTypeTerminal) {
				if (reward > 0) {
					cellColor = [UIColor colorWithRed:80.0/255.0 green:238/255.0 blue:60.0/255.0 alpha:1.0];
				}
				
				else {
					cellColor = [UIColor colorWithRed:254.0/255.0 green:130.0/255.0 blue:16.0/255.0 alpha:1.0];
				}
				
				text = [NSString stringWithFormat:@"%.2f", reward];
			}
			
			GridCellView *gridCellView = [[GridCellView alloc] initWithFrame:CGRectZero color:cellColor];
		
			// show center label if start or terminal cells
			if ((cellViewType == GridCellViewTypeTerminal || cellViewType == GridCellViewTypeStart)) {
				if (cellViewType == GridCellViewTypeTerminal) {
					BOOL isDiscovered = NO;
					
					if ([self.delegate respondsToSelector:@selector(isDiscoveredForRow:col:)]) {
						isDiscovered = [self.delegate isDiscoveredForRow:(int)row col:(int)col];
					}
					
					if (!isDiscovered) {
						double reward = 0;
						text = [NSString stringWithFormat:@"%.2f", reward];
					}
					
					UIColor *undiscoveredBackgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
					[gridCellView setBackgroundColor:undiscoveredBackgroundColor];
				}
				
				[gridCellView.centerLabel setText:text];
				[gridCellView showCenterLabel];
			}
			
			gridCellViews[row*numberOfCols + col] = gridCellView;
			
			[self addSubview:gridCellView];
		}
	}
	
	_gridCellViews = [gridCellViews copy];
}

#pragma mark - Show q values

- (void)showQValues {
	NSUInteger numberOfRows = 0;
	NSUInteger numberOfCols = 0;
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridRows)]) {
		numberOfRows = [self.delegate numberOfGridRows];
	}
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridCols)]) {
		numberOfCols = [self.delegate numberOfGridCols];
	}
	
	for (NSUInteger row = 0; row < numberOfRows; row++) {
		for (NSUInteger col = 0; col < numberOfCols; col++) {
			GridCellView *gridCellView = [self gridCellViewForRow:row col:col];
			
			GridCellViewType gridCellViewType = GridCellViewTypeWall;
			
			if ([self.delegate respondsToSelector:@selector(gridCellViewTypeForRow:col:)]) {
				gridCellViewType = [self.delegate gridCellViewTypeForRow:(int)row col:(int)col];
			}
			
			if (gridCellViewType == GridCellViewTypeNonterminal || gridCellViewType == GridCellViewTypeStart) {
				int numberOfQValues = 0;
				
				if ([self.delegate respondsToSelector:@selector(numberOfQValues)]) {
					numberOfQValues = [self.delegate numberOfQValues];
				}
				
				for (int i = 0; i < numberOfQValues; i++) {
					double qValue = 0;
					Direction direction = DirectionUp;
					
					if (i == DirectionUp) {
						if ([self.delegate respondsToSelector:@selector(qValueForDirection:atRow:col:)]) {
							qValue = [self.delegate qValueForDirection:DirectionUp atRow:(int)row col:(int)col];
						}
						
						direction = DirectionUp;
					}
					
					else if (i == DirectionDown) {
						if ([self.delegate respondsToSelector:@selector(qValueForDirection:atRow:col:)]) {
							qValue = [self.delegate qValueForDirection:DirectionUp atRow:(int)row col:(int)col];
						}
							
						direction = DirectionDown;
					}
					
					else if (i == DirectionLeft) {
						if ([self.delegate respondsToSelector:@selector(qValueForDirection:atRow:col:)]) {
							qValue = [self.delegate qValueForDirection:DirectionUp atRow:(int)row col:(int)col];
						}
						
						direction = DirectionLeft;
					}
					
					else if (i == DirectionRight) {
						if ([self.delegate respondsToSelector:@selector(qValueForDirection:atRow:col:)]) {
							qValue = [self.delegate qValueForDirection:DirectionUp atRow:(int)row col:(int)col];
						}
						
						direction = DirectionRight;
					}
					
					NSString *qValueText = [NSString stringWithFormat:@"%.2f", qValue];
					
					[gridCellView setQValueLabelText:qValueText forDirection:direction];
					[gridCellView showQValues];
				}
			}
		}
	}
}

#pragma mark - Show policies

- (void)showPolicies {
	NSUInteger numberOfRows = 0;
	NSUInteger numberOfCols = 0;
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridRows)]) {
		numberOfRows = [self.delegate numberOfGridRows];
	}
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridCols)]) {
		numberOfCols = [self.delegate numberOfGridCols];
	}
	
	for (NSUInteger row = 0; row < numberOfRows; row++) {
		for (NSUInteger col = 0; col < numberOfCols; col++) {
			GridCellView *gridCellView = [self gridCellViewForRow:row col:col];
			
			GridCellViewType gridCellViewType = GridCellViewTypeWall;
			
			if ([self.delegate respondsToSelector:@selector(gridCellViewTypeForRow:col:)]) {
				gridCellViewType = [self.delegate gridCellViewTypeForRow:(int)row col:(int)col];
			}
			
			if (gridCellViewType == GridCellViewTypeNonterminal || gridCellViewType == GridCellViewTypeStart) {
				PolicyViewType shownPolicyViewType = PolicyViewTypeUp;
				
				if ([self.delegate respondsToSelector:@selector(shownPolicyViewTypeForRow:col:)]) {
					shownPolicyViewType = [self.delegate shownPolicyViewTypeForRow:(int)row col:(int)col];
				}
				
				[gridCellView showPolicyViewType:shownPolicyViewType];
			}
		}
	}
}

#pragma mark - Grid cell view

- (GridCellView *)gridCellViewForRow:(NSUInteger)row col:(NSUInteger)col {
	NSUInteger numberOfCols = 0;
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridCols)]) {
		numberOfCols = [self.delegate numberOfGridCols];
	}
	
	return _gridCellViews[row*numberOfCols + col];
}

- (void)layoutSubviews {
	// grid background
	
	CGFloat numberOfRows = 0;
	CGFloat numberOfCols = 0;
	CGFloat width = 0;
	CGFloat height = 0;
	
	if ([self.delegate respondsToSelector:@selector(screenWidth)]) {
		width = [self.delegate screenWidth];
	}
	
	if ([self.delegate respondsToSelector:@selector(screenHeight)]) {
		height = [self.delegate screenHeight];
	}
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridRows)]) {
		numberOfRows = [self.delegate numberOfGridRows];
	}
	
	if ([self.delegate respondsToSelector:@selector(numberOfGridCols)]) {
		numberOfCols = [self.delegate numberOfGridCols];
	}
	
	CGFloat horizontalMargin = GRID_WORLD_HORIZONATAL_MARGIN_LOWER_BOUND;
	CGFloat gridWidth = width - 2*horizontalMargin;
	CGFloat cellSize = gridWidth/numberOfCols;
	
	while (cellSize - floorf(cellSize) != 0) {
		horizontalMargin++;
		
		gridWidth = width - 2*horizontalMargin;
		cellSize = gridWidth/numberOfCols;
	}
	
	CGFloat gridHeight = cellSize*numberOfRows;
	CGFloat yCoordinate = (height - gridHeight)/2;
	
	[self setFrame:CGRectMake(horizontalMargin, yCoordinate, gridWidth, gridHeight)];
	
	// grid cells
	for (NSUInteger col = 0; col < numberOfCols; col++) {
		for (NSUInteger row = 0; row < numberOfRows; row++) {
			GridCellView *gridCellView = [self gridCellViewForRow:row col:col];
			
			[gridCellView setFrame:CGRectMake(col*cellSize,	row*cellSize, cellSize, cellSize)];
		}
	}
}

@end
