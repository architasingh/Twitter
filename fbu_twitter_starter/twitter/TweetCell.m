//
//  TweetCell.m
//  twitter
//
//  Created by Archita Singh on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (IBAction)didTapFavorite:(id)sender {
    if ((self.tweet.favorited == YES)) {
        [self ifFavorited];
    } else {
        [self ifUnFavorited];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if ((self.tweet.retweeted == YES)) {
        [self ifRetweeted];
    } else {
        [self ifUnRetweeted];
    }
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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
