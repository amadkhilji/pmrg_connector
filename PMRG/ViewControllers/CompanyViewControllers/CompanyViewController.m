//
//  CompanyViewController.m
//  PMRG
//
//  Created by SSASOFT on 8/18/14.
//  Copyright (c) 2014 TechLeadz. All rights reserved.
//

#import "CompanyViewController.h"
#import "NewsCell.h"
#import "TimelineCell.h"

@interface CompanyViewController ()

-(void)configureLayout;

@end

@implementation CompanyViewController

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
    bg_image.image = [[AppInfo sharedInfo] getCompanyBackgroundImage];
    newsList = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"News_List" ofType:@"plist"]];
    timelineList = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Timeline_List" ofType:@"plist"]];
    [self configureLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Company";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

-(void)configureLayout {
    
    CGRect frame = about_us_view.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    about_us_view.frame = frame;
    frame = news_tableView.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    news_tableView.frame = frame;
    frame = timeline_tableView.frame;
    frame.origin.y = top_bar.frame.origin.y+top_bar.frame.size.height;
    frame.size.height = bottom_bar.frame.origin.y-frame.origin.y;
    timeline_tableView.frame = frame;
    
    about_btn.selected = YES;
    timeline_btn.selected = NO;
    news_btn.selected = NO;
    social_btn.selected = NO;
    
    about_us_view.hidden = NO;
    news_tableView.hidden = YES;
    timeline_tableView.hidden = YES;
    
    news_tableView.tableHeaderView = newsHeaderView;
    news_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, news_tableView.frame.size.width, 15.0)];
    timeline_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, news_tableView.frame.size.width, 15.0)];
}

#pragma mark
#pragma mark IBAction Methods

-(IBAction)menuAction:(id)sender {
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
}

-(IBAction)settingsAction:(id)sender{
    
}

-(IBAction)homeAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)aboutAction:(id)sender {
    
    about_btn.selected = YES;
    timeline_btn.selected = NO;
    news_btn.selected = NO;
    social_btn.selected = NO;
    
    news_tableView.hidden = YES;
    timeline_tableView.hidden = YES;
    about_us_view.hidden = NO;
}

-(IBAction)timelineAction:(id)sender {
    
    about_btn.selected = NO;
    timeline_btn.selected = YES;
    news_btn.selected = NO;
    social_btn.selected = NO;
    
    news_tableView.hidden = YES;
    about_us_view.hidden = YES;
    timeline_tableView.hidden = NO;
    
    [timeline_tableView reloadData];
}

-(IBAction)newsAction:(id)sender {
    
    about_btn.selected = NO;
    timeline_btn.selected = NO;
    news_btn.selected = YES;
    social_btn.selected = NO;
    
    about_us_view.hidden = YES;
    timeline_tableView.hidden = YES;
    news_tableView.hidden = NO;
    
    [news_tableView reloadData];
}

-(IBAction)socialAction:(id)sender {
    
    about_btn.selected = NO;
    timeline_btn.selected = NO;
    news_btn.selected = NO;
    social_btn.selected = YES;
    
    about_us_view.hidden = YES;
    timeline_tableView.hidden = YES;
    news_tableView.hidden = YES;
}

#pragma mark
#pragma mark UITableViewDataSource/UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (news_btn.selected) {
        NSString *text = [[newsList objectAtIndex:indexPath.row] objectForKey:@"news"];
        CGFloat height = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0] constrainedToSize:CGSizeMake(200, 100)].height;
        if (height < 25.0) {
            height = 25.0;
        }
        else if (height > 100.0) {
            height = 100.0;
        }
        return height+10.0;
    }
    else if (timeline_btn.selected) {
        NSString *text = [[timelineList objectAtIndex:indexPath.row] objectForKey:@"description"];
        CGFloat height = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0] constrainedToSize:CGSizeMake(270, 200)].height;
        if (height < 50.0) {
            height = 50.0;
        }
        else if (height > 200.0) {
            height = 200.0;
        }
        return height+40.0;
    }
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (news_btn.selected) {
        return [newsList count];
    }
    else if (timeline_btn.selected) {
        return [timelineList count];
    }
    return 0;//[contactsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (news_btn.selected) {
        static NSString *cellIdentifier = @"NewsCellIdentifier";
        NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
        }
        
        NSDictionary *news = [newsList objectAtIndex:indexPath.row];
        cell.date_lbl.text = [news objectForKey:@"date"];
        cell.news_lbl.text = [news objectForKey:@"news"];

        CGFloat height = [cell.news_lbl.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0] constrainedToSize:CGSizeMake(200, 100)].height;
        if (height < 25.0) {
            height = 25.0;
        }
        else if (height > 100.0) {
            height = 100.0;
        }
        CGRect frame = cell.frame;
        frame.size.height = height+10.0;
        cell.frame = frame;
        
        return cell;
    }
    else if (timeline_btn.selected) {
        static NSString *cellIdentifier = @"TimelineCellIdentifier";
        TimelineCell *cell = (TimelineCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil] lastObject];
        }
        
        NSDictionary *timeline = [timelineList objectAtIndex:indexPath.row];
        cell.title.text = [timeline objectForKey:@"title"];
        cell.description.text = [timeline objectForKey:@"description"];
        if (indexPath.row == 0) {
            cell.dots_separator.hidden = YES;
        }
        else {
            cell.dots_separator.hidden = NO;
        }
        
        CGFloat height = [cell.description.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0] constrainedToSize:CGSizeMake(270, 200)].height;
        if (height < 50.0) {
            height = 50.0;
        }
        else if (height > 200.0) {
            height = 200.0;
        }
        CGRect frame = cell.frame;
        frame.size.height = height+40.0;
        cell.frame = frame;
        
        return cell;
    }
    
    return nil;//cell;
}

@end
