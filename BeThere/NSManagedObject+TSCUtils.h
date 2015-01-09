//
//  NSManagedObject+TSCUtils.h
//  TableViewTutorial
//
//  Created by hoangha052 on 10/28/14.
//  Copyright (c) 2014 Codigator. All rights reserved.
//

#import <CoreData/CoreData.h>

// array functions to work with Managed Objects
@interface NSArray (TSCManagedObjectUtils)
// return array of fault entities
-(NSArray *)faultEntities;
-(NSArray *)faultEntitiesWithRange:(NSRange)range;
@end

@interface NSManagedObject (TSCUtils)
// set value from dict with key
- (void)setStringForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict;
- (void)setNumberForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict;
//- (void)setDateForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict;
// fetch methods
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fetchOptions:(NSDictionary *)fetchOptions sortDescriptors:(NSArray *)sortDescriptors;
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fetchOptions:(NSDictionary *)fetchOptions sortDescriptors:(NSArray *)sortDescriptors limit:(NSInteger)limit;
+(NSArray *)entitiesWithValue:(id)value forKey:(id)key fault:(BOOL)isFault;
+(NSArray *)entitiesWithANDPredicateFromDictionary:(NSDictionary *)dictionary fault:(BOOL)isFault;;
//+(NSArray *)entitiesWithORPredicateFromDictionary:(NSDictionary *)dictionary fault:(BOOL)isFault;;
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fault:(BOOL)isFault;
+(NSArray *)entitiesWithValueForKey:(id)key inValues:(NSArray *)values fault:(BOOL)isFault;
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fault:(BOOL)isFault sortDescriptor:(NSArray*)sortDesciptor;
+(void)fireFaultEntities:(NSArray *)entities;
// sorted entities
+(id)sortedEntitiesWithPredicate:(NSPredicate *)predicate sortKey:(id)key ascending:(BOOL)ascending fault:(BOOL)isFault;
// sorted entities
+(id)sortedEntitiesWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fault:(BOOL)isFault;
// fetch entitiy with max value
//+(id)entityWithPredicate:(NSPredicate *)predicate havingMaxValueOnKey:(id)key;
//// delete method
//+(void)deleteEntitiesWithValue:(id)value forKey:(id)key;
//+(void)deleteEntitiesWithANDPredicateFromDictionary:(NSDictionary *)dictionary;
//+(void)deleteEntitiesWithORPredicateFromDictionary:(NSDictionary *)dictionary;
//+(void)deleteEntitiesWithPredicate:(NSPredicate *)predicate;
+(void)deleteEntities:(NSArray *)entities;
// count method (can be used to check existence)
+(NSInteger)countWithValue:(id)value forKey:(id)key;
//+(NSInteger)countWithANDPredicateFromDictionary:(NSDictionary *)dictionary;
//+(NSInteger)countWithORPredicateFromDictionary:(NSDictionary *)dictionary;
+(NSInteger)countWithPredicate:(NSPredicate *)predicate;

// insert new object
+(NSManagedObject *)newObject;
// save context with error pointer
+(BOOL)save;
-(BOOL)save:(NSError **)error;
// save context with self-traced error
-(BOOL)save;
// Abstract: update object from xml dictionary
-(void)updateValuesFromXMLDictionary:(NSDictionary *)dic;
// auto increased number
-(NSNumber *)autoIncreasedIntNumber;

+ (NSArray *)entitiesBetweenTable:(NSString*)nameTableA nameTableB:(NSString*)nameTableB;

@end
