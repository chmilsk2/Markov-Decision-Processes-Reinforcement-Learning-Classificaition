//
//  GridCellView.h
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Direction.h"

typedef NS_ENUM(NSUInteger, PolicyViewType) {
	PolicyViewTypeUp,
	PolicyViewTypeDown,
	PolicyViewTypeLeft,
	PolicyViewTypeRight
};

@interface GridCellView : UIView

@property (nonatomic, strong) NSArray *policyViews;
@property (nonatomic, strong) UILabel *centerLabel;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;
- (void)setQValueLabelText:(NSString *)text forDirection:(Direction)direction;
- (void)showPolicyViewType:(PolicyViewType)policyViewType;
- (void)showQValues;
- (void)showCenterLabel;

@end