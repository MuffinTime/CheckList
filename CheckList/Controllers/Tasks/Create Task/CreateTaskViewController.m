//
//  CreateTaskViewController.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "CreateTaskViewController.h"



@interface CreateTaskViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIActionSheetDelegate>

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UITextField    *nameField;
@property (weak, nonatomic) IBOutlet UIView         *nameView;

@property (weak, nonatomic) IBOutlet UITextView     *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView         *descriptionView;

@property (weak, nonatomic) IBOutlet UIImageView    *photoImageView;

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
    
    if ([self.editableTask.image length]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.editableTask.image];
        self.photoImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

- (void)selectCamera {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:NULL];
}

- (void)selectPhotoLibrary {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    pickerController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    pickerController.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:pickerController animated:YES completion:NULL];
}


#pragma mark - Actions

- (IBAction)photoAction:(id)sender {
    
    UIActionSheet *action;
    
    
    
    if (self.photoImageView.image) {
        
        action = [[UIActionSheet alloc] initWithTitle:@"Upload a photo:"
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles: @"Take Photo", @"Choose From Library", @"Delete Photo", nil];
    }
    else {
        
        action = [[UIActionSheet alloc] initWithTitle:@"Upload a photo:"
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles: @"Take Photo", @"Choose From Library", nil];
    }

    
    [action showInView:self.view];
}

- (IBAction)createAction:(id)sender {
    
    // Shake when textField is empty
    if (![self.nameField.text length]) {
        
        [self.nameView shakeView];
        return;
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.editableTask) {
        
        [[DataManager defaultManager] createTask:self.nameField.text
                                 taskDescription:self.descriptionTextView.text
                                        forEvent:self.currentEvent
                                       imageData:UIImagePNGRepresentation(self.photoImageView.image)
                                 withbCompletion:^(Task *task) {
                                     
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }];
    }
    else {
        
        [[DataManager defaultManager] updateTask:self.editableTask
                                        taskName:self.nameField.text
                                 taskDescription:self.descriptionTextView.text
                                       imageData:UIImagePNGRepresentation(self.photoImageView.image)
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


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    switch (buttonIndex) {
        case 0:
            [self selectCamera];
            break;
            
        case 1:
            [self selectPhotoLibrary];
            break;
            
        case 2:
            self.photoImageView.image = nil;
            break;
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.photoImageView.image = image;
}


@end
