//
//  MenuButtonViewController.h
//  GridWorld
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlgorithmType) {
	AlgorithmTypeValueIteration,
	AlgorithmTypeReinforceMentLearning
};

@protocol MenuDelegate <NSObject>

- (void)didSelectAlgorithmType:(AlgorithmType)algorithmType;

@end

@interface MenuButtonViewController : UITableViewController

@property (nonatomic, weak) id delegate;

@end
