//
//  UIImage+TurboJPEG.h
//  Fellytone
//
//  Created by Ryhor Burakou on 10/9/13.
//  Copyright (c) 2013 Elinext. All rights reserved.
//

#import "UIImage+TurboJPEG.h"
#import "turbojpeg.h"

@implementation UIImage (TurboJPEG)

+(UIImage*)imageUsingTurboJpegWithContentsOfURL:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [self imageUsingTurboJpegWithData:data];
}

+(UIImage*)imageUsingTurboJpegWithContentsOfFile:(NSString *)file
{
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self imageUsingTurboJpegWithData:data];
}

+ (UIImage *)imageUsingTurboJpegWithData:(NSData*)data
{
    // decompress image (may be bigger than desired size)
    tjhandle handle = tjInitDecompress();
    
    uint8_t *buffer = malloc(data.length);
    [data getBytes:buffer length:data.length];
    
    //let's decompress header
    int width, height;
    tjDecompressHeader(handle, buffer, data.length, &width, &height);
    
    
    //invalid size
    if (width < 1 || height <1)
    {
        free(buffer);
        tjDestroy(handle);
        return nil;
    }
    
    
    CGSize imageSize = CGSizeMake(width, height);
    
    
    uint8_t *imageBuffer = malloc(imageSize.width * 4 * imageSize.height);
    int success = tjDecompress2(handle, buffer, data.length, imageBuffer, imageSize.width, imageSize.width * 4, imageSize.height, TJPF_BGRA, TJFLAG_FASTDCT);
    free(buffer);
    
    if (success < 0)
    {
        free(imageBuffer);
        tjDestroy(handle);
        return nil;
    }
    
    
    // Create CGImage from Buffer directly to avoid copy operation to context
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef rawImageDataProvider = CGDataProviderCreateWithData(nil, imageBuffer, imageSize.width * 4 * imageSize.height, MemoryPlaneReleaseDataCallback);
    CGImageRef image = CGImageCreate(imageSize.width, imageSize.height, 8, 8 * 4, imageSize.width * 4, colorspace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, rawImageDataProvider, NULL, YES, kCGRenderingIntentDefault);
    CGDataProviderRelease(rawImageDataProvider);
    CGColorSpaceRelease(colorspace);
    
    
    // scaling and orientation correction
    CGImageRef result = image;
    UIImage *finalImage = [UIImage imageWithCGImage:result];
    CGImageRelease(image);
    return finalImage;
}

//memory cleanup
static void MemoryPlaneReleaseDataCallback (void *info, const void *data, size_t size)
{
    free((void *)data);
}

static NSUInteger const kBytesPerPixel = 4;
static NSUInteger const kBitsPerComponent = 8;

+ (NSData *)JPEGRepresentationUsingTurboJpegFromUIImage:(UIImage *)image compressionQuality:(NSUInteger)compressionQuality
{
    if (compressionQuality > 100) {
        compressionQuality = 100;
    }
    
    CGImageRef imageRef = [image CGImage];
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    uint8_t *sourceData = calloc(imageHeight * imageWidth * kBytesPerPixel, sizeof(uint8_t));
    NSUInteger sourceBytesPerRow = kBytesPerPixel * imageWidth;
    
    CGContextRef context = CGBitmapContextCreate(sourceData, imageWidth, imageHeight,
                                                 kBitsPerComponent, sourceBytesPerRow, colorSpace,
                                                 kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    CGContextRelease(context);
    
    unsigned long jpegSize = 0;
    uint8_t *compressedImage = NULL;
    
    tjhandle handle = tjInitCompress();
    int result = tjCompress2(handle, sourceData, imageWidth, 0, imageHeight,
                             TJPF_RGBX, &compressedImage, &jpegSize,
                             TJSAMP_420, compressionQuality, TJFLAG_FASTDCT);
    
    NSData *data;
    if (result == 0) {
        data = [NSData dataWithBytes:compressedImage length:jpegSize];
    }
    
    tjDestroy(handle);
    if (compressedImage) {
        tjFree(compressedImage);
    }
    
    return data;
}

- (NSData *)JPEGRepresentationUsingTurboJpeg:(NSUInteger)compressionQuality
{
    return [UIImage JPEGRepresentationUsingTurboJpegFromUIImage:self compressionQuality:compressionQuality];
}

@end




