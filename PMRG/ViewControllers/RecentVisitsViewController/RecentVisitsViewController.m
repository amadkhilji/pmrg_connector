//
//  RecentVisitsViewController.m
//  PMRG
//
//  Created by SSASOFT on 1/13/15.
//  Copyright (c) 2015 TechLeadz. All rights reserved.
//

#import "RecentVisitsViewController.h"
#import "SettingsViewController.h"
#import "SVWebViewController.h"

@interface RecentVisitsViewController ()

-(IBAction)editAction:(id)sender;
-(IBAction)doneAction:(id)sender;

@end

@implementation RecentVisitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    bg_image.image = [[AppInfo sharedInfo] getContactsBackgroundImage];
    
    if ([[AppInfo sharedInfo].visitedBeaconsList count] > 0) {
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
        [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
    }
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE d MMM, hh:mm a"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Recent Visits";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGRect frame = visitsTableView.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    visitsTableView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark IBAction Methods

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

-(IBAction)editAction:(id)sender {
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneBtn animated:YES];
    [visitsTableView setEditing:YES animated:YES];
}

-(IBAction)doneAction:(id)sender {
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
    [visitsTableView setEditing:NO animated:YES];
}

#pragma mark
#pragma mark UITableViewDataSource/UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[AppInfo sharedInfo].visitedBeaconsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"VisitedBeaconCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    NSDictionary *beacon = [[AppInfo sharedInfo].visitedBeaconsList objectAtIndex:indexPath.row];
    NSString *titleStr = [beacon objectForKey:@"title"];
    NSString *dateStr = [formatter stringFromDate:[beacon objectForKey:@"date"]];
    cell.textLabel.text = titleStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Visited at: %@", dateStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *beacon = [[AppInfo sharedInfo].visitedBeaconsList objectAtIndex:indexPath.row];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[beacon objectForKey:@"pdf_url"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *beacon = [[AppInfo sharedInfo].visitedBeaconsList objectAtIndex:indexPath.row];
        [[AppInfo sharedInfo] removeVisitedBeacon:beacon];
        [[AppInfo sharedInfo] saveVisitedBeacons];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
