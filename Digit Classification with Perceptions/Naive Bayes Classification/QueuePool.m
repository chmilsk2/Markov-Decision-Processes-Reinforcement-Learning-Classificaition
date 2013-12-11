//
//  QueuePool.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "QueuePool.h"

@implementation QueuePool

+ (QueuePool *)sharedQueuePool {
	static QueuePool *sharedQueuePool;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedQueuePool = [[QueuePool alloc] init];
	});
	
	return sharedQueuePool;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_queue = [[NSOperationQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
	}
	
	return self;
}

@end
