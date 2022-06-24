//
//  TweetCell.h
//  twitter
//
//  Created by Archita Singh on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
//@protocol TweetCellDelegate
//@end

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *actualTweet;
@property (weak, nonatomic) IBOutlet UIButton *reply;
@property (weak, nonatomic) IBOutlet UIButton *retweet;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UILabel *actualUsername;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (nonatomic, strong) Tweet *tweet;
//@property (nonatomic, weak) id<TweetCellDelegate> TCDelegate;

- (void)ifRetweeted;
- (void)ifUnRetweeted;
- (void)ifFavorited;
- (void)ifUnFavorited;

@end

NS_ASSUME_NONNULL_END
