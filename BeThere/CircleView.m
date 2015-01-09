//
//  CircleView.m
//  bethere
//
//  Created by hoangha052 on 12/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "CircleView.h"

#define MAX_RATIO 1.2
#define MIN_RATIO 0.8
#define STEP_RATIO 0.05

#define ANIMATION_DURATION 0.8

//repeat forever
#define ANIMATION_REPEAT HUGE_VALF
@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc{
    
    [self removeExistingAnimation];
}

-(void)start{
    
    [self removeExistingAnimation];
    
    //create the image
    UIImage* img = [UIImage imageNamed:@"redcircle.png"];
    self.imageView = [[UIImageView alloc] initWithImage:img];
    self.imageView.frame = CGRectMake(0, 0, 0, 0);
    [self addSubview:self.imageView];
    
    //opacity animation setup
    CABasicAnimation *opacityAnimation;
    
    opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = ANIMATION_DURATION;
    opacityAnimation.repeatCount = ANIMATION_REPEAT;
    //theAnimation.autoreverses=YES;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.2];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.025];
    
    //resize animation setup
    CABasicAnimation *transformAnimation;
    
    transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    transformAnimation.duration = ANIMATION_DURATION;
    transformAnimation.repeatCount = ANIMATION_REPEAT;
    //transformAnimation.autoreverses=YES;
    transformAnimation.fromValue = [NSNumber numberWithFloat:MIN_RATIO];
    transformAnimation.toValue = [NSNumber numberWithFloat:MAX_RATIO];
    
    
    //group the two animation
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.repeatCount = ANIMATION_REPEAT;
    [group setAnimations:[NSArray arrayWithObjects:opacityAnimation, transformAnimation, nil]];
    group.duration = ANIMATION_DURATION;
    
    //apply the grouped animaton
    [self.imageView.layer addAnimation:group forKey:@"groupAnimation"];
}


-(void)stop{
    
    [self removeExistingAnimation];
}

-(void)removeExistingAnimation{
    
    if(self.imageView){
        [self.imageView.layer removeAllAnimations];
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
}


- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    //the circle center
    MKMapPoint mpoint = MKMapPointForCoordinate([[self overlay] coordinate]);
    
    //geting the radius in map point
    double radius = [(MKCircle*)[self overlay] radius];
    double mapRadius = radius * MKMapPointsPerMeterAtLatitude([[self overlay] coordinate].latitude);
    
    //calculate the rect in map coordination
    MKMapRect mrect = MKMapRectMake(mpoint.x - mapRadius, mpoint.y - mapRadius, mapRadius/100, mapRadius/100);
    
    //get the rect in pixel coordination and set to the imageView
    CGRect rect = [self rectForMapRect:mrect];
    
    if(self.imageView){
        self.imageView.frame = rect;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
