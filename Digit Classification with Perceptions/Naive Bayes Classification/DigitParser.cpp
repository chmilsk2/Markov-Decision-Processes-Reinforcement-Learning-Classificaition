
//
//  DigitParser.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitParser.h"
#include "Digit.h"
#include <fstream>

using namespace std;

DigitParser::DigitParser(const char * filePath):mFilePath(filePath) {}

DigitParser::~DigitParser() {}

void DigitParser::parseDigits(DigitSet &digitSet) {
	string line;
	
	ifstream digitsFile(mFilePath);
	
	int row = 0;
	
	if (digitsFile.is_open()) {
		while (getline(digitsFile, line)) {
			if (!row) {
				Digit digit;
				digitSet.digits.push_back(digit);
			}
			
			Digit digit = digitSet.digits.back();
			
			int col = 0;
			
			for (string::iterator it = line.begin(); it != line.end(); ++it) {
				char value = *it;
							
				digit.setPixelValue(row, col, value);
				
				int componentValues[NUMBER_OF_COLOR_COMPONENTS];
				
				RGBValuesForValue(value, componentValues);
				
				digit.setImageBufferRGBForRowCol(componentValues[0], componentValues[1], componentValues[2], row, col);
				
				col++;
			}
			
			digitSet.digits.back() = digit;
			
			if (row == DIGIT_SIZE - 1) {
				row = 0;
			}
			
			else {
				row++;
			}
		}
	}
}

void DigitParser::RGBValuesForValue(char value, int componentValues[NUMBER_OF_COLOR_COMPONENTS]) {
	int red = 0;
	int green = 0;
	int blue = 0;
	
	// add pixel colors to image buffer
	if (value == '#') {
		red = 0;
		green = 0;
		blue = 0;
	}
	
	else if (value == '+') {
		red = 130;
		green = 130;
		blue = 130;
	}
	
	else if (value == ' ') {
		red = 255;
		green = 255;
		blue = 255;
	}
	
	componentValues[0] = red;
	componentValues[1] = green;
	componentValues[2] = blue;
}

