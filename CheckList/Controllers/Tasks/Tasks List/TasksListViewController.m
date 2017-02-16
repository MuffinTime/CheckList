//
//  TasksListViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "TasksListViewController.h"
#import "CreateTaskViewController.h"
#import "TaskTableViewCell.h"

/* Cells id */
static NSString *TASK_CELL_ID  = @"TaskCell";

/* Segues id */
static NSString *EDIT_SEGUE_ID          = @"EditTaskSegue";
static NSString *TASK_SEGUE_ID          = @"TaskSegue";
static NSString *CREATE_TASK_SEGUE_ID   = @"CreateTaskSegue";



@interface TasksListViewController () <UITableViewDelegate, UITableViewDataSource>

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* --- Data --- */
@property (strong, nonatomic) NSMutableArray    *content;
@property (strong, nonatomic) Task              *currentTask;

@end



@implementation TasksListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getTasks];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:CREATE_TASK_SEGUE_ID]) {
        
        [segue.destinationViewController setCurrentEvent:self.currentEvent];
    }
    else if ([segue.identifier isEqualToString:EDIT_SEGUE_ID]) {
        
        [segue.destinationViewController setCurrentEvent:self.currentEvent];
        [segue.destinationViewController setEditableTask:self.currentTask];
    }
    else if ([segue.identifier isEqualToString:TASK_SEGUE_ID]) {
        
        [segue.destinationViewController setCurrentTask:self.currentTask];
    }
}


#pragma mark - Private

- (void)setup {
    
    self.navigationItem.title = self.currentEvent.name;
}

- (void)getTasks {
    
    __weak typeof(self) weakSelf = self;
    
    [[DataManager defaultManager] getTasksForEvent:self.currentEvent withCompletion:^(NSArray *content, NSError *error) {
        
        weakSelf.content = [content mutableCopy];
        [weakSelf.tableView reloadData];
    }];
}

- (void)goToTask:(Task *)task {
    
    self.currentTask = task;
    [self performSegueWithIdentifier:TASK_SEGUE_ID sender:self];
}

- (void)editTask:(Task *)task {
    
    self.currentTask = task;
    [self performSegueWithIdentifier:EDIT_SEGUE_ID sender:self];
}

- (void)deleteTask:(Task *)task {
    
    __weak typeof(self) weakSelf = self;
    
    // Delete event
    [[DataManager defaultManager] deleteTask:task withCompletion:^(NSError *error) {
        
        [weakSelf.content removeObject:task];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Task *task = [self.content objectAtIndex:indexPath.row];
    
    TaskTableViewCell *taskCell = [tableView dequeueReusableCellWithIdentifier:TASK_CELL_ID];
    [taskCell setupForTask:task];
    
    return taskCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Task *task = [self.content objectAtIndex:indexPath.row];
    
    [self goToTask:task];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    // Edit button
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:@"Edit"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                            
                                                                            // Hide cell editing
                                                                            [self.tableView setEditing:NO animated:YES];
                                                                            
                                                                            // Current task
                                                                            Task *task = [weakSelf.content objectAtIndex:indexPath.row];
                                                                            
                                                                            [weakSelf editTask:task];
                                                                        }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    
    
    // Delete button
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                              
                                                                              // Current task
                                                                              Task *task = [weakSelf.content objectAtIndex:indexPath.row];
                                                                              [weakSelf deleteTask:task];
                                                                              
                                                                              // Animate cell
                                                                              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    
    return @[deleteAction, editAction];
}

@end
