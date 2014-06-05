UIImage+TurboJPEG
=================


This is a simple category on UIImage that allows to load a JPEG from NSData using Turbo-JPEG library, instead of standard iOS imaging methods.

Usage is simple, like this:


NSData *jpegData = ...

UIImage *image = [UIImage imageUsingTurboJpegWithData:jpegData];


=================
Important credits

Based on the code by: https://github.com/ryhor/uiimage-turbojpeg
