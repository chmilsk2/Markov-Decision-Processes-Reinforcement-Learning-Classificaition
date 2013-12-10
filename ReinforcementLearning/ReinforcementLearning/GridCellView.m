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

@implementation GridCellView {
	UIFont *_labelFont;
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
		[self addSubview:self.rewardLabel];
		
		// add utility label
		[self addSubview:self.utilityLabel];
		
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

#pragma mark - Show policy view type

- (void)showPolicyViewType:(PolicyViewType)policyViewType {
	NSMutableArray *hiddenPolicyViews = [NSMutableArray arrayWithObjects:_policyViewUp, _policyViewDown, _policyViewLeft, _policyViewRight, nil];
	NSMutableArray *shownPolicyViews = [NSMutableArray array];
	
	if (policyViewType == PolicyViewTypeUp) {
		[shownPolicyViews addObject:_policyViewUp];
		[hiddenPolicyViews removeObject:_policyViewUp];
	}
	
	else if (policyViewType == PolicyViewTypeDown) {
		[shownPolicyViews addObject:_policyViewDown];
		[hiddenPolicyViews removeObject:_policyViewDown];
	}
	
	else if (policyViewType == PolicyViewTypeLeft) {
		[shownPolicyViews addObject:_policyViewLeft];
		[hiddenPolicyViews removeObject:_policyViewLeft];
	}
	
	else if (policyViewType == PolicyViewTypeRight) {
		[shownPolicyViews addObject:_policyViewRight];
		[hiddenPolicyViews removeObject:_policyViewRight];
	}
	
	[self showPolicyViews:shownPolicyViews];
	[self hidePolicyViews:hiddenPolicyViews];
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

- (void)layoutSubviews {
	CGFloat labelFontSize = floor(self.frame.size.height/6);
	_labelFont = [UIFont fontWithName:GRID_CELL_FONT_NAME size:labelFontSize];
	
	CGFloat combinedLabelHeight = 2*_labelFont.pointSize;
	
	// set utility label frame
	[_utilityLabel setFont:_labelFont];
	[_utilityLabel setFrame:CGRectMake(0, (self.frame.size.height - combinedLabelHeight)/2, self.frame.size.width, _labelFont.pointSize)];
	
	// set reward label frame
	[_rewardLabel setFont:_labelFont];
	[_rewardLabel setFrame:CGRectMake(0, (self.frame.size.height - combinedLabelHeight)/2 + _labelFont.pointSize, self.frame.size.width, _labelFont.pointSize)];
	
	CGFloat policyViewSize = self.frame.size.height/8;
	
	// set policy view up frame
	[_policyViewUp setFrame:CGRectMake((self.frame.size.width - policyViewSize)/2, 0, policyViewSize, policyViewSize)];
	
	
	// set policy view down frame
	[_policyViewDown setFrame:CGRectMake((self.frame.size.width - policyViewSize)/2, self.frame.size.height - policyViewSize, policyViewSize, policyViewSize)];
	
	// set policy view left frame
	[_policyViewLeft setFrame:CGRectMake(0, (self.frame.size.height - policyViewSize)/2, policyViewSize, policyViewSize)];
	
	// set policy view right frame
	[_policyViewRight setFrame:CGRectMake(self.frame.size.height - policyViewSize, (self.frame.size.height - policyViewSize)/2, policyViewSize, policyViewSize)];
}

@end
