//
//  ComposeViewController.h
//  twitter
//
//  Created by Archita Singh on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *close;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createTweet;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *charCount;

@end

NS_ASSUME_NONNULL_END
