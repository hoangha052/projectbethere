//
//  MyCustomAnnotation.h
//  bethere
//
//  Created by hoangha052 on 12/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject<MKAnnotation>
{
     CLLocationCoordinate2D coordinate;
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
