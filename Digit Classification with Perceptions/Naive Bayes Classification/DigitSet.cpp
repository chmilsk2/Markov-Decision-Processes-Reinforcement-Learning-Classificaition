//
//  DigitSet.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitSet.h"
#include <math.h>

#pragma mark - Public Functions

DigitSet::DigitSet() {}

DigitSet::~DigitSet() {}

void DigitSet::setBitShiftSizeUsingDigitSize(int digitSize) {
	// compute the number of bits necessary to represent the digitSize
	int bitShiftSize = 0;
	
	if (digitSize != 0) {
		int exponent = 0;
		int divisor = pow(2, exponent);
		bool shouldContinue = true;
		
		while (shouldContinue) {
			if (digitSize/divisor >= 1) {
				exponent++;
				divisor = pow(2, exponent);
			}
			
			else {
				shouldContinue = false;
				bitShiftSize = exponent;
			}
		}
	}
	
	mBitShiftSize = bitShiftSize;
}

#pragma mark - Frequency

int DigitSet::frequencyForClassIndex(int classIndex) {
	int frequency = frequencyMap[classIndex];
	
	return frequency;
}

#pragma mark - Pixel Frequency

map<int, int> DigitSet::pixelFrequencyMapForClassIndex(int classIndex) {
	map<int, int> pixelFrequencyMap = pixelFrequencyMaps[classIndex];
	
	return pixelFrequencyMap;
}

void DigitSet::updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, Digit digit, int classIndex) {
	char pixelValue = digit.pixelValue(row, col);
	
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	if (pixelFrequencyMaps[classIndex].find(pixelIndex) == pixelFrequencyMaps[classIndex].end()) {
		pixelFrequencyMaps[classIndex][pixelIndex] = 0;
	}
	
	if (pixelValue == '+' || pixelValue == '#') {
		pixelFrequencyMaps[classIndex][pixelIndex]++;
	}
}

int DigitSet::pixelFrequencyForRowColumnAndClassIndex(int row, int col, int classIndex) {
	int pixelFrequency = 0;
	
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	pixelFrequency = pixelFrequencyMaps[classIndex][pixelIndex];
	
	return pixelFrequency;
}

#pragma mark - Prior Probabilities

void DigitSet::updatePriorProbabilityForClassIndex(int classIndex) {
	int numberOfExamplesInTrainingSetForClass = frequencyMap[classIndex];
	unsigned long totalNumberOfExamplesInTrainingSet = digits.size();
	
	double priorProbability = (double)numberOfExamplesInTrainingSetForClass/(double)totalNumberOfExamplesInTrainingSet;
	priorProbabilityMap[classIndex] = priorProbability;
}

#pragma mark - Likelihood Probabilities

void DigitSet::updateLikelihoodMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex, double likelihood) {
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	if (likelihoodMaps[classIndex].find(pixelIndex) == likelihoodMaps[classIndex].end()) {
		likelihoodMaps[classIndex][pixelIndex] = 0;
	}
	
	likelihoodMaps[classIndex][pixelIndex] = likelihood;
}

double DigitSet::likelihoodForRowColumnAndClassIndex(int row, int col, int classIndex) {
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	double likelihood = likelihoodMaps[classIndex][pixelIndex];
	
	return likelihood;
}

#pragma mark - Pixel Index

int DigitSet::pixelIndexForRowAndColumn(int row, int col) {
	int pixelIndex = (row << mBitShiftSize) + col;
	
	return pixelIndex;
}

void DigitSet::printFrequencyMap() {
	int total = 0;
	
	for (map<int, int>::iterator it = frequencyMap.begin(); it != frequencyMap.end(); it++) {
		cout << it->first << " => " << it->second << endl;
		
		total += it-> second;
	}
	
	cout << "total: " << total << endl;
	cout << endl;
}

void DigitSet::printPixelFrequencyMaps() {
	for (map<int, map<int, int>>::iterator pixelFrequencyMapsIterator = pixelFrequencyMaps.begin(); pixelFrequencyMapsIterator != pixelFrequencyMaps.end(); pixelFrequencyMapsIterator++) {
		map<int, int> pixelFrequencyMap = pixelFrequencyMapsIterator->second;
		
		for (map<int, int>::iterator pixelFrequencyMapIterator = pixelFrequencyMap.begin(); pixelFrequencyMapIterator != pixelFrequencyMap.end();
			 pixelFrequencyMapIterator++) {
			cout << pixelFrequencyMapsIterator->first << ": " << pixelFrequencyMapIterator->first << ": " << pixelFrequencyMapIterator->second << endl;
		}
	}
	
	cout << endl;
}

void DigitSet::printLikelihoodMaps() {
	for (map<int, map<int, double>>::iterator likelihoodMapsIterator = likelihoodMaps.begin(); likelihoodMapsIterator != likelihoodMaps.end(); likelihoodMapsIterator++) {
		map<int, double> likelihoodMap = likelihoodMapsIterator->second;
		
		for (map<int, double>::iterator likelihoodMapIterator = likelihoodMap.begin(); likelihoodMapIterator != likelihoodMap.end(); likelihoodMapIterator++) {
			cout << likelihoodMapsIterator->first << ": " << likelihoodMapIterator->first << ": " << likelihoodMapIterator->second << endl;
		}
	}
	
	cout << endl;
}

void DigitSet::printPrototypicalMaximumAPosterioriDigitIndexMap() {
	for (auto it : prototypicalMaximumAPosterioriDigitIndexMap) {
		cout << it.first << ": " << it.second << endl;
	}
	
	cout << endl;
}


void DigitSet::printPrototypicalMaximumLikelihoodDigitIndexMap() {
	for (auto it : prototypicalMaximumLikelihoodDigitIndexMap) {
		cout << it.first << ": " << it.second << endl;
	}
	
	cout << endl;
}