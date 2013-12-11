//
//  DigitStatisticsViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitStatisticsViewController.h"
#import "DigitPrototypicalInstancesViewController.h"
#import "ImageMaker.h"
#import "OddsRatio.h"

#define STATISTICS_CELL_SIZE_MULTIPLIER 2
#define NUMBER_OF_ODD_RATIO_BUFFERS 3
#define NUMBER_OF_HIGHEST_CONFUSION_PAIRS 4
#define DIGIT_STATISTICS_NAVIGATION_ITEM_TITLE @"Odds Ratios"
#define PROTOTYPICAL_INSTANCES_BUTTON_TITLE @"Prototypical instances"
#define DigitStatisticsCollectionViewCellIdentifier @"DigitStatisticsCollectionViewCellIdentifier"

@implementation DigitStatisticsViewController {
	vector<pair<int, int>> mHighestConfusionPairs;
	DigitSet mTrainingDigitSet;
	DigitSet mTestingDigitSet;
	DigitStatistics mDigitStatistics;
	vector<OddsRatio> mOddsRatios;
	NSArray *_oddsRatioImages;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_prototypicalInstancesButton;
	ClassificationRule _classificationRule;
	UIColor *_backgroundColor;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout trainingDigitSet:(DigitSet)trainingDigitSet testingDigitSet:(DigitSet)testingDigitSet statistics:(DigitStatistics)digitStatistics classificationRule:(ClassificationRule)classificationRule {
	self = [super initWithCollectionViewLayout:layout];
	
	if (self) {
		_classificationRule = classificationRule;
		mTrainingDigitSet = trainingDigitSet;
		mTestingDigitSet = testingDigitSet;
		mDigitStatistics = digitStatistics;
		_backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	
	mHighestConfusionPairs = [self highestConfusionPairs];
	mOddsRatios = [self oddRatios];
	_oddsRatioImages = [self oddsRatioImagesFromRawData];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_STATISTICS_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.prototypicalInstancesButton] animated:YES];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitStatisticsCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_oddsRatioImages count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*STATISTICS_CELL_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitStatisticsCollectionViewCellIdentifier forIndexPath:indexPath];
	
	cell.delegate = self;
	
	// set image
	UIImage *digitImage = _oddsRatioImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	return cell;
}

#pragma mark - Cancel Button

- (UIBarButtonItem *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTouched)];
	}
	
	return _cancelButton;
}

#pragma mark - Cancel Button Touched

- (void)cancelButtonTouched {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Prototypical Instances Button

- (UIBarButtonItem *)prototypicalInstancesButton {
	if (!_prototypicalInstancesButton) {
		_prototypicalInstancesButton = [[UIBarButtonItem alloc] initWithTitle:PROTOTYPICAL_INSTANCES_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(prototypicalInstancesButtonTouched)];
	}
	
	return _prototypicalInstancesButton;
}

#pragma mark - Prototypical Instances Button Touched

- (void)prototypicalInstancesButtonTouched {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	DigitPrototypicalInstancesViewController *prototypicalInstancesViewController = [[DigitPrototypicalInstancesViewController alloc] initWithCollectionViewLayout:flowLayout digitSet:mTestingDigitSet classificationRule:_classificationRule];
	[self.navigationController pushViewController:prototypicalInstancesViewController animated:YES];
}

#pragma mark - Highest Confusion Pairs

- (vector<pair<int, int>>)highestConfusionPairs {
	return mDigitStatistics.nHighestConfusionPairs(NUMBER_OF_HIGHEST_CONFUSION_PAIRS);
}

#pragma mark - Odd Ratios

- (vector<OddsRatio>)oddRatios {
	vector<OddsRatio> oddRatios;
	
	for (auto it : mHighestConfusionPairs) {
		OddsRatio oddsRatio;
		
		oddsRatio.setFirstDigitClass(it.first);
		oddsRatio.setSecondDigitClass(it.second);
		
		// first find the minimum and maximum values for each case
		
		double mostNegativeLikelihood1LogValue = DBL_MAX;
		double mostPositiveLikelihood1LogValue = -DBL_MAX;
		
		double mostNegativeLikelihood2LogValue = DBL_MAX;
		double mostPositiveLikelihood2LogValue = -DBL_MAX;
		
		double mostNegativeOddsRatioLogValue = DBL_MAX;
		double mostPositiveOddsRatioLogValue = -DBL_MAX;
		
		for (int row = 0; row < DIGIT_SIZE; row++) {
			for (int col = 0; col < DIGIT_SIZE; col++) {
				double likelihood1 = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.firstDigitClass());
				double likelihood1LogValue = log10(likelihood1);
				
				double likelihood2 = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.secondDigitClass());
				double likelihood2LogValue = log10(likelihood2);
				
				double oddsRatioLogValue = likelihood1LogValue - likelihood2LogValue;
				
				if (likelihood1LogValue < mostNegativeLikelihood1LogValue) {
					mostNegativeLikelihood1LogValue = likelihood1LogValue;
				}
				
				if (likelihood1LogValue > mostPositiveLikelihood1LogValue) {
					mostPositiveLikelihood1LogValue = likelihood1LogValue;
				}
				
				if (likelihood2LogValue < mostNegativeLikelihood2LogValue) {
					mostNegativeLikelihood2LogValue = likelihood2LogValue;
				}
				
				if (likelihood2LogValue > mostPositiveLikelihood2LogValue) {
					mostPositiveLikelihood2LogValue = likelihood2LogValue;
				}
				
				if (oddsRatioLogValue < mostNegativeOddsRatioLogValue) {
					mostNegativeOddsRatioLogValue = oddsRatioLogValue;
				}
				
				if (oddsRatioLogValue > mostPositiveOddsRatioLogValue) {
					mostPositiveOddsRatioLogValue = oddsRatioLogValue;
				}
			}
		}
		
		cout << "most negative likelihood 1 log value: " << mostNegativeLikelihood1LogValue << endl;
		cout << "most positive likelihood 1 log value: " << mostPositiveLikelihood1LogValue << endl;
		
		cout << "most negative likelihood 2 log value: " << mostNegativeLikelihood2LogValue << endl;
		cout << "most positive likelihood 2 log value: " << mostPositiveLikelihood2LogValue << endl;
		
		cout << "most negative odds ratio log value: " << mostNegativeOddsRatioLogValue << endl;
		cout << "most positive odds ratio log value: " << mostPositiveOddsRatioLogValue << endl;
		
		// fill in the image buffers
		for (int row = 0; row < DIGIT_SIZE; row++) {
			for (int col = 0; col < DIGIT_SIZE; col++) {
				int componentValues[NUMBER_OF_COLOR_COMPONENTS];
				
				// first likelihood buffer
				double likelihood1 = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.firstDigitClass());
				double likelihood1LogValue = log10(likelihood1);
				oddsRatio.RGBValuesForLogLikelihood(likelihood1LogValue, componentValues, mostNegativeLikelihood1LogValue, mostPositiveLikelihood1LogValue);
				oddsRatio.setImageBufferRGBForRowColAndType(componentValues[0], componentValues[1], componentValues[2], row, col, OddsRatioTypeLikelihood1);
				
				// second likelihood buffer
				double likelihood2 = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.secondDigitClass());
				double likelihood2LogValue = log10(likelihood2);
				oddsRatio.RGBValuesForLogLikelihood(likelihood2LogValue, componentValues, mostNegativeLikelihood2LogValue, mostPositiveLikelihood2LogValue);
				oddsRatio.setImageBufferRGBForRowColAndType(componentValues[0], componentValues[1], componentValues[2], row, col, OddsRatioTypeLikelihood2);
				
				// odds ratio buffer
				// odds(Fij=1, c1, c2) = P(Fij=1 | c1) / P(Fij=1 | c2)
				double oddsRatioLogValue = likelihood1LogValue - likelihood2LogValue;
				oddsRatio.RGBValuesForLogLikelihood(oddsRatioLogValue, componentValues, mostNegativeOddsRatioLogValue, mostPositiveOddsRatioLogValue);
				oddsRatio.setImageBufferRGBForRowColAndType(componentValues[0], componentValues[1], componentValues[2], row, col, OddsRatioTypeRatio);
			}
		}
		
		oddRatios.push_back(oddsRatio);
	}
	
	return oddRatios;
}

#pragma mark - Odds Ratio Images from Raw Data

- (NSArray *)oddsRatioImagesFromRawData {
	NSMutableArray *images = [NSMutableArray array];
	
	int oddRatioIndex = 0;
	
	for (auto it : mOddsRatios) {
		UIImage *likelihood1Image = [ImageMaker imageFromRawImageData:mOddsRatios[oddRatioIndex].imageBufferForType(OddsRatioTypeLikelihood1) width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		[images addObject:likelihood1Image];
		
		UIImage *likelihood2Image = [ImageMaker imageFromRawImageData:mOddsRatios[oddRatioIndex].imageBufferForType(OddsRatioTypeLikelihood2) width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		[images addObject:likelihood2Image];
		
		UIImage *oddsRatioImage = [ImageMaker imageFromRawImageData:mOddsRatios[oddRatioIndex].imageBufferForType(OddsRatioTypeRatio) width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		[images addObject:oddsRatioImage];
		
		oddRatioIndex++;
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
    // Dispose of any resources that can be recreated.
}

@end
