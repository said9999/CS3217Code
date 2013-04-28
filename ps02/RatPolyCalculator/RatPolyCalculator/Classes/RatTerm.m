#import "RatTerm.h"


@implementation RatTerm
@synthesize coeff;
@synthesize expt;

// Checks that the representation invariant holds.
-(void) checkRep{ // 5 points
    // You need to fill in the implementation of this method
    if ([self.coeff isEqual:[RatNum initZERO]]&& self.expt!=0) {
        [NSException raise:@"RatTerm rep error" format:
         @"EXp!=0 when Coeff == ZERO"];
    }
    
    if ([self.coeff isEqual:nil]) {
        [NSException raise:@"RatTerm rep error" format:
         @"nil pointer for coeff"];
    }
}

-(id)initWithCoeff:(RatNum*)c Exp:(int)e{
    // REQUIRES: (c, e) is a valid RatTerm
    // EFFECTS: returns a RatTerm with coefficient c and exponent e
    
    RatNum *ZERO = [RatNum initZERO];
    // if coefficient is 0, exponent must also be 0
    // we'd like to keep the coefficient, so we must retain it
    
    if ([c isEqual:ZERO]) {
        coeff = ZERO;
        expt = 0;
    } else {
        coeff = c;
        expt = e;
    }
    [self checkRep];
    return self;
}

+(id)initZERO { // 5 points
    // EFFECTS: returns a zero ratterm
    return [[RatTerm alloc] initWithCoeff:[RatNum initZERO] Exp:0];
}

+(id)initNaN { // 5 points
    // EFFECTS: returns a nan ratterm
    return [[RatTerm alloc] initWithCoeff:[RatNum initNaN] Exp:0];
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is NaN
    return [self.coeff isNaN];
    
}

-(BOOL)isZero { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is zero
    return [self.coeff isEqual:[[RatNum alloc] initWithInteger:0]];
}


// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return the value of this polynomial when evaluated at
    //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
    //            [self isNaN] returns YES, return NaN
    if (self.isNaN) {
        return NAN;
    }else{
        return self.coeff.doubleValue * pow(d, self.expt);
    }
}

-(RatTerm*)negate{ // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: return the negated term, return NaN if the term is NaN
    if (self.isNaN) {
        return [RatTerm initNaN];
    }else{
        return [[RatTerm alloc] initWithCoeff:[self.coeff negate] Exp:self.expt];
    }
}



// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //            arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    if(self.isNaN||arg.isNaN){
        return [RatTerm initNaN];printf("pass1");
    }else if([arg isZero]){
        return self;
    }else if([self isZero]){
        return arg;
    }else if(arg.expt != self.expt){
         @throw [NSException exceptionWithName:@"Expt Error" reason:@"Not Equal" userInfo:nil];

    }else{
        return [[RatTerm alloc] initWithCoeff:[self.coeff add:arg.coeff] Exp:self.expt];
    }
    
}


// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //             arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    return [self add:[arg negate]];
    
}


// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN
    if(self.isNaN||arg.isNaN)
        return [RatTerm initNaN];
    return [[RatTerm alloc] initWithCoeff:[self.coeff mul:arg.coeff] Exp:self.expt + arg.expt];
}


// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
    if(self.isNaN||arg.isNaN)
        return [RatTerm initNaN];
    return [[RatTerm alloc] initWithCoeff:[self.coeff div:arg.coeff] Exp:self.expt - arg.expt];
}


// Returns a string representation of this RatTerm.
-(NSString*)stringValue { // 5 points
    //  REQUIRES: self != nil
    // EFFECTS: return A String representation of the expression represented by this.
    //           There is no whitespace in the returned string.
    //           If the term is itself zero, the returned string will just be "0".
    //           If this.isNaN(), then the returned string will be just "NaN"
    //		    
    //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
    //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
    //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
    //          in which case T takes the form "C" (2) the exponent E is one, in which
    //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
    //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero).
    // 
    //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".
    if(self.isNaN)
        return @"NaN";
    if(self.isZero)
        return @"0";
    if (self.expt == 0) {
        return [self.coeff stringValue];
    }
    
    if (self.expt == 1) {
        if (self.coeff.denom==1) {
            if (self.coeff.numer==1) {
                return @"x";
            }
            if (self.coeff.numer==-1) {
                return @"-x";
            }
            return [NSString stringWithFormat:@"%d*x",self.coeff.numer];
        }else{
            return [NSString stringWithFormat:@"%d/%d*x",self.coeff.numer,self.coeff.denom];
        }
    }
    
    if (self.coeff.numer==1&&self.coeff.denom==1) {
        return [NSString stringWithFormat:@"x^%d",self.expt];
    }
                                        
    if (self.coeff.numer==-1&&self.coeff.denom==1) {
        return [NSString stringWithFormat:@"-x^%d",self.expt];
    }

    
    if (self.coeff.denom==1) {
        return [NSString stringWithFormat:@"%d*x^%d",self.coeff.numer,self.expt];
    }else{
        return [NSString stringWithFormat:@"%d/%d*x^%d",self.coeff.numer,self.coeff.denom,self.expt];
    }

}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
    // REQUIRES: that self != nil and "str" is an instance of
    //             NSString with no spaces that expresses
    //             RatTerm in the form defined in the stringValue method.
    //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
    // EFFECTS: returns a RatTerm t such that [t stringValue] = str
    if ([str isEqual:@"NaN"]) {
        return [RatTerm initNaN];
    }
    if ([str isEqual:@"0"]) {
        return [RatTerm initZERO];
    }
    NSArray *tokens = [str componentsSeparatedByString:@"*"];
    NSString *first;
    
    if ([tokens count] == 1) {
        first = [tokens objectAtIndex:0];
        if ([RatTerm isContainX:first]) {
            int exp = [RatTerm getExp:first];
            if ([RatTerm isContainMinus:first]) {
                return [[RatTerm alloc] initWithCoeff:[[RatNum alloc] initWithInteger:-1] Exp:exp];
            }
            else{
                return [[RatTerm alloc] initWithCoeff:[[RatNum alloc] initWithInteger:1] Exp:exp];
            }
        }
        else{
            return [[RatTerm alloc] initWithCoeff:[RatNum valueOf:first] Exp:0];
        }
    }else{//count == 2
        RatNum* rn = (RatNum*) [RatNum valueOf:[tokens objectAtIndex:0]];
        int _exp = [RatTerm getExp:[tokens objectAtIndex:1]];
        return [[RatTerm alloc] initWithCoeff:rn Exp:_exp];
    }
    return nil;
}

+(int) getExp:(NSString*) str{
     NSArray *tokens = [str componentsSeparatedByString:@"^"];
    if ([tokens count]==1) {
        return 1;
    }
    else{
        return [[tokens objectAtIndex:1] intValue];
    }
}

+(BOOL)isContainX:(NSString*) str{
    NSString *x = @"x";
    NSRange foundObj=[str rangeOfString:x options:NSCaseInsensitiveSearch];
    
    if(foundObj.length>0) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isContainMinus:(NSString*) str{
    NSString *x = @"-";
    NSRange foundObj=[str rangeOfString:x options:NSCaseInsensitiveSearch];
    
    if(foundObj.length>0) {
        return YES;
    } else {
        return NO;
    }
}

    
//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
    //            the same RatTerm as self.
    RatTerm *rt = (RatTerm*)obj;
    if (self.isNaN && rt.isNaN) {
        return YES;
    }
    
    if ([self.coeff isEqual:rt.coeff]&&self.expt == rt.expt) {
        return YES;
    }else{
        return NO;
    }
}

@end
