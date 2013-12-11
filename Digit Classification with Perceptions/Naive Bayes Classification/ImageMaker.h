//
//  ImageMaker.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/18/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMaker : NSObject

+ (UIImage *)imageFromRawImageData:(unsigned char *)rawImageData width:(int)width height:(int)height numberOfColorComponents:(int)numberOfColorComponents bitsPerColorComponent:(int)bitsPerColorComponent;

@end
