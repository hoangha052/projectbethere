//
//  NSDictionary+TSCPridicateUtils.h
//  TabStyleCloud
//
//  Created by Tuan Anh Nguyen on 7/23/14.
//  Copyright (c) 2014 FPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TSCPridicateUtils)
// return list of SELF predicates
-(NSArray *)predicates;
// return and predicate
-(NSPredicate *)andPredicate;
// return or predicate
-(NSPredicate *)orPredicate;
@end
