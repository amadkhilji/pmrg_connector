//
//  ContactsViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPRequestDelegate> {
    
    IBOutlet UITableView    *contactsTableView;
    IBOutlet UIImageView    *bg_image;
    IBOutlet UIView         *top_bar, *bottom_bar;
    IBOutlet UIButton       *western_btn, *central_btn, *southeast_btn, *northeast_btn;
    
    NSMutableArray          *contactsList;
    NSMutableDictionary     *contactsData;
}

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)homeAction:(id)sender;
-(IBAction)westernButtonAction:(id)sender;
-(IBAction)centralButtonAction:(id)sender;
-(IBAction)southeastButtonAction:(id)sender;
-(IBAction)northeastButtonAction:(id)sender;

@end
