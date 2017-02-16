//
//  DataManager.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

#pragma mark - Class methods

+ (instancetype)defaultManager {
    
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}


#pragma mark - Event Methods

- (void)getAllEventsWithCompletion:(ContentBlock)block {
    
    if (block)
        block([Event MR_findAllSortedBy:@"date"
                              ascending:YES
                              inContext:[NSManagedObjectContext MR_defaultContext]], nil);
}

- (void)createEvent:(NSString *)name withbCompletion:(void (^)(Event *event))block {
    
    Event *event = [Event MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];

    event.name = name;
    event.date = [NSDate date];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    if (block)
        block(event);
}

- (void)updateEvent:(Event *)event eventName:(NSString *)name withCompletion:(SuccesBlock)block {
    
    event.name = name;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];

    if (block)
        block(nil);
}

- (void)deleteEvent:(Event *)event withCompletion:(SuccesBlock)block {
    
    [event MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    if (block)
        block(nil);
}


#pragma mark - Task Methods

- (void)getTasksForEvent:(Event *)event withCompletion:(ContentBlock)block {
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedTasks = [[event.tasks allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    
    if (block)
        block(sortedTasks, nil);
}

- (void)createTask:(NSString *)name taskDescription:(NSString *)description forEvent:(Event *)event imageData:(NSData *)data withbCompletion:(void (^)(Task *task))block {
    
    Task *task = [Task MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    
    task.name               = name;
    task.date               = [NSDate date];
    task.completeStatus     = NO;
    task.taskDescription    = description;
    
    // Image
    if (data) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *imageName = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".png"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        [UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:filePath atomically:YES];
        
        task.image = imageName;
    }

    
    
    [event addTasksObject:task];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    if (block)
        block(task);
}

- (void)updateTask:(Task *)task taskName:(NSString *)name taskDescription:(NSString *)description imageData:(NSData *)data withCompletion:(SuccesBlock)block {
    
    task.name = name;
    task.taskDescription = description;
    
    
    // Delete image
    if ([task.image length]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:task.image];
        [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil];
        
        task.image = nil;;

    }
    
    
    // Add new image
    if (data) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *imageName = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".png"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        [UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:filePath atomically:YES];
        
        task.image = imageName;
    }

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    
    if (block)
        block(nil);
}

- (void)updateTask:(Task *)task completeStatus:(BOOL)status withCompletion:(SuccesBlock)block {
    
    task.completeStatus = status;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    if (block)
        block(nil);
}

- (void)deleteTask:(Task *)task withCompletion:(SuccesBlock)block {
    
    [task MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    if (block)
        block(nil);
}

@end
