
//
//  world.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "World.h"

@implementation World

- (id) init{
        self = [super init];
        self.gravity = GRAVITY;
        self.objectsList = [NSMutableArray array];
        self.detector = [[CollisionDetector alloc] init];
        return self;
}

- (void)run{
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.delegate = self;
    for (Rectangle* rect in self.objectsList) {
        if (rect.type == KEY) {
            self.keyObject = rect;
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(step:) userInfo:nil repeats:YES];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    //self.gravity = [[Vector2D vectorWith:acceleration.x y:acceleration.y] multiply:GRAVITY.length];
}

- (void)step:(NSTimer*)timer{

    
    [self applyForce];
    
    [self detectCollision];
    
    [self refreshPoints];
    
    [self updatePosition];

}

- (void)applyForce{
    
    for (Rectangle* rect in self.objectsList) {
        
        if (rect.type == EMPTY) {
            continue;
        }
        if (rect.type != bound) {
            rect.gravity = self.gravity;
        }
        rect.velocity = [rect.velocity add:[rect.gravity multiply:TIME_INTERVAL]];
    }
}

- (void)detectCollision{
    [self.detector.contactPointsList removeAllObjects];
    
    for (int i=0; i<[self.objectsList count]-1; i++) {
        Rectangle* A = [self.objectsList objectAtIndex:i];
        if (A.type == EMPTY) {
            continue;
        }
        for (int j = i+1; j<[self.objectsList count]; j++) {
            Rectangle* B = [self.objectsList objectAtIndex:j];
            if (B.type == EMPTY) {
                continue;
            }
            [self.detector solveWithA:A B:B];
        }
    }
}

- (void)refreshPoints{
    for (int i = 0; i<ITERATION; i++) {
        for (int j=0;j<[self.detector.contactPointsList count];j++) {
            ContactPoint* c = [self.detector.contactPointsList objectAtIndex:j];
            [c applyImpulse];
        }
    }
    
    for (ContactPoint *P in self.detector.contactPointsList) {
        if (P.rectA.type == bound || P.rectB.type == bound || P.rectA.type == EMPTY || P.rectB.type ==EMPTY
            || (P.rectA.type != circle && P.rectB.type != circle )) {
            continue;
        }
        int HA = P.rectA.HP;
        if (HA < 0) {
            HA = 0;
        }
        int HB = P.rectB.HP;
        if (HB<0) {
            HB = 0;
        }
        
        P.rectA.HP =  HA - HB;
        P.rectB.HP = HB - HA;
        
        if (P.rectA.HP<=0) {
            P.rectA.type = EMPTY;
        }
        if (P.rectB.HP <= 0 ){
            P.rectB.type = EMPTY;
        }
    }

}

- (void)updatePosition{
    for (Rectangle* rect in self.objectsList) {
        if (rect.type == bound) {
            continue;
        }
        rect.postion = [rect.postion add:[rect.velocity multiply:TIME_INTERVAL]];
        rect.rotation += TIME_INTERVAL*rect.angularV;
        [rect.reDelegate update];
    }

    
}
@end
