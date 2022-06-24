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
    // Do any additional setup after loading the view.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return self.text.text.length + (self.text.text.length - range.length) <= 140;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

 - (IBAction)makeATweet:(id)sender {
     [[APIManager shared] postStatusWithText:(NSString *)self.text.text completion:^(Tweet* tweet, NSError *error) {
         if(error){
                 NSLog(@"Error composing Tweet: %@", error.localizedDescription);
             }
             else{
               [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
            }
     }];
 }
     
 
- (IBAction)closePage:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
