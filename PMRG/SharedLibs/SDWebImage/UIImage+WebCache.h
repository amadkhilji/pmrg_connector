//
//  UIImage+WebCache.h
//  ChatApplication
//
//  Created by AmadKhilji on 3/6/13.
//  Copyright (c) 2013 Bridgegate Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"

@interface UIImage (WebCache) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
