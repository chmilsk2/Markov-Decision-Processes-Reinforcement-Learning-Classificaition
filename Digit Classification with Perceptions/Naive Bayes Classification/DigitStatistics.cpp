//
//  DigitStatistics.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitStatistics.h"
#include <algorithm>
#include <iomanip>
#include <float.h>

#define DIGIT_LENGTH 3

typedef struct ConfusionItem {
	int row;
	int col;
	double confusionRate;
	
	bool operator < (const ConfusionItem &confusionItem) const {
        return (confusionItem.confusionRate < confusionRate);
    }
} ConfusionItem;

DigitStatistics::DigitStatistics() {};

DigitStatistics::~DigitStatistics() {};

#pragma mark - Overall Success Rate 

double DigitStatistics::overallSuccessRate() {
	return mOverallSuccessRate;
}

void DigitStatistics::setOverallSuccessRate(double overallSuccessRate) {
	mOverallSuccessRate = overallSuccessRate;
}

#pragma mark - Success Rates

double DigitStatistics::successRateForClassIndex(int classIndex) {
	double successRate = mSuccessRates[classIndex];
	
	return successRate;
}

void DigitStatistics::setSuccessRateForClassIndex(int classIndex, double successRate) {
	mSuccessRates[classIndex] = successRate;
}

#pragma mark - Confusion Matrix

double DigitStatistics::confusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC) {
	double confusionRate = mConfusionMatrix[classIndexR][classIndexC];
	
	return confusionRate;
}

void DigitStatistics::setConfusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC, double confusionRate) {
	mConfusionMatrix[classIndexR][classIndexC] = confusionRate;
}

vector<pair<int, int>> DigitStatistics::nHighestConfusionPairs(int n) {
	vector<pair<int, int>> highestConfusionPairs;
	
	vector<ConfusionItem> highestConfusionItems;
	
	for (int i = 0; i < n; i++) {
		ConfusionItem confusionItem;
		confusionItem.row = -1;
		confusionItem.col = -1;
		confusionItem.confusionRate = -DBL_MAX;
		highestConfusionItems.push_back(confusionItem);
	}
	
	for (int row = 0; row < NUMBER_OF_DIGIT_CLASSES; row++) {
		for (int col = 0; col < NUMBER_OF_DIGIT_CLASSES; col++) {
			if (row != col) {
				double confusionRate = mConfusionMatrix[row][col];
				
				if (confusionRate > 0 && confusionRate > highestConfusionItems.back().confusionRate) {
					highestConfusionItems.back().row = row;
					highestConfusionItems.back().col = col;
					highestConfusionItems.back().confusionRate = confusionRate;
				}
				
				// sort the confusion rates from highest to lowest
				sort(highestConfusionItems.begin(), highestConfusionItems.end());
			}
		}
	}
	
	for (auto it : highestConfusionItems) {
		pair<int, int> pair(it.row, it.col);
		highestConfusionPairs.push_back(pair);
	}
	
	return highestConfusionPairs;
}

#pragma mark - Logging

void DigitStatistics::printSuccessRates() {
	cout << "--- Success Rates ---" << endl;
	cout << endl;
	
	for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
		cout << classIndex << ": " << setprecision(DIGIT_LENGTH) << mSuccessRates[classIndex] << endl;
	}
	
	cout << endl;
}

void DigitStatistics::printConfusionMatrix() {
	cout << "--- Confusion Matrix ---" << endl;
	cout << endl;
	
	for (int i = 0; i < DIGIT_LENGTH; i++) {
		cout << " ";
	}
	
	for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
		cout << classIndexC;
		
		for (int i = 0; i < DIGIT_LENGTH*2; i++) {
			cout << " ";
		}
	}
	
	cout << endl;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		cout << classIndexR << ": ";
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			printf("%.2f", mConfusionMatrix[classIndexR][classIndexC]);
			
			for (int i = 0; i < DIGIT_LENGTH; i++) {
				cout << " ";
			}
		}
		
		cout << endl;
	}
	
	cout << endl;
}

void DigitStatistics::printOverallSuccessRate() {
	cout << "--- Overall Success Rate ---" << endl;
	cout << endl;
	
	printf("%.2f\n\n", mOverallSuccessRate);
}






