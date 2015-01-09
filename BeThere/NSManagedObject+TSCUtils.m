//
//  NSManagedObject+TSCUtils.m
//  TableViewTutorial
//
//  Created by hoangha052 on 10/28/14.
//  Copyright (c) 2014 Codigator. All rights reserved.
//

#import "NSManagedObject+TSCUtils.h"
#import "NSManagedObjectContext+TSCUtils.h"
#import "NSPredicate+TSCUtils.h"
#import "NSDictionary+TSCPridicateUtils.h"
//#import "NSDate+TSCUtils.h"

// array functions to work with Managed Objects
@implementation NSArray (TSCManagedObjectUtils)
// return array of fault entities
-(NSArray *)faultEntities
{
    NSPredicate *preidcate = [NSPredicate predicateWithValue:@YES forKey:@"isFault"];
    return [self filteredArrayUsingPredicate:preidcate];
}
-(NSArray *)faultEntitiesWithRange:(NSRange)range
{
    NSArray *subArray = [self subarrayWithRange:range];
    return [subArray faultEntities];
}
@end


@implementation NSManagedObject (TSCUtils)

// insert new object
+(NSManagedObject *)newObject
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[NSManagedObjectContext sharedContext]];
}

// save the context
-(BOOL)save:(NSError **)error
{
    return [[NSManagedObjectContext sharedContext] save:error];
}
+(BOOL)save
{
    NSError *error;
    BOOL result = [[NSManagedObjectContext sharedContext] save:&error];
    if (error) {
        NSLog(@"NSManagedObject: error on save %@", error);
    }
    return result;
}
// save context with self-traced error
-(BOOL)save
{
    NSError *error;
    BOOL result = [self save:&error];
    if (error) {
        NSLog(@"NSManagedObject: error on save %@", error);
    }
    return result;
}

- (void)setStringForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict {
    if (key != nil && key.length > 0) {
        NSString *data = nil;
        if (fromKey != nil && fromKey.length > 0 && dict != nil) {
            data = [dict objectForKey:fromKey];
            if (data != nil && [data isKindOfClass:[NSString class]] && data.length > 0) {
                [super setValue:data forKey:key];
                return;
                //            } else {
                //                NSLog(@"===============\n\n1ERROR:\nKEY1: %@\nKEY2: %@\nDATA: %@\n\n===============", key, fromKey, data);
            }
        }
        [super setValue:nil forKey:key];
    }
}

- (void)setNumberForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict {
    if (key != nil && key.length > 0) {
        NSNumber *data = nil;
        if (fromKey != nil && fromKey.length > 0 && dict != nil) {
            NSString *tmp = [dict objectForKey:fromKey];
            if (tmp != nil && [tmp isKindOfClass:[NSString class]] && tmp.length > 0) {
                if ([tmp rangeOfString:@"."].location != NSNotFound) {
                    data = [NSNumber numberWithFloat:[tmp floatValue]];
                } else {
                    data = [NSNumber numberWithInteger:[tmp integerValue]];
                }
                [super setValue:data forKey:key];
                return;
                //            } else {
                //                NSLog(@"===============\n\n2ERROR:\nKEY1: %@\nKEY2: %@\nDATA: %@\n\n===============", key, fromKey, data);
            }
        }
        [super setValue:nil forKey:key];
    }
}

//- (void)setDateForKey:(NSString *)key fromKey:(NSString *)fromKey inDict:(NSDictionary *)dict {
//    if (key != nil && key.length > 0) {
//        NSDate *data = nil;
//        if (fromKey != nil && fromKey.length > 0 && dict != nil) {
//            NSString *tmp = [dict objectForKey:fromKey];
//            if (tmp != nil && [tmp isKindOfClass:[NSString class]] && tmp.length > 0) {
//                data = [NSDate dateWithString:tmp];
//                [super setValue:data forKey:key];
//                return;
//                //            } else {
//                //                NSLog(@"===============\n\n3ERROR:\nKEY1: %@\nKEY2: %@\nDATA: %@\n\n===============", key, fromKey, data);
//            }
//        }
//        [super setValue:nil forKey:key];
//    }
//}

// basic function to fetch entities
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fetchOptions:(NSDictionary *)fetchOptions sortDescriptors:(NSArray *)sortDescriptors {
    return [self entitiesWithPredicate:predicate fetchOptions:fetchOptions sortDescriptors:sortDescriptors limit:-1];
}

+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fetchOptions:(NSDictionary *)fetchOptions sortDescriptors:(NSArray *)sortDescriptors limit:(NSInteger)limit {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    
    if (fetchOptions) {
        [fetchRequest setValuesForKeysWithDictionary:fetchOptions];
    }
    
    if (sortDescriptors) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    
    if (limit > 0) {
        fetchRequest.fetchLimit = limit;
    }
    
    NSError *error = nil;
    NSArray *results = [[NSManagedObjectContext sharedContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"entitiesWithPredicate: %@", error);
        return nil;
    }
    if (![results count]) {
        return nil;
    }
    return results;
}

// sorted entities
+(id)sortedEntitiesWithPredicate:(NSPredicate *)predicate sortKey:(id)key ascending:(BOOL)ascending fault:(BOOL)isFault
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    return [self sortedEntitiesWithPredicate:predicate sortDescriptors:@[sortDescriptor] fault:isFault];
}
// sorted entities
+(id)sortedEntitiesWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fault:(BOOL)isFault
{
    id fetchOption = @{@"returnsObjectsAsFaults" : @(isFault)};
    return [self entitiesWithPredicate:predicate fetchOptions:fetchOption sortDescriptors:sortDescriptors];
}

// fetch entitiy with max value
+(id)entityWithPredicate:(NSPredicate *)predicate havingMaxValueOnKey:(id)key
{
    return [[self sortedEntitiesWithPredicate:predicate sortKey:key ascending:NO fault:NO] firstObject];
}

+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fault:(BOOL)isFault sortDescriptor:(NSArray*)sortDesciptor
{
    id fetchOption = @{@"returnsObjectsAsFaults": @(isFault)};
    return [self entitiesWithPredicate:predicate fetchOptions:fetchOption sortDescriptors:sortDesciptor];}


// convenient function to fetch entities with predicate
+(NSArray *)entitiesWithPredicate:(NSPredicate *)predicate fault:(BOOL)isFault
{
    id fetchOption = @{@"returnsObjectsAsFaults" : @(isFault)};
    return [self entitiesWithPredicate:predicate fetchOptions:fetchOption sortDescriptors:nil];
}

+(void)fireFaultEntities:(NSArray *)entities
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", entities];
    id fetchOption = @{@"returnsObjectsAsFaults" : @NO};
    [self entitiesWithPredicate:predicate fetchOptions:fetchOption sortDescriptors:nil];
}

// convenient function to fetch entities with key-value
+(NSArray *)entitiesWithValue:(id)value forKey:(id)key fault:(BOOL)isFault;
{
    return [self entitiesWithPredicate:[NSPredicate predicateWithValue:value forKey:key] fault:isFault];
}

// entities with AND predicate
+(NSArray *)entitiesWithANDPredicateFromDictionary:(NSDictionary *)dictionary fault:(BOOL)isFault
{
    return [self entitiesWithPredicate:[dictionary andPredicate] fault:isFault];
}
//
//// entities with OR predicate
//+(NSArray *)entitiesWithORPredicateFromDictionary:(NSDictionary *)dictionary fault:(BOOL)isFault
//{
//    return [self entitiesWithPredicate:[dictionary orPredicate] fault:isFault];
//}

+(NSArray *)entitiesWithValueForKey:(id)key inValues:(NSArray *)values fault:(BOOL)isFault
{
    NSPredicate *predicate = [NSPredicate inPredicateWithValues:values forKey:key];
    return [self entitiesWithPredicate:predicate fault:isFault];
}

// delete entities which matche key-value
+(void)deleteEntitiesWithValue:(id)value forKey:(id)key
{
    [self deleteEntitiesWithPredicate:[NSPredicate predicateWithValue:value forKey:key]];
}

// delete entities which match AND Predicate
//+(void)deleteEntitiesWithANDPredicateFromDictionary:(NSDictionary *)dictionary
//{
//    [self deleteEntitiesWithPredicate:[dictionary andPredicate]];
//}
//
//// delete entities which match OR Predicate
//+(void)deleteEntitiesWithORPredicateFromDictionary:(NSDictionary *)dictionary
//{
//    [self deleteEntitiesWithPredicate:[dictionary orPredicate]];
//}

// delete entities which match Predicate
+(void)deleteEntitiesWithPredicate:(NSPredicate *)predicate
{
    NSArray *entities = [self entitiesWithPredicate:predicate fault:YES];
    NSLog(@"willl delete entities = %@", entities);
    [self deleteEntities:entities];
}

+(void)deleteEntities:(NSArray *)entities
{
    NSManagedObjectContext *context = [NSManagedObjectContext sharedContext];
    for (id entity in entities) {
        [context deleteObject:entity];
    }
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"failed to delete entities %@", error);
    }
}

// count method (can be used to check existence)
+(NSInteger)countWithValue:(id)value forKey:(id)key
{
    return [self countWithPredicate:[NSPredicate predicateWithValue:value forKey:key]];
}
//+(NSInteger)countWithANDPredicateFromDictionary:(NSDictionary *)dictionary
//{
//    return [self countWithPredicate:[dictionary andPredicate]];
//}
//+(NSInteger)countWithORPredicateFromDictionary:(NSDictionary *)dictionary
//{
//    return [self countWithPredicate:[dictionary orPredicate]];
//}

+(NSInteger)countWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    fetchRequest.predicate = predicate;
    NSManagedObjectContext *context = [NSManagedObjectContext sharedContext];
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
    return error? 0 : (count == NSNotFound) ? 0 : count;
}

// update object from xml dictionary
-(void)updateValuesFromXMLDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

// auto increased number
-(NSNumber *)autoIncreasedIntNumber
{
    NSString *lastPath = [[self.objectID.URIRepresentation absoluteString] lastPathComponent];
    NSString *numberStr = [lastPath stringByReplacingOccurrencesOfString:@"p" withString:@""];
    return [NSNumber numberWithInteger:[numberStr integerValue]];
}

+ (NSArray *)entitiesBetweenTable:(NSString*)nameTableA nameTableB:(NSString*)nameTableB
{
    NSManagedObjectContext *context = [NSManagedObjectContext sharedContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:nameTableA inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:nameTableB, nil]];
    
    
    NSError *error;
    NSArray *results = [[NSManagedObjectContext sharedContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return results;
}

@end
