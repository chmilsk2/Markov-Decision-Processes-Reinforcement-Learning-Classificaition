//
//  OddsRatio.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/19/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "OddsRatio.h"
#include <math.h>

#pragma mark - Public

OddsRatio::OddsRatio() {};

OddsRatio::~OddsRatio() {};

#pragma mark - First Digit Class

int OddsRatio::firstDigitClass() {
	return mFirstDigitClass;
}

void OddsRatio::setFirstDigitClass(int digitClass) {
	mFirstDigitClass = digitClass;
}

#pragma mark - Second Digit Class

int OddsRatio::secondDigitClass() {
	return mSecondDigitClass;
}

void OddsRatio::setSecondDigitClass(int digitClass) {
	mSecondDigitClass = digitClass;
}

#pragma mark - Image Buffers

unsigned char * OddsRatio::imageBufferForType(OddsRatioType oddsRatioType) {
	unsigned char *imageBuffer = NULL;
	
	if (oddsRatioType == OddsRatioTypeLikelihood1) {
		imageBuffer = mFirstLikelihoodImageBuffer;
	}
	
	else if (oddsRatioType == OddsRatioTypeLikelihood2) {
		imageBuffer = mSecondLikelihoodImageBuffer;
	}
	
	else if (oddsRatioType == OddsRatioTypeRatio) {
		imageBuffer = mOddsRatioImageBuffer;
	}
	
	return imageBuffer;
}

#pragma mark - RGB Values for Likelihood

void OddsRatio::RGBValuesForLogLikelihood(double logLikelihood, int componentValues[NUMBER_OF_COLOR_COMPONENTS], double mostNegativeLogValue, double mostPositiveLogValue) {
	// normalize the value between 0 and 1
	double normalizedValue = normalizedValueWithRange(logLikelihood, mostNegativeLogValue, mostPositiveLogValue);
	
	int *r = new int;
	int *g = new int;
	int *b = new int;
	
	heatMapColor((float)normalizedValue, r, g, b);
	
	int red = *r;
	int green = *g;
	int blue = *b;
	
	componentValues[0] = red;
	componentValues[1] = green;
	componentValues[2] = blue;
	
	delete r;
	delete g;
	delete b;
}

void OddsRatio::setImageBufferRGBForRowColAndType(int r, int g, int b, int row, int col, OddsRatioType oddsRatioType) {
	int offset = (row*(DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER)*DIGIT_SIZE_MULTIPLIER + col*DIGIT_SIZE_MULTIPLIER)*NUMBER_OF_COLOR_COMPONENTS;
	
	// only consider image scale size of 1 for now
	int redOffset = 0;
	int greenOffset = 1;
	int blueOffset = 2;
	
	for (int row = 0; row < DIGIT_SIZE_MULTIPLIER; row++) {
		int priorOffset = offset;
		
		for (int col = 0; col < DIGIT_SIZE_MULTIPLIER; col++) {
			if (oddsRatioType == OddsRatioTypeLikelihood1) {
				mFirstLikelihoodImageBuffer[offset+redOffset] = r;
				mFirstLikelihoodImageBuffer[offset+greenOffset] = g;
				mFirstLikelihoodImageBuffer[offset+blueOffset] = b;
			}
			
			else if (oddsRatioType == OddsRatioTypeLikelihood2) {
				mSecondLikelihoodImageBuffer[offset+redOffset] = r;
				mSecondLikelihoodImageBuffer[offset+greenOffset] = g;
				mSecondLikelihoodImageBuffer[offset+blueOffset] = b;
			}
			
			else if (oddsRatioType == OddsRatioTypeRatio) {
				mOddsRatioImageBuffer[offset+redOffset] = r;
				mOddsRatioImageBuffer[offset+greenOffset] = g;
				mOddsRatioImageBuffer[offset+blueOffset] = b;
			}
			
			offset += NUMBER_OF_COLOR_COMPONENTS;
		}
		
		offset = priorOffset;
		offset += DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS;
	}
}

#pragma mark - Private

#pragma mark - Heat Map Color

void OddsRatio::heatMapColor(float value, int *red, int *green, int *blue) {
	const int numColors = 5;
	const int numColorComponents = 3;
	
	// A static array of 5 colors:  (blue, cyan, green, yellow, red) using {r,g,b} for each.
	static float color[numColors][numColorComponents] = { {0,0,1}, {0,1,1}, {0,1,0}, {1,1,0}, {1,0,0} };
	
	// desired color will be between these two indices in the color array
	int index1;
	int index2;
	
	// fraction between index 1 and index 2 where the desired value is
	float fractionBetween = 0;
	
	// accounts for inputs <= 0
	if (value <= 0) {
		index1 = index2 = 0;
	}
	
	// accounts for inputs >= 1
	else if (value >= 1) {
		index1 = index2 = numColors - 1;
	}
	
	else {
		value = value * (numColors - 1);
		
		// desired color will be after this index
		index1 = floor(value);
		
		// desired color will be before this index
		index2 = index1 + 1;
		
		// distance between the two indices (0-1)
		fractionBetween = value - float(index1);
	}
	
	float r = (color[index2][0] - color[index1][0])*fractionBetween + color[index1][0];
	float g = (color[index2][1] - color[index1][1])*fractionBetween + color[index1][1];
	float b = (color[index2][2] - color[index1][2])*fractionBetween + color[index1][2];
	
	*red = (int)(r*255);
	*green = (int)(g*255);
	*blue = (int)(b*255);
}

#pragma mark - Normalized Value

double OddsRatio::normalizedValueWithRange(double value, double mostNegativeValue, double mostPositiveValue) {
	double normalizedValue = 0;
	
	// norm_data = (value - min(value)) / (max(value) - min(value))
	normalizedValue = (value - mostNegativeValue)/(mostPositiveValue - mostNegativeValue);
	
	return normalizedValue;
}
