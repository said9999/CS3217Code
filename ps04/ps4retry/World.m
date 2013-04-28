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
    
        self.gravity = GRAVITY;
        self.objectsList = [NSMutableArray array];
        self.detector = [[CollisionDetector alloc] init];
        return self;
}

- (void)run{
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.delegate = self;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(step:) userInfo:nil repeats:YES];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    self.gravity = [[Vector2D vectorWith:acceleration.x y:acceleration.y] multiply:GRAVITY.length];
}

- (void)step:(NSTimer*)timer{
    
    
    [self applyForce];
    
    [self detectCollision];
    
    [self refreshPoints];
    
    [self updatePosition];

}

- (void)applyForce{
    for (Rectangle* rect in self.objectsList) {
        if (rect.type != bound) {
            rect.gravity = self.gravity;
        }
        rect.velocity = [rect.velocity add:[rect.gravity multiply:TIME_INTERVAL]];
    }
}

- (void)detectCollision{
    [self.detector.contactPointsList removeAllObjects];
    
    for (int i=0; i<[self.objectsList count]-1; i++) {
        for (int j = i+1; j<[self.objectsList count]; j++) {
                Rectangle* A = [self.objectsList objectAtIndex:i];
                Rectangle* B = [self.objectsList objectAtIndex:j];
                [self.detector solveWithA:A B:B];
        }
    }
}

- (void)refreshPoints{
    for (int i = 0; i<ITERATION; i++) {
        for (int i=0;i<[self.detector.contactPointsList count];i++) {
            ContactPoint* c = [self.detector.contactPointsList objectAtIndex:i];
            [c applyImpulse];
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
        [rect.delegate update];
    }

}
@end
