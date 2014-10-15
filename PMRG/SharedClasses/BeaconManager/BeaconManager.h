//
//  BeaconManager.h
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"

@import CoreLocation;

@interface BeaconManager : NSObject <UIAlertViewDelegate, CLLocationManagerDelegate, HTTPRequestDelegate> {
    
    NSMutableArray  *beaconsList, *beaconsInRange;
    CLLocationManager   *locationManager;
    
    UIAlertView     *beaconAlertView;
}

@property (nonatomic, readonly) BOOL  isBeaconOn;

+(instancetype)sharedManager;

-(void)setBeaconOn:(BOOL)isOn;
-(void)startMonitoringRegions;
-(void)stopMonitoringRegions;
-(void)openBeaconScreenWithTag:(int)beaconTag;

@end
