//
//  AuthManager.h
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthManager : NSObject

@property (strong, nonatomic, readonly) NSString *facebookID;


+ (instancetype)defaultManager;


- (void)loginViaFacebook:(UIViewController *)controller withCompletion:(void (^)(NSError *error))block;

- (void)tryLoginWithbCompletion:(void (^)(NSError *error))block;


- (void)logOut;

@end
