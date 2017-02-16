//
//  TaskViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "TaskViewController.h"



@interface TaskViewController ()

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UILabel        *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel        *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UIButton       *completeStatusButton;

/* --- Layouts --- */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayout;

@end



@implementation TaskViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark - Private

- (void)setup {
    
    self.nameTitle.text = self.currentTask.name;
    self.descriptionLabel.text = self.currentTask.taskDescription;
    
    if (![self.currentTask.image length]) {
        self.imageHeightLayout.constant = 0;
        
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.currentTask.image];
        self.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    }
    
    [self setupStatusButton];
}

- (void)setupStatusButton {
    
    if (self.currentTask.completeStatus) {
        
        self.completeStatusButton.backgroundColor = [UIColor lightGrayColor];
        [self.completeStatusButton setTitle:@"OPEN TASK" forState:UIControlStateNormal];
    }
    else {
        
        self.completeStatusButton.backgroundColor = [UIColor colorWithRed:44 / 255.f green:211 / 255.f blue:183 / 255.f alpha:1];
        [self.completeStatusButton setTitle:@"CLOSE TASK" forState:UIControlStateNormal];
    }
}


#pragma mark - Actions

- (IBAction)statusAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    // Update Task Status
    [[DataManager defaultManager] updateTask:self.currentTask completeStatus:!self.currentTask.completeStatus withCompletion:^(NSError *error) {
        
        [weakSelf setupStatusButton];
    }];
}


@end
