//
//  DigitLabelParser.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__DigitLabelParser__
#define __Naive_Bayes_Classification__DigitLabelParser__

#include "DigitSet.h"
#include <iostream>

using namespace std;

class DigitLabelParser {
	public:
		DigitLabelParser(const char *filePath);
		~DigitLabelParser();
		DigitSet parseDigitLabels();
	private:
		const char *mFilePath;
};

#endif /* defined(__Naive_Bayes_Classification__DigitLabelParser__) */
