//
//  ReportsCell.h
//  PMRG
//
//  Created by SSASOFT on 8/31/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportsViewController;

@interface ReportsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *heading_lbl, *name_lbl, *title_lbl, *description_lbl;
@property (nonatomic, strong) IBOutlet UIButton  *pdf_btn;
@property (nonatomic, strong) IBOutlet UIImageView  *report_image;
@property (nonatomic, weak) ReportsViewController   *parentController;

-(IBAction)clickPDFLink:(id)sender;

@end
