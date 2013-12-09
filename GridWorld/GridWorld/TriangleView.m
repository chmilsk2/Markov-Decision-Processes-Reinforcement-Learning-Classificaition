//
//  TriangleView.m
//  GridWorld
//
//  Created by Troy Chmieleski on 12/8/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView {
	TriangleDirection _triangleDirection;
}

- (id)initWithFrame:(CGRect)frame triangleDirection:(TriangleDirection)triangleDirection {
	self = [super init];
	
	if (self) {
		_triangleDirection = triangleDirection;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextBeginPath(ctx);
	
	if (_triangleDirection == TriangleDirectionUp) {
		CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // bottom left
		CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect)); // mid top
		CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // bottom right
	}
	
	else if (_triangleDirection == TriangleDirectionDown) {
		CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect)); // top left
		CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(rect)); // mid bottom
		CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // top right
	}
	
	else if (_triangleDirection == TriangleDirectionLeft) {
		CGContextMoveToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // top right
		CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect)); // mid left
		CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // bottom right
	}
	
	else if (_triangleDirection == TriangleDirectionRight) {
		CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect)); // top left
		CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect)); // mid right
		CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // bottom left
		CGContextClosePath(ctx);
	}
	
	
	UIColor *fillColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextFillPath(ctx);
}

@end
