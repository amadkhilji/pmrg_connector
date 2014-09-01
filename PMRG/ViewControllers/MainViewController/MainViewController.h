//
//  MainViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController {
    
    IBOutlet    UIImageView     *bg_image, *logo_image, *drag_to_select_image, *left_dots_image, *right_dots_image, *top_dots_image, *bottom_dots_image;
    IBOutlet    UIButton        *company_btn, *contacts_btn, *reports_btn, *properties_btn;
    
    CGPoint     touchPoint, logo_center;
}

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)companyAction:(id)sender;
-(IBAction)contactsAction:(id)sender;
-(IBAction)marketReportsAction:(id)sender;
-(IBAction)propertiesAction:(id)sender;

@end
