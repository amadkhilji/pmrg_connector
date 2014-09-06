//
//  SocialCell.m
//  PMRG
//
//  Created by SSASOFT on 9/6/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "SocialCell.h"

@implementation SocialCell

@synthesize tag;
@synthesize detail_TV;
@synthesize link_btn;
@synthesize social_image, social_icon;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

-(IBAction)linkClickAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[link_btn titleForState:UIControlStateNormal]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
