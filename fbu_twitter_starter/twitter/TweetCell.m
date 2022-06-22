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
            }
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
