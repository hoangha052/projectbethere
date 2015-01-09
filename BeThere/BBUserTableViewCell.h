//
//  BBUserTableViewCell.h
//  bethere
//
//  Created by hoangha052 on 11/13/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBUserTableViewCellDelegate <NSObject>
- (void)selectedBlackUser:(id)sender;
- (void)selectedCell:(id)sender;
- (void)showMessage:(id)sender;

@end

@interface BBUserTableViewCell : UITableViewCell
@property (weak, nonatomic) id<BBUserTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isSwipe;

- (void)setValueInfo:(NSDictionary *)valueData;
- (void)showIconMessage;
@end
