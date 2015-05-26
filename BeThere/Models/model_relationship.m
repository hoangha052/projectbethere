//
// Created by Mac_MGT_1 on 26/05/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import "model_relationship.h"


@implementation model_relationship

+ (BOOL) user:(NSString*) user1 friend_with:(NSString*) user2
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user1];
    [query whereKey:@"receiver" equalTo:user2];
    PFObject* request = [query getFirstObject];
    if(request != nil) return YES;

    query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user2];
    [query whereKey:@"receiver" equalTo:user1];
    request = [query getFirstObject];
    if(request != nil) return YES;

    return NO;
}

@end