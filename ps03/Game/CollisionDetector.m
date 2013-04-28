
//
//  CollisionDetector.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CollisionDetector.h"

@implementation CollisionDetector

-(id)init{
    self.contactPointsList = [NSMutableArray array];
    return self;
}

-(void)solveWithA:(Rectangle *)rectA B:(Rectangle *)rectB{
    //this method happens when two rectangles collide with each other, it will create two contact points into its
    //list
    
    //prepare needed data
    Vector2D* pA = rectA.postion;
    Vector2D* pB = rectB.postion;
    Vector2D* d = [pB subtract:pA];
    Vector2D* dA = [[rectA.R transpose] multiplyVector:d];
    Vector2D* dB = [[rectB.R transpose] multiplyVector:d];
    Matrix2D* C = [[rectA.R transpose] multiply:rectB.R];
    Vector2D *fA = [[[dA abs] subtract:rectA.h] subtract:[[C abs] multiplyVector:rectB.h]];
    Vector2D *fB = [[[dB abs] subtract:rectB.h] subtract:[[[C transpose] abs] multiplyVector:rectA.h]];

    
    if (!(fA.x < ZERO && fA.y < ZERO && fB.x < ZERO && fB.y < ZERO)) {
        return;
    }
    //start edge verify/Users/sai/Documents/workspace/ps4retry/ps4retry/RectangleViewController.m
    Vector2D* n;
    Vector2D* nf;
    Vector2D* ns;
    double Df;
    double Ds;
    double Dneg;
    double Dpos;
    
    EdgeNo result = [self getEdgeNoWithfA:fA fB:fB hA:rectA.h hB:rectB.h];
    
    switch (result) {
        case firstEdge:
            if (dA.x > ZERO) {
                n = rectA.R.col1;
            } else {
                n = [rectA.R.col1 negate];
            }
            
            nf = n;      
            Df = [pA dot:nf] + rectA.h.x;
            ns = rectA.R.col2;
            Ds = [pA dot:ns];
            Dneg = rectA.h.y - Ds;
            Dpos = rectA.h.y + Ds;
            break;
        
        case secondEdge:
            if (dA.y > ZERO) {
                n = rectA.R.col2;
            } else {
                n = [rectA.R.col2 negate];
            }
            
            nf = n;
            Df = [pA dot:nf] + rectA.h.y;
            ns = rectA.R.col1;
            Ds = [pA dot:ns];
            Dneg = rectA.h.x - Ds;
            Dpos = rectA.h.x + Ds;

            break;
        case thirdEdge:
            if (dB.x > ZERO) {
                n = rectB.R.col1;
            } else {
                n = [rectB.R.col1 negate];
            }
            
            nf = [n negate];
            Df = [pB dot:nf] + rectB.h.x;
            ns = rectB.R.col2;
            Ds = [pB dot:ns];
            Dneg = rectB.h.y - Ds;
            Dpos = rectB.h.y + Ds;
            
            break;
            
        case fourthEdge:
            if (dB.y > ZERO) {
                n = rectB.R.col2;
            } else {
                n = [rectB.R.col2 negate];
            }
            
            nf = [n negate];
            Df = [pB dot:nf] + rectB.h.y;
            ns = rectB.R.col1;
            Ds = [pB dot:ns];
            Dneg = rectB.h.x - Ds;
            Dpos = rectB.h.x + Ds;
            
            break;


        default:
            break;
    }
    
    Vector2D* p;
    Vector2D* ni;
    Matrix2D* R;
    Vector2D* h;
    
    switch (result) {
        case firstEdge:
        case secondEdge:
            ni = [[[rectB.R transpose] multiplyVector:nf] negate];
            p = pB;
            R = rectB.R;
            h = rectB.h;
            break;
            
        case thirdEdge:
        case fourthEdge:
            ni = [[[rectA.R transpose] multiplyVector:nf] negate];
            p = pA;
            R = rectA.R;
            h = rectA.h;
            break;
            
        default:
            break;
    }
    
    Vector2D* absni = [ni abs];
    Vector2D* v1;
    Vector2D* v2;
    ///start projection
    
    
    if (absni.x > absni.y) {
        if (ni.x > ZERO) {
            v1 = [p add:[R multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
            v2 = [p add:[R multiplyVector:h]];
        } else {
            v1 = [p add:[R multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
            v2 = [p add:[R multiplyVector:[h negate]]];
        }
    }
    else {
        if (ni.y > ZERO) {
            v1 = [p add:[R multiplyVector:h]];
            v2 = [p add:[R multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
        } else {
            v1 = [p add:[R multiplyVector:[h negate]]];
            v2 = [p add:[R multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
        }
    }
    
    
    double dist1 = [[ns negate] dot:v1] - Dneg;
    double dist2 = [[ns negate] dot:v2] - Dneg;
    
    Vector2D* v1P;
    Vector2D* v2P;
    Vector2D* v1PP;
    Vector2D* v2PP;
    
    if (dist1<ZERO && dist2 < ZERO) {
        v1P = v1;
        v2P = v2;
    }else if(dist1 > ZERO && dist2 > ZERO){
        return;
    }else if(dist1 < ZERO && dist2 > ZERO){
        v1P = v1;
        v2P = [v1 add:[[v2 subtract:v1] multiply:(dist1/(dist1 - dist2))]];
    }else if(dist1 > ZERO && dist2 < ZERO){
        v1P = v2;
        v2P = [v1 add:[[v2 subtract:v1] multiply:(dist1/(dist1 - dist2))]];
    }
    
    dist1 = [ns dot:v1P] - Dpos;
    dist2 = [ns dot:v2P] - Dpos;

    if (dist1<ZERO && dist2 < ZERO) {
        v1PP = v1P;
        v2PP = v2P;
    }else if(dist1 > ZERO && dist2 > ZERO){
        return;
    }else if(dist1 < ZERO && dist2 > ZERO){
        v1PP = v1P;
        v2PP = [v1P add:[[v2P subtract:v1P] multiply:(dist1/(dist1 - dist2))]];
    }else if(dist1 > ZERO && dist2 < ZERO){
        v1PP = v2P;
        v2PP = [v1P add:[[v2P subtract:v1P] multiply:(dist1/(dist1 - dist2))]];
    }

    if(fabs(v1PP.x - v2PP.x) < TOLERATNCE && fabs(v1PP.y - v2PP.y) < TOLERATNCE){
        return;
    }

    double s1 = [nf dot:v1PP] - Df;
    Vector2D* c1 = [v1PP subtract: [nf multiply:s1]];
        
    double s2 = [nf dot:v2PP] - Df;
    Vector2D* c2 = [v2PP subtract: [nf multiply:s2]];
    
    if (fabs(s1-s2)<0.126) {
        s1 = s2;
    }
    /*
    if(rectA.type == circle || rectB.type == circle){
        Rectangle* rectC;
        Rectangle* rectR;
        if (rectA.type == circle) {
            rectC = rectA;
            rectR = rectB;
        }else{
            rectC = rectB;
            rectR = rectA;
        }
        
        
            rectC.type = EMPTY;
        
        if(fabs(rectC.rotation-rectR.rotation)>0.1){
            rectC.rotation = rectR.rotation;
            return; //return here no need to add point
        }
    }*/

    ContactPoint* point1 = [[ContactPoint alloc] initWithRectA:rectA RectB:rectB Normal:n Separation:s1 Point:c1];
    ContactPoint* point2 = [[ContactPoint alloc] initWithRectA:rectA RectB:rectB Normal:n Separation:s2 Point:c2];
    
    [self.contactPointsList addObject:point1];
    [self.contactPointsList addObject:point2];
}

-(EdgeNo)getEdgeNoWithfA:(Vector2D*)fA fB:(Vector2D*)fB hA:(Vector2D*)hA hB:(Vector2D*) hB{
    
    double kAx = ETA*fA.x;
    double kAy = ETA*fA.y;
    double kBx = ETA*fB.x;
    double kBy = ETA*fB.y;
    
    if (fA.x > kAy && fA.x > kBx && fA.x > kBy) {
        return firstEdge;
    }else if(fA.y > kAx && fA.y > kBx && fA.y > kBy){
        return secondEdge;
    }else if(fB.x > kAx && fB.x > kAy && fB.x > kBy){
        return thirdEdge;
    }else if(fB.y > kAx && fB.y > kAy && fB.y > kBx){
        return fourthEdge;
    }

    double max = fA.x;
    EdgeNo result = firstEdge;
    
    if (max < fA.y) {
        max = fA.y;
        result = secondEdge;
    }else if(max < fB.x ){
        max = fB.x;
        result = thirdEdge;
    }else if(max < fB.y){
        max = fB.y;
        result = fourthEdge;
    }

    return result;
}

@end
