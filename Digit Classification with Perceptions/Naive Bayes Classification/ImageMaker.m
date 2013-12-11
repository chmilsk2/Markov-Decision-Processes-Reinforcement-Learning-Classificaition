//
//  ImageMaker.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/18/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "ImageMaker.h"

@implementation ImageMaker

+ (UIImage *)imageFromRawImageData:(unsigned char *)rawImageData width:(int)width height:(int)height numberOfColorComponents:(int)numberOfColorComponents bitsPerColorComponent:(int)bitsPerColorComponent {
	UIImage *image;

	int rawImageDataLength = width*height*numberOfColorComponents;
	BOOL interpolateAndSmoothPixels = NO;
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	 GLubyte *rawImageDataBuffer = rawImageData;
	
	CGDataProviderRef dataProviderRef;
	CGColorSpaceRef colorSpaceRef;
	CGImageRef imageRef;
	
	dataProviderRef = CGDataProviderCreateWithData(NULL, rawImageDataBuffer, rawImageDataLength, nil);
	colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	imageRef = CGImageCreate(width, height, bitsPerColorComponent, bitsPerColorComponent*numberOfColorComponents, width*numberOfColorComponents, colorSpaceRef, bitmapInfo, dataProviderRef, NULL, interpolateAndSmoothPixels, renderingIntent);
	image = [[UIImage alloc] initWithCGImage:imageRef];
	
	return image;
}

@end
