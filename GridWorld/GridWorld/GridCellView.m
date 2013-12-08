//
//  GridCellView.m
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridCellView.h"

#define GRID_CELL_FONT_NAME @"Helvetica-Bold"

@implementation GridCellView {
	UIFont *_labelFont;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setBackgroundColor:color];
	
		// add reward label
		[self addSubview:self.rewardLabel];
		
		// add utility label
		[self addSubview:self.utilityLabel];
    }
	
    return self;
}

#pragma mark - Reward label

- (UILabel *)rewardLabel {
	if (!_rewardLabel) {
		_rewardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_rewardLabel setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _rewardLabel;
}

#pragma mark - Utility label

- (UILabel *)utilityLabel {
	if (!_utilityLabel) {
		_utilityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_utilityLabel setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _utilityLabel;
}

- (void)layoutSubviews {
	CGFloat labelFontSize = floor(self.frame.size.height/6);
	_labelFont = [UIFont fontWithName:GRID_CELL_FONT_NAME size:labelFontSize];
	
	// set reward label frame
	[_rewardLabel setFont:_labelFont];
	[_rewardLabel setFrame:CGRectMake(0, (self.frame.size.height - _labelFont.pointSize), self.frame.size.width, _labelFont.pointSize)];
	
	// set utility label frame
	[_utilityLabel setFont:_labelFont];
	[_utilityLabel setFrame:CGRectMake(0, (self.frame.size.height - _labelFont.pointSize)/2, self.frame.size.width, _labelFont.pointSize)];
}

@end
