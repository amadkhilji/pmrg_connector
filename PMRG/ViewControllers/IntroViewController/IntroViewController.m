//
//  IntroViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "IntroViewController.h"
#import "MainViewController.h"
#import "SideMenuViewController.h"

@interface IntroViewController ()

-(void)loadMainViewController;

@end

@implementation IntroViewController

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
    bg_image.image = [[AppInfo sharedInfo] getIntroBackgroundImage];
    
    [self performSelector:@selector(loadMainViewController) withObject:nil afterDelay:3.0];
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

#pragma mark
#pragma mark Private Methods

-(void)loadMainViewController {
    
    MainViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [navigationController setNavigationBarHidden:YES];
    
    SideMenuViewController *sideMenuController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navigationController
                                                    leftMenuViewController:sideMenuController
                                                    rightMenuViewController:nil];
    
    container.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:container animated:YES completion:nil];
}

@end
