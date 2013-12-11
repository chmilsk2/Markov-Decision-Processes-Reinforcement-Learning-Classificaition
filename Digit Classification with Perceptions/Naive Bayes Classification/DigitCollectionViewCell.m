//
//  DigitCollectionViewCell.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitCollectionViewCell.h"

#define LABEL_HEIGHT_FACTOR 4;
#define CLASSIFICATION_LABEL_FONT_SIZE 12.0f

@implementation DigitCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setUpImageView];
		[self setUpClassificationLabel];
    }
	
    return self;
}

- (void)setUpImageView {
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.clipsToBounds = YES;
	
	[self.contentView addSubview:_imageView];
}

- (void)setUpClassificationLabel {
	_classificationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_classificationLabel setTextAlignment:NSTextAlignmentCenter];
	[_classificationLabel setFont:[UIFont systemFontOfSize:CLASSIFICATION_LABEL_FONT_SIZE]];
	
	[self.contentView addSubview:_classificationLabel];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
	
    self.imageView.image = nil;
}

- (void)layoutSubviews {
	// layout image view
	
	CGFloat imageSize = 0;
	
	if ([self.delegate respondsToSelector:@selector(imageSize)]) {
		imageSize = [self.delegate imageSize];
	}
	
	[_imageView setFrame:CGRectMake((self.bounds.size.width - imageSize)/2, 0, imageSize, imageSize)];
	
	// layout classification label
	CGFloat labelHeight = CLASSIFICATION_LABEL_FONT_SIZE;
	[_classificationLabel setFrame:CGRectMake(0, imageSize + (self.bounds.size.height - imageSize - labelHeight)/2, self.bounds.size.width, labelHeight)];
}

@end
