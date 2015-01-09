//
//  NSDictionary+TSCPridicateUtils.m
//  TabStyleCloud
//
//  Created by Tuan Anh Nguyen on 7/23/14.
//  Copyright (c) 2014 FPT. All rights reserved.
//

#import "NSDictionary+TSCPridicateUtils.h"
#import "NSPredicate+TSCUtils.h"

@implementation NSDictionary (TSCPridicateUtils)
// return list of SELF predicates
-(NSArray *)predicates
{
    NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:[self count]];
    for (id key in [self allKeys]) {
        // SELF predicate from key-value
        id predicate = [NSPredicate predicateWithValue:[self valueForKey:key] forKey:key];
        if (predicate) {
            [predicates addObject:predicate];
        }
    }
    if ([predicates count]) {
        return predicates;
    }
    return nil;
}
// return and predicate
-(NSPredicate *)andPredicate
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:[self predicates]];
}
// return or predicate
-(NSPredicate *)orPredicate
{
    return [NSCompoundPredicate orPredicateWithSubpredicates:[self predicates]];
}
@end
