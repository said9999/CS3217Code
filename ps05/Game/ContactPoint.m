//
//  ContactPoint.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ContactPoint.h"

@implementation ContactPoint

-(id)init{
    return self;
}

-(id)initWithRectA:(Rectangle*)rectA RectB:(Rectangle*)rectB Normal:(Vector2D*)n Separation:(double)s Point:(Vector2D *)c{
    
    if(self = [super init]){
        self.c = c;
        self.rectA = rectA;
        self.rectB = rectB;
        self.n = n;
        self.separation = s;
        self.t = [n crossZ:1.0];
    }
    return self;
}

-(void)applyImpulse{
    //this method will apply the impulse to the corresponding two rectangles by the given formula
    if (self.separation > 0) {
        return;
    }
    
    
    if(self.rectA.type == circle || self.rectB.type == circle){
        Rectangle* rectC;
        Rectangle* rectR;
        if (self.rectA.type == circle) {
            rectC = self.rectA;
            rectR = self.rectB;
        }else{
            rectC = self.rectB;
            rectR = self.rectA;
        }
        
        if(fabs(rectC.rotation-rectR.rotation)>0.1){
            rectC.rotation = rectR.rotation;
            return; //return here no need to add point
        }
        
        self.isCollideWithOther = YES;
        
        if (rectR.type == bound) {
            rectC.type = EMPTY;
        }
    }

    
    
    Rectangle* A = self.rectA;
    Rectangle* B = self.rectB;
    Vector2D* c = self.c;
    Vector2D* pA = A.postion;
    Vector2D* pB = B.postion;
    Vector2D* vA = A.velocity;
    Vector2D* vB = B.velocity;
    double wA = A.angularV;
    double wB = B.angularV;
    Vector2D* n = [self.n multiply:1.0/self.n.length];
    Vector2D* t = [self.t multiply:1.0/self.t.length];
    double mA = A.mass;
    double mB = B.mass;
    double IA = A.ineria;
    double IB = B.ineria;
    
    Vector2D* rA = [c subtract:pA];
    Vector2D* rB = [c subtract:pB];
    
    Vector2D* uA = [vA add:[[rA crossZ:wA] negate]];
    Vector2D* uB = [vB add:[[rB crossZ:wB] negate]];
    
    Vector2D* u = [uB subtract:uA];
    
    double un = [u dot:n];
    double ut = [u dot:t];
    
    double mn = 1.0/((1.0/mA) + (1.0/mB) + (([rA dot:rA] - pow([rA dot:n], 2))/IA) + (([rB dot:rB] - pow([rB dot:n], 2))/IB));
    double mt = 1.0/((1.0/mA) + (1.0/mB) + (([rA dot:rA] - pow([rA dot:t], 2))/IA) + (([rB dot:rB] - pow([rB dot:t], 2))/IB));
 
    double e_ = sqrt(A.e * B.e);
    
    double bias=0;
    
    if (fabs(self.separation)>K) {
        bias = fabs(E/TIME_INTERVAL*(K + self.separation));
    }
    //Vector2D* Pn = [n multiply:MIN(0, mn*(1+e_)*un)];
    Vector2D* Pn = [n multiply:MIN(0, mn*((1+e_)*un-bias))];
    double dPt = mt*ut;
    
    double Ptmax = A.mu * B.mu * Pn.length;
    
    dPt = MAX(-Ptmax, MIN(dPt, Ptmax));
    
    Vector2D* Pt = [t multiply:dPt];
    Vector2D* Pnt = [Pn add:Pt];
    
    if (A.type != bound) {
        A.velocity = [vA add:[Pnt multiply:(1.0/mA)]];
        A.angularV = wA + (1.0/IA) * [rA cross:Pnt];
    }
    
    if (B.type != bound) {
        B.angularV = wB - (1.0/IB) * [rB cross:Pnt];
        B.velocity = [vB subtract:[Pnt multiply:(1.0/mB)]];
    }
}




@end
