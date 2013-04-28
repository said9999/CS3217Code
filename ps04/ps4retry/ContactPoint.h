//
//  ContactPoint.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "Rectangle.h"
/*
 this class is a single point which can apply impulse on the corresponding rectangles.
 */
@interface ContactPoint : NSObject

@property double separation;
@property Vector2D* c;
@property Vector2D* n;
@property (weak)Rectangle* rectA;
@property (weak)Rectangle* rectB;
@property Vector2D* t;

-(id)initWithRectA:(Rectangle*)rectA RectB:(Rectangle*)rectB Normal:(Vector2D*)n Separation:(double)s Point:(Vector2D*)c;

- (void)applyImpulse;
//this method will apply the impulse to the corresponding two rectangles by the given formula
@end
