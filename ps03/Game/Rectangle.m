//
//  Rectangle.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

@synthesize h = _h;
@synthesize R = _R;

-(Vector2D*)h {
    return [Vector2D vectorWith:self.width/2 y:self.height/2];
}

-(Matrix2D*)R{
    return [Matrix2D initRotationMatrix:self.rotation];
}

-(Rectangle*)initWithPosition:(Vector2D *)pos Width:(double)width Height:(double)height Mass:(double)mass Type:(RectType)type{
        self.postion = pos;
        self.width = width;
        self.height = height;
        self.mass = mass;
        self.ineria = (self.width*self.width + self.height*self.height)/12.0*self.mass;
        self.e = E_COEFF;
        self.mu = MU;
        self.force = ZERO;
        self.rotation = ZERO;
        self.angularV = ZERO;
        self.velocity = ZERO_VECTOR;
        self.gravity = ZERO_VECTOR;
        self.type = type;
        //self.h = [Vector2D vectorWith:self.width/2 y:self.height/2];
        //self.R = [Matrix2D initRotationMatrix:self.rotation];
       
        return self;
}

@end
