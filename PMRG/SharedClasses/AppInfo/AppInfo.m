//
//  AppInfo.m
//  PMRG
//
//  Created by SSASOFT on 8/17/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo ()

-(void)loadIntroBackgroundImage;

@end

@implementation AppInfo

static AppInfo *singletonInstance;
+(AppInfo*)sharedInfo {
    
    @synchronized ([AppInfo class]) {
        
        if (!singletonInstance) {
            singletonInstance = [[AppInfo alloc] init];
        }
    }
    
    return singletonInstance;
}

+(id)alloc {
    
    @synchronized ([AppInfo class]) {
        
        NSAssert(singletonInstance == nil, @"Error, trying to allocate another instance of singleton class.");
        return [super alloc];
    }
}

-(id)init {
    
    if (self = [super init]) {
        
        imageType = IntroBackgroundImage1;
        [self loadIntroBackgroundImage];
    }
    
    return self;
}

-(void)loadIntroBackgroundImage {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:k_BACKGROUND_IMAGE_TYPE] == IntroBackgroundImage1) {
        imageType = IntroBackgroundImage1;
    }
    else if ([defaults integerForKey:k_BACKGROUND_IMAGE_TYPE] == IntroBackgroundImage2) {
        imageType = IntroBackgroundImage2;
    }
    else if ([defaults integerForKey:k_BACKGROUND_IMAGE_TYPE] == IntroBackgroundImage3) {
        imageType = IntroBackgroundImage3;
    }
    else if ([defaults integerForKey:k_BACKGROUND_IMAGE_TYPE] == IntroBackgroundImage4) {
        imageType = IntroBackgroundImage4;
    }
    NSInteger  introImageType = (imageType%4)+1;
    [defaults setInteger:introImageType forKey:k_BACKGROUND_IMAGE_TYPE];
    [defaults synchronize];
}

-(UIImage*)getIntroBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"Intro_bg%i%@.png", imageType, ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

-(UIImage*)getMainBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"main_bg4%@.png", ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

-(UIImage*)getCompanyBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"main_bg2%@.png", ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

-(UIImage*)getContactsBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"main_bg3%@.png", ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

-(UIImage*)getMarketReportsBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"main_bg4%@.png", ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

-(UIImage*)getPropertiesBackgroundImage {
    
    NSMutableString *ext = [NSMutableString string];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        [ext appendString:@"_i5"];
    }
    NSString *name = [NSString stringWithFormat:@"main_bg4%@.png", ext];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

@end
