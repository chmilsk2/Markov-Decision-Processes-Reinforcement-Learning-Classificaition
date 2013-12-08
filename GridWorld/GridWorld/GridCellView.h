//
//  GridCellView.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/7/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCellView : UIView

@property (nonatomic, strong) UILabel *textLabel;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end
