//
//  NSPredicate+TSCUtils.m
//  TabStyleCloud
//
//  Created by Tuan Anh Nguyen on 7/9/14.
//  Copyright (c) 2014 FPT. All rights reserved.
//

#import "NSPredicate+TSCUtils.h"
#import "NSDictionary+TSCPridicateUtils.h"

@implementation NSArray (TSCPredicateUtils)
// return list of predicate from array of dictionaries
-(NSArray *)predicates
{
    NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSDictionary *dic in self) {
        [predicates addObject:[dic andPredicate]];
    }
    if ([predicates count]) {
        return predicates;
    }
    return nil;
}
@end

@implementation NSPredicate (TSCUtils)
// create predicate with value-key for SELF
+(NSPredicate *)predicateWithValue:(id)value forKey:(id)key
{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K = %@", _key, _value];
}
//create a predicate not equal with a given value, key
+(NSPredicate *)predicateWithValueNotEqual:(id)value forKey:(id)key{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K != %@", _key, _value];
}

// array of property predicate
+(NSArray *)predicatesWithDictionary:(NSDictionary *)dic
{
    return [dic predicates];
}
// return and predicate from dictionary
+(NSPredicate *)andPredicateWithDictionary:(NSDictionary *)dic
{
    return [dic andPredicate];
}
// return or predicate from dictionary
+(NSPredicate *)orPredicateWithDictionary:(NSDictionary *)dic
{
    return [dic orPredicate];
}
// return and predicate from array of dictionaries
+(NSPredicate *)andPredicateWithDictionaries:(NSArray *)dics
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:[dics predicates]];
}
// return or predicate from array of dictionaries
+(NSPredicate *)orPredicateWithDictionaries:(NSArray *)dics
{
    return [NSCompoundPredicate orPredicateWithSubpredicates:[dics predicates]];
}

// create predicate to fecth entitis having the property contains the value
+(NSPredicate *)containPredicateWithValue:(id)value forKey:(id)key
{    
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K CONTAINS[cd] %@", _key, _value];
}

//create a predicate of IN with a key and a given array
+(NSPredicate *)inPredicateWithValues:(NSArray*)array forKey:(id)key
{
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"self.%K IN %@", key, array];
    return predicate;
}

//create a predicate of NOT IN with a key and a given array
+(NSPredicate *)notInPredicateWithValues:(NSArray*)array forKey:(id)key
{
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"NOT self.%K IN %@", key, array];
    return predicate;
}

+(NSPredicate *)predicateWithValueIsGreaterThanAndEqual:(id)value forKey:(id)key{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K >= %@", _key, _value];
}

+(NSPredicate *)predicateWithValueIsGreaterThan:(id)value forKey:(id)key{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K > %@", _key, _value];
}

+(NSPredicate *)predicateWithValueIsLessThanAndEqual:(id)value forKey:(id)key{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K <= %@", _key, _value];
}

+(NSPredicate *)predicateWithValueIsLessThan:(id)value forKey:(id)key{
    id _value = value;
    id _key = key;
    return [NSPredicate predicateWithFormat:@"self.%K < %@", _key, _value];
}


@end
