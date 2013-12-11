//
//  Digit.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Digit.h"
#include <math.h>
#include <float.h>

using namespace std;

Digit::Digit() {
	// -1 means the digit class has not yet been classified
	mDigitClass = -1;
	mClassificationType = ClassificationTypeNone;
}

Digit::~Digit() {}

#pragma mark - Image Buffer

unsigned char * Digit::imageBuffer() {
	return mImageBuffer;
}

void Digit::setImageBufferRGBForRowCol(int r, int g, int b, int row, int col) {
	// using row major order: offset = row*NUMCOLS + column
	int offset = (row*(DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER)*DIGIT_SIZE_MULTIPLIER + col*DIGIT_SIZE_MULTIPLIER)*NUMBER_OF_COLOR_COMPONENTS;
	
	// only consider image scale size of 1 for now
	int redOffset = 0;
	int greenOffset = 1;
	int blueOffset = 2;
	
	for (int row = 0; row < DIGIT_SIZE_MULTIPLIER; row++) {
		int priorOffset = offset;
		
		for (int col = 0; col < DIGIT_SIZE_MULTIPLIER; col++) {
			mImageBuffer[offset+redOffset] = r;
			mImageBuffer[offset+greenOffset] = g;
			mImageBuffer[offset+blueOffset] = b;
			
			offset += NUMBER_OF_COLOR_COMPONENTS;
		}
		
		offset = priorOffset;
		offset += DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS;
	}
}

#pragma mark - Digit Class

int Digit::digitClass() {
	return mDigitClass;
}

void Digit::setDigitClass(int digitClass) {
	mDigitClass = digitClass;
}

#pragma mark - Pixel Values

char Digit::pixelValue(int row, int col) {
	char pixelChar = mPixels[row][col];
	return pixelChar;
}

void Digit::setPixelValue(int row, int col, char value) {
	mPixels[row][col] = value;
}

#pragma mark - Digit Classification

ClassificationType Digit::classificationType() {
	return mClassificationType;
}

void Digit::setClassificationType(ClassificationType classificationType) {
	mClassificationType = classificationType;
}

#pragma mark - Maximum A Posteriori

double Digit::maximumAPosterioriProbabilityForClassIndex(int classIndex) {
	return mMaximumAPosterioriMap[classIndex];
}

void Digit::setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability) {
	mMaximumAPosterioriMap[classIndex] = maximumAPosterioiProbability;
}

#pragma mark - Maximum Likelihood

double Digit::maximumLikelihoodProbabilityForClassIndex(int classIndex) {
	return mMaximumLikelihoodMap[classIndex];
}

void Digit::setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability) {
	mMaximumLikelihoodMap[classIndex] = maximumLikelihoodProbability;
}

#pragma mark - Logging

void Digit::printDigit() {
	for (int row = 0; row < DIGIT_SIZE; row++) {
		for (int col = 0; col < DIGIT_SIZE; col++) {
			cout << pixelValue(row, col) << " ";
		}
		
		cout << endl;
	}
}

void Digit::printMaximumAPosterioriMap() {
	for (map<int, double>::iterator it = mMaximumAPosterioriMap.begin(); it != mMaximumAPosterioriMap.end(); it++) {
		cout << it->first << ": " << it->second << endl;
	}
}

void Digit::printMaximumLikelihoodMap() {
	for (map<int, double>::iterator it = mMaximumLikelihoodMap.begin(); it != mMaximumLikelihoodMap.end(); it++) {
		cout << it->first << ": " << it->second;
	}
}
