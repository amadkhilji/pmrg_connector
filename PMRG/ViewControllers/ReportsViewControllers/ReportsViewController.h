//
//  ReportsViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView    *reportsTableView;
    IBOutlet UIImageView    *bg_image;
    IBOutlet UIView         *top_bar, *bottom_bar;
    IBOutlet UIButton       *western_btn, *central_btn, *southeast_btn, *northeast_btn;
    
    NSMutableArray          *reportsList;
    NSDictionary            *reportsData;
}

-(void)openPDFAtIndex:(NSInteger)index;

-(IBAction)menuAction:(id)sender;
-(IBAction)settingsAction:(id)sender;
-(IBAction)homeAction:(id)sender;
-(IBAction)westernButtonAction:(id)sender;
-(IBAction)centralButtonAction:(id)sender;
-(IBAction)southeastButtonAction:(id)sender;
-(IBAction)northeastButtonAction:(id)sender;

@end
