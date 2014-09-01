//
//  PropertiesViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertiesViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView      *webView;
    IBOutlet UIActivityIndicatorView    *indicator;
    IBOutlet UIView         *top_bar, *bottom_bar;
}

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)homeAction:(id)sender;

@end
