//
//  BeaconManager.m
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "BeaconManager.h"
#import "BeaconViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface BeaconManager ()

-(void)loadBeacons:(NSArray*)list;
-(void)loadMonitoringBeacons;
-(void)requestToGetBeacons;
-(CLBeaconRegion *)beaconRegionWithMajorItem:(NSDictionary *)item;
-(CLBeaconRegion *)beaconRegionWithMinorItem:(NSDictionary *)item;
-(void)stopMonitoringForBeacon:(CLBeaconRegion*)beacon;
-(void)showAlertWithBeacon:(NSDictionary*)beacon;
-(void)sendNotificationForBeacon:(NSDictionary*)beacon;
-(BOOL)isMonitoringBeacon:(NSDictionary*)beacon;

@end

@implementation BeaconManager

@synthesize isBeaconOn;

static BeaconManager *singletonInstance;
+(instancetype)sharedManager {
    
    @synchronized ([BeaconManager class]) {
        
        if (!singletonInstance) {
            singletonInstance = [[BeaconManager alloc] init];
        }
    }
    
    return singletonInstance;
}

+(id)alloc {
    
    @synchronized ([BeaconManager class]) {
        
        NSAssert(singletonInstance == nil, @"Error, trying to allocate another instance of singleton class.");
        return [super alloc];
    }
}

-(id)init {
    
    if (self = [super init]) {
        
        beaconsList = [[NSMutableArray alloc] init];
        beaconsInRange = [[NSMutableArray alloc] init];
        monitoringBeacons = [[NSMutableArray alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.activityType = CLActivityTypeFitness;
        locationManager.delegate = self;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:k_Beacon_Notification_Obj]) {
            isBeaconOn = [[NSUserDefaults standardUserDefaults] boolForKey:k_Beacon_Notification];
        }
        else {
            isBeaconOn = YES;
            [defaults setObject:@"Beacon" forKey:k_Beacon_Notification_Obj];
            [defaults setBool:isBeaconOn forKey:k_Beacon_Notification];
            [defaults synchronize];
        }
    }
    
    return self;
}

#pragma mark
#pragma mark Private Methods

-(void)loadBeacons:(NSArray*)list {
    
    if (list && [list count] > 0) {
        [beaconsList removeAllObjects];
        for (int i=0; i<[list count]; i++) {
            NSMutableDictionary *beaconObj = [NSMutableDictionary dictionaryWithDictionary:[list objectAtIndex:i]];
            if ((NSNull*)[beaconObj objectForKey:@"uuid"] != [NSNull null] && [[beaconObj objectForKey:@"uuid"] length] > 0 && (NSNull*)[beaconObj objectForKey:@"major"] != [NSNull null] && [[beaconObj objectForKey:@"major"] unsignedIntValue] > 0 && (NSNull*)[beaconObj objectForKey:@"minor"] != [NSNull null] && [[beaconObj objectForKey:@"minor"] unsignedIntValue] > 0) {
                [beaconObj setObject:[NSString stringWithFormat:@"%@:%i", [beaconObj objectForKey:@"uuid"], [[beaconObj objectForKey:@"id"] intValue]] forKey:@"identifier"];
                [beaconObj setObject:[beaconObj objectForKey:@"id"] forKey:@"tag"];
                [beaconsList addObject:beaconObj];
            }
        }
    }
    [self loadMonitoringBeacons];
}

-(void)loadMonitoringBeacons {
    
    [monitoringBeacons removeAllObjects];
    for (int i=0; i<[beaconsList count]; i++) {
        NSDictionary *beacon = [beaconsList objectAtIndex:i];
        if (![self isMonitoringBeacon:beacon]) {
            [monitoringBeacons addObject:beacon];
        }
    }
}

-(void)requestToGetBeacons {
    
    [HTTPRequest requestGetWithMethod:nil Params:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:GET_ALL_BEACONS, SERVER_USERNAME, SERVER_PASSWORD, nil] forKeys:[NSArray arrayWithObjects:@"method", @"userName", @"password", nil]] andDelegate:self];
}

- (CLBeaconRegion *)beaconRegionWithMajorItem:(NSDictionary *)item {
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[item objectForKey:@"uuid"]] major:[[item objectForKey:@"major"] unsignedIntValue] identifier:k_PMRG_Beacon];
    return beaconRegion;
}

- (CLBeaconRegion *)beaconRegionWithMinorItem:(NSDictionary *)item {
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[item objectForKey:@"uuid"]] major:[[item objectForKey:@"major"] unsignedIntValue] minor:[[item objectForKey:@"minor"] unsignedIntValue] identifier:k_PMRG_Beacon];
    return beaconRegion;
}

-(void)stopMonitoringForBeacon:(CLBeaconRegion*)beacon {
    
    if (beacon) {
        [locationManager stopMonitoringForRegion:beacon];
        [locationManager stopRangingBeaconsInRegion:beacon];
    }
}

-(void)showAlertWithBeacon:(NSDictionary*)beacon {
    
    if (beaconAlertView) {
        [beaconAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    beaconAlertView = [[UIAlertView alloc] initWithTitle:@"PM Realty Group" message:[beacon objectForKey:@"title"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View", nil];
    beaconAlertView.tag = [[beacon objectForKey:@"tag"] intValue];
    [beaconAlertView show];
}

-(void)sendNotificationForBeacon:(NSDictionary*)beacon {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [beacon objectForKey:@"title"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = beacon;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

-(BOOL)isMonitoringBeacon:(NSDictionary*)beacon {
    
    BOOL isMonitoring = NO;
    if (beacon && [beacon isKindOfClass:[NSDictionary class]]) {
        for (int i=0; i<[monitoringBeacons count] && !isMonitoring; i++) {
            NSDictionary *beaconObj = [monitoringBeacons objectAtIndex:i];
            if ([[beacon objectForKey:@"uuid"] isEqualToString:[beaconObj objectForKey:@"uuid"]] && [[beacon objectForKey:@"major"] unsignedIntValue] == [[beaconObj objectForKey:@"major"] unsignedIntValue]) {
                isMonitoring = YES;
            }
        }
    }
    return isMonitoring;
}

#pragma mark
#pragma mark Public Methods

-(void)setBeaconOn:(BOOL)isOn {

    isBeaconOn = isOn;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOn forKey:k_Beacon_Notification];
    [defaults synchronize];
}

-(void)startMonitoringRegions {
    
    if ([beaconsList count] == 0) {
        [self requestToGetBeacons];
    }
    else {
        for (int i=0; i<[monitoringBeacons count] && isBeaconOn; i++) {
            CLBeaconRegion *beaconRegion = [self beaconRegionWithMajorItem:[monitoringBeacons objectAtIndex:i]];
            if (beaconRegion) {
                beaconRegion.notifyEntryStateOnDisplay = YES;
                if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [locationManager requestAlwaysAuthorization];
                }
                [locationManager startMonitoringForRegion:beaconRegion];
                [locationManager requestStateForRegion:beaconRegion];
            }
        }
    }
}

-(void)stopMonitoringRegions {
    
    for (int i=0; i<[monitoringBeacons count]; i++) {
        
        CLBeaconRegion *beaconRegion = [self beaconRegionWithMajorItem:[monitoringBeacons objectAtIndex:i]];
        [self stopMonitoringForBeacon:beaconRegion];
    }
}

-(void)stopMonitoringBeacon:(NSDictionary*)beacon {
    
    CLBeaconRegion *beaconRegion = [self beaconRegionWithMinorItem:beacon];
    [self stopMonitoringForBeacon:beaconRegion];
    [beaconsInRange removeObject:beacon];
}

-(void)openBeaconScreenWithTag:(int)beaconTag {
    
    for (NSDictionary *beacon in beaconsList) {
        if ([[beacon objectForKey:@"tag"] intValue] == beaconTag) {
//            CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:beacon];
//            [self stopMonitoringForBeacon:beaconRegion];
//            BeaconViewController *beaconVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BeaconViewController"];
//            beaconVC.beaconData = beacon;
//            [beaconVC showBeaconView];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Beacon_Notification object:beacon];
            break;
        }
    }
}

#pragma mark
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    for (CLBeacon *beacon in beacons) {
        for (int i=0; i<[beaconsList count]; i++) {
            NSDictionary *item = [beaconsList objectAtIndex:i];
            // Determine if item is equal to ranged beacon
            if ([[item objectForKey:@"uuid"] isEqualToString:[beacon.proximityUUID UUIDString]] && [[item objectForKey:@"major"] unsignedIntValue] == [beacon.major unsignedIntValue] && [[item objectForKey:@"minor"] unsignedIntValue] == [beacon.minor unsignedIntValue]) {
                if ([beaconsInRange indexOfObject:item] == NSNotFound) {
                    [beaconsInRange addObject:item];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        [self showAlertWithBeacon:item];
                    }
                    else {
                        [self sendNotificationForBeacon:item];
                    }
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    if (state == CLRegionStateInside) {
        for (NSDictionary *item in monitoringBeacons) {
            if ([k_PMRG_Beacon isEqualToString:region.identifier]) {
                CLBeaconRegion *beaconRegion = [self beaconRegionWithMajorItem:item];
                [locationManager startRangingBeaconsInRegion:beaconRegion];
            }
        }
    }
//    else {
//        for (NSDictionary *item in beaconsList) {
//            if ([k_PMRG_Beacon isEqualToString:region.identifier]) {
//                CLBeaconRegion *beaconRegion = [self beaconRegionWithMinorItem:item];
//                [locationManager stopRangingBeaconsInRegion:beaconRegion];
//                [beaconsInRange removeObject:item];
//            }
//        }
//    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    for (NSDictionary *item in monitoringBeacons) {
        if ([k_PMRG_Beacon isEqualToString:region.identifier]) {
            CLBeaconRegion *beaconRegion = [self beaconRegionWithMajorItem:item];
            [locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
//    for (NSDictionary *item in beaconsList) {
//        if ([k_PMRG_Beacon isEqualToString:region.identifier]) {
//            CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
//            [locationManager stopRangingBeaconsInRegion:beaconRegion];
//            [beaconsInRange removeObject:item];
//        }
//    }
}

#pragma mark
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self openBeaconScreenWithTag:(int)alertView.tag];
    }
    
    beaconAlertView = nil;
}

#pragma mark
#pragma mark HTTPRequestDelegate Methods

-(void)didFinishRequest:(HTTPRequest*)httpRequest withData:(id)data {
    
    if (data && [data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"message"] && (NSNull*)[data objectForKey:@"message"] != [NSNull null] && [[data objectForKey:@"message"] caseInsensitiveCompare:@"success"] == NSOrderedSame && [data objectForKey:@"ibeacons"] && [[data objectForKey:@"ibeacons"] isKindOfClass:[NSArray class]]) {
        [self loadBeacons:[data objectForKey:@"ibeacons"]];
        [self startMonitoringRegions];
    }
}

-(void)didFailRequest:(HTTPRequest*)httpRequest withError:(NSString*)errorMessage {
    
    
}

@end
