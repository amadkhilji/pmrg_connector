//
//  ReportsCell.m
//  PMRG
//
//  Created by SSASOFT on 8/31/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "ReportsCell.h"
#import "ReportsViewController.h"

@implementation ReportsCell

@synthesize parentController;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

-(IBAction)clickPDFLink:(id)sender {

    if (parentController && [parentController respondsToSelector:@selector(openPDFAtIndex:)]) {
        [parentController openPDFAtIndex:self.tag];
    }
}

@end
