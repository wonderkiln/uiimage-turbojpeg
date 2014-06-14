//
//  TJHelper.h
//  Fellytone
//
//  Created by Ryhor Burakou on 10/9/13.
//  Copyright (c) 2013 Elinext. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Chrominance subsampling options.
 * When an image is converted from the RGB to the YCbCr colorspace as part of
 * the JPEG compression process, some of the Cb and Cr (chrominance) components
 * can be discarded or averaged together to produce a smaller image with little
 * perceptible loss of image clarity (the human eye is more sensitive to small
 * changes in brightness than small changes in color.)  This is called
 * "chrominance subsampling".
 * <p>
 * NOTE: Technically, the JPEG format uses the YCbCr colorspace, but per the
 * convention of the digital video community, the TurboJPEG API uses "YUV" to
 * refer to an image format consisting of Y, Cb, and Cr image planes.
 */
typedef NS_ENUM(NSUInteger, TurboJPEGSampling)
{
    /**
     * 4:4:4 chrominance subsampling (no chrominance subsampling).  The JPEG or
     * YUV image will contain one chrominance component for every pixel in the
     * source image.
     */
    TurboJPEGSAMP_444=0,
    /**
     * 4:2:2 chrominance subsampling.  The JPEG or YUV image will contain one
     * chrominance component for every 2x1 block of pixels in the source image.
     */
    TurboJPEGSAMP_422,
    /**
     * 4:2:0 chrominance subsampling.  The JPEG or YUV image will contain one
     * chrominance component for every 2x2 block of pixels in the source image.
     */
    TurboJPEGSAMP_420,
    /**
     * Grayscale.  The JPEG or YUV image will contain no chrominance components.
     */
    TurboJPEGSAMP_GRAY,
    /**
     * 4:4:0 chrominance subsampling.  The JPEG or YUV image will contain one
     * chrominance component for every 1x2 block of pixels in the source image.
     * Note that 4:4:0 subsampling is not fully accelerated in libjpeg-turbo.
     */
    TurboJPEGSAMP_440
};

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

/**
 * Create a NSData from an UIImage using Turbo-JPEG library
 *
 * @param image the UIImage, desired to be compressed
 * @param compressionQuality for the compression, between 0 and 100
 * @param sampling TurboJPEGSampling for the compression
 *
 * @return an autoreleased instance of NSData, if successfull, nil otherwise
 */
+ (NSData *)JPEGRepresentationUsingTurboJpegFromUIImage:(UIImage *)image compressionQuality:(NSUInteger)compressionQuality sampling:(TurboJPEGSampling)sampling;
- (NSData *)JPEGRepresentationUsingTurboJpeg:(NSUInteger)compressionQuality sampling:(TurboJPEGSampling)sampling;

@end