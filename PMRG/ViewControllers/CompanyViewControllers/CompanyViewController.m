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
#import "SocialCell.h"
#import "UIImageView+WebCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SVProgressHUD.h"

@interface CompanyViewController ()

-(void)configureLayout;
-(void)getSocialNewsFeed;
-(void)getFacebookFeed;
-(void)getTwitterFeed;
-(void)loadSocialFeed;

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
    socialFeed = [NSMutableArray array];
    [self loadSocialFeed];
    [self configureLayout];
    
    if ([[FBSession activeSession] isOpen]) {
        [self getFacebookFeed];
    }
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
    frame = social_tableView.frame;
    frame.origin.y = (top_bar.frame.origin.y+top_bar.frame.size.height)-20.0;
    frame.size.height = (bottom_bar.frame.origin.y-frame.origin.y)+20.0;
    social_tableView.frame = frame;
    
    about_btn.selected = YES;
    timeline_btn.selected = NO;
    news_btn.selected = NO;
    social_btn.selected = NO;
    
    about_us_view.hidden = NO;
    news_tableView.hidden = YES;
    timeline_tableView.hidden = YES;
    social_tableView.hidden = YES;
    
    news_tableView.tableHeaderView = newsHeaderView;
    news_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, news_tableView.frame.size.width, 15.0)];
    timeline_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, news_tableView.frame.size.width, 15.0)];
    social_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, social_tableView.frame.size.width, 15.0)];
}

-(void)getSocialNewsFeed {
    
    if ([[FBSession activeSession] isOpen]) {
        [self getFacebookFeed];
    }
    else {
        [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObjects:@"read_stream", nil] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
            if (!error && status == FBSessionStateOpen) {
                [self getFacebookFeed];
            }
        }];
    }
}

-(void)getFacebookFeed {
    
    if (social_btn.selected && [[AppInfo sharedInfo].facebookFeed count] == 0) {
        [SVProgressHUD showWithStatus:@"Loading facebook feed..." maskType:SVProgressHUDMaskTypeGradient];
    }
    [social_btn setUserInteractionEnabled:NO];
    [FBRequestConnection startWithGraphPath:@"/145542828839722/posts"
                                 parameters:[NSDictionary dictionaryWithObject:@"200" forKey:@"limit"]
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSArray *list = [result objectForKey:@"data"];
                              if (list && [list count] > 0) {
                                  [[AppInfo sharedInfo] loadFacebookFeed:list];
                                  if ([[AppInfo sharedInfo].facebookFeed count] > 0) {
                                      [self loadSocialFeed];
                                  }
                                  [social_tableView reloadData];
                              }
                              [SVProgressHUD dismiss];
                              [self getTwitterFeed];
                          }];
}

-(void)getTwitterFeed {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            if (social_btn.selected && [[AppInfo sharedInfo].twitterFeed count] == 0) {
                [SVProgressHUD showWithStatus:@"Loading twitter feed..." maskType:SVProgressHUDMaskTypeGradient];
            }
            NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
            NSString *urlString = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            [paramsDict setObject:@"@PMRealtyGroup" forKey:@"screen_name"];
            [paramsDict setObject:@"true" forKey:@"exclude_replies"];
            [paramsDict setObject:@"true" forKey:@"trim_user"];
            [paramsDict setObject:@"200" forKey:@"count"];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:urlString] parameters:paramsDict];
            [request setAccount:[twitterAccounts lastObject]];
            [request performRequestWithHandler:
             ^(NSData *responseData,
               NSHTTPURLResponse *urlResponse,
               NSError *error) {
                 if (responseData) {
                     if (urlResponse.statusCode >= 200 &&
                         urlResponse.statusCode < 300) {
                         NSError *jsonError;
                         NSArray *list = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                         if (list && [list count] > 0) {
                             [[AppInfo sharedInfo] loadTwitterFeed:list];
                             if ([[AppInfo sharedInfo].twitterFeed count] > 0) {
                                 [self loadSocialFeed];
                             }
                             [social_tableView reloadData];
                             [SVProgressHUD dismiss];
                         }
                     }
                 }
                 [SVProgressHUD dismiss];
                 [social_btn setUserInteractionEnabled:YES];
             }];
        }
        else {
            [social_btn setUserInteractionEnabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PMRG!" message:@"Please go to Settings.app and Login to your Twitter Account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)loadSocialFeed {
    
    [socialFeed removeAllObjects];
    [socialFeed addObjectsFromArray:[AppInfo sharedInfo].facebookFeed];
    [socialFeed addObjectsFromArray:[AppInfo sharedInfo].twitterFeed];
    [socialFeed sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSDate *date1 = [obj1 objectForKey:@"created_time"];
        NSDate *date2 = [obj2 objectForKey:@"created_time"];
        if ([date1 compare:date2] == NSOrderedAscending) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
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
    social_tableView.hidden = YES;
    about_us_view.hidden = NO;
}

-(IBAction)timelineAction:(id)sender {
    
    about_btn.selected = NO;
    timeline_btn.selected = YES;
    news_btn.selected = NO;
    social_btn.selected = NO;
    
    news_tableView.hidden = YES;
    about_us_view.hidden = YES;
    social_tableView.hidden = YES;
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
    social_tableView.hidden = YES;
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
    social_tableView.hidden = NO;
    
    [social_tableView reloadData];
    
    if ([socialFeed count] == 0) {
        [self getSocialNewsFeed];
    }
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
    else if (social_btn.selected) {
        NSDictionary *feed = [socialFeed objectAtIndex:indexPath.row];
        if ([feed objectForKey:@"type"] && [[feed objectForKey:@"type"] hasPrefix:@"photo"]) {
            return 240.0;
        }
        else {
            return 115.0;
        }
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
    else if (social_btn.selected) {
        return [socialFeed count];
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
    else if (social_btn.selected) {
        static NSString *cellIdentifier = @"SocialCellIdentifier";
        SocialCell *cell = (SocialCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SocialCell" owner:self options:nil] lastObject];
        }
        
        NSDictionary *feed = [socialFeed objectAtIndex:indexPath.row];
        if ([feed objectForKey:@"social_type"] && [[feed objectForKey:@"social_type"] isEqualToString:@"Facebook"]) {
            cell.tag_lbl.hidden = YES;
            cell.social_icon.image = [UIImage imageNamed:@"fb_icon.png"];
            if ([feed objectForKey:@"type"] && [[feed objectForKey:@"type"] hasPrefix:@"photo"]) {
                NSString *image_url = [feed objectForKey:@"picture"];
                if (image_url) {
                    cell.social_image.hidden = NO;
                    [cell.social_image setImageWithURL:[NSURL URLWithString:image_url]];
                }
                else {
                    cell.social_image.hidden = YES;
                }
            }
            else {
                cell.social_image.hidden = YES;
            }
            if ([feed objectForKey:@"message"] && [[feed objectForKey:@"message"] length] > 0) {
                cell.detail_TV.text = [feed objectForKey:@"message"];
            }
            else if ([feed objectForKey:@"description"] && [[feed objectForKey:@"description"] length] > 0) {
                cell.detail_TV.text = [feed objectForKey:@"description"];
            }
            else if ([feed objectForKey:@"caption"] && [[feed objectForKey:@"caption"] length] > 0) {
                cell.detail_TV.text = [feed objectForKey:@"caption"];
            }
            else {
                cell.detail_TV.text = @"PM Realty Group";
            }
            CGRect frame = cell.detail_TV.frame;
            frame.size.height = (cell.link_btn.frame.origin.y-frame.origin.y)-4.0;
            cell.detail_TV.frame = frame;
            if ([feed objectForKey:@"link"] && [[feed objectForKey:@"link"] length] > 0) {
                [cell.link_btn setTitle:[feed objectForKey:@"link"] forState:UIControlStateNormal];
                cell.link_btn.hidden = NO;
            }
            else if ([feed objectForKey:@"caption"] && [[feed objectForKey:@"caption"] length] > 0) {
                [cell.link_btn setTitle:[feed objectForKey:@"caption"] forState:UIControlStateNormal];
                cell.link_btn.hidden = NO;
            }
            else {
                cell.link_btn.hidden = YES;
                frame = cell.detail_TV.frame;
                frame.size.height = (cell.link_btn.frame.origin.y-frame.origin.y)+cell.link_btn.frame.size.height;
                cell.detail_TV.frame = frame;
            }
        }
        else {
            cell.tag_lbl.hidden = NO;
            cell.social_image.hidden = YES;
            cell.link_btn.hidden = YES;
            cell.social_icon.image = [UIImage imageNamed:@"twitter_icon.png"];
            if ([feed objectForKey:@"text"] && [[feed objectForKey:@"text"] length] > 0) {
                cell.detail_TV.text = [feed objectForKey:@"text"];
            }
            else {
                cell.detail_TV.text = @"PM Realty Group";
            }
            CGRect frame = cell.detail_TV.frame;
            frame.size.height = (cell.link_btn.frame.origin.y-frame.origin.y)+cell.link_btn.frame.size.height;
            cell.detail_TV.frame = frame;
        }
        
        return cell;
    }
    
    return nil;//cell;
}

@end
