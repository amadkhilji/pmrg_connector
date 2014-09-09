//
//  MainViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "MainViewController.h"
#import "CompanyViewController.h"
#import "ContactsViewController.h"
#import "ReportsViewController.h"
#import "PropertiesViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
    bg_image.image = [[AppInfo sharedInfo] getMainBackgroundImage];
    
    if ([UIScreen mainScreen].bounds.size.height <= 480.0) {
        CGRect frame = properties_btn.frame;
        frame.origin.y -= 10.0;
        properties_btn.frame = frame;
        frame = bottom_dots_image.frame;
        frame.origin.y -= 10.0;
        bottom_dots_image.frame = frame;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:k_Should_Display_Beacon]) {
        NSDictionary *beacon = [defaults objectForKey:k_Should_Display_Beacon];
        [[BeaconManager sharedManager] openBeaconScreenWithTag:[[beacon objectForKey:@"tag"] intValue]];
        [defaults removeObjectForKey:k_Should_Display_Beacon];
        [defaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    drag_to_select_image.hidden = YES;
    left_dots_image.hidden = YES;
    right_dots_image.hidden = YES;
    top_dots_image.hidden = YES;
    bottom_dots_image.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    logo_center = logo_image.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)menuAction:(id)sender {
 
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
}

-(IBAction)settingsAction:(id)sender {
    
//    [[BeaconManager sharedManager] openBeaconScreenWithTag:k_Beacon1_TAG];
}

-(IBAction)companyAction:(id)sender {
    
    CompanyViewController *companyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CompanyViewController"];
    [self.navigationController pushViewController:companyVC animated:YES];
}

-(IBAction)contactsAction:(id)sender {
    
    ContactsViewController *contactsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ContactsViewController"];
    [self.navigationController pushViewController:contactsVC animated:YES];
}

-(IBAction)marketReportsAction:(id)sender {
    
    ReportsViewController *reportsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ReportsViewController"];
    [self.navigationController pushViewController:reportsVC animated:YES];
}

-(IBAction)propertiesAction:(id)sender {
    
    PropertiesViewController *propertiesVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PropertiesViewController"];
    [self.navigationController pushViewController:propertiesVC animated:YES];
}

#pragma mark
#pragma mark UITouch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(logo_image.frame, touchLocation)) {
        drag_to_select_image.hidden = NO;
        touchPoint = CGPointMake(logo_image.center.x-touchLocation.x, logo_image.center.y-touchLocation.y);
    }
    else {
        drag_to_select_image.hidden = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (!drag_to_select_image.hidden) {
        CGFloat xPoint = touchPoint.x;
        CGFloat yPoint = touchPoint.y;
        CGPoint centerPoint = CGPointMake(touchLocation.x+xPoint, touchLocation.y+yPoint);
        if (fabs(centerPoint.x-logo_center.x) > 30.0) {
            centerPoint.x = logo_image.center.x;
        }
        if (fabs(centerPoint.y-logo_center.y) > 30.0) {
            centerPoint.y = logo_image.center.y;
        }
        logo_image.center = centerPoint;
        if (fabsf(logo_image.center.y-logo_center.y) > fabsf(logo_image.center.x-logo_center.x)) {
            if (logo_image.center.y > logo_center.y && logo_image.center.x >= contacts_btn.frame.origin.x && logo_image.center.x <= (contacts_btn.frame.origin.x+contacts_btn.frame.size.width)) {
                bottom_dots_image.hidden = NO;
                top_dots_image.hidden = YES;
                left_dots_image.hidden = YES;
                right_dots_image.hidden = YES;
            }
            else if (logo_image.center.y < logo_center.y && logo_image.center.x >= properties_btn.frame.origin.x && logo_image.center.x <= (properties_btn.frame.origin.x+properties_btn.frame.size.width)) {
                top_dots_image.hidden = NO;
                bottom_dots_image.hidden = YES;
                left_dots_image.hidden = YES;
                right_dots_image.hidden = YES;
            }
            else {
                bottom_dots_image.hidden = YES;
                top_dots_image.hidden = YES;
                left_dots_image.hidden = YES;
                right_dots_image.hidden = YES;
            }
        }
        else if (fabsf(logo_image.center.y-logo_center.y) < fabsf(logo_image.center.x-logo_center.x)) {
            if (logo_image.center.x > logo_center.x && logo_image.center.y >= company_btn.frame.origin.y && logo_image.center.y <= (company_btn.frame.origin.y+company_btn.frame.size.height)) {
                bottom_dots_image.hidden = YES;
                top_dots_image.hidden = YES;
                left_dots_image.hidden = YES;
                right_dots_image.hidden = NO;
            }
            else if (logo_image.center.x < logo_center.x && logo_image.center.y >= reports_btn.frame.origin.y && logo_image.center.y <= (reports_btn.frame.origin.y+reports_btn.frame.size.height)) {
                top_dots_image.hidden = YES;
                bottom_dots_image.hidden = YES;
                left_dots_image.hidden = NO;
                right_dots_image.hidden = YES;
            }
            else {
                bottom_dots_image.hidden = YES;
                top_dots_image.hidden = YES;
                left_dots_image.hidden = YES;
                right_dots_image.hidden = YES;
            }
        }
        else {
            bottom_dots_image.hidden = YES;
            top_dots_image.hidden = YES;
            left_dots_image.hidden = YES;
            right_dots_image.hidden = YES;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!drag_to_select_image.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            logo_image.center = logo_center;
        }completion:^(BOOL finished){
            if (finished) {
                if (!top_dots_image.hidden) {
                    [self propertiesAction:nil];
                }
                else if (!bottom_dots_image.hidden) {
                    [self contactsAction:nil];
                }
                else if (!left_dots_image.hidden) {
                    [self marketReportsAction:nil];
                }
                else if (!right_dots_image.hidden) {
                    [self companyAction:nil];
                }
                else {
                    drag_to_select_image.hidden = YES;
                    bottom_dots_image.hidden = YES;
                    top_dots_image.hidden = YES;
                    left_dots_image.hidden = YES;
                    right_dots_image.hidden = YES;
                }
            }
        }];
    }
    else {
        logo_image.center = logo_center;
        drag_to_select_image.hidden = YES;
        bottom_dots_image.hidden = YES;
        top_dots_image.hidden = YES;
        left_dots_image.hidden = YES;
        right_dots_image.hidden = YES;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
}

@end
