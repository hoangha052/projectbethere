//
//  NSPredicate+TSCUtils.h
//  TabStyleCloud
//
//  Created by Tuan Anh Nguyen on 7/9/14.
//  Copyright (c) 2014 FPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (TSCUtils)
// create property predicate
+(NSPredicate *)predicateWithValue:(id)value forKey:(id)key;

//create a predicate not equal with a given value, key
+(NSPredicate *)predicateWithValueNotEqual:(id)value forKey:(id)key;

// create predicate to fecth entitis having the property contains the value
+(NSPredicate *)containPredicateWithValue:(id)value forKey:(id)key;
// array of property predicate
+(NSArray *)predicatesWithDictionary:(NSDictionary *)dic;
// return and predicate from dictionary
+(NSPredicate *)andPredicateWithDictionary:(NSDictionary *)dic;
// return or predicate from dictionary
+(NSPredicate *)orPredicateWithDictionary:(NSDictionary *)dic;
// return and predicate from array of dictionaries
+(NSPredicate *)andPredicateWithDictionaries:(NSArray *)dics;
// return or predicate from array of dictionaries
+(NSPredicate *)orPredicateWithDictionaries:(NSArray *)dics;
//create a predicate with a key and a given array
+(NSPredicate *)inPredicateWithValues:(NSArray*)array forKey:(id)key;
//create a predicate of NOT IN with a key and a given array
+(NSPredicate *)notInPredicateWithValues:(NSArray*)array forKey:(id)key;
//create a predicate with a given keyword is greater than and equal a value
+(NSPredicate *)predicateWithValueIsGreaterThanAndEqual:(id)value forKey:(id)key;
//create a predicate with a given keyword is greater than a value
+(NSPredicate *)predicateWithValueIsGreaterThan:(id)value forKey:(id)key;
//create a predicate with a given keyword is less than and equal a value
+(NSPredicate *)predicateWithValueIsLessThanAndEqual:(id)value forKey:(id)key;
//create a predicate with a given keyword is less than a value
+(NSPredicate *)predicateWithValueIsLessThan:(id)value forKey:(id)key;
@end
