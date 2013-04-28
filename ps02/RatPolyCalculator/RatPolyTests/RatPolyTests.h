//
//  RatPolyTests.h
//  RatPolyTests
//
//  Created by sai on 1/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RatPoly.h"

@interface RatPolyTests : SenTestCase {
    RatNum *nanNum;
    RatTerm *nanTerm;
    RatPoly *nanPoly;
    NSArray *polyz, *poly1, *poly2, *poly3;
}

@end
