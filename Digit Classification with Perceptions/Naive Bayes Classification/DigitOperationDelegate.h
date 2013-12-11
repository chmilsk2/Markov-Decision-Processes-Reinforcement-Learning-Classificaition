//
//  DigitOperationDelegate.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DigitOperationDelegate <NSObject>

- (void)showProgressView;
- (void)setProgress:(float)progress;

@end
