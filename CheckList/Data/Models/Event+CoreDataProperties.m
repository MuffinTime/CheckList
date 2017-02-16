//
//  Event+CoreDataProperties.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

- (NSArray *)getSortedTasks {
    
    
}

@dynamic date;
@dynamic eventID;
@dynamic name;
@dynamic status;
@dynamic tasks;

@end
