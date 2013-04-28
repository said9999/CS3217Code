//
//  GameObject.m
//  Game
//
//  Created by sai on 1/31/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"



@implementation GameObject
@synthesize center,transform,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)assignModel{
    Rectangle* model;
    
    double mass = 200;
    if (self.view.tag == kGameObjectBlock) {
        mass = 100;
    }else if(self.view.tag == GameBlockWood){
        mass = 150;
    }else if(self.view.tag == GameBlockIron){
        mass = 200;
    }else if(self.view.tag == GameBlockStone){
        mass = 250;
    }else if(self.view.tag == kGameObjectWind){
        mass = 201;
    }
    
    if (self.view.tag == kGameObjectWind) {
        model = [[Rectangle alloc] initWithPosition:toVector(self.animation.center) Width:82 Height:82 Mass:mass Type:circle];
    }else if(self.view.tag == kGameObjectPig){
         model = [[Rectangle alloc] initWithPosition:toVector(self.view.center) Width:self.realWidth Height:self.realHeight Mass:mass Type:KEY];
    }
    else{
        model = [[Rectangle alloc] initWithPosition:toVector(self.view.center) Width:self.realWidth Height:self.realHeight Mass:mass Type:actor];
    }
    
    model.HP = mass;
    self.model = model;
    self.model.reDelegate = self;
    
    //renew rotation
    self.model.rotation = -atan2(self.view.transform.b, self.view.transform.a);
    
    CGAffineTransform t = self.view.transform;
    //renew width and height
    CGFloat xSize = sqrt(t.a * t.a + t.c * t.c);
    CGFloat ySize = sqrt(t.b * t.b + t.d * t.d);
    self.model.width = self.realWidth * xSize;
    self.model.height = self.realHeight * ySize;
    self.model.ineria = (self.model.width*self.model.width + self.model.height*self.model.height)/12.0*self.model.mass;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    //MODIFIES: object view
    //REQUIRES: game begins
    //EFFECT: set the view of controller as Imgview
    self.view = self.selfImgView;
}

- (id)initWithBackground:(UIScrollView*) downArea:(UIView*)upArea{
    //REQUIRES: game begins
    //EFFECTS: create a new object knowing the information of the game
    //REMARK: this method is overrided in GameWolf,GamePig,and GameBlock
    return self;
}

- (void)translate:(UIPanGestureRecognizer*)gesture{
    // MODIFIES: object model (coordinates)
    // REQUIRES: game in designer mode
    // EFFECTS: the user drags around the object with one finger
    //          if the object is in the palette, it will be moved in the game area
    assert(self.delegate!=nil);
    [self.delegate getGameArea].scrollEnabled = NO;
    [gesture.view setBounds:CGRectMake(ZERO, ZERO, self.realWidth, self.realHeight)];
    //move view
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                      gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
    //if view is moved into gamearea, then add it to gamearea
    if (gesture.state == UIGestureRecognizerStateChanged && gesture.view.superview == [self.delegate getTopBar]) {
        Boolean isInGameArea = gesture.view.center.y - gesture.view.frame.size.height/2 >= [self.delegate getTopBar].frame.size.height;
        
        if (isInGameArea) {
            CGFloat offX = [self.delegate getGameArea].contentOffset.x + gesture.view.center.x;
            gesture.view.center = CGPointMake(offX,gesture.view.center.y - [self.delegate getTopBar].frame.size.height);
            [[self.delegate getGameArea] addSubview:gesture.view];
        }
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate getGameArea].scrollEnabled = YES;
        Boolean isNeedToMoveBack = gesture.view.center.y <= [self.delegate getTopBar].frame.size.height && gesture.view.superview == [self.delegate getTopBar];
        
        if (isNeedToMoveBack) {//move view back if it's still in topbar after translation
            [gesture.view setBounds:CGRectMake(ZERO, ZERO, self.originWidth, self.originHeight)];
            gesture.view.center = CGPointMake(self.originX , self.originY);
        }
        
        Boolean isNeedToAddBlock = gesture.view.tag >= 4 && gesture.view.superview == [self.delegate getGameArea];
        if (isNeedToAddBlock) {//add a new block to platte after a successful translation
            [self resetBlock];
        }
        //update position
        self.model.postion = toVector(self.view.center);
    }
}

-(void)resetBlock{
    //REQUIRES:this method is overrided in class GameBlock
    //EFFECTS: add a new block to platte
}


- (void)rotate:(UIRotationGestureRecognizer *)gesture{
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture
        [self.delegate getGameArea].scrollEnabled = NO;
        
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        self.model.rotation = -atan2(gesture.view.transform.b, gesture.view.transform.a);
        gesture.rotation = 0;
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self.delegate getGameArea].scrollEnabled = YES;
        }
    
        
}

- (void)zoom:(UIPinchGestureRecognizer *)gesture{
    // MODIFIES: object model (size)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is scaled up/down with a pinch gesture

// You will need to define more methods to complete the specification.
    [self.delegate getGameArea].scrollEnabled = NO;
    //caculate  the scale of current view
    CGFloat xA = self.view.transform.a;
    CGFloat yB = self.view.transform.b;
    CGFloat xC = self.view.transform.c;
    CGFloat yD = self.view.transform.d;
    
    CGFloat xScale = sqrt(xA*xA + xC*xC);
    CGFloat yScale = sqrt(yB*yB + yD*yD);
    
    if (xScale>MAX_SCALE||yScale>MAX_SCALE) {//too big then don't zoom in
        self.view.transform = CGAffineTransformScale(self.view.transform, SCALE_ZOOMOUT, SCALE_ZOOMOUT);
    }else if(xScale <MIN_SCALE||yScale<MIN_SCALE){//too small then don't zoom out
        self.view.transform = CGAffineTransformScale(self.view.transform, SCALE_ZOOMIN, SCALE_ZOOMIN);
    }else{ //zoom in and out
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    }
    
    //self.model.width = self.model.width*gesture.scale;
    //self.model.height = self.model.height*gesture.scale;

    gesture.scale = ORIGIN_SCALE;
    if (gesture.state == UIGestureRecognizerStateEnded) {
                
        [self.delegate getGameArea].scrollEnabled = YES;
    }
    
    CGAffineTransform t = self.view.transform;
    CGFloat xSize = sqrt(t.a * t.a + t.c * t.c);
    CGFloat ySize = sqrt(t.b * t.b + t.d * t.d);
    
    
    self.model.width = self.realWidth * xSize;
    self.model.height = self.realHeight * ySize;
    self.model.ineria = (self.model.width*self.model.width + self.model.height*self.model.height)/12.0*self.model.mass;
}

- (void)handleSingleTap:(UITapGestureRecognizer*)gesture{
    //MODIFIES: texture of a block
    //REQUIRES: in designer modes, this method is overrided in GameBlock
    //EFFECTS: change texture of a block
}

- (void)handleDoubleTap:(UITapGestureRecognizer*) gesture{
    self.view.transform = CGAffineTransformIdentity;
    gesture.view.frame = CGRectMake(self.originX-self.originWidth/2, self.originY-self.originHeight/2, self.originWidth, self.originHeight);
    
    [[self.delegate getTopBar] addSubview:self.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   //EFFECTS: able to autorotate
    // Return YES for supported orientations
	return YES;
}

- (void)update{
    if (self.model.type == EMPTY) {
        if (self.objectType != kGameObjectWind && self.view.tag != kGameObjectPig) {
            [self.view removeFromSuperview];
        }else if(self.view.tag == kGameObjectPig){
            self.pigDieAnimation.frame = self.view.frame;
            self.pigDieSmoke.frame = self.view.frame;
            
            [self.view removeFromSuperview];
            [self.pigDieAnimation startAnimating];
            [self.pigDieSmoke startAnimating];
            
            [[self.delegate getGameArea] addSubview:self.pigDieAnimation];
            [[self.delegate getGameArea] addSubview:self.pigDieSmoke];
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Nice Job!"
                                                          message:@"Mission Complete!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Okay"
                                                otherButtonTitles:nil];
            [alert show];
            [self.delegate gameOver];
            [self.delegate reset];
        }
        else{
            [self.animation removeFromSuperview];
        }
    }else{
        if (self.objectType ==kGameObjectWind) {
            self.animation.center = toCG(self.model.postion);
            self.animation.transform = CGAffineTransformMakeRotation(-self.model.rotation);
        }
        else{
            self.view.bounds = CGRectMake(0, 0, self.model.width, self.model.height);
            self.view.center = toCG(self.model.postion);
            for(UIView* vw in self.view.subviews)
                vw.frame = CGRectMake(0, 0, self.model.width, self.model.height);
            self.view.transform = CGAffineTransformMakeRotation(-self.model.rotation);
        }
    }
}

- (NSMutableArray*)getImgsWithName:(NSString*)name Row:(int)rowN Col:(int)colN{
    NSMutableArray* result = [NSMutableArray array];
    UIImage* img = [UIImage imageNamed:name];
    CGFloat height = img.size.height/rowN;
    CGFloat width = img.size.width/colN;
    for (int row = 0; row<rowN;row++) {
        for(int col = 0; col <colN;col++){
            CGFloat startX = col*width;
            CGFloat startY = row*height;
            
            UIImage* wolfsImage = [UIImage imageNamed:name];
            CGImageRef imageRef = CGImageCreateWithImageInRect([wolfsImage CGImage],
                                                               CGRectMake(startX, startY, width, height));
            UIImage* wolfImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            [result addObject:wolfImage];
        }
    }
    return result;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer
{   //EFFECTS: detect multiple gesture recognizers simutaneously
    //REQUIRES: game begins
    return YES;
}
@end
