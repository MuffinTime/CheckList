//
//  Task+CoreDataProperties.h
//  
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//
//  This file was automatically generated and should not be edited.
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *taskDescription;
@property (nonatomic) BOOL completeStatus;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t status;
@property (nonatomic) int64_t taskID;
@property (nullable, nonatomic, retain) Event *event;

@end

NS_ASSUME_NONNULL_END
