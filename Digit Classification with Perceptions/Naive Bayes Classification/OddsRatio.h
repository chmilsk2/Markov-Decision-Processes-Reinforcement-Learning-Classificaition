//
//  OddsRatio.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/19/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__OddsRatio__
#define __Naive_Bayes_Classification__OddsRatio__

#include <iostream>
#include <map>

using namespace std;

enum OddsRatioType {
	OddsRatioTypeLikelihood1,
	OddsRatioTypeLikelihood2,
	OddsRatioTypeRatio
};

class OddsRatio {
	int mFirstDigitClass;
	int mSecondDigitClass;
	
	// image buffer is of type unsigned char since the size of unsigned char is 8 bits RGB8 represents each color component with 8 bits, this custom format ignores the alpha component, normally the typical format is RGBA8 which is 32 bits in size due to the 4 8 bit components
	unsigned char mFirstLikelihoodImageBuffer[DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS];
	unsigned char mSecondLikelihoodImageBuffer[DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS];
	unsigned char mOddsRatioImageBuffer[DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS];
	
	public:
		OddsRatio();
		~OddsRatio();
	
		// first digit class
		int firstDigitClass();
		void setFirstDigitClass(int digitClass);
	
		// second digit class
		int secondDigitClass();
		void setSecondDigitClass(int digitClass);
	
		// RGB values for likelihood
		void RGBValuesForLogLikelihood(double logLikelihood, int componentValues[NUMBER_OF_COLOR_COMPONENTS], double mostNegativeLogValue, double mostPositiveLogValue);
	
		// image buffers
		unsigned char *imageBufferForType(OddsRatioType oddsRatioType);
		void setImageBufferRGBForRowColAndType(int r, int g, int b, int row, int col, OddsRatioType oddsRatioType);
	
	private:
		void heatMapColor(float value, int *red, int *green, int *blue);
		double normalizedValueWithRange(double value, double mostNegativeValue, double mostPositiveValue);
};

#endif /* defined(__Naive_Bayes_Classification__OddsRatio__) */
