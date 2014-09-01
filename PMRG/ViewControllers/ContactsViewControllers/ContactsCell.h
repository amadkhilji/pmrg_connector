//
//  ContactsCell.h
//  PMRG
//
//  Created by SSASOFT on 8/24/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *heading_lbl, *name_lbl, *title_lbl, *description_lbl, *email_lbl;
@property (nonatomic, strong) IBOutlet UIImageView  *profile_image;

@end
