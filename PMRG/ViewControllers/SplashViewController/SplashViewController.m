//
//  SplashViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/17/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "SplashViewController.h"
#import "IntroViewController.h"
#import "AppDelegate.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    IntroViewController *introVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"IntroViewController"];
    appDelegate.window.rootViewController = introVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
