//
//  CreateTaskViewController.h
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTaskViewController : UIViewController

@property (strong, nonatomic) Event *currentEvent;
@property (strong, nonatomic) Task  *editableTask;

@end
