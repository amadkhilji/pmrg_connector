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

+(AppInfo*)sharedInfo;

-(UIImage*)getIntroBackgroundImage;
-(UIImage*)getMainBackgroundImage;
-(UIImage*)getCompanyBackgroundImage;
-(UIImage*)getContactsBackgroundImage;
-(UIImage*)getMarketReportsBackgroundImage;
-(UIImage*)getPropertiesBackgroundImage;

@end
