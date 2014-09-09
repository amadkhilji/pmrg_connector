//
//  BeaconManager.h
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BeaconManager : NSObject <CLLocationManagerDelegate> {
    
    NSMutableArray  *beaconsList;
    CLLocationManager   *locationManager;
}

+(instancetype)sharedManager;

-(void)startMonitoringBeacons;
-(void)stopMonitoringBeacons;
-(void)openBeaconScreenWithTag:(int)beaconTag;

@end
