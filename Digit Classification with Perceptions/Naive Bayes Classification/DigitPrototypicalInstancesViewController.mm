//
//  DigitPrototypicalInstancesViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitPrototypicalInstancesViewController.h"
#import "ImageMaker.h"
#import "DigitClassificaitonRule.h"
#import "DigitCollectionViewCell.h"

#define DIGIT_PROTOTYPICAL_NAVIGATION_ITEM_TITLE @"Prototypical Instances"
#define PROTOTYPICAL_CELL_SIZE_MULTIPLIER 2
#define DigitPrototypicalInstancesCollectionViewCellIdentifier @"DigitPrototypicalInstancesCollectionViewCellIdentifier"

@implementation DigitPrototypicalInstancesViewController {
	UIBarButtonItem *_cancelButton;
	NSArray *_prototypicalImages;
	NSMutableArray *_prototypicalDigitIndices;
	ClassificationRule _classificationRule;
	UIColor *_backgroundColor;
	DigitSet mDigitSet;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout digitSet:(DigitSet)digitSet classificationRule:(ClassificationRule)classificationRule {
	self = [super initWithCollectionViewLayout:layout];
	
	if (self) {
		_prototypicalDigitIndices = [NSMutableArray array];
		_classificationRule = classificationRule;
		_backgroundColor = [UIColor whiteColor];
		mDigitSet = digitSet;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	_prototypicalImages = [self prototypicalImagesFromRawData];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_PROTOTYPICAL_NAVIGATION_ITEM_TITLE];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitPrototypicalInstancesCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_prototypicalImages count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*PROTOTYPICAL_CELL_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitPrototypicalInstancesCollectionViewCellIdentifier forIndexPath:indexPath];
	
	cell.delegate = self;
	
	// set image
	UIImage *digitImage = _prototypicalImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	int prototypicalDigitIndex = ((NSNumber *)_prototypicalDigitIndices[indexPath.row]).intValue;
	
	// set text
	[cell.classificationLabel setText:[NSString stringWithFormat:@"%d", mDigitSet.digits[prototypicalDigitIndex].digitClass()]];
	
	return cell;
}

#pragma mark - Prototypical Images from Raw Data

- (NSArray *)prototypicalImagesFromRawData {
	NSMutableArray *images = [NSMutableArray array];
	
	if (_classificationRule == ClassificationRuleMaximumAPosteriori) {
		for (auto it : mDigitSet.prototypicalMaximumAPosterioriDigitIndexMap) {
			[_prototypicalDigitIndices addObject:[NSNumber numberWithInt:it.second]];
		}
	}
	
	else if (_classificationRule == ClassificationRuleMaximumLikelihood) {
		for (auto it : mDigitSet.prototypicalMaximumLikelihoodDigitIndexMap) {
			[_prototypicalDigitIndices addObject:[NSNumber numberWithInt:it.second]];
		}
	}
	
	for (NSNumber *prototypicalDigitIndex in _prototypicalDigitIndices) {
		UIImage *image = [ImageMaker imageFromRawImageData:mDigitSet.digits[prototypicalDigitIndex.intValue].imageBuffer() width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		
		[images addObject:image];
	}
	
	return [images copy];
}

#pragma mark - Digit Collection View Cell Delegate

- (CGFloat)imageSize {
	return (CGFloat)(DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
