#import "RatPoly.h"

@interface RatPoly()
-(BOOL)isNaN;

+ (NSString*) reverseToPositive:(NSString*)str;

+(void) mySort:(NSMutableArray*)array;

+(RatPoly*) negatePoly:(NSString*)origin:(NSString*)new:(NSMutableArray*)array;

-(id)initNaN;

@property (readwrite) NSArray* terms;
@property (readwrite,nonatomic) int degree;

@end

@interface RatTerm()

@property (readwrite) RatNum* coeff;

@end


@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
    // EFFECTS: returns the degree of this RatPoly object. 
    
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
    if ([self isZero]) {
        return 0;
    }
    return [[self.terms objectAtIndex:0] expt];
	//[NSException raise:@"RatPoly degree not implemented" format:@"fill me up plz!"];
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
    RatTerm* zero = [RatTerm initZERO];
    NSArray* array = [self.terms mutableCopy];
    
    for (int i=0; i<[array count]; i++) {
        RatTerm* term = [array objectAtIndex:i];
        if ([term expt]<0) { //Negative expt
            [NSException raise:@"RatPoly rep error" format:
             @"EXpt<0"];
        }
        
        if (i+1<[array count]) { // not des order
            RatTerm* nextTerm = [array objectAtIndex:i+1];
            if ([term isZero]||[nextTerm isZero]) {//do nothing is one of them is zero 
            
            }else if([term expt] <= [nextTerm expt]) {
                [NSException raise:@"RatPoly rep error" format:
                 @"Not in des order"];
            }
        }
        
        if ([term isEqual:zero]) {//zero coeff
            [NSException raise:@"RatPoly rep error" format:
             @"Zero exists"];
        }
    }
}

-(id)init { // 5 points
    //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
    //           remember to call checkRep to check for representation invariant
    self = [super init];
    if (self) {
        self.terms = [NSArray array];
    }
    [self checkRep];
    return self;
}

-(id)initNaN{
    return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
}

-(BOOL)isZero{
    if ([self.terms count] == 0) {
        return YES;
    }else{
        return NO;
    }
}

-(id)initWithTerm:(RatTerm*)rt{ // 5 points
    //  REQUIRES: [rt expt] >= 0
    //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
    //             a zero polynomial remember to call checkRep to check for representation invariant
    self = [self init];
    if (![rt isEqual:[RatTerm initZERO]]) {
        terms = [terms arrayByAddingObject:rt];
    }
    
    [self checkRep];
    return self;
}

-(id)initWithTerms:(NSArray*)ts{ // 5 points
    // REQUIRES: "ts" satisfies clauses given in the representation invariant
    // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
    //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant
    self = [self init];
    terms = [terms arrayByAddingObjectsFromArray:ts];
    [self checkRep];
    return self;
}

-(RatTerm*)getTerm:(int)deg { // 5 points
    // REQUIRES: self != nil && ![self isNaN]
    // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
    //            the zero RatTerm
    for (RatTerm* term in self.terms) {
        if ([term expt] == deg) {//term's degree == deg
            return term;
        }
    }
    return [RatTerm initZERO];
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    //  EFFECTS: returns YES if this RatPoly is NaN
    //             i.e. returns YES if and only if some coefficient = "NaN".
    RatNum *nan = [RatNum initNaN];
    
    for (RatTerm* term in self.terms) {//coeff == nan
        if ([[term coeff] isEqual:nan]) {
            return YES;
        }
    }
    return NO;
}

+(void) mySort:(NSMutableArray*)array{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int expt1 = [obj1 expt];
        int expt2 = [obj2 expt];
        
        if (expt1 > expt2) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        if(expt1 < expt2){
            return (NSComparisonResult) NSOrderedDescending;
        }
        return (NSComparisonResult) NSOrderedSame;
    }];
}

-(RatPoly*)negate { // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: returns the additive inverse of this RatPoly.
    //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
    //            some r such that [r isNaN]
    long termsLength = [self.terms count];
    if ([self isNaN]) {
        return [self initNaN];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:termsLength];
    for (int i=0; i<termsLength; i++) {
        [result addObject:[[self.terms objectAtIndex:i] negate]];
    }
    
    return [[RatPoly alloc] initWithTerms:result];
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    if ([self isNaN]||[p isNaN]) {
        return [self initNaN];
    }else if([self isZero]){
        return p;
    }else if([p isZero]){
        return self;
    }else{
        NSMutableArray *returnArray = [self.terms mutableCopy];
        
        for (RatTerm* pT in p.terms) {
            int exp = [pT expt];
            RatTerm* selfT = [self getTerm:exp];
            
            if (![selfT isEqual:[RatTerm initZERO]]) {
                RatTerm* sum = [selfT add:pT];
                if ([sum isZero]) {
                    [returnArray removeObject:selfT];
                }else{
                    [returnArray removeObject:selfT];
                    [returnArray addObject:sum];
                }
            }else{
                [returnArray addObject:pT];
            }
        }
        
        //sort here
        [RatPoly mySort:returnArray];
        return [[RatPoly alloc] initWithTerms:returnArray];
    }
}


// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    return [self add:[p negate]];
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
    // some r such that [r isNaN]
    RatPoly* origin = [[RatPoly alloc] init];
    
    if ([self isNaN]||[p isNaN]) {
        return [[RatPoly alloc] initNaN];
    }
    if ([self isZero]||[p isZero]) {
        return [[RatPoly alloc] init];
    }
    
    for (RatTerm* selfT in self.terms) {
        for (RatTerm* pT in p.terms) {
            RatPoly* multiResult = [[RatPoly alloc] initWithTerm:[selfT mul:pT]];
            origin = [origin add:multiResult];
        }
    }
    
    NSMutableArray* array = [origin.terms mutableCopy];
    [RatPoly mySort:array];
    return [[RatPoly alloc] initWithTerms:array];
}


// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p{ // 5 points
    // REQUIRES: p != null, self != nil
    // EFFECTS: return a RatPoly, q, such that q = "this / p"; if p = 0 or [self isNaN]
    //           or [p isNaN], returns some q such that [q isNaN]
    //
    // Division of polynomials is defined as follows: Given two polynomials u
    // and v, with v != "0", we can divide u by v to obtain a quotient
    // polynomial q and a remainder polynomial r satisfying the condition u = "q *
    // v + r", where the degree of r is strictly less than the degree of v, the
    // degree of q is no greater than the degree of u, and r and q have no
    // negative exponents.
    // 
    // For the purposes of this class, the operation "u / v" returns q as
    // defined above.
    //
    // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
    // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
    // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
    //
    // Note that this truncating behavior is similar to the behavior of integer
    // division on computers.
    if ([self isNaN]||[p isNaN]||[p isZero]) {
        return [self initNaN];
    }else if([self isZero]){
        return [[RatPoly alloc] init];
    }else{
        RatPoly *copySelf = [[RatPoly alloc] initWithTerms:self.terms];
        NSMutableArray* result = [NSMutableArray array];
        int pDegree = [p degree];
        
        while ([copySelf degree] >= pDegree) {
            RatTerm* ratio = [[copySelf getTerm:[copySelf degree]] div:[p getTerm:pDegree]];// term = selfTermAtDegree/pTermAtDegree
            [result addObject:ratio];
            RatPoly *multi = [p mul:[[RatPoly alloc] initWithTerm:ratio]];// p * ratio
            copySelf = [copySelf sub:multi]; // copy - p*ratio
            if ([copySelf isZero]) {
                break;
            }
        }
        return [[RatPoly alloc] initWithTerms:result];
    }
    
}

-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns the value of this RatPoly, evaluated at d
    //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
    //            if [self isNaN], return NaN
    if ([self isNaN]) {
        return NAN;
    }else{
        double sum = 0;
        for (int i=0; i<[self.terms count]; i++) {
            sum += [[self.terms objectAtIndex:i] eval:d];
        }

        return sum;
    }

}


// Returns a string representation of this RatPoly.
-(NSString*)stringValue { // 5 points
    // REQUIRES: self != nil
    // EFFECTS:
    // return A String representation of the expression represented by this,
    // with the terms sorted in order of degree from highest to lowest.
    //
    // There is no whitespace in the returned string.
    //        
    // If the polynomial is itself zero, the returned string will just
    // be "0".
    //         
    // If this.isNaN(), then the returned string will be just "NaN"
    //         
    // The string for a non-zero, non-NaN poly is in the form
    // "(-)T(+|-)T(+|-)...", where "(-)" refers to a possible minus
    // sign, if needed, and "(+|-)" refer to either a plus or minus
    // sign, as needed. For each term, T takes the form "C*x^E" or "C*x"
    // where C > 0, UNLESS: (1) the exponent E is zero, in which case T
    // takes the form "C", or (2) the coefficient C is one, in which
    // case T takes the form "x^E" or "x". In cases were both (1) and
    // (2) apply, (1) is used.
    //        
    // Valid example outputs include "x^17-3/2*x^2+1", "-x+1", "-1/2",
    // and "0".
    if ([self isZero]) {
        return @"0";
    }else if([self isNaN]){
        return @"NaN";
    }else{
        NSString *str = @"";
        NSString *strTerm;
        NSString *prefix = @"+";
        int count = 0;
        
        for (RatTerm *selfT in self.terms) {
            strTerm = [selfT stringValue];
            if ([[selfT coeff] isPositive] && count!=0) {//add + before a string if it's positive and not at the head
                strTerm = [prefix stringByAppendingString:strTerm];
            }
            str = [str stringByAppendingString:strTerm];
            count++;
        }
        return str;
    }
    
}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
    // REQUIRES : 'str' is an instance of a string with no spaces that
    //              expresses a poly in the form defined in the stringValue method.
    //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
    // EFFECTS : return a RatPoly p such that [p stringValue] = str
    if ([str isEqual:@"0"]) {
        return [[RatPoly alloc] init];
    }else if([str isEqual:@"NaN"]){
        return [[RatPoly alloc] initNaN];
    }else{
        NSMutableArray* array = [NSMutableArray array];
        NSString *termStr;
        NSString *allPositiveString = [RatPoly reverseToPositive:str]; //make all negative terms to positive for the convenience of
                                                                       //separate
        NSArray *tokensByPlus = [allPositiveString componentsSeparatedByString:@"+"];
        long numOfTerms = [tokensByPlus count];
        
        for (int i=0; i<numOfTerms; i++) {
            termStr = [tokensByPlus objectAtIndex:i];
            [array addObject:[RatTerm valueOf:termStr]];
        }
        
        //negate the terms that should be negative
        return [RatPoly negatePoly:str:allPositiveString:array];
    }
}

+ (RatPoly*) negatePoly:(NSString*)origin:(NSString*)new:(NSMutableArray*)array{
    NSMutableArray *result = [NSMutableArray array];
    int termCount = 0;
    if ([origin characterAtIndex:0] == '-') {//add + to the head of the poly
        NSString *prefix = @"+";
        new = [prefix stringByAppendingString:new];
    }else{
        termCount++;
        [result addObject:[array objectAtIndex:termCount-1]];
    }
    
    long length = [origin length];
    
    for (int i=0; i<length; i++) {
        char oriChar = [origin characterAtIndex:i];
        char newChar = [new characterAtIndex:i];
        
        if (oriChar == '-' ||oriChar == '+') {
            termCount++;
        }
        
        if (oriChar == '+' && newChar == '+') {
            [result addObject:[array objectAtIndex:termCount-1]];
        }else if(oriChar != newChar){
            [result addObject:[((RatTerm*)[array objectAtIndex:termCount -1]) negate]];
        }
    }
    return [[RatPoly alloc] initWithTerms:result];
}
                 
+ (NSString*) reverseToPositive:(NSString*)str{
    long length = [str length];
    NSString *string = @"";
    for (int i=0; i<length; i++) {
        char ch = [str characterAtIndex:i];
        if (i == 0 && ch == '-') {
            continue;
        }else if (ch == '-') {
            string = [string stringByAppendingFormat:@"+"];
        }else{
            string = [string stringByAppendingFormat:@"%c",ch];

        }
    }
    
    return string;
}
// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
    //            the same rational polynomial as self. All NaN polynomials are considered equal
    if ([obj isKindOfClass:[RatPoly class]]) {
        RatPoly* comparingObj = (RatPoly*) obj;
        if ([self isNaN] && [obj isNaN]) {
            return YES;
        }else if([self.terms isEqual:comparingObj.terms]){
            return YES;
        }
    }
    
    return NO;
}

@end

/* 
 
 Question 1(a)
 ========
 
 r=p+q:
 let r = p + (-q);
 by making each constant of each term in q become negative.
 
 Question 1(b)
 ========
 r = p * q;
 r = 0;
 for each term tp in p 
    for each term tq in q
        r += tp * tq;
 
 Question 1(c)
 ========
 r = p / q;
 r = 0;
 while(degree(p) >= degree(q))
    term = termAtDegree(degree(p))/termAtDegree(degree(q));
    r += term;
    p -= term * q;
 
 Question 2(a)
 ========
 because [nil method] will not cause an exception, which will cause confusion when we try to debug.
 For div, if we do not verify NaN, we may return a Rational Number when diving a NaN, since
 1/2 div 1/0 = 0/2 which becomes Rational from NaN.
 
 
 Question 2(b)
 ========
 since this method is more related to the class, and the return type is RatNum* which is used by this class, hence no need to
 make it an instance method, or we need to create a new instance.
 
 We can create a initWithString method to replace valueOf method.
 
 Question 2(c)
 ========
 
 - initWithInteger and 
 - stringValue needs to use checkRep to gaurantee the reduced form
 - isEqual has to reduce two comparing numbers
 
 the code won't be omplex since we can use gcd to get the reduce form very quickly, hence the efficiency won't
 be affected too much.
 
 
 Question 2(d)
 ========
 
 addtion or substraction can violate its representation, e.g 1/3 + 1/6 = 9/18 but the reduced form should be 1/2. But
 method addion and substraction return a new RatNum by using the constructor, and at the end of every constructor, method 
 [self checkRep] is called. Hence, there won't be a violation for add and sub finally.
 And the same for mult,and div methods(noted that we check NaN for div).
 
 Question 2(e)
 ========
 ? no such question on the ibook
 
 
 Question 3(a)
 ========
 at the end of constructors, reason is that every other method only return a constructor,
 hence only need to check at the end of every constructor.
 
 Question 3(b)
 ========
 1. no need to check zero coeff in checkRep
 2. add Method need to check zero and kick zero values out
 3. isEqual has to kick all zero values out to check equality
 
 The complexity won't be change too much, since it's O([terms length]) time to check if there is a zero.
 Efficiency won't be changed too much.
 
 Question 3(c)
 ========
 1. checkRep need to check expt too.
 2. initWithCoeff to check NaN's expt
 3. isNaN needs to check expt
 
 the complexity won't change too much since we won't use too much time to check the expt of a RatNum
 
 Question 3(d)
 ========
 neither, since these two extra restrictions dont help us too much on solving this kind of problems.
 And the complexity is almost the same without the restrictions.
 
 Question 5: Reflection (Bonus Question)
 ==========================
 (a) How many hours did you spend on each problem of this problem set?
 
 p1 20mins
 p2 1hr to read
 p3 3hr
 p4 15hr for debug and testing
 
 (b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?
 
 should get used to the debugger of Xcode, and get familiar with objective c
 
 (c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
 may provide some useful API or most common API like NSString NSArray NSMutableArray etc.
 
 */
