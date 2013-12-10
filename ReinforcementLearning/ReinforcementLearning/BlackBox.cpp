//
//  BlackBox.cpp
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "BlackBox.h"
#include <time.h>

using namespace std;

#define MAX_RANDOM_NUM 10

BlackBox::BlackBox() {};

BlackBox::BlackBox(double intendedProbability, double unintendedProbability):mIntendedProbability(intendedProbability), mUintendedProbability(unintendedProbability) {};

BlackBox::~BlackBox() {};

BlackBoxDirection BlackBox::actionForIntendedAction(BlackBoxDirection intendedAction) {
	BlackBoxDirection action;
	
	srand((unsigned int)time(NULL));
	
	int randomNumber = 1 + (rand() % MAX_RANDOM_NUM);
	
	BlackBoxDirection unintendedAction1 = BlackBoxDirection::BlackBoxDirectionUp;
	BlackBoxDirection unintendedAction2 = BlackBoxDirection::BlackBoxDirectionDown;
	
	if (intendedAction == BlackBoxDirection::BlackBoxDirectionUp) {
		unintendedAction1 = BlackBoxDirection::BlackBoxDirectionLeft;
		unintendedAction2 = BlackBoxDirection::BlackBoxDirectionRight;
	}
	
	else if (intendedAction == BlackBoxDirection::BlackBoxDirectionDown) {
		unintendedAction1 = BlackBoxDirection::BlackBoxDirectionRight;
		unintendedAction2 = BlackBoxDirection::BlackBoxDirectionLeft;
	}
	
	else if (intendedAction == BlackBoxDirection::BlackBoxDirectionLeft) {
		unintendedAction1 = BlackBoxDirection::BlackBoxDirectionUp;
		unintendedAction2 = BlackBoxDirection::BlackBoxDirectionDown;
	}
	
	else if (intendedAction == BlackBoxDirection::BlackBoxDirectionRight) {
		unintendedAction1 = BlackBoxDirection::BlackBoxDirectionDown;
		unintendedAction2 = BlackBoxDirection::BlackBoxDirectionUp;
	}
	
	if (randomNumber <= mIntendedProbability*MAX_RANDOM_NUM) {
		action = intendedAction;
	}
	
	else if (randomNumber <= (mIntendedProbability + mUintendedProbability)*MAX_RANDOM_NUM){
		action = unintendedAction1;
	}
	
	else {
		action = unintendedAction2;
	}
	
	return action;
}


