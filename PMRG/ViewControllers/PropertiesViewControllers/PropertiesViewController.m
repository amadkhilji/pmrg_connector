//
//  PropertiesViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "PropertiesViewController.h"
#import "SettingsViewController.h"

@interface PropertiesViewController ()

@end

@implementation PropertiesViewController

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
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:k_PROPERTIES_MAP_LINK]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Properties";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    CGRect frame = webView.frame;
//    frame.origin.y = top_bar.frame.origin.y;//+top_bar.frame.size.height;
//    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
//    webView.frame = frame;
    
    indicator.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    indicator.center = self.view.center;
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

-(IBAction)settingsAction:(id)sender{
    
    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(IBAction)homeAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [indicator stopAnimating];
}

@end
