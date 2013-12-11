//
//  DigitLabelParser.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitLabelParser.h"
#include <fstream>
#include <vector>
#include <map>

DigitLabelParser::DigitLabelParser(const char * filePath):mFilePath(filePath) {}

DigitLabelParser::~DigitLabelParser() {}

DigitSet DigitLabelParser::parseDigitLabels() {
	DigitSet digitSet;
	
	map<int, int> frequencyMap;
	vector<int> digitLabels;
	
	string line;
	
	ifstream digitLabelFile(mFilePath);
	
	if (digitLabelFile.is_open()) {
		while (getline(digitLabelFile, line)) {
			int labelValue = atoi(line.c_str());
			
			if (frequencyMap.count(labelValue) == 0) {
				frequencyMap[labelValue] = 1;
			}
			
			else {
				frequencyMap[labelValue]++;
			}
			
			digitLabels.push_back(labelValue);
		}
	}
	
	digitSet.frequencyMap = frequencyMap;
	digitSet.digitLabels = digitLabels;
	
	return digitSet;
}