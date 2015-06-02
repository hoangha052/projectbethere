//
// Created by Mac_MGT_1 on 12/03/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import "BaseViewController.h"
#import "NSManagedObject+TSCUtils.h"


@implementation BaseViewController

- (Message*) dummy_message
{
    Message *dummy = [Message newObject];
    dummy.messageid = @"0";
    dummy.content = @"dummy content";
    dummy.sender = @"0";
    dummy.receiver = @"0";
    dummy.readmessage = [NSNumber numberWithInt:1];
    return dummy;
}

- (void)dummy_friend_request_from_username:(NSString *)username
{
    NSDictionary *data =@{@"type":@"request",@"sender":username};
    [[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:data];
}

@end