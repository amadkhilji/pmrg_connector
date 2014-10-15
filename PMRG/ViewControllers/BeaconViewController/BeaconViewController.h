//
//  BeaconViewController.h
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView  *pdf_webView;
    IBOutlet UIActivityIndicatorView    *indicator;
}

@property (nonatomic, strong) NSDictionary  *beaconData;

-(void)showBeaconView;

-(IBAction)backAction:(id)sender;

@end
