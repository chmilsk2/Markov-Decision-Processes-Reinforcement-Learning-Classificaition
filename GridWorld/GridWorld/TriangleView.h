//
//  TriangleView.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/8/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TriangleDirection) {
	TriangleDirectionUp,
	TriangleDirectionDown,
	TriangleDirectionLeft,
	TriangleDirectionRight
};

@interface TriangleView : UIView

- (id)initWithFrame:(CGRect)frame triangleDirection:(TriangleDirection)triangleDirection;

@end
