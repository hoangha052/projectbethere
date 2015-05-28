//
// Created by Mac_MGT_1 on 26/05/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface model_relationship : NSObject

- (void) sync_relationship_between_user:(NSString*) user1 and_user:(NSString*) user2;
- (BOOL) is_user:(NSString *)user1 friend_with:(NSString*) user2;
- (NSString*) the_relationship_status;
- (BOOL) is_friend;
- (void) unfriend_user:(NSString *) user1 and_user:(NSString *) user2;
- (void) clear_cache;

@end