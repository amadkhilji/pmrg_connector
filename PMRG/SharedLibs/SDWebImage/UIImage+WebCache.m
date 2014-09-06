//
//  UIImage+WebCache.m
//  ChatApplication
//
//  Created by AmadKhilji on 3/6/13.
//  Copyright (c) 2013 Bridgegate Studios. All rights reserved.
//

#import "UIImage+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImage (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        self = cachedImage;
    }
    else
    {
        if (placeholder)
        {
            self = placeholder;
        }
        
        [manager downloadWithURL:url delegate:self];
    }
}

#pragma mark SDWebImageManagerDelegate Method

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self = image;
    
}

@end
