//
//  Friends+Utils.m
//  bethere
//
//  Created by hoangha052 on 12/15/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "Friends+Utils.h"
#import "NSPredicate+TSCUtils.h"
#import "NSManagedObject+TSCUtils.h"

@implementation Friends (Utils)
+(NSArray *)arrayDatawithFriendName:(NSString *)friendName andSenderName: (NSString *)senderName{
    NSPredicate *predicate1 = [NSPredicate predicateWithValue:friendName forKey:@"friendName"];
    NSPredicate *predicate2 = [NSPredicate predicateWithValue:senderName    forKey:@"sender"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
    return  [Friends entitiesWithPredicate:predicate fault:NO];

}

@end
