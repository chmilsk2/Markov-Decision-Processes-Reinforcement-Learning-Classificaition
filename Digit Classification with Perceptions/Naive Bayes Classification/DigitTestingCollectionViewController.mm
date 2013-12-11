//
//  DigitTestingCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingCollectionViewController.h"
#import "DigitStatisticsViewController.h"
#import "DigitTestingOperation.h"
#import "DigitCollectionViewCell.h"
#import "DigitSet.h"
#import "DigitLabelParser.h"
#import "DigitParser.h"
#import "DigitStatistics.h"
#import "QueuePool.h"
#import "DigitClassificaitonRule.h"
#import "DigitClassificaitonRule.h"
#import "ImageMaker.h"

#define TESTING_CELL_SIZE_MULTIPLIER 2
#define DIGIT_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION 2.0
#define DIGIT_TESTING_NAVIGATION_ITEM_TITLE @"Testing"
#define TEST_BUTTON_TITLE @"Test"
#define STATISTICS_BUTTON_TITLE @"Statistics"
#define DigitTestingCollectionViewCellIdentifier @"DigitTestingCollectionViewCellIdentifier"
#define TESTING_LABELS_TEXT_NAME @"testlabels"
#define TESTING_IMAGES_TEXT_NAME @"testimages"

@implementation DigitTestingCollectionViewController {
	DigitSet mTrainingDigitSet;
	DigitSet mTestingDigitSet;
	DigitStatistics mDigitStatistics;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_testButton;
	UIBarButtonItem *_statisticsButton;
	UIProgressView *_progressView;
	UIColor *_backgroundColor;
	UIColor *_correctClassificationTextColor;
	UIColor *_incorrectClassificationTextColor;
	NSArray *_digitImages;
	ClassificationRule _classificationRule;
}

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)flowLayout trainingDigitSet:(DigitSet)trainingDigitSet {
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		_backgroundColor = [UIColor whiteColor];
		mTrainingDigitSet = trainingDigitSet;
		_correctClassificationTextColor = [UIColor colorWithRed:46.0/255.0 green:139.0/255.0 blue:87.0/255.0 alpha:1.0];
		_incorrectClassificationTextColor = [UIColor colorWithRed:1.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0];
		
		// configure classification rule
		_classificationRule = ClassificationRuleMaximumAPosteriori;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self setUpProgressView];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
	_digitImages = [self imagesFromRawData];

}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_TESTING_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.statisticsButton, self.testButton] animated:YES];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitTestingCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mTestingDigitSet.digits.size();
	
	return numberOfDigits;
}

- (void)setUpProgressView {
	[self.navigationController.navigationBar addSubview:self.progressView];
}

- (UIProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		[_progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - _progressView.frame.size.height, self.view.frame.size.width, _progressView.frame.size.height)];
		[_progressView setAlpha:0.0];
	}
	
	return _progressView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitTestingCollectionViewCellIdentifier forIndexPath:indexPath];
	
	cell.delegate = self;
	
	// set image
	UIImage *digitImage = _digitImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	// set text
	ClassificationType classificationType = mTestingDigitSet.digits[indexPath.row].classificationType();

	if (classificationType != ClassificationTypeNone) {
		[cell.classificationLabel setText:[NSString stringWithFormat:@"%d", mTestingDigitSet.digits[indexPath.row].digitClass()]];
		
		// set text color
		UIColor *textColor = [UIColor blackColor];
		
		if (classificationType == ClassificationTypeCorrect) {
			textColor = _correctClassificationTextColor;
		}
		
		else if (classificationType == ClassificationTypeIncorrect) {
			textColor = _incorrectClassificationTextColor;
		}
		
		[cell.classificationLabel setTextColor:textColor];
	}
	
	else {
		[cell.classificationLabel setText:@""];
	}
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*TESTING_CELL_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
}

- (void)parseDigitLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_LABELS_TEXT_NAME ofType:@"txt"];
	DigitLabelParser digitLabelParser([filePath fileSystemRepresentation]);
	mTestingDigitSet = digitLabelParser.parseDigitLabels();
}

- (void)setUpDigitSet {
	mTestingDigitSet.setBitShiftSizeUsingDigitSize(DIGIT_SIZE);
}

- (void)parseDigits {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_IMAGES_TEXT_NAME ofType:@"txt"];
	DigitParser digitParser([filePath fileSystemRepresentation]);
	digitParser.parseDigits(mTestingDigitSet);
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

#pragma mark - Test Button 

- (UIBarButtonItem *)testButton {
	if (!_testButton) {
		_testButton = [[UIBarButtonItem alloc] initWithTitle:TEST_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testButtonTouched)];
	}
	
	return _testButton;
}

#pragma mark - Test Button Touched 

- (void)testButtonTouched {
	NSLog(@"Test button touched");

	DigitTestingOperation *digitTestingOperation = [[DigitTestingOperation alloc] initWithTestDigitSet:mTestingDigitSet trainingDigitSet:mTrainingDigitSet classificationRule:_classificationRule];
	[digitTestingOperation setDelegate:self];
	
	digitTestingOperation.digitTestingOperationCompletionBlock = ^(DigitSet & testedDigitSet) {
		NSLog(@"finished testing");
		
		mTestingDigitSet = testedDigitSet;
		
		[self didFinishUpdatingProgressView];
		
		[self weightStatistics];
		[self.collectionView reloadData];
	};
	
	[[QueuePool sharedQueuePool].queue addOperation:digitTestingOperation];
}

#pragma mark - Statistics Button

- (UIBarButtonItem *)statisticsButton {
	if (!_statisticsButton) {
		_statisticsButton = [[UIBarButtonItem alloc] initWithTitle:STATISTICS_BUTTON_TITLE
															 style:UIBarButtonItemStylePlain
															target:self
															action:@selector(statisticsButtonTouched)];
	}
	
	return _statisticsButton;
}

#pragma mark - Statistics Button Touched

- (void)statisticsButtonTouched {
	NSLog(@"Statistics button touched");
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	DigitStatisticsViewController *digitStatisticsViewController = [[DigitStatisticsViewController alloc] initWithCollectionViewLayout:flowLayout trainingDigitSet:mTrainingDigitSet testingDigitSet:mTestingDigitSet statistics:mDigitStatistics classificationRule:_classificationRule];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:digitStatisticsViewController];
		
	[navController setModalPresentationStyle:UIModalPresentationFormSheet];
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Images from Raw Data

- (NSArray *)imagesFromRawData {
	NSMutableArray *images = [NSMutableArray arrayWithCapacity:mTestingDigitSet.digits.size()];
	
	NSUInteger digitIndex = 0;
	
	for (auto it : mTestingDigitSet.digits) {
		UIImage *image = [ImageMaker imageFromRawImageData:mTestingDigitSet.digits[digitIndex].imageBuffer() width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		
		[images insertObject:image atIndex:digitIndex];
		
		digitIndex++;
	}
	
	return [images copy];
}

- (void)weightStatistics {
	// set success rates, confusion matrix, and overall success rate
	int successCounts[NUMBER_OF_DIGIT_CLASSES];
	int confusionMatrixCount[NUMBER_OF_DIGIT_CLASSES][NUMBER_OF_DIGIT_CLASSES];
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int successCount = 0;
		int confusionCount = 0;
		
		successCounts[classIndexR] = successCount;
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			confusionMatrixCount[classIndexR][classIndexC] = confusionCount;
		}
	}
	
	int digitIndex = 0;
	
	for (auto it : mTestingDigitSet.digits) {
		int classifiedDigitClass = it.digitClass();
		int correctDigitClass = mTestingDigitSet.digitLabels[digitIndex];
		
		// set classification type
		if (classifiedDigitClass == correctDigitClass) {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeCorrect);
			successCounts[classifiedDigitClass]++;
		}
		
		else {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeIncorrect);
		}
		
		// percentage of images in class r that are classified as class c
		confusionMatrixCount[correctDigitClass][classifiedDigitClass]++;
		
		digitIndex++;
	}
	
	int totalNumberOfInstances = 0;
	int overallSuccessCount = 0;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int totalNumberOfInstancesFromClass = mTestingDigitSet.frequencyMap[classIndexR];
		
		totalNumberOfInstances += totalNumberOfInstancesFromClass;
		overallSuccessCount += successCounts[classIndexR];
		
		double successRate = (double)successCounts[classIndexR]/(double)totalNumberOfInstancesFromClass;
		
		mDigitStatistics.setSuccessRateForClassIndex(classIndexR, successRate);
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			double confusionRate = (double)confusionMatrixCount[classIndexR][classIndexC]/(double)totalNumberOfInstancesFromClass;
			
			mDigitStatistics.setConfusionRateForTestImagesFromClassRClassifiedAsClassC(classIndexR, classIndexC, confusionRate);
		}
	}
	
	double overallSuccessRate = (double)overallSuccessCount/(double)totalNumberOfInstances;
	mDigitStatistics.setOverallSuccessRate(overallSuccessRate);
	
	mDigitStatistics.printSuccessRates();
	mDigitStatistics.printConfusionMatrix();
	mDigitStatistics.printOverallSuccessRate();
}

#pragma mark - Statistics

- (void)bayesStatistics {
	// set success rates, confusion matrix, and overall success rate
	int successCounts[NUMBER_OF_DIGIT_CLASSES];
	int confusionMatrixCount[NUMBER_OF_DIGIT_CLASSES][NUMBER_OF_DIGIT_CLASSES];
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int successCount = 0;
		int confusionCount = 0;
		
		successCounts[classIndexR] = successCount;
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			confusionMatrixCount[classIndexR][classIndexC] = confusionCount;
		}
	}
	
	map<int, double> mostPositiveMaximumAPosterioriProbabilityMap;
	map<int, double> mostPositiveMaximumLikelihoodProbabilityMap;
	
	for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
		mostPositiveMaximumAPosterioriProbabilityMap[classIndex] = -DBL_MAX;
		mostPositiveMaximumLikelihoodProbabilityMap[classIndex] = -DBL_MAX;
	}
	
	int digitIndex = 0;
	
	for (auto it : mTestingDigitSet.digits) {
		int classifiedDigitClass = it.digitClass();
		int correctDigitClass = mTestingDigitSet.digitLabels[digitIndex];
		
		// set classification type
		if (classifiedDigitClass == correctDigitClass) {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeCorrect);
			successCounts[classifiedDigitClass]++;
		}
		
		else {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeIncorrect);
		}
		
		// percentage of images in class r that are classified as class c
		confusionMatrixCount[correctDigitClass][classifiedDigitClass]++;
		
		// find prototypical instance from each class
		for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
			if (mTestingDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex) > mostPositiveMaximumAPosterioriProbabilityMap[classIndex]) {
				mostPositiveMaximumAPosterioriProbabilityMap[classIndex] = mTestingDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);;
				mTestingDigitSet.prototypicalMaximumAPosterioriDigitIndexMap[classIndex] = digitIndex;
			}
			
			if (mTestingDigitSet.digits[digitIndex].maximumLikelihoodProbabilityForClassIndex(classIndex) > mostPositiveMaximumLikelihoodProbabilityMap[classIndex]) {
				mostPositiveMaximumLikelihoodProbabilityMap[classIndex] = mTestingDigitSet.digits[digitIndex].maximumLikelihoodProbabilityForClassIndex(classIndex);
				mTestingDigitSet.prototypicalMaximumLikelihoodDigitIndexMap[classIndex] = digitIndex;
			}
		}
		
		digitIndex++;
	}
	
	int totalNumberOfInstances = 0;
	int overallSuccessCount = 0;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int totalNumberOfInstancesFromClass = mTestingDigitSet.frequencyMap[classIndexR];
		
		totalNumberOfInstances += totalNumberOfInstancesFromClass;
		overallSuccessCount += successCounts[classIndexR];
		
		double successRate = (double)successCounts[classIndexR]/(double)totalNumberOfInstancesFromClass;
		
		mDigitStatistics.setSuccessRateForClassIndex(classIndexR, successRate);
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			double confusionRate = (double)confusionMatrixCount[classIndexR][classIndexC]/(double)totalNumberOfInstancesFromClass;
			
			mDigitStatistics.setConfusionRateForTestImagesFromClassRClassifiedAsClassC(classIndexR, classIndexC, confusionRate);
		}
	}
	
	double overallSuccessRate = (double)overallSuccessCount/(double)totalNumberOfInstances;
	mDigitStatistics.setOverallSuccessRate(overallSuccessRate);
	
	mDigitStatistics.printSuccessRates();
	mDigitStatistics.printConfusionMatrix();
	mDigitStatistics.printOverallSuccessRate();
	
	mTestingDigitSet.printPrototypicalMaximumAPosterioriDigitIndexMap();
	mTestingDigitSet.printPrototypicalMaximumLikelihoodDigitIndexMap();
}

#pragma mark - Digit Collection View Cell Delegate

- (CGFloat)imageSize {
	return (CGFloat)(DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER);
}

#pragma mark - Digit Training Operation Delegate

- (void)showProgressView {
	[_progressView setAlpha:1.0];
}

- (void)setProgress:(float)progress {
	[_progressView setProgress:progress animated:YES];
}

- (void)didFinishUpdatingProgressView {
	[UIView animateWithDuration:DIGIT_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION animations:^{
		_progressView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[_progressView setProgress:0.0];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
