//
//  DigitTestingCollectionViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitOperationDelegate.h"
#import "DigitSet.h"
#import "DigitCollectionViewCell.h"

@interface DigitTestingCollectionViewController : UICollectionViewController <DigitCollectionViewDelegate, DigitOperationDelegate>

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)flowLayout trainingDigitSet:(DigitSet)trainingDigitSet;

@end
