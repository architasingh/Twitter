//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "DateTools.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOut;
- (IBAction)didTapLogout:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end
@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:refreshControl atIndex:0];

    self.timelineTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        
        self.timelineTableView.dataSource = self;
        
        self.arrayOfTweets = (NSMutableArray *)tweets;
        
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            [self.timelineTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        
        self.timelineTableView.dataSource = self;
        
        self.arrayOfTweets = (NSMutableArray *)tweets;
        
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            [self.timelineTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
            // Reload the tableView now that there is new data
            [self.timelineTableView reloadData];

            // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ComposeViewSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"DetailViewSegue"]) {
        DetailsViewController *dvc = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.timelineTableView indexPathForCell:(UITableViewCell *)sender];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        dvc.tweet = tweet;
    }
}

- (IBAction)didTapLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetID" forIndexPath:indexPath];

    // Get the tweet at the specified index in the tweet array
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    NSString *URLString = tweet.user.profilePicture;
    NSString *URLUnblurry = [URLString
       stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLUnblurry];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    cell.tweet = tweet;
    cell.profilePic.image = [UIImage imageWithData: urlData];
    
    cell.username.text = tweet.user.name;
    cell.actualUsername.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.actualTweet.text = tweet.text;
    
    cell.date.text = tweet.date.shortTimeAgoSinceNow;
    
    cell.retweet.titleLabel.text = [NSString stringWithFormat: @"%d", tweet.retweetCount];
    cell.like.titleLabel.text = [NSString stringWithFormat: @"%d", tweet.favoriteCount];
    
    cell.retweet.titleLabel.adjustsFontForContentSizeCategory = true;
    cell.like.titleLabel.adjustsFontForContentSizeCategory = true;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (void)didTweet:(nonnull Tweet *)tweet {
}



@end
