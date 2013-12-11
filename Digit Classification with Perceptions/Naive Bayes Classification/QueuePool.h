//
//  QueuePool.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueuePool : NSObject

@property NSOperationQueue *queue;

+ (QueuePool *)sharedQueuePool;

@end
