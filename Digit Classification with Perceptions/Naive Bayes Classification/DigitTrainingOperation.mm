//
//  DigitTrainingOperation.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTrainingOperation.h"

#define SMOOTHING_CONSTANT 1
#define NUMBER_OF_POSSIBLE_VALUES_PER_FEATURE 2


@implementation DigitTrainingOperation {
	DigitSet mDigitSet;
}

- (void)main {
	[self train];
	
	[self didFinishTraining];
}

- (id)initWithDigitSet:(DigitSet)digitSet {
	self = [super init];
	
	if (self) {
		mDigitSet = digitSet;
	}
	
	return self;
}

- (void)train {
	cout << "training" << endl;
	
	if ([self.delegate respondsToSelector:@selector(showProgressView)]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate showProgressView];
		});
	}
	
	unsigned long totalNumberOfDigits = mDigitSet.digits.size();
	
	int digitIndex = 0;
	
	int progressFactor = 2;
	
	// populate pixel frequency maps
	for (vector<Digit>::iterator it = mDigitSet.digits.begin(); it != mDigitSet.digits.end(); it++) {
		Digit digit = mDigitSet.digits[digitIndex];
		int classIndex = digit.digitClass();
		
		for (int row = 0; row < DIGIT_SIZE; row++) {
			for (int col = 0; col < DIGIT_SIZE; col++) {
				mDigitSet.updatePixelFrequencyMapUsingRowAndColumnForClassIndex(row, col, mDigitSet.digits[digitIndex], classIndex);
			}
		}
		
		digitIndex++;
		
		float progress = (float)digitIndex/(float)totalNumberOfDigits;
		progress = progress/(float)progressFactor;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
	
	// compute likelihoods P(F_ij|class)
	for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
		for (int row = 0; row < DIGIT_SIZE; row++) {
			for (int col = 0; col < DIGIT_SIZE; col++) {
				int pixelFrequency = mDigitSet.pixelFrequencyForRowColumnAndClassIndex(row, col, classIndex);
				int totalNumberOfTrainingExamplesInClass = mDigitSet.frequencyForClassIndex(classIndex);
				
				// likelihood = P(Fij = f | class) = (# of times pixel (i,j) has value f in training examples from this class) / (Total # of training examples from this class)
				double likelihood = [self likelihoodWithSmoothingForPixelFrequency:pixelFrequency
												 totalNumberOfTrainingExamplesInClass:totalNumberOfTrainingExamplesInClass];
				
				mDigitSet.updateLikelihoodMapUsingRowAndColumnForClassIndex(row, col, classIndex, likelihood);
			}
		}
		
		// compute prior probabilities P(class) = (# of examples in training set from this class)/(total # of examples in training set)
		mDigitSet.updatePriorProbabilityForClassIndex(classIndex);
		
		float progress = (float)(classIndex + 1)/(float)NUMBER_OF_DIGIT_CLASSES;
		progress = (float)progressFactor + progress/(float)progressFactor;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
}

#pragma mark - Likelihood without Smoothing

- (double)likelihoodWithoutSmoothingForPixelFrequency:(int)pixelFrequency totalNumberOfTrainingExamplesInClass:(int)totalNumberOfTrainingExamplesInClass {
	double likelihood = (double)pixelFrequency/(double)totalNumberOfTrainingExamplesInClass;
	
	return likelihood;
}

#pragma mark - Likelihood with Smoothing

- (double)likelihoodWithSmoothingForPixelFrequency:(int)pixelFrequency totalNumberOfTrainingExamplesInClass:(int)totalNumberOfTrainingExamplesInClass {
	// smoothing constant, the higher the value of k, the stronger the smoothing (experiment with values from 1 to 50)
	int k = SMOOTHING_CONSTANT;
	
	// v is the number of possible values the feature can take on (in this case the pixel feature can be filled or not filled)
	int v = NUMBER_OF_POSSIBLE_VALUES_PER_FEATURE;
	
	double likelihood = (double)(pixelFrequency + k)/(double)(totalNumberOfTrainingExamplesInClass + k*v);
	
	return likelihood;
}

- (void)didFinishTraining {
	if (self.digitTrainingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.digitTrainingOperationCompletionBlock(mDigitSet);
		});
	}
}

@end
