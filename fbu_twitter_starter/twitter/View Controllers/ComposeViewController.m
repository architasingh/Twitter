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
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.text.text stringByReplacingCharactersInRange:range withString:text];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

 - (IBAction)makeATweet:(id)sender {
     [[APIManager shared] postStatusWithText:(NSString *)self.text.text completion:^(Tweet* tweet, NSError *error) {
         if(error){
                 NSLog(@"Error composing Tweet: %@", error.localizedDescription);
             }
             else{
                 if ([self textView:self.text shouldChangeTextInRange:NSMakeRange(0, 140) replacementText:self.text.text]) {
                     [self.delegate didTweet:tweet];
                      NSLog(@"Compose Tweet Success!");
                 } else {
                     NSLog(@"Exceeded character limit");
                 }
            }
     }];
 }
     
- (IBAction)closePage:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
