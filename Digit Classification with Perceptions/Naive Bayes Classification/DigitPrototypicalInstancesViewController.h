//
//  DigitPrototypicalInstancesViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitSet.h"
#import "DigitClassificaitonRule.h"
#import "DigitCollectionViewCell.h"

@interface DigitPrototypicalInstancesViewController : UICollectionViewController <DigitCollectionViewDelegate>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout digitSet:(DigitSet)digitSet classificationRule:(ClassificationRule)classificationRule;

@end
