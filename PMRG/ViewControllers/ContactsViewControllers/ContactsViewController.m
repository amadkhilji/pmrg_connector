//
//  ContactsViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"

@interface ContactsViewController ()

-(void)loadContactsList;

@end

@implementation ContactsViewController

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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 16)];
    headerView.backgroundColor = [UIColor clearColor];
    contactsTableView.tableHeaderView = headerView;
    bg_image.image = [[AppInfo sharedInfo] getContactsBackgroundImage];
    
    
    contactsData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Contacts_List" ofType:@"plist"]];
    contactsList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Contacts";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGRect frame = contactsTableView.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    contactsTableView.frame = frame;
    
    [self loadContactsList];
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

-(void)loadContactsList {
    
    [contactsList removeAllObjects];
    if (western_btn.selected) {
        [contactsList addObjectsFromArray:[contactsData objectForKey:@"western"]];
    }
    else if (central_btn.selected) {
        [contactsList addObjectsFromArray:[contactsData objectForKey:@"central"]];
    }
    else if (southeast_btn.selected) {
        [contactsList addObjectsFromArray:[contactsData objectForKey:@"southeast"]];
    }
    else if (northeast_btn.selected) {
        [contactsList addObjectsFromArray:[contactsData objectForKey:@"northeast"]];
    }
}

-(IBAction)menuAction:(id)sender {
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
}

-(IBAction)settingsAction:(id)sender{
    
}

-(IBAction)homeAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)westernButtonAction:(id)sender {
    
    western_btn.selected = YES;
    central_btn.selected = NO;
    southeast_btn.selected = NO;
    northeast_btn.selected = NO;
    
    [contactsTableView reloadData];
}

-(IBAction)centralButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = YES;
    southeast_btn.selected = NO;
    northeast_btn.selected = NO;
    
    [contactsTableView reloadData];
}

-(IBAction)southeastButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = NO;
    southeast_btn.selected = YES;
    northeast_btn.selected = NO;
    
    [contactsTableView reloadData];
}

-(IBAction)northeastButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = NO;
    southeast_btn.selected = NO;
    northeast_btn.selected = YES;
    
    [contactsTableView reloadData];
}

#pragma mark
#pragma mark UITableViewDataSource/UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *contact = [contactsList objectAtIndex:indexPath.row];
    NSString *heading = [contact objectForKey:@"heading"];
    if (heading.length == 0) {
        return 100.0;
    }
    return 115.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self loadContactsList];
    return [contactsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactsCellIdentifier";
    ContactsCell *cell = (ContactsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *contact = [contactsList objectAtIndex:indexPath.row];
    NSString *heading = [contact objectForKey:@"heading"];
    cell.heading_lbl.text = [NSString stringWithFormat:@"  %@", heading];
    cell.name_lbl.text = [contact objectForKey:@"name"];
    cell.title_lbl.text = [contact objectForKey:@"title"];
    cell.description_lbl.text = [contact objectForKey:@"description"];
    cell.email_lbl.text = [contact objectForKey:@"email"];
    cell.profile_image.image = [UIImage imageNamed:[contact objectForKey:@"image"]];
    if (heading.length > 0) {
        cell.heading_lbl.hidden = NO;
    }
    else {
        cell.heading_lbl.hidden = YES;
    }
    
    return cell;
}

@end
