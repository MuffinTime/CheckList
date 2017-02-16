//
//  EventTableViewCell.m
//  CheckList
//
//  Created by Винниченко Дмитрий on 15/02/2017.
//  Copyright © 2017 Vinnichenko Dmitry. All rights reserved.
//

#import "EventTableViewCell.h"



@interface EventTableViewCell ()

/* --- UI --- */
@property (weak, nonatomic) IBOutlet UILabel *title;

@end



@implementation EventTableViewCell


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

- (void)setupForEvent:(Event *)event {
    
    self.title.text = event.name;
}


@end
