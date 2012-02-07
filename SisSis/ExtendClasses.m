//
//  ExtendClasses.m
//  SisSis
//
//  Created by 直毅 江川 on 12/02/05.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "ExtendClasses.h"

@implementation UIImage (Extras)

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  
  CGFloat scaleFactor = 0.0f;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  
  CGPoint thumbnailPoint = CGPointMake(0.0f, 0.0f);
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if (widthFactor < heightFactor) {
      scaleFactor = widthFactor;
    } else {
      scaleFactor = heightFactor;
    }
    
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    if (widthFactor < heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5f; 
    } else if (widthFactor > heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5f;
    }
  }
  
  // this is actually the interesting part:
  UIGraphicsBeginImageContext(targetSize);
  
  [[UIColor blackColor] set];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextFillRect(context, CGRectMake(0.0f, 0.0f, targetWidth, targetHeight));
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  if (newImage == nil) NSLog(@"could not scale image");
  
  return newImage ;
}
@end
