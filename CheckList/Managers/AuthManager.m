//
//  AuthManager.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "AuthManager.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

/* Animation duration after login */
static float const TRANSITION_DURATION = 0.5;

static NSString * const kUserID = @"userID";



@interface AuthManager ()

/* --- Data --- */
@property (strong, nonatomic, readwrite) NSString *facebookID;

@end



@implementation AuthManager

#pragma mark - Class methods

+ (instancetype)defaultManager {
    
    static AuthManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[AuthManager alloc] init];
    });
    
    return manager;
}



#pragma mark - Public

- (void)loginViaFacebook:(UIViewController *)controller withCompletion:(void (^)(NSError *error))block {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logOut];
    
    NSArray *permisions = [[NSArray alloc] initWithObjects: @"email", nil];
    
    [login logInWithReadPermissions:permisions
                 fromViewController:controller
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    if (block)
                                        block(error);
                                }
                                else if (result.isCancelled) {
                                    
                                    if (block)
                                        block([NSError errorWithDomain:@"" code:101 userInfo:nil]);
                                }
                                else {
                                    
                                    [self setupUser:[result.token userID]];
                                    [self setupCoreDataStack];
                                    
                                    // Go to app navigation
                                    [self showAppNavigation];
                                    
                                    if (block)
                                        block(nil);
                                    }
                            }];
}

- (void)tryLoginWithbCompletion:(void (^)(NSError *error))block {
    
    if ([self isLogged]) {
        
        self.facebookID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
        [self setupCoreDataStack];
        [self showAppNavigation];
        
        if (block)
            block(nil);
    }
    else {
        
        if (block)
            block([NSError errorWithDomain:@"" code:111 userInfo:@{}]);
    }
}

- (void)logOut {
    
    [self removeUser];
    [self showAppAuth];
}


#pragma mark - Private

- (void)setupCoreDataStack {
    
    [MagicalRecord cleanUp];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:self.facebookID];
}

- (void)setupUser:(NSString *)facebookID {
    
    // Remember userID
    [[NSUserDefaults standardUserDefaults] setObject:facebookID forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.facebookID = facebookID;
    [self setupCoreDataStack];
}

- (void)removeUser {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.facebookID = nil;
    [MagicalRecord cleanUp];
}

- (BOOL)isLogged {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
}

- (void)showAppNavigation {
    
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CheckListNavigationController"];
    
    // Sign In animation
    [UIView transitionWithView:[(AppDelegate *)[[UIApplication sharedApplication] delegate] window]
                      duration:TRANSITION_DURATION
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^(void) {
                        
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] setRootViewController:navigationController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)showAppAuth {
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AuthViewController"];
    
    // Sign Out animation
    [UIView transitionWithView:[(AppDelegate *)[[UIApplication sharedApplication] delegate] window]
                      duration:TRANSITION_DURATION
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] setRootViewController:viewController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

@end
