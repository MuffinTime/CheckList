//
//  CreateEventViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "CreateEventViewController.h"



@interface CreateEventViewController () <UITextFieldDelegate>

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView      *nameView;

@end



@implementation CreateEventViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark - Private

- (void)setup {
    
    if (self.editableEvent) {
        
        self.nameField.text = self.editableEvent.name;
        self.navigationItem.title = @"Edit Event";
    }
    else
        self.navigationItem.title = @"Add New Event";
}


#pragma mark - Actions

- (IBAction)createAction:(id)sender {
    
    // Shake if textField is empty
    if (![self.nameField.text length]) {
        
        [self.nameView shakeView];
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.editableEvent) {
        
        [[DataManager defaultManager] createEvent:self.nameField.text withbCompletion:^(Event *event) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        
        [[DataManager defaultManager] updateEvent:self.editableEvent eventName:self.nameField.text withCompletion:^(NSError *error) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
