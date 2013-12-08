//
//  GridView.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GridCellViewType) {
	GridCellViewTypeWall,
	GridCellViewTypeNonterminal,
	GridCellViewTypeStart,
	GridCellViewTypeTerminal
};

@protocol GridViewDelegate <NSObject>

- (CGFloat)screenWidth;
- (CGFloat)screenHeight;
- (NSUInteger)numberOfGridRows;
- (NSUInteger)numberOfGridCols;
- (GridCellViewType)gridCellViewTypeForRow:(int)row col:(int)col;
- (float)rewardForRow:(int)row col:(int)col;

@end

@interface GridView : UIView

@property (nonatomic, weak) id <GridViewDelegate> delegate;

- (void)addCellViews;

@end
