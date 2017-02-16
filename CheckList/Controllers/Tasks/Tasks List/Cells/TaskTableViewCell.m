//
//  TaskTableViewCell.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 16/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "TaskTableViewCell.h"


@interface TaskTableViewCell ()

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UILabel        *title;
@property (weak, nonatomic) IBOutlet UIImageView    *statusImageView;

@end



@implementation TaskTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupDefaultSettings];
}

- (void)prepareForReuse {
    
    [self setupDefaultSettings];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}


#pragma mark - Private

- (void)setupDefaultSettings {
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Public

- (void)setupForTask:(Task *)task {
    
    self.title.text = task.name;
    self.statusImageView.hidden = !task.completeStatus;
}

@end
