//
//  SettingsViewController.m
//  PMRG
//
//  Created by SSASOFT on 10/14/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [beacon_switch setOn:[BeaconManager sharedManager].isBeaconOn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark IBAction Methods

-(IBAction)backAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)switchValueChanged:(id)sender {
    
    [[BeaconManager sharedManager] setBeaconOn:beacon_switch.isOn];
    if ([BeaconManager sharedManager].isBeaconOn) {
        [[BeaconManager sharedManager] startMonitoringRegions];
    }
    else {
        [[BeaconManager sharedManager] stopMonitoringRegions];
    }
}

@end
