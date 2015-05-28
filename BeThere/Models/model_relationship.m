//
// Created by Mac_MGT_1 on 26/05/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import "model_relationship.h"


@implementation model_relationship
{
    PFObject *cache_relationship;
}

- (BOOL)is_user:(NSString *)user1 friend_with:(NSString*) user2
{
    [self sync_relationship_between_user:user1 and_user:user2];
    if(cache_relationship != nil) return YES;
    return NO;
}

// Precondition: the relationship should be synced first in order to have data for checking.
- (NSString*) the_relationship_status
{
    if(cache_relationship == nil) return @"";
    return [cache_relationship objectForKey:@"status"];
}

// Precondition: the relationship should be synced first in order to have data for checking.
- (BOOL) is_friend
{
    if(cache_relationship == nil) return @"";
    return [[cache_relationship objectForKey:@"status"] isEqualToString:@"accepted"];
}

// Delete the relationship in parse server.
- (void) unfriend_user:(NSString *) user1 and_user:(NSString *) user2
{
    // If no relationship info, should sync info from parse server before deleting.w
    if(cache_relationship == nil) [self sync_relationship_between_user:user1 and_user:user2];

    // This relationship doesn't exist, no need to do anything more.
    if(cache_relationship == nil) return;

    [cache_relationship delete];
}

// Retrieve the relationship info from parse server, this info will be used widely by other public functions
// such as is_friend(), the_relationship_status()...
- (void) sync_relationship_between_user:(NSString*) user1 and_user:(NSString*) user2
{
    cache_relationship = nil;

    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user1];
    [query whereKey:@"receiver" equalTo:user2];
    PFObject* request = [query getFirstObject];
    if(request != nil)
    {
        cache_relationship = request;
        return;
    }

    query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"sender" equalTo:user2];
    [query whereKey:@"receiver" equalTo:user1];
    request = [query getFirstObject];
    if(request != nil) cache_relationship = request;
}

- (void) clear_cache
{
    cache_relationship = nil;
}

@end