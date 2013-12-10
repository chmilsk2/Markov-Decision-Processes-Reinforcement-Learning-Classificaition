//
//  GridView.h
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCellView.h"

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
- (double)rewardForRow:(int)row col:(int)col;
- (int)numberOfQValues;
- (double)qValueForDirection:(Direction)direction atRow:(int)row col:(int)col;
- (PolicyViewType)shownPolicyViewTypeForRow:(int)row col:(int)col;
- (BOOL)isDiscoveredForRow:(int)row col:(int)col;
- (CGPoint)agentCoordinate;

@end

@interface GridView : UIView

@property (nonatomic, weak) id <GridViewDelegate> delegate;

- (void)addCellViews;
- (void)showQValues;
- (void)showPolicies;
- (void)setQValueText:(NSString *)qValueText forRow:(int)row col:(int)col direction:(Direction)direction;
- (void)moveAgentToRow:(int)row col:(int)col;

@end
