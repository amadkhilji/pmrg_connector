//
//  SocialCell.h
//  PMRG
//
//  Created by SSASOFT on 9/6/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialCell : UITableViewCell

@property (nonatomic, strong) IBOutlet  UILabel     *tag_lbl;
@property (nonatomic, strong) IBOutlet  UITextView  *detail_TV;
@property (nonatomic, strong) IBOutlet  UIButton    *link_btn;
@property (nonatomic, strong) IBOutlet  UIImageView *social_image, *social_icon;

-(IBAction)linkClickAction:(id)sender;

@end
