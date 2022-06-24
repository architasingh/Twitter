//
//  LoginViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Takes user to log-in page if log-in button is clicked
- (IBAction)didTapLogin:(id)sender {
    [[APIManager shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
