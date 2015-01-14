//
//  SideMenuViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "SideMenuViewController.h"
#import "CompanyViewController.h"
#import "ContactsViewController.h"
#import "ReportsViewController.h"
#import "PropertiesViewController.h"
#import "RecentVisitsViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

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
    
    itemLabels = [NSArray arrayWithObjects:@"Company", @"Contacts", @"Market Reports", @"Properties", @"Recent Visits", nil];
    itemIcons = [NSArray arrayWithObjects:@"company_icon.png", @"contacts_icon.png", @"chart_icon.png", @"properties_icon.png", @"visit_icon.png", nil];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [itemLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SideMenu_CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:[itemIcons objectAtIndex:indexPath.row]];
    cell.imageView.image = placeholderImage;
    cell.textLabel.text = [itemLabels objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *contentController = nil;
    UIViewController *centerViewController = nil;
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    
    switch (indexPath.row) {
        case 0:
            for (UIViewController *vc in navigationController.viewControllers) {
                if ([vc isKindOfClass:[CompanyViewController class]]) {
                    centerViewController = vc;
                    break;
                }
            }
            if (!centerViewController) {
                contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CompanyViewController"];
            }
            break;
        case 1:
            for (UIViewController *vc in navigationController.viewControllers) {
                if ([vc isKindOfClass:[ContactsViewController class]]) {
                    centerViewController = vc;
                    break;
                }
            }
            if (!centerViewController) {
                contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ContactsViewController"];
            }
            break;
        case 2:
            for (UIViewController *vc in navigationController.viewControllers) {
                if ([vc isKindOfClass:[ReportsViewController class]]) {
                    centerViewController = vc;
                    break;
                }
            }
            if (!centerViewController) {
                contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ReportsViewController"];
            }
            break;
        case 3:
            for (UIViewController *vc in navigationController.viewControllers) {
                if ([vc isKindOfClass:[PropertiesViewController class]]) {
                    centerViewController = vc;
                    break;
                }
            }
            if (!centerViewController) {
                contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PropertiesViewController"];
            }
            break;
        case 4:
            for (UIViewController *vc in navigationController.viewControllers) {
                if ([vc isKindOfClass:[RecentVisitsViewController class]]) {
                    centerViewController = vc;
                    break;
                }
            }
            if (!centerViewController) {
                contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RecentVisitsViewController"];
            }
            break;
        default:
            break;
    }
    
    if (!centerViewController && contentController) {
        NSArray *controllers = [NSArray arrayWithObjects:[navigationController.viewControllers firstObject], contentController, nil];
        navigationController.viewControllers = controllers;
    }
    else if (centerViewController && ![navigationController.topViewController isKindOfClass:[centerViewController class]]) {
        [navigationController popToViewController:centerViewController animated:YES];
    }
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end
