//
//  TimelineCell.h
//  PMRG
//
//  Created by SSASOFT on 8/31/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *title, *description;
@property (nonatomic, strong) IBOutlet UIImageView  *dots_separator;

@end
