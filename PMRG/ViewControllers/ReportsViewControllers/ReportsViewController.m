//
//  ReportsViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "ReportsViewController.h"
#import "ReportsCell.h"
#import "PDFViewController.h"
#import "SettingsViewController.h"

@interface ReportsViewController ()

-(void)loadReportsList;

@end

@implementation ReportsViewController

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
    reportsTableView.tableHeaderView = headerView;
    bg_image.image = [[AppInfo sharedInfo] getMarketReportsBackgroundImage];
    
    reportsData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Reports_List" ofType:@"plist"]];
    reportsList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Market Reports";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGRect frame = reportsTableView.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    reportsTableView.frame = frame;
    
    [self loadReportsList];
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

-(void)loadReportsList {
    
    [reportsList removeAllObjects];
    if (western_btn.selected) {
        [reportsList addObjectsFromArray:[reportsData objectForKey:@"western"]];
    }
    else if (central_btn.selected) {
        [reportsList addObjectsFromArray:[reportsData objectForKey:@"central"]];
    }
    else if (southeast_btn.selected) {
        [reportsList addObjectsFromArray:[reportsData objectForKey:@"southeast"]];
    }
    else if (northeast_btn.selected) {
        [reportsList addObjectsFromArray:[reportsData objectForKey:@"northeast"]];
    }
}

#pragma mark
#pragma mark Public Methods

-(void)openPDFAtIndex:(NSInteger)index {
    
    NSDictionary *report = [reportsList objectAtIndex:index];
    NSURL *pdf_url = nil;
    if ([[report objectForKey:@"pdf_file"] length] > 0) {
        pdf_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[[report objectForKey:@"pdf_file"] stringByReplacingOccurrencesOfString:@".pdf" withString:@""] ofType:@"pdf"]];
    }
    else if ([[report objectForKey:@"pdf_link"] length] > 0) {
        pdf_url = [NSURL URLWithString:[report objectForKey:@"pdf_link"]];
    }
    
    if (pdf_url) {
        PDFViewController *pdfVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PDFViewController"];
        pdfVC.heading = [report objectForKey:@"name"];
        pdfVC.pdf_url = pdf_url;
        [self.navigationController pushViewController:pdfVC animated:YES];
    }
}

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

-(IBAction)westernButtonAction:(id)sender {
    
    western_btn.selected = YES;
    central_btn.selected = NO;
    southeast_btn.selected = NO;
    northeast_btn.selected = NO;
    
    [reportsTableView reloadData];
}

-(IBAction)centralButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = YES;
    southeast_btn.selected = NO;
    northeast_btn.selected = NO;
    
    [reportsTableView reloadData];
}

-(IBAction)southeastButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = NO;
    southeast_btn.selected = YES;
    northeast_btn.selected = NO;
    
    [reportsTableView reloadData];
}

-(IBAction)northeastButtonAction:(id)sender {
    
    western_btn.selected = NO;
    central_btn.selected = NO;
    southeast_btn.selected = NO;
    northeast_btn.selected = YES;
    
    [reportsTableView reloadData];
}

#pragma mark
#pragma mark UITableViewDataSource/UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *report = [reportsList objectAtIndex:indexPath.row];
    NSString *heading = [report objectForKey:@"heading"];
    if (heading.length == 0) {
        return 115.0;
    }
    return 135.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self loadReportsList];
    return [reportsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ReportsCellIdentifier";
    ReportsCell *cell = (ReportsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportsCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *report = [reportsList objectAtIndex:indexPath.row];
    NSString *heading = [report objectForKey:@"heading"];
    cell.heading_lbl.text = [NSString stringWithFormat:@"   %@", heading];
    cell.name_lbl.text = [report objectForKey:@"name"];
    cell.title_lbl.text = [report objectForKey:@"title"];
    cell.description_lbl.text = [report objectForKey:@"description"];
    cell.report_image.image = [UIImage imageNamed:[report objectForKey:@"image"]];
    cell.tag = indexPath.row;
    cell.parentController = self;
    if (heading.length > 0) {
        cell.heading_lbl.hidden = NO;
    }
    else {
        cell.heading_lbl.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    [self openPDFAtIndex:indexPath.row];
}

@end
