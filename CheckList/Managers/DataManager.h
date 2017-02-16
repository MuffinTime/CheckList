//
//  DataManager.h
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Handler blocks */
typedef void (^ContentBlock)    (NSArray *content, NSError *error);
typedef void (^SuccesBlock)     (NSError *error);


@interface DataManager : NSObject

+ (instancetype)defaultManager;


/* ------ Event Methods ------ */

- (void)getAllEventsWithCompletion:(ContentBlock)block;

- (void)createEvent:(NSString *)name withbCompletion:(void (^)(Event *event))block;

- (void)updateEvent:(Event *)event eventName:(NSString *)name withCompletion:(SuccesBlock)block;

- (void)deleteEvent:(Event *)event withCompletion:(SuccesBlock)block;


/* ------ Task Methods ------ */

- (void)getTasksForEvent:(Event *)event withCompletion:(ContentBlock)block;

- (void)createTask:(NSString *)name taskDescription:(NSString *)description forEvent:(Event *)event withbCompletion:(void (^)(Task *task))block;

- (void)updateTask:(Task *)task taskName:(NSString *)name taskDescription:(NSString *)description withCompletion:(SuccesBlock)block;

- (void)updateTask:(Task *)task completeStatus:(BOOL)status withCompletion:(SuccesBlock)block;

- (void)deleteTask:(Task *)task withCompletion:(SuccesBlock)block;

@end
