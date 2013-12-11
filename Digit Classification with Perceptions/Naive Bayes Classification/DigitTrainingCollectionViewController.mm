//
//  DigitCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTrainingCollectionViewController.h"
#import "DigitTestingCollectionViewController.h"
#import "DigitTrainingOperation.h"
#import "DigitParser.h"
#import "DigitLabelParser.h"
#import "DigitSet.h"
#import "QueuePool.h"
#import "ImageMaker.h"

#define TRAINING_CELL_SIZE_MULTIPLIER 2
#define DIGIT_TRAINING_NAVIGATION_ITEM_TITLE @"Training"
#define TRAIN_BUTTON_TITLE @"Train"
#define TEST_SET_BUTTON_TITLE @"Test set"
#define TRAINING_LABELS_TEXT_NAME @"traininglabels"
#define TRAINING_IMAGES_TEXT_NAME @"trainingimages"
#define DIGIT_TRAINING_PROGRESS_VIEW_FADE_DURATION 2.0
#define DigitTrainingCollectionViewCellIdentifier @"DigitTrainingCollectionViewCellIdentifier"

@implementation DigitTrainingCollectionViewController {
	DigitSet mDigitSet;
	UIProgressView *_progressView;
	UIBarButtonItem *_trainButton;
	UIBarButtonItem *_testSetButton;
	UIColor *_backgroundColor;
	NSArray *_digitImages;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	self = [super initWithCollectionViewLayout:layout];
	
	if (self) {
		_backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self setUpProgressView];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
	[self setUpDigits];
	_digitImages = [self imagesFromRawData];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_TRAINING_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setRightBarButtonItems:@[self.testSetButton, self.trainButton]];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitTrainingCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mDigitSet.digits.size();
	
	return numberOfDigits;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitTrainingCollectionViewCellIdentifier forIndexPath:indexPath];

	cell.delegate = self;

	// set image
	UIImage *digitImage = _digitImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	// set text
	[cell.classificationLabel setText:[NSString stringWithFormat:@"%d", mDigitSet.digitLabels[indexPath.row]]];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*TRAINING_CELL_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
}

- (void)parseDigitLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TRAINING_LABELS_TEXT_NAME ofType:@"txt"];
	DigitLabelParser digitLabelParser([filePath fileSystemRepresentation]);
	mDigitSet = digitLabelParser.parseDigitLabels();
}

- (void)setUpDigitSet {
	mDigitSet.setBitShiftSizeUsingDigitSize(DIGIT_SIZE);
}

- (void)parseDigits {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TRAINING_IMAGES_TEXT_NAME ofType:@"txt"];
	DigitParser digitParser([filePath fileSystemRepresentation]);
	digitParser.parseDigits(mDigitSet);
}

- (void)setUpDigits {
	int digitIndex = 0;
	
	for (vector<Digit>::iterator it = mDigitSet.digits.begin(); it != mDigitSet.digits.end(); it++) {
		it->setDigitClass(mDigitSet.digitLabels[digitIndex]);
		
		digitIndex++;
	}
}

#pragma mark - Train Button

- (UIBarButtonItem *)trainButton {
	if (!_trainButton) {
		_trainButton = [[UIBarButtonItem alloc] initWithTitle:TRAIN_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(trainButtonTouched)];
	}
	
	return _trainButton;
}

#pragma mark - Train Button Touched

- (void)trainButtonTouched {
	NSLog(@"Train button touched");
	
	DigitTrainingOperation *digitTrainingOperation = [[DigitTrainingOperation alloc] initWithDigitSet:mDigitSet];
	[digitTrainingOperation setDelegate:self];
	
	digitTrainingOperation.digitTrainingOperationCompletionBlock = ^(DigitSet trainedDigitSet) {
		NSLog(@"finished training");
		
		mDigitSet = trainedDigitSet;
		
		[self didFinishUpdatingProgressView];
	};
	
	[[QueuePool sharedQueuePool].queue addOperation:digitTrainingOperation];
}

#pragma mark - Test Button

- (UIBarButtonItem *)testSetButton {
	if (!_testSetButton) {
		_testSetButton = [[UIBarButtonItem alloc] initWithTitle:TEST_SET_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testSetButtonTouched)];
	}
	
	return _testSetButton;
}

#pragma mark - Test Set Button Touched

- (void)testSetButtonTouched {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	DigitTestingCollectionViewController *digitTestingCollectionViewController = [[DigitTestingCollectionViewController alloc] initWithCollectionViewLayout:flowLayout trainingDigitSet:mDigitSet];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:digitTestingCollectionViewController];
	
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Images from Raw Data

- (NSArray *)imagesFromRawData {
	NSMutableArray *images = [NSMutableArray arrayWithCapacity:mDigitSet.digits.size()];
	
	NSUInteger digitIndex = 0;
	
	for (auto it : mDigitSet.digits) {
		UIImage *image = [ImageMaker imageFromRawImageData:mDigitSet.digits[digitIndex].imageBuffer() width:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER height:DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER numberOfColorComponents:NUMBER_OF_COLOR_COMPONENTS bitsPerColorComponent:NUMBER_OF_BITS_PER_COMPONENT];
		
		[images insertObject:image atIndex:digitIndex];
		
		digitIndex++;
	}
	
	return [images copy];
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
	[UIView animateWithDuration:DIGIT_TRAINING_PROGRESS_VIEW_FADE_DURATION animations:^{
		_progressView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[_progressView setProgress:0.0];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
