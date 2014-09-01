//
//  SideMenuViewController.h
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView    *sideMenuTableView;
    
    NSArray *itemLabels;
    NSArray *itemIcons;
}

@end
