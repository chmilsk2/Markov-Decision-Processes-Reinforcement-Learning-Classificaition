//
//  DigitTrainingOperation.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTrainingOperation.h"
#include <algorithm>

#define SMOOTHING_CONSTANT 1
#define NUMBER_OF_POSSIBLE_VALUES_PER_FEATURE 2
#define ALPHA_VALUE_DECAY 1

@implementation DigitTrainingOperation {
	DigitSet mDigitSet;
}

- (void)main {
	[self weightTraining];
	
	[self didFinishTraining];
}

- (id)initWithDigitSet:(DigitSet)digitSet {
	self = [super init];
	
	if (self) {
		mDigitSet = digitSet;
	}
	
	return self;
}

- (void)weightTraining {
	// pass through all the digits, update the weights as you go if incorrectly classified
	// compute all of the dot products and find the highest dot product
	int numberOfDigits = (int)mDigitSet.digits.size();
	
	int randomIndices[numberOfDigits];
	
	for (int i = 0; i < numberOfDigits; i++) {
		randomIndices[i] = i;
	}
	
	// randomly sort
	random_shuffle(&randomIndices[0], &randomIndices[numberOfDigits - 1]);
	
	for (int i = 0; i < numberOfDigits; i++) {
		int randomIndex = randomIndices[i];
		Digit digit = mDigitSet.digits[i];
		
		double maxDotProduct = -DBL_MAX;
		int estimateClassIndex = 0;
		
		// loop through all the digit classes to compute the weight values
		for (int digitIndex = 0; digitIndex < NUMBER_OF_DIGIT_CLASSES; digitIndex++) {
			double dotProduct = 0;
			
			for (int row = 0; row < DIGIT_SIZE; row++) {
				for (int col = 0; col < DIGIT_SIZE; col++) {
					double featureWeight = digit.featureWeight(row, col);
					double weight = mDigitSet.weightForIndexRowAndCol(digitIndex, row, col);
					
					dotProduct += weight*featureWeight;
				}
			}
			
			// figure out the max dot
			if (dotProduct > maxDotProduct) {
				maxDotProduct = dotProduct;
				estimateClassIndex = digitIndex;
			}
		}
		
		// check to see if digit index is equal to the actual class index provided by the training data
		int correctClassIndex = digit.digitClass();
		
		[self updateRuleForDigit:digit correctClassIndex:correctClassIndex estimateClassIndex:estimateClassIndex];
	}
}

- (void)updateRuleForDigit:(Digit)digit correctClassIndex:(int)correctClassIndex estimateClassIndex:(int)estimateClassIndex {
	BOOL isEstimateCorrect = NO;
	
	if (estimateClassIndex == correctClassIndex) {
		isEstimateCorrect = YES;
	}
	
	for (int row = 0; row < DIGIT_SIZE; row++) {
		for (int col = 0; col < DIGIT_SIZE; col++) {
			double featureWeight = digit.featureWeight(row, col);
			
			double alpha = [self alpha];
			
			if (!isEstimateCorrect) {
				// incorrectly classfied
				
				// update the weight values of the actual class
				// wc = wc + alpha*x
				double wc = mDigitSet.weightForIndexRowAndCol(correctClassIndex, row, col);
				wc += alpha*featureWeight;
				mDigitSet.setWeightForIndexRowAndCol(correctClassIndex, row, col, wc);
				
				// update teh weight values of the incorrectly identified class
				// wc = wc - alpha*x
				double wcPrime = mDigitSet.weightForIndexRowAndCol(estimateClassIndex, row, col);
				wcPrime -= alpha*featureWeight;
				mDigitSet.setWeightForIndexRowAndCol(estimateClassIndex, row, col, wcPrime);
			}
		}
	}
}

- (double)alpha {
	double alpha = 1;
	
	if (ALPHA_VALUE_DECAY) {
		double epoch = mDigitSet.epoch();
		alpha = 1000.0/(1000.0 + epoch);
	}
	
	return alpha;
}

- (void)bayesTraining {
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
