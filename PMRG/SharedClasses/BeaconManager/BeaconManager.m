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

-(void)loadBeacons;
-(CLBeaconRegion *)beaconRegionWithItem:(NSDictionary *)item;
-(void)stopMonitoringForBeacon:(CLBeaconRegion*)beacon;
-(void)showAlertWithBeacon:(NSDictionary*)beacon;
-(void)sendNotificationForBeacon:(NSDictionary*)beacon;

@end

@implementation BeaconManager

static BeaconManager *singletonInstance;
+(instancetype)sharedManager {
    
    @synchronized ([AppInfo class]) {
        
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
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [self loadBeacons];
    }
    
    return self;
}

#pragma mark
#pragma mark Private Methods

-(void)loadBeacons {
    
    if ([beaconsList count] > 0) {
        [beaconsList removeAllObjects];
    }
    NSArray *list = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Beacons_List" ofType:@"plist"]];
    [beaconsList addObjectsFromArray:list];
}

- (CLBeaconRegion *)beaconRegionWithItem:(NSDictionary *)item {
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[item objectForKey:@"UUID"]] major:[[item objectForKey:@"major"] unsignedIntValue] minor:[[item objectForKey:@"minor"] unsignedIntValue] identifier:[item objectForKey:@"identifier"]];
    return beaconRegion;
}

-(void)stopMonitoringForBeacon:(CLBeaconRegion*)beacon {
    
    [locationManager stopMonitoringForRegion:beacon];
    [locationManager stopRangingBeaconsInRegion:beacon];
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

#pragma mark
#pragma mark Public Methods

-(void)startMonitoringRegions {
    
    for (int i=0; i<[beaconsList count]; i++) {
        
        CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:[beaconsList objectAtIndex:i]];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        [locationManager startMonitoringForRegion:beaconRegion];
        [locationManager requestStateForRegion:beaconRegion];
    }
}

-(void)stopMonitoringRegions {
    
    for (int i=0; i<[beaconsList count]; i++) {
        
        CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:[beaconsList objectAtIndex:i]];
        [self stopMonitoringForBeacon:beaconRegion];
    }
}

-(void)openBeaconScreenWithTag:(int)beaconTag {
    
    for (NSDictionary *beacon in beaconsList) {
        if ([[beacon objectForKey:@"tag"] intValue] == beaconTag) {
            CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:beacon];
            [self stopMonitoringForBeacon:beaconRegion];
            BeaconViewController *beaconVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BeaconViewController"];
            beaconVC.beaconData = beacon;
            [beaconVC showBeaconView];
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
            if ([[item objectForKey:@"UUID"] isEqualToString:[beacon.proximityUUID UUIDString]] && [[item objectForKey:@"major"] unsignedIntValue] == [beacon.major unsignedIntValue] && [[item objectForKey:@"minor"] unsignedIntValue] == [beacon.minor unsignedIntValue]) {
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
        for (NSDictionary *item in beaconsList) {
            if ([[item objectForKey:@"identifier"] isEqualToString:region.identifier]) {
                CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
                [locationManager startRangingBeaconsInRegion:beaconRegion];
            }
        }
    }
    else {
        for (NSDictionary *item in beaconsList) {
            if ([[item objectForKey:@"identifier"] isEqualToString:region.identifier]) {
                CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
                [locationManager stopRangingBeaconsInRegion:beaconRegion];
                [beaconsInRange removeObjectIdenticalTo:item];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    for (NSDictionary *item in beaconsList) {
        if ([[item objectForKey:@"identifier"] isEqualToString:region.identifier]) {
            CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
            [locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    for (NSDictionary *item in beaconsList) {
        if ([[item objectForKey:@"identifier"] isEqualToString:region.identifier]) {
            CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
            [locationManager stopRangingBeaconsInRegion:beaconRegion];
            [beaconsInRange removeObjectIdenticalTo:item];
        }
    }
}

#pragma mark
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self openBeaconScreenWithTag:(int)alertView.tag];
    }
    
    beaconAlertView = nil;
}

@end
