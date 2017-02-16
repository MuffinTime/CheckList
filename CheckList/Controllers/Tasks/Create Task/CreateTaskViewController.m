//
//  CreateTaskViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "CreateTaskViewController.h"



@interface CreateTaskViewController () <UITextFieldDelegate, UITextViewDelegate>

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView      *nameView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView     *descriptionView;

@end



@implementation CreateTaskViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark - Private

- (void)setup {
    
    if (self.editableTask) {
        
        self.nameField.text = self.editableTask.name;
        self.descriptionTextView.text = self.editableTask.taskDescription;
        self.navigationItem.title = @"Edit Task";
    }
    else
        self.navigationItem.title = @"Add New Task";
}


#pragma mark - Actions

- (IBAction)createAction:(id)sender {
    
    // Shake if textField is empty
    if (![self.nameField.text length]) {
        
        [self.nameView shakeView];
        return;
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.editableTask) {
        
        [[DataManager defaultManager] createTask:self.nameField.text
                                 taskDescription:self.descriptionTextView.text
                                        forEvent:self.currentEvent
                                 withbCompletion:^(Task *task) {
                                     
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }];
    }
    else {
        
        [[DataManager defaultManager] updateTask:self.editableTask
                                        taskName:self.nameField.text
                                 taskDescription:self.descriptionTextView.text
                                  withCompletion:^(NSError *error) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
