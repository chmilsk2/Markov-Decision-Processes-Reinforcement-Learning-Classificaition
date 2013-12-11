//
//  DigitParser.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__DigitParser__
#define __Naive_Bayes_Classification__DigitParser__

#include <iostream>
#include "DigitSet.h"
#include <vector>
#include <map>

using namespace std;

class DigitParser {
	public:
		DigitParser(const char *);
		~DigitParser();
		void parseDigits(DigitSet &digitSet);
		
	private:
		const char *mFilePath;
		void RGBValuesForValue(char value, int componentValues[NUMBER_OF_COLOR_COMPONENTS]);
};

#endif /* defined(__Naive_Bayes_Classification__DigitParser__) */
