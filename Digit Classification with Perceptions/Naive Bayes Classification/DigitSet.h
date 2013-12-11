//
//  DigitSet.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__DigitSet__
#define __Naive_Bayes_Classification__DigitSet__

#include <iostream>
#include <vector>
#include <map>
#include "Digit.h"

using namespace std;

class DigitSet {
	int mBitShiftSize;
	int mEpoch = 0;
	double mWeightVector[NUMBER_OF_DIGIT_CLASSES][DIGIT_SIZE][DIGIT_SIZE];
	
	public:
		DigitSet();
		~DigitSet();
	
		// epoch
		double epoch();
	
		void setEpoch(double epoch);
	
		// zero out weight vectors
		void zeroOutWeightVectors();
	
		// set weights
		double weightForIndexRowAndCol(int index, int row, int col);
	
		void setWeightForIndexRowAndCol(int index, int row, int col, double weight);
	
		// class frequency
		int frequencyForClassIndex(int classIndex);
	
		// pixel frequency
		map<int, int> pixelFrequencyMapForClassIndex(int classIndex);
		void updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, Digit digit, int classIndex);
		int pixelFrequencyForRowColumnAndClassIndex(int row, int col, int classIndex);
	
		// prior probabilities
		void updatePriorProbabilityForClassIndex(int classIndex);
	
		// likelihoood
		map<int, double> likelihoodMapForClassIndex(int classIndex);
		void updateLikelihoodMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex, double likelihood);
		double likelihoodForRowColumnAndClassIndex(int row, int col, int classIndex);
	
		// bit shift size
		void setBitShiftSizeUsingDigitSize(int digitSize);
	
		// logging
		void printFrequencyMap();
		void printPixelFrequencyMaps();
		void printLikelihoodMaps();
		void printPrototypicalMaximumAPosterioriDigitIndexMap();
		void printPrototypicalMaximumLikelihoodDigitIndexMap();
	
		// digit label
		vector<int> digitLabels;
	
		// need digit vector to display digits in the the collection view
		vector<Digit> digits;
	
		// frequency map keeps track of the # of instances from each class
		map<int, int> frequencyMap;
	
		// pixel frequency maps keeps track of the pixel frequency map for each class
		map<int, map<int, int>> pixelFrequencyMaps;
	
		// prior probabilities for each class in the training set
		map<int, double> priorProbabilityMap;
	
		// likelihood maps keep track of P(Fij | class) for every pixel location (i,j) and for every digit class from 0 to 9
		map<int, map<int, double>> likelihoodMaps;
	
		// feature likelihood image buffer for class index
		unsigned char * featureLikelihoodImageBufferForClassIndex(int classIndex);
	
		// prototypical MAP digit index map
		map<int, int> prototypicalMaximumAPosterioriDigitIndexMap;
	
		// protypical ML digit index map
		map<int, int> prototypicalMaximumLikelihoodDigitIndexMap;
	
	private:
		int pixelIndexForRowAndColumn(int row, int col);
};

#endif /* defined(__Naive_Bayes_Classification__DigitSet__) */
