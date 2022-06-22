//
//  DetailsViewController.m
//  twitter
//
//  Created by Archita Singh on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *pfp;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetInfo;
@property (weak, nonatomic) IBOutlet UIButton *replyDetails;
@property (weak, nonatomic) IBOutlet UIButton *rtDetails;
@property (weak, nonatomic) IBOutlet UIButton *favDetails;
@property (weak, nonatomic) IBOutlet UIButton *dmDetails;


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
    
    self.pfp.image = [UIImage imageWithData: urlData];

    
    self.username.text = self.tweet.user.name;
    self.screenName.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.tweetInfo.text = self.tweet.text;
    
    //self.date.text = self.tweet.date.shortTimeAgoSinceNow;
    
    self.rtDetails.titleLabel.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount];
    self.favDetails.titleLabel.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    
    self.rtDetails.titleLabel.adjustsFontForContentSizeCategory = true;
    self.favDetails.titleLabel.adjustsFontForContentSizeCategory = true;
    
}

- (IBAction)didTapFavorite:(id)sender {
    if ((self.tweet.favorited == YES)) {
        
        // Update local tweet model when unliked
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Update cell UI
        [self.favDetails setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
        
        UIImage *unlikedImage = [UIImage imageNamed:@"favor-icon"];
        [self.favDetails setImage:unlikedImage forState:UIControlStateNormal];
        
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
        [self.favDetails setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
        
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.favDetails setImage:likedImage forState:UIControlStateNormal];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
