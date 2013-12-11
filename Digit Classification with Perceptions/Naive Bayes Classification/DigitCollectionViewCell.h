//
//  DigitCollectionViewCell.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DigitCollectionViewCell;

@protocol DigitCollectionViewDelegate <NSObject>

- (CGFloat)imageSize;

@end

@interface DigitCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <DigitCollectionViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *classificationLabel;

@end
