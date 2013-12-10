//
//  GridCellView.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "GridCellView.h"
#import "TriangleView.h"

#define GRID_CELL_FONT_NAME @"Helvetica-Bold"
#define NUMBER_OF_Q_VALUES 4

@implementation GridCellView {
	NSArray *_qValueLabels;
	
	UIFont *_centerLabelFont;
	UIFont *_qLabelFont;
	
	TriangleView *_policyViewUp;
	TriangleView*_policyViewDown;
	TriangleView *_policyViewLeft;
	TriangleView *_policyViewRight;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setBackgroundColor:color];
		
		// add reward label
		[self addSubview:self.centerLabel];
		[self.centerLabel setHidden:YES];
		
		// add q value labels
		NSMutableArray *qValueLabels = [NSMutableArray array];
		
		for (NSUInteger i = 0; i < NUMBER_OF_Q_VALUES; i++) {
			UILabel *qValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[self addSubview:qValueLabel];
			
			[qValueLabel setHidden:YES];
			
			[qValueLabels addObject:qValueLabel];
		}
		
		_qValueLabels = [qValueLabels copy];
		
		// add policy views
		[self addSubview:self.policyViewUp];
		[self addSubview:self.policyViewDown];
		[self addSubview:self.policyViewLeft];
		[self addSubview:self.policyViewRight];
		
		[_policyViewUp setBackgroundColor:color];
		[_policyViewDown setBackgroundColor:color];
		[_policyViewLeft setBackgroundColor:color];
		[_policyViewRight setBackgroundColor:color];
		
		[self hidePolicyViews:@[_policyViewUp, _policyViewDown, _policyViewLeft, _policyViewRight]];
	}
	
    return self;
}

#pragma mark - Show q values

- (void)showQValues {
	for (UILabel *qValueLabel in _qValueLabels) {
		[qValueLabel setHidden:NO];
	}
}

#pragma mark - Show policy view type

- (void)showPolicyViewType:(PolicyViewType)policyViewType {
	NSMutableArray *hiddenPolicyViews = [NSMutableArray arrayWithObjects:_policyViewUp, _policyViewDown, _policyViewLeft, _policyViewRight, nil];
	NSMutableArray *shownPolicyViews = [NSMutableArray array];
	
//	if (policyViewType == PolicyViewTypeUp) {
//		[shownPolicyViews addObject:_policyViewUp];
//		[hiddenPolicyViews removeObject:_policyViewUp];
//	}
//	
//	else if (policyViewType == PolicyViewTypeDown) {
//		[shownPolicyViews addObject:_policyViewDown];
//		[hiddenPolicyViews removeObject:_policyViewDown];
//	}
//	
//	else if (policyViewType == PolicyViewTypeLeft) {
//		[shownPolicyViews addObject:_policyViewLeft];
//		[hiddenPolicyViews removeObject:_policyViewLeft];
//	}
//	
//	else if (policyViewType == PolicyViewTypeRight) {
//		[shownPolicyViews addObject:_policyViewRight];
//		[hiddenPolicyViews removeObject:_policyViewRight];
//	}
	
//	[self showPolicyViews:shownPolicyViews];
//	[self hidePolicyViews:hiddenPolicyViews];
	
	[self showPolicyViews:hiddenPolicyViews];
}

#pragma mark - Show policy view types

- (void)showPolicyViews:(NSArray *)policyViews {
	for (TriangleView *triangleView in policyViews) {
		[triangleView setHidden:NO];
	}
}

#pragma mark - Hide policy view types

- (void)hidePolicyViews:(NSArray *)policyViews {
	for (TriangleView *triangleView in policyViews) {
		[triangleView setHidden:YES];
	}
}

#pragma mark - Reward label

- (UILabel *)centerLabel {
	if (!_centerLabel) {
		_centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[_centerLabel setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _centerLabel;
}

#pragma mark - Show reward label

- (void)showCenterLabel {
	[self.centerLabel setHidden:NO];
}

#pragma mark - Policy view up

- (TriangleView *)policyViewUp {
	if (!_policyViewUp) {
		_policyViewUp = [[TriangleView alloc] initWithFrame:CGRectZero triangleDirection:TriangleDirectionUp];
	}
	
	return _policyViewUp;
}

- (TriangleView *)policyViewDown {
	if (!_policyViewDown) {
		_policyViewDown = [[TriangleView alloc] initWithFrame:CGRectZero triangleDirection:TriangleDirectionDown];
	}
	
	return _policyViewDown;
}

- (TriangleView *)policyViewLeft {
	if (!_policyViewLeft) {
		_policyViewLeft = [[TriangleView alloc] initWithFrame:CGRectZero triangleDirection:TriangleDirectionLeft];
	}
	
	return _policyViewLeft;
}

- (TriangleView *)policyViewRight {
	if (!_policyViewRight) {
		_policyViewRight = [[TriangleView alloc] initWithFrame:CGRectZero triangleDirection:TriangleDirectionRight];
	}
	
	return _policyViewRight;
}

# pragma mark - Set Q value label text 

- (void)setQValueLabelText:(NSString *)text forDirection:(Direction)direction {
	UILabel *qLabel;
	
	if (direction == DirectionUp) {
		qLabel = _qValueLabels[DirectionUp];
	}
	
	else if (direction == DirectionDown) {
		qLabel = _qValueLabels[DirectionDown];
	}
	
	else if (direction == DirectionLeft) {
		qLabel = _qValueLabels[DirectionLeft];
	}
	
	else if (direction == DirectionRight) {
		qLabel = _qValueLabels[DirectionRight];
	}
	
	[qLabel setText:text];

}

- (void)layoutSubviews {
	CGFloat centerLabelFontSize = floor(self.frame.size.height/6);
	_centerLabelFont = [UIFont fontWithName:GRID_CELL_FONT_NAME size:centerLabelFontSize];
	
	// set reward label frame
	[_centerLabel setFont:_centerLabelFont];
	[_centerLabel setFrame:CGRectMake(0, (self.frame.size.height - _centerLabelFont.pointSize)/2, self.frame.size.width, _centerLabelFont.pointSize)];
	
	CGFloat policyViewSize = self.frame.size.height/8;
	
	// set policy view up frame
	[_policyViewUp setFrame:CGRectMake((self.frame.size.width - policyViewSize)/2, 0, policyViewSize, policyViewSize)];
	
	// set policy view down frame
	[_policyViewDown setFrame:CGRectMake((self.frame.size.width - policyViewSize)/2, self.frame.size.height - policyViewSize, policyViewSize, policyViewSize)];
	
	// set policy view left frame
	[_policyViewLeft setFrame:CGRectMake(0, (self.frame.size.height - policyViewSize)/2, policyViewSize, policyViewSize)];
	
	// set policy view right frame
	[_policyViewRight setFrame:CGRectMake(self.frame.size.height - policyViewSize, (self.frame.size.height - policyViewSize)/2, policyViewSize, policyViewSize)];
	
	// set q label frames
	CGFloat qLabelFontSize = floor(self.frame.size.height/8);
	_qLabelFont = [UIFont fontWithName:GRID_CELL_FONT_NAME size:qLabelFontSize];
	
	CGFloat qValueWidth = (self.frame.size.width - 2*_policyViewUp.frame.size.width)/2;
	
	NSUInteger index = 0;
	
	for (UILabel *qValueLabel in _qValueLabels) {
		[qValueLabel setFont:_qLabelFont];
		
		CGRect frame = CGRectZero;
		
		if (index == DirectionUp) {
			frame = CGRectMake((self.frame.size.width - qValueWidth)/2, _policyViewUp.frame.size.height, qValueWidth, _qLabelFont.pointSize);
			[qValueLabel setTextAlignment:NSTextAlignmentCenter];
		}
		
		else if (index == DirectionDown) {
			frame = CGRectMake((self.frame.size.width - qValueWidth)/2, self.frame.size.height - _qLabelFont.pointSize - _policyViewDown.frame.size.height, qValueWidth, _qLabelFont.pointSize);
			[qValueLabel setTextAlignment:NSTextAlignmentCenter];
		}
		
		else if (index == DirectionLeft) {
			frame = CGRectMake(_policyViewLeft.frame.size.width, (self.frame.size.height - _qLabelFont.pointSize)/2, qValueWidth, _qLabelFont.pointSize);
			[qValueLabel setTextAlignment:NSTextAlignmentLeft];
		}
		
		else if (index == DirectionRight) {
			frame = CGRectMake(self.frame.size.width - _policyViewRight.frame.size.width - qValueWidth, (self.frame.size.height - _qLabelFont.pointSize)/2, qValueWidth, _qLabelFont.pointSize);
			[qValueLabel setTextAlignment:NSTextAlignmentRight];
		}
		
		[qValueLabel setFrame:frame];
			
		index++;
	}
}

@end
