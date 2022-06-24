//
//  ComposeViewController.m
//  twitter
//
//  Created by Archita Singh on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
- (IBAction)closePage:(id)sender;
- (IBAction)makeATweet:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.text.delegate = self;
    
    self.charCount.text = @"Characters Left: 280";
}

// Asks delegate if max limit has been reached
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int characterLimit = 281;
    NSString *newText = [self.text.text stringByReplacingCharactersInRange:range withString:text];
    return newText.length < characterLimit;
}

// Displays the number of available characters left in the tweet that's being composed
- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger length;
    length = [textView.text length];
    NSString *numToString = [NSString stringWithFormat:@"%lu", 280 - (unsigned long)length];
    NSString *addLabel = [@"Characters left: " stringByAppendingString: numToString];
    self.charCount.text = addLabel;
}

// Creates tweet if its within the character count
 - (IBAction)makeATweet:(id)sender {
     [[APIManager shared] postStatusWithText:(NSString *)self.text.text completion:^(Tweet* tweet, NSError *error) {
         if(error){
                 NSLog(@"Error composing Tweet: %@", error.localizedDescription);
             }
             else{
                 if ([self textView:self.text shouldChangeTextInRange:NSMakeRange(0, 280) replacementText:self.text.text]) {
                     [self.delegate didTweet:tweet];
                      NSLog(@"Compose Tweet Success!");
                 }
            }
     }];
 }

// Closes compose tweet page
- (IBAction)closePage:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
