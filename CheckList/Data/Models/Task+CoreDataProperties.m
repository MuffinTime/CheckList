//
//  Task+CoreDataProperties.m
//  
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//
//  This file was automatically generated and should not be edited.
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Task"];
}

@dynamic date;
@dynamic taskDescription;
@dynamic completeStatus;
@dynamic image;
@dynamic name;
@dynamic status;
@dynamic taskID;
@dynamic event;

@end
