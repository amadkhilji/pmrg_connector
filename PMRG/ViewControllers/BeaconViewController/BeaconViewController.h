//
//  BeaconViewController.h
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconViewController : UIViewController {
    
    IBOutlet UIScrollView    *scrollView;
    IBOutlet UIImageView     *bg_image;
    IBOutlet UIButton        *info_button;
}

@property (nonatomic, strong) NSDictionary  *beaconData;

-(void)showBeaconView;

-(IBAction)backAction:(id)sender;
-(IBAction)infoAction:(id)sender;

@end
