//
//  AgentView.m
//  ReinforcementLearning
//
//  Created by Troy Chmieleski on 12/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "AgentView.h"

@implementation AgentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        self.alpha = 0.5;
		[self setBackgroundColor:[UIColor blueColor]];
    }
	
    return self;
}

@end
