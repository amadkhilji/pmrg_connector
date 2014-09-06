//
//  CompanyViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UIView         *about_us_view, *top_bar, *bottom_bar, *newsHeaderView;
    IBOutlet UIImageView    *bg_image;
    IBOutlet UITableView    *timeline_tableView, *news_tableView, *social_tableView;
    IBOutlet UIButton       *about_btn, *timeline_btn, *news_btn, *social_btn;
    
    NSMutableArray          *newsList, *timelineList, *socialFeed;
}

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)homeAction:(id)sender;
-(IBAction)aboutAction:(id)sender;
-(IBAction)timelineAction:(id)sender;
-(IBAction)newsAction:(id)sender;
-(IBAction)socialAction:(id)sender;

@end
