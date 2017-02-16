//
//  AuthViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 15/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "AuthViewController.h"



@interface AuthViewController ()

@end



@implementation AuthViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[AuthManager defaultManager] tryLoginWithbCompletion:nil];
}



#pragma mark - Actions

- (IBAction)facebookAction:(id)sender {
    
    // Login via facebook
    [[AuthManager defaultManager] loginViaFacebook:self withCompletion:nil];
}

@end
