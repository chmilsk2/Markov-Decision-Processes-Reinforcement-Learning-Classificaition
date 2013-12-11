//
//  DigitTestingOperation.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingOperation.h"
#import <vector>
#import <math.h>

@implementation DigitTestingOperation {
	DigitSet mTrainingDigitSet;
	DigitSet mTestDigitSet;
	ClassificationRule _classificationRule;
}

- (void)main {
	[self weightTesting];
	
	[self didFinishTesting];
}

- (id)initWithTestDigitSet:(DigitSet)testDigitSet trainingDigitSet:(DigitSet)trainingDigitSet classificationRule:(ClassificationRule)classificationRule {
	self = [super init];
	
	if (self) {
		mTrainingDigitSet = trainingDigitSet;
		mTestDigitSet = testDigitSet;
		_classificationRule = classificationRule;
	}
	
	return self;
}

- (void)weightTesting {
	int digitIndex = 0;
	
	// go through all the digits and classify according to the weight decision rule
	for (auto it : mTestDigitSet.digits) {
		int classificationIndex = 0;
		double maxDotProduct = -DBL_MAX;
		
		for (int digitClassIndex = 0; digitClassIndex < NUMBER_OF_DIGIT_CLASSES; digitClassIndex++) {
			double dotProduct = 0;
			
			for (int row = 0; row < DIGIT_SIZE; row++) {
				for (int col = 0; col < DIGIT_SIZE; col++) {
					double featureWeight = it.featureWeight(row, col);
					double weight = mTrainingDigitSet.weightForIndexRowAndCol(digitClassIndex, row, col);
					
					dotProduct += featureWeight*weight;
				}
			}
			
			if (dotProduct > maxDotProduct) {
				maxDotProduct = dotProduct;
				classificationIndex = digitClassIndex;
			}
		}
		
		mTestDigitSet.digits[digitIndex].setDigitClass(classificationIndex);
		
		digitIndex++;
	}
}

- (void)bayesTesting {
	NSLog(@"weight testing");
	
	if ([self.delegate respondsToSelector:@selector(showProgressView)]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate showProgressView];
		});
	}
	
	unsigned long totalNumberOfDigits = mTestDigitSet.digits.size();
	
	// in order to avoid underflow, work with logs instead
	for (int digitIndex = 0; digitIndex < mTestDigitSet.digits.size(); digitIndex++) {
		for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
			double priorProbability = mTrainingDigitSet.priorProbabilityMap[classIndex];
			double logOfPriorProbability = log10(priorProbability);
			
			// MAP
			double maximumAPosterioriProbability = 0;
			mTestDigitSet.digits[digitIndex].setMaximumAPosterioriProbabilityForClassIndex(classIndex, maximumAPosterioriProbability);
			maximumAPosterioriProbability = mTestDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex) + logOfPriorProbability;
			mTestDigitSet.digits[digitIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumAPosterioriProbability);
			
			// ML (omit prior probability)
			double maximumLikelihoodProbability = 0;
			mTestDigitSet.digits[digitIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumLikelihoodProbability);
			
			for (int row = 0; row < DIGIT_SIZE; row++) {
				for (int col = 0; col < DIGIT_SIZE; col++) {
					double likelihood = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, classIndex);
					
					char pixelValue = mTestDigitSet.digits[digitIndex].pixelValue(row, col);
					
					if (pixelValue == ' ') {
						likelihood = (double)(1 - likelihood);
					}
					
					double logOfLikelihood = log10(likelihood);
					
					maximumAPosterioriProbability = mTestDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
					maximumLikelihoodProbability = mTestDigitSet.digits[digitIndex].maximumLikelihoodProbabilityForClassIndex(classIndex);
					
					mTestDigitSet.digits[digitIndex].setMaximumAPosterioriProbabilityForClassIndex(classIndex, maximumAPosterioriProbability + logOfLikelihood);
					mTestDigitSet.digits[digitIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumLikelihoodProbability + logOfLikelihood);
				}
			}
		}
		
		// classify the digits based on the most positive probability value
		double mostPositiveMaximumAPosterioriProbability = -DBL_MAX;
		double mostPositiveMaximumLikelihoodProbability = -DBL_MAX;
		
		int digitClass = -1;
		
		for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
			double maximumAPosterioriProbability = mTestDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
			double maximumLikelihoodProbability = mTestDigitSet.digits[digitIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
			
			if (_classificationRule == ClassificationRuleMaximumAPosteriori) {
				if (maximumAPosterioriProbability > mostPositiveMaximumAPosterioriProbability) {
					mostPositiveMaximumAPosterioriProbability = maximumAPosterioriProbability;
					digitClass = classIndex;
				}
			}
			
			else if (_classificationRule == ClassificationRuleMaximumLikelihood) {
				if (maximumLikelihoodProbability > mostPositiveMaximumLikelihoodProbability) {
					mostPositiveMaximumLikelihoodProbability = maximumLikelihoodProbability;
					digitClass = classIndex;
				}
			}
			
			mTestDigitSet.digits[digitIndex].setDigitClass(digitClass);
		}
		
		float progress = (float)digitIndex/(float)totalNumberOfDigits;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
}

- (void)didFinishTesting {
	if (self.digitTestingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.digitTestingOperationCompletionBlock(mTestDigitSet);
		});
	}
}

@end
