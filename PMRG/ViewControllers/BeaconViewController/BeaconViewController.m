//
//  BeaconViewController.m
//  PMRG
//
//  Created by SSASOFT on 9/9/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "BeaconViewController.h"
#import "UIView+AlertAnimations.h"

@interface BeaconViewController ()

@end

@implementation BeaconViewController

@synthesize beaconData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bg_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"ibeacon_screen_%@.png", [beaconData objectForKey:@"tag"]]];
    if ([[beaconData objectForKey:@"tag"] intValue] == k_Beacon1_TAG) {
        info_button.hidden = NO;
    }
    else {
        info_button.hidden = YES;
    }
    [scrollView setContentSize:CGSizeMake(320, 568)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [beaconData release];
    beaconData = nil;
    
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showBeaconView {
    
    // Retaining self is odd, but we do it to make this "fire and forget"
    [self retain];
    
    //We need to add it to the window, which we can get from the delegate
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:self.view];
    
    // Make sure the alert covers the whole window
    self.view.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    self.view.center = window.center;
    
    // "Fade in" animation for background
    [self.view doFadeInAnimation];
}

-(IBAction)backAction:(id)sender {

    [UIView animateWithDuration:kFadeAnimationDuration animations:^{
        self.view.alpha = 0.0;
    }completion:^(BOOL finished){
        if (finished) {
            [self.view removeFromSuperview];
            [self autorelease];
        }
    }];
}

-(IBAction)infoAction:(id)sender {
    
    info_button.hidden = YES;
    UIImage * newImage= [UIImage imageNamed:@"ibeacon_screen_2.png"];
    [UIView transitionWithView:self.view
                      duration:kFadeAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        bg_image.image = newImage;
                    } completion:NULL];
}

@end
