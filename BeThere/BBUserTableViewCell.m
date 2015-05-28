//
//  BBUserTableViewCell.m
//  bethere
//
//  Created by hoangha052 on 11/13/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "BBUserTableViewCell.h"
#define TSCCellColor ([UIColor colorWithRed:217.0/255.0 green:238.0/255.0 blue:241.0/255.0 alpha:1.0])
#define TSCSelectColor ([UIColor colorWithRed:255.0/255.0 green:196.0/255.0 blue:21.0/255.0 alpha:1.0])


@interface BBUserTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *contentCellView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *inboxMessage;
@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;



@end

@implementation BBUserTableViewCell

- (void)awakeFromNib
{
    // Ensure when user taps anywhere in cell, the cell will response to user action.
    UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
    [self.contentCellView addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
        [self.delegate selectedCell:self];
    }

}

- (void)showIconMessage
{
   
    self.isSwipe = YES;
    
}

- (void)setIsSwipe:(BOOL)isSwipe
{
    _isSwipe = isSwipe;
    if (isSwipe) {
         [self.contentCellView setFrame:CGRectMake(56+33, 0, 320, 44)];
    }
    else
    {
        [self.contentCellView setFrame:CGRectMake(0, 0, 320, 44)];
    }
    self.btnCancel.hidden = !isSwipe;
    self.inboxMessage.hidden = !isSwipe;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueInfo:(NSDictionary *)valueData
{
    PFUser *user = [valueData objectForKey:@"user"];
    self.userNameLabel.text = user.username;
    self.viewImage.layer.cornerRadius = 16;
    PFFile *theImage = user[@"image"];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];

    // User profile photo or default Fluke image ?
    if (image) self.photoView.image = image;
    else self.photoView.image = [UIImage imageNamed:@"bethere-profile-photo.png"];


    self.isSelected = [[valueData objectForKey:@"isSelected"] boolValue];
    [self.switchButton setOn:[[valueData objectForKey:@"blacklist"] boolValue]];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        [self setBackgroundColor:TSCSelectColor];
    }
    else
    {
        [self setBackgroundColor:TSCCellColor];
    }
}
- (IBAction)btnCellPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
        [self.delegate selectedCell:self];
    }
}

- (IBAction)changeValueSwitch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectedBlackUser:)]) {
        [self.delegate selectedBlackUser:self];
    }
}

- (IBAction)showMessageView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showMessage:)]) {
        [self.delegate showMessage:self];
    }
}

- (IBAction)btnCancelPress:(id)sender {
    self.isSwipe = NO;
}



@end
