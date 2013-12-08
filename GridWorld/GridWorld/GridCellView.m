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
	
		// add label
		[self addSubview:self.textLabel];
    }
	
    return self;
}

- (UILabel *)textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_textLabel setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _textLabel;
}

- (void)layoutSubviews {
	// set reward label frame
	CGFloat labelFontSize = floor(self.frame.size.height/6);
	_labelFont = [UIFont fontWithName:GRID_CELL_FONT_NAME size:labelFontSize];
	[_textLabel setFont:_labelFont];
	
	[_textLabel setFrame:CGRectMake(0, (self.frame.size.height - _labelFont.pointSize), self.frame.size.width, _labelFont.pointSize)];
}

@end
