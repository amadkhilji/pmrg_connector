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

@synthesize facebookFeed, twitterFeed, newsFeed;
@synthesize contactsData;

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
        
        facebookFeed = [[NSMutableArray alloc] init];
        twitterFeed = [[NSMutableArray alloc] init];
        newsFeed = [[NSMutableArray alloc] init];
        contactsData = [[NSMutableDictionary alloc] init];
        [contactsData setObject:[NSMutableArray array] forKey:@"western"];
        [contactsData setObject:[NSMutableArray array] forKey:@"central"];
        [contactsData setObject:[NSMutableArray array] forKey:@"southeast"];
        [contactsData setObject:[NSMutableArray array] forKey:@"northeast"];
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

-(void)loadFacebookFeed:(NSArray*)list {

    if ([list count] > 0) {
        [facebookFeed removeAllObjects];
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        for (int i=0; i<[list count]; i++) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[[list objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
            [data setObject:[[list objectAtIndex:i] objectForKey:@"from"] forKey:@"from"];
            if ([[list objectAtIndex:i] objectForKey:@"message"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"message"] forKey:@"message"];
            }
            else if ([[list objectAtIndex:i] objectForKey:@"story"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"story"] forKey:@"message"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"description"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"description"] forKey:@"description"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"name"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"caption"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"caption"] forKey:@"caption"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"link"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"link"] forKey:@"link"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"picture"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"picture"] forKey:@"picture"];
            }
            if ([[list objectAtIndex:i] objectForKey:@"type"]) {
                [data setObject:[[list objectAtIndex:i] objectForKey:@"type"] forKey:@"type"];
            }
            NSDate* date = [dateFormat dateFromString:[[list objectAtIndex:i] objectForKey:@"created_time"]];
            [data setObject:date forKey:@"created_time"];
            [data setObject:@"Facebook" forKey:@"social_type"];
            [facebookFeed addObject:data];
        }
    }
}

-(void)loadTwitterFeed:(NSArray*)list {
    
    if ([list count] > 0) {
        [twitterFeed removeAllObjects];
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
        for (int i=0; i<[list count]; i++) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[list objectAtIndex:i]];
            NSDate* date = [dateFormat dateFromString:[data objectForKey:@"created_at"]];
            [data setObject:date forKey:@"created_time"];
            [data removeObjectForKey:@"created_at"];
            [twitterFeed addObject:data];
        }
    }
}

-(void)loadNewsList:(NSArray*)list {
    
    if ([list count] > 0) {
        [newsFeed removeAllObjects];
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        for (int i=0; i<[list count]; i++) {
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[list objectAtIndex:i]];
            NSDate* date = [dateFormat dateFromString:[data objectForKey:@"date"]];
            [dateFormat setDateFormat:@"MMM d,yyyy"];
            [data setObject:[dateFormat stringFromDate:date] forKey:@"date"];
            [newsFeed addObject:data];
        }
    }
}

-(void)loadContactsData:(NSArray *)list {
    
    if ([list count] > 0) {
        [contactsData removeAllObjects];
        NSMutableArray *western = [NSMutableArray array];
        NSMutableArray *central = [NSMutableArray array];
        NSMutableArray *southeast = [NSMutableArray array];
        NSMutableArray *northeast = [NSMutableArray array];
        for (int i=0; i<[list count]; i++) {
            NSDictionary *contact = [list objectAtIndex:i];
            if (contact && [contact objectForKey:@"division"] && (NSNull*)[contact objectForKey:@"division"] != [NSNull null]) {
                if ([[contact objectForKey:@"division"] caseInsensitiveCompare:@"western"] == NSOrderedSame) {
                    [western addObject:contact];
                }
                else if ([[contact objectForKey:@"division"] caseInsensitiveCompare:@"central"] == NSOrderedSame) {
                    [central addObject:contact];
                }
                else if ([[contact objectForKey:@"division"] caseInsensitiveCompare:@"southeast"] == NSOrderedSame) {
                    [southeast addObject:contact];
                }
                else if ([[contact objectForKey:@"division"] caseInsensitiveCompare:@"northeast"] == NSOrderedSame) {
                    [northeast addObject:contact];
                }
            }
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rankType" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [western sortUsingDescriptors:sortDescriptors];
        [central sortUsingDescriptors:sortDescriptors];
        [southeast sortUsingDescriptors:sortDescriptors];
        [northeast sortUsingDescriptors:sortDescriptors];
        NSMutableArray *leasingList = [NSMutableArray array];
        for (int i=0; i<[western count]; i++) {
            NSDictionary *obj = [western objectAtIndex:i];
            if ([[obj objectForKey:@"rankType"] caseInsensitiveCompare:@"leasing"] == NSOrderedSame) {
                [leasingList addObject:obj];
            }
        }
        [western removeObjectsInArray:leasingList];
        [leasingList addObjectsFromArray:western];
        [western removeAllObjects];
        [western addObjectsFromArray:leasingList];
        [leasingList removeAllObjects];
        for (int i=0; i<[central count]; i++) {
            NSDictionary *obj = [central objectAtIndex:i];
            if ([[obj objectForKey:@"rankType"] caseInsensitiveCompare:@"leasing"] == NSOrderedSame) {
                [leasingList addObject:obj];
            }
        }
        [central removeObjectsInArray:leasingList];
        [leasingList addObjectsFromArray:central];
        [central removeAllObjects];
        [central addObjectsFromArray:leasingList];
        [leasingList removeAllObjects];
        for (int i=0; i<[southeast count]; i++) {
            NSDictionary *obj = [southeast objectAtIndex:i];
            if ([[obj objectForKey:@"rankType"] caseInsensitiveCompare:@"leasing"] == NSOrderedSame) {
                [leasingList addObject:obj];
            }
        }
        [southeast removeObjectsInArray:leasingList];
        [leasingList addObjectsFromArray:southeast];
        [southeast removeAllObjects];
        [southeast addObjectsFromArray:leasingList];
        [leasingList removeAllObjects];
        for (int i=0; i<[northeast count]; i++) {
            NSDictionary *obj = [northeast objectAtIndex:i];
            if ([[obj objectForKey:@"rankType"] caseInsensitiveCompare:@"leasing"] == NSOrderedSame) {
                [leasingList addObject:obj];
            }
        }
        [northeast removeObjectsInArray:leasingList];
        [leasingList addObjectsFromArray:northeast];
        [northeast removeAllObjects];
        [northeast addObjectsFromArray:leasingList];
        [leasingList removeAllObjects];
        
        NSString *rank = @"";
        for (int i=0; i<[western count]; i++) {
            NSDictionary *obj = [western objectAtIndex:i];
            if ([rank isEqualToString:[obj objectForKey:@"rankType"]]) {
                NSMutableDictionary *contact = [NSMutableDictionary dictionaryWithDictionary:obj];
                [contact setObject:@"" forKey:@"rankType"];
                [western replaceObjectAtIndex:i withObject:contact];
            }
            else {
                rank = [obj objectForKey:@"rankType"];
            }
        }
        rank = @"";
        for (int i=0; i<[central count]; i++) {
            NSDictionary *obj = [central objectAtIndex:i];
            if ([rank isEqualToString:[obj objectForKey:@"rankType"]]) {
                NSMutableDictionary *contact = [NSMutableDictionary dictionaryWithDictionary:obj];
                [contact setObject:@"" forKey:@"rankType"];
                [central replaceObjectAtIndex:i withObject:contact];
            }
            else {
                rank = [obj objectForKey:@"rankType"];
            }
        }
        rank = @"";
        for (int i=0; i<[southeast count]; i++) {
            NSDictionary *obj = [southeast objectAtIndex:i];
            if ([rank isEqualToString:[obj objectForKey:@"rankType"]]) {
                NSMutableDictionary *contact = [NSMutableDictionary dictionaryWithDictionary:obj];
                [contact setObject:@"" forKey:@"rankType"];
                [southeast replaceObjectAtIndex:i withObject:contact];
            }
            else {
                rank = [obj objectForKey:@"rankType"];
            }
        }
        rank = @"";
        for (int i=0; i<[northeast count]; i++) {
            NSDictionary *obj = [northeast objectAtIndex:i];
            if ([rank isEqualToString:[obj objectForKey:@"rankType"]]) {
                NSMutableDictionary *contact = [NSMutableDictionary dictionaryWithDictionary:obj];
                [contact setObject:@"" forKey:@"rankType"];
                [northeast replaceObjectAtIndex:i withObject:contact];
            }
            else {
                rank = [obj objectForKey:@"rankType"];
            }
        }
        [contactsData setObject:western forKey:@"western"];
        [contactsData setObject:central forKey:@"central"];
        [contactsData setObject:southeast forKey:@"southeast"];
        [contactsData setObject:northeast forKey:@"northeast"];
    }
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
