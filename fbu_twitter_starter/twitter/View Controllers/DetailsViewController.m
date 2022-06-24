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
#import "TweetCell.h"

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
    
    [self setButtonUI];
}

// Update local tweet model, cell UI, and send post request for favorite button
- (IBAction)didTapFavorite:(id)sender {
    if ((self.tweet.favorited == YES)) {
        [self ifFavorited];
    } else {
        [self ifUnFavorited];
    }
    [self.delegate didLikeOrRetweet:self.tweet];
}

- (IBAction)didTapRetweet:(id)sender {
    if ((self.tweet.retweeted == YES)) {
        [self ifRetweeted];
    } else {
        [self ifUnRetweeted];
    }
    [self.delegate didLikeOrRetweet:self.tweet];
}
// Updates cell UI and sends post request for retweeting
- (void)ifRetweeted {
    self.tweet.retweeted = NO;
    self.tweet.retweetCount -= 1;
    
    [self.retweet setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    
    UIImage *unretweetImage = [UIImage imageNamed:@"retweet-icon"];
    [self.retweet setImage:unretweetImage forState:UIControlStateNormal];
    
    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
}

// Updates cell UI and sends post request for unretweeting
- (void)ifUnRetweeted {
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;

    [self.retweet setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];

    UIImage *rtImage = [UIImage imageNamed:@"retweet-icon-green"];
    [self.retweet setImage:rtImage forState:UIControlStateNormal];

    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error un-retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully un-retweeted the following Tweet: %@", tweet.text);
        }
    }];
}

// Updates cell UI and sends post request for favoriting
- (void)ifFavorited {
    self.tweet.favorited = NO;
    self.tweet.favoriteCount -= 1;

    [self.like setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];

    UIImage *likedImage = [UIImage imageNamed:@"favor-icon"];
    [self.like setImage:likedImage forState:UIControlStateNormal];

    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}

// Updates cell UI and sends post request for unfavoriting
- (void)ifUnFavorited {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;

    [self.like setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];

    UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red"];
    [self.like setImage:likedImage forState:UIControlStateNormal];

    [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        
    if(error) {
        NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
    }
    else {
        NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
    }
    }];
}

- (void)setButtonUI {
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)closePage:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
