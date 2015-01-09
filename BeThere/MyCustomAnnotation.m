//
//  MyCustomAnnotation.m
//  bethere
//
//  Created by hoangha052 on 12/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
- (NSString *)subtitle
{
    return @"";
}
- (NSString *)title
{
    return @"";
}

@end
