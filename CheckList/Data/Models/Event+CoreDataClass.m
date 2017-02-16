//
//  Event+CoreDataClass.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Event+CoreDataClass.h"
#import "Task+CoreDataClass.h"

@implementation Event

#pragma mark - Lifecycle

- (void)prepareForDeletion {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.image];
    [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil];
}

@end
