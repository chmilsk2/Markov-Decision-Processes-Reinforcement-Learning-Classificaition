//
//  DigitStatisticsViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitSet.h"
#import "DigitClassificaitonRule.h"
#import "DigitStatistics.h"
#import "DigitCollectionViewCell.h"

@interface DigitStatisticsViewController : UICollectionViewController <DigitCollectionViewDelegate>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout trainingDigitSet:(DigitSet)trainingDigitSet testingDigitSet:(DigitSet)testingDigitSet statistics:(DigitStatistics)digitStatistics classificationRule:(ClassificationRule)classificationRule;

@end
