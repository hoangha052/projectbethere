//
// Created by Mac_MGT_1 on 26/05/2015.
// Copyright (c) 2015 hoangha052. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface model_relationship : NSObject

- (BOOL) user:(NSString*) user1 friend_with:(NSString*) user2;
- (NSString*) the_relationship_status;
- (BOOL) is_friend;

@end