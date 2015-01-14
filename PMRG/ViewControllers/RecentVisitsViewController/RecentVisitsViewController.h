//
//  RecentVisitsViewController.h
//  PMRG
//
//  Created by SSASOFT on 1/13/15.
//  Copyright (c) 2015 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentVisitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView    *visitsTableView;
    IBOutlet UIImageView    *bg_image;
    IBOutlet UIView         *top_bar, *bottom_bar;
    
    NSDateFormatter         *formatter;
}

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)homeAction:(id)sender;

@end
