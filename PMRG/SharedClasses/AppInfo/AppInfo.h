//
//  AppInfo.h
//  PMRG
//
//  Created by SSASOFT on 8/17/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  
    IntroBackgroundImage1 = 1,
    IntroBackgroundImage2 = 2,
    IntroBackgroundImage3 = 3,
    IntroBackgroundImage4 = 4
    
} IntroBackgroundImage;

@interface AppInfo : NSObject {
    
    IntroBackgroundImage    imageType;
}

@property (nonatomic, readonly) NSMutableArray  *facebookFeed, *twitterFeed, *newsFeed, *visitedBeaconsList;
@property (nonatomic, readonly) NSMutableDictionary  *contactsData;

+(AppInfo*)sharedInfo;

-(void)loadFacebookFeed:(NSArray*)list;
-(void)loadTwitterFeed:(NSArray*)list;
-(void)loadNewsList:(NSArray*)list;
-(void)loadContactsData:(NSArray*)list;
-(void)addVisitedBeacon:(NSDictionary*)beacon;
-(void)removeVisitedBeacon:(NSDictionary*)beacon;
-(void)loadVisitedBeacons;
-(void)saveVisitedBeacons;
-(UIImage*)getIntroBackgroundImage;
-(UIImage*)getMainBackgroundImage;
-(UIImage*)getCompanyBackgroundImage;
-(UIImage*)getContactsBackgroundImage;
-(UIImage*)getMarketReportsBackgroundImage;
-(UIImage*)getPropertiesBackgroundImage;

@end
