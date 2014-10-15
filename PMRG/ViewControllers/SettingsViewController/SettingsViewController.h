//
//  SettingsViewController.h
//  PMRG
//
//  Created by SSASOFT on 10/14/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    
    IBOutlet UISwitch   *beacon_switch;
}

-(IBAction)backAction:(id)sender;
-(IBAction)switchValueChanged:(id)sender;

@end
