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

@interface TimelineViewController () <ComposeViewControllerDelegate, DetailsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOut;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
- (IBAction)didTapLogout:(id)sender;

@end
@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.timelineTableView insertSubview:refreshControl atIndex:0];
    self.timelineTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
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

// Loads updated home timeline
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

            [self.timelineTableView reloadData];
            [refreshControl endRefreshing];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// Sets up segue to both compose tweet and details page
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
        dvc.delegate = self;
    }
}

// Takes user to log-in page if log-out button is clicked
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

// Sets table view fields
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetID" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.actualUsername.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.username.text = tweet.user.name;
    cell.actualTweet.text = tweet.text;
    cell.date.text = tweet.date.shortTimeAgoSinceNow;
    
    [self setImageUI:cell forProfilePic:tweet];
    
    [self setButtonUI:cell forlikeRt:tweet];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// Returns number of tweets
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// Adds newly composed tweet to the top of the timeline
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.timelineTableView reloadData];
}

// Reloads table view to reflect if something has been liked/retweeted
- (void)didLikeOrRetweet:(Tweet *)tweet; {
    [self.timelineTableView reloadData];
}

// Sets images and counts for retweet and like buttons
- (void)setButtonUI:(nonnull TweetCell *)cell forlikeRt:(nonnull Tweet *)tweet {
    [cell.retweet setTitle:[NSString stringWithFormat: @"%d", cell.tweet.retweetCount] forState:UIControlStateNormal];
    
    [cell.like setTitle:[NSString stringWithFormat: @"%d", cell.tweet.favoriteCount] forState:UIControlStateNormal];
    
    if ((tweet.favorited == YES)) {
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red"];
        [cell.like setImage:likedImage forState:UIControlStateNormal];
    } else {
        UIImage *unlikedImage = [UIImage imageNamed:@"favor-icon"];
        [cell.like setImage:unlikedImage forState:UIControlStateNormal];
    }
    
    if ((tweet.retweeted == YES)) {
        UIImage *rtImage = [UIImage imageNamed:@"retweet-icon-green"];
        [cell.retweet setImage:rtImage forState:UIControlStateNormal];
    } else {
        UIImage *unretweetImage = [UIImage imageNamed:@"retweet-icon"];
        [cell.retweet setImage:unretweetImage forState:UIControlStateNormal];
    }
}

// Sets profile pic image to be circular and good quality
- (void)setImageUI:(nonnull TweetCell *)cell forProfilePic:(nonnull Tweet *)tweet {
    NSString *URLString = tweet.user.profilePicture;
    NSString *URLUnblurry = [URLString
       stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLUnblurry];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profilePic.image = [UIImage imageWithData: urlData];
    cell.profilePic.layer.cornerRadius = 25;
    cell.profilePic.layer.masksToBounds = YES;
}

@end
