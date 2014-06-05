//
//  TJHelper.h
//  Fellytone
//
//  Created by Ryhor Burakou on 10/9/13.
//  Copyright (c) 2013 Elinext. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (TurboJPEG)

/**
 * Create a UIImage from an NSData using Turbo-JPEG library
 *
 * @param data the JPEG data, desired to be decompressed
 *
 * @return an autoreleased instance of UIImage, if successfull, nil otherwise
 */

+ (UIImage*)imageUsingTurboJpegWithContentsOfURL:(NSURL *)url;
+ (UIImage*)imageUsingTurboJpegWithContentsOfFile:(NSString *)file;
+ (UIImage*)imageUsingTurboJpegWithData:(NSData *)data;

+ (NSData *)JPEGRepresentationUsingTurboJpegFromUIImage:(UIImage *)image compressionQuality:(NSUInteger)compressionQuality;
- (NSData *)JPEGRepresentationUsingTurboJpeg:(NSUInteger)compressionQuality;

@end