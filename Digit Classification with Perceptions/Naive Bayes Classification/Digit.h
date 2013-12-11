//
//  Digit.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__Digit__
#define __Naive_Bayes_Classification__Digit__

#include <iostream>
#include <map>

using namespace std;

enum ClassificationType {
	ClassificationTypeNone,
	ClassificationTypeCorrect,
	ClassificationTypeIncorrect
};

class Digit {
	// image buffer is of type unsigned char since the size of unsigned char is 8 bits RGB8 represents each color component with 8 bits, this custom format ignores the alpha component, normally the typical format is RGBA8 which is 32 bits in size due to the 4 8 bit components
	unsigned char mImageBuffer[DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*DIGIT_SIZE*DIGIT_SIZE_MULTIPLIER*NUMBER_OF_COLOR_COMPONENTS];
	int mDigitClass;
	char mPixels[DIGIT_SIZE][DIGIT_SIZE];
	map<int, double> mMaximumAPosterioriMap;
	map<int, double> mMaximumLikelihoodMap;
	ClassificationType mClassificationType;
	
	public:
		Digit();
		~Digit();
	
		// feature weight
		int featureWeight(int row, int col);
	
		// image buffer
		unsigned char *imageBuffer();
		void setImageBufferRGBForRowCol(int r, int g, int b, int row, int col);
	
		// digit class
		int digitClass();
		void setDigitClass(int digitClass);
	
		// pixel value
		char pixelValue(int row, int col);
		void setPixelValue(int row, int col, char value);
	
		// classification type
		ClassificationType classificationType();
		void setClassificationType(ClassificationType classificationType);
	
		// MAP classification
		double maximumAPosterioriProbabilityForClassIndex(int classIndex);
		void setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability);
	
		// ML classification
		double maximumLikelihoodProbabilityForClassIndex(int classIndex);
		void setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability);
	
		// logging
		void printDigit();
		void printMaximumAPosterioriMap();
		void printMaximumLikelihoodMap();
};

#endif /* defined(__Naive_Bayes_Classification__Digit__) */
