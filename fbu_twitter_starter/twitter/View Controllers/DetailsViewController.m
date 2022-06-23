//
//  DetailsViewController.m
//  twitter
//
//  Created by Archita Singh on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *actualTweet;
@property (weak, nonatomic) IBOutlet UIButton *reply;
@property (weak, nonatomic) IBOutlet UIButton *retweet;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UILabel *actualUsername;
@property (weak, nonatomic) IBOutlet UILabel *date;

- (IBAction)closePage:(id)sender;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.tweet);
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSString *URLUnblurry = [URLString
       stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLUnblurry];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profilePic.image = [UIImage imageWithData: urlData];
    
    self.actualUsername.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.username.text = self.tweet.user.name;
    
    self.actualTweet.text = self.tweet.text;
    
    self.date.text = self.tweet.date.shortTimeAgoSinceNow;
    
    [self.retweet setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    
    [self.like setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    
    if ((self.tweet.favorited == YES)) {
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.like setImage:likedImage forState:UIControlStateNormal];
    } else {
        UIImage *unlikedImage = [UIImage imageNamed:@"favor-icon"];
        [self.like setImage:unlikedImage forState:UIControlStateNormal];
    }
    
    if ((self.tweet.retweeted == YES)) {
        UIImage *rtImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweet setImage:rtImage forState:UIControlStateNormal];
    } else {
        UIImage *unretweetImage = [UIImage imageNamed:@"retweet-icon"];
        [self.retweet setImage:unretweetImage forState:UIControlStateNormal];
    }
    
}



- (IBAction)didTapFavorite:(id)sender {
    if ((self.tweet.favorited == YES)) {
        
        // Update local tweet model when unliked
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Update cell UI
        [self.like setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
        
        UIImage *unlikedImage = [UIImage imageNamed:@"favor-icon"];
        [self.like setImage:unlikedImage forState:UIControlStateNormal];
        
        // Send a POST request to the POST unfavorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                [self.delegate didLikeOrRetweet:self.tweet];
            }
        }];
    } else {
        // TODO: Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // TODO: Update cell UI
        [self.like setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
        
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.like setImage:likedImage forState:UIControlStateNormal];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                [self.delegate didLikeOrRetweet:self.tweet];
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if ((self.tweet.retweeted == YES)) {
        
        // Update local tweet model when unliked
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // Update cell UI
        [self.retweet setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
        
        UIImage *unretweetImage = [UIImage imageNamed:@"retweet-icon"];
        [self.retweet setImage:unretweetImage forState:UIControlStateNormal];
        
        // Send a POST request to the POST unfavorites/create endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                [self.delegate didLikeOrRetweet:self.tweet];
            }
        }];
    } else {
        // TODO: Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // TODO: Update cell UI
        [self.retweet setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
        
        UIImage *rtImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweet setImage:rtImage forState:UIControlStateNormal];
        
        // TODO: Send a POST request to the POST rt/create endpoint
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error un-retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully un-retweeted the following Tweet: %@", tweet.text);
                [self.delegate didLikeOrRetweet:self.tweet];
            }
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closePage:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
