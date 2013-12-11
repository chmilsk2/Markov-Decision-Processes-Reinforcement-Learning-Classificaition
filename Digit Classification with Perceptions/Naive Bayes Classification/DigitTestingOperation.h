//
//  DigitTestingOperation.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigitOperationDelegate.h"
#include "DigitSet.h"
#include "DigitClassificaitonRule.h"

typedef void(^DigitTestingOperationHandler)(DigitSet testedDigitSet);

@interface DigitTestingOperation : NSOperation

@property (copy) DigitTestingOperationHandler digitTestingOperationCompletionBlock;
@property (nonatomic, weak) id <DigitOperationDelegate> delegate;

- (id)initWithTestDigitSet:(DigitSet)testDigitSet trainingDigitSet:(DigitSet)trainingDigitSet classificationRule:(ClassificationRule)classificationRule;

@end
