//
// Created by Mac_MGT_1 on 26/05/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import "model_relationship.h"


@implementation model_relationship
{
    PFObject *cache_relationship;
}

- (BOOL) user:(NSString*) user1 friend_with:(NSString*) user2
{
    cache_relationship = nil;

    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user1];
    [query whereKey:@"receiver" equalTo:user2];
    PFObject* request = [query getFirstObject];
    if(request != nil) cache_relationship = request;

    query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user2];
    [query whereKey:@"receiver" equalTo:user1];
    request = [query getFirstObject];
    if(request != nil) cache_relationship = request;

    if(cache_relationship != nil) return YES;

    return NO;
}

- (NSString*) the_relationship_status
{
    if(cache_relationship == nil) return @"";
    return [cache_relationship objectForKey:@"status"];
}

- (BOOL) is_friend
{
    if(cache_relationship == nil) return @"";
    return [[cache_relationship objectForKey:@"status"] isEqualToString:@"accepted"];
}

@end