//
//  Event+CoreDataProperties.h
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int64_t eventID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, retain) NSSet<Task *> *tasks;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet<Task *> *)values;
- (void)removeTasks:(NSSet<Task *> *)values;

- (NSArray *)getSortedTasks;

@end

NS_ASSUME_NONNULL_END
