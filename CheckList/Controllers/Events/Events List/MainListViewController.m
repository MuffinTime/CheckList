//
//  MainListViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 15/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "MainListViewController.h"
#import "CreateEventViewController.h"
#import "TasksListViewController.h"
#import "EventTableViewCell.h"
#import "Event+CoreDataClass.h"

/* Cells id */
static NSString *EVENT_CELL_ID  = @"EventCell";

/* Segues id */
static NSString *EDIT_SEGUE_ID  = @"EditEventSegue";
static NSString *EVENT_SEGUE_ID = @"EventSegue";



@interface MainListViewController () <UITableViewDelegate, UITableViewDataSource>

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* --- Data --- */
@property (strong, nonatomic) NSMutableArray    *content;
@property (strong, nonatomic) Event             *currentEvent;

@end



@implementation MainListViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getList];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:EDIT_SEGUE_ID]) {
        
        [segue.destinationViewController setEditableEvent:self.currentEvent];
    }
    else if ([segue.identifier isEqualToString:EVENT_SEGUE_ID]) {
        
        [segue.destinationViewController setCurrentEvent:self.currentEvent];
    }
}

#pragma mark - Private

- (void)getList {
    
    __weak typeof(self) weakSelf = self;
    
    // Get all events
    [[DataManager defaultManager] getAllEventsWithCompletion:^(NSArray *content, NSError *error) {
        
        weakSelf.content = [content mutableCopy];
        [weakSelf.tableView reloadData];
    }];
}

- (void)goToEvent:(Event *)event {
    
    self.currentEvent = event;
    [self performSegueWithIdentifier:EVENT_SEGUE_ID sender:self];
}

- (void)editEvent:(Event *)event {
    
    self.currentEvent = event;
    [self performSegueWithIdentifier:EDIT_SEGUE_ID sender:self];
}

- (void)deleteEvent:(Event *)event {
    
    __weak typeof(self) weakSelf = self;
    
    // Delete event
    [[DataManager defaultManager] deleteEvent:event withCompletion:^(NSError *error) {
        
        [weakSelf.content removeObject:event];
    }];
}

#pragma mark - Actions 

- (IBAction)signOutAction:(id)sender {
    
    [[AuthManager defaultManager] logOut];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = [self.content objectAtIndex:indexPath.row];
    
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:EVENT_CELL_ID];
    [eventCell setupForEvent:event];

    return eventCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = [self.content objectAtIndex:indexPath.row];

    [self goToEvent:event];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    // Edit button
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:@"Edit"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                            
                                                                            // Hide cell editing
                                                                            [weakSelf.tableView setEditing:NO animated:YES];

                                                                            // Current event
                                                                            Event *event = [weakSelf.content objectAtIndex:indexPath.row];
                                                                            
                                                                            [weakSelf editEvent:event];
                                                                        }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    
    
    // Delete button
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                              
                                                                              // Current event
                                                                              Event *event = [weakSelf.content objectAtIndex:indexPath.row];
                                                                              [weakSelf deleteEvent:event];
                                                                              
                                                                              // Animate cell
                                                                              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    
    return @[deleteAction, editAction];
}

@end
