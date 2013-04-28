//
//  NSObject+GameViewControllerExtension.m
//  Game
//
//  Created by sai on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameViewControllerExtension.h"

@implementation ViewController (Extension)



-(void)reset{
    // MODIFIES: self (game objects)
    // REQUIRES: game in designer mode
    // EFFECTS: current game objects are deleted and palette contains all objects
    //release all pigg
    [self.myWorld.timer invalidate];
    self.myWorld.timer = nil;
    
    for(UIView* view in self.gamearea.subviews){
        if (view.tag>ZERO) {
            [view removeFromSuperview];
        }
    }
    
    for(UIView* view in self.topBar.subviews){
        if (view.tag>ZERO) {
            [view removeFromSuperview];
        }
    }
    
    for (UIViewController* con in self.childViewControllers) {
        if (con.view.superview == self.gamearea) {
            [con removeFromParentViewController];
        }
    }
    
    self.wolf = [[GameWolf alloc] init];
    self.wolf.delegate = self;
    [self.wolf assignModel];
    [self.wolf.delegate setGestures:self.wolf];
    [[self.wolf.delegate getTopBar] addSubview:self.wolf.view];
    ((GameWolf*)self.wolf).heartCount = HEART_NO;
    
    self.pig = [[GamePig alloc] init];
    self.pig.delegate = self;
    [self.pig assignModel];
    [self.pig.delegate setGestures:self.pig];
    [[self.pig.delegate getTopBar] addSubview:self.pig.view];
    
    self.block = [[GameBlock alloc] init];
    self.block.delegate = self;
    [self.block assignModel];
    [self.block.delegate setGestures:self.block];
    [[self.wolf.delegate getTopBar] addSubview:self.block.view];
    
}

-(void)play{
    //leave one stop button
    [self disableAllButtons];
    [self addStopButton];
    
    //add three hearts for the wolf
    [self addHearts];
    [self addWindTypes];
    
    //set powerIndex and arrowRotation
    self.powerIndex = POWER_INIT;
    self.arrowRotation = ROTATION_INIT;
    [self removeGestureInPlatte];
    
    //set my world
    self.myWorld = [[World alloc] init];
    [self prepareTheWorld];
        
    //remove gestures from wolf pig and blocks
    [self wolfModify];
    [self pigModify];
    [self blockModify];
    
    //set other things
    [self setPowerBar];
    [self setDegree];
    [self setArrow];
    
    //run world now!
    [self.myWorld run];
       
}

- (void)disableAllButtons{
    [self.saveButton setEnabled:NO];
    [self.loadButton setEnabled:NO];
    [self.resetButton setEnabled:NO];
    [self.deleteButton setEnabled:NO];
    [self.levelOneButtom setEnabled:NO];
    [self.levelTwoButtom setEnabled:NO];
    [self.levelThreeButton setEnabled:NO];
}

- (void)addStopButton{
    [self.playButton setTitle:@"Stop"];
}

- (void)prepareTheWorld{
    //add ground
    RectangleViewController* bottom = [[RectangleViewController alloc] initWithX:BOTTOM_X Y:BOTTOM_Y Width:BOTTOM_WIDTH Height:BOTTOM_HEIGHT Mass:INFINITY Type:bound Color:TRANSPARENT];
    [self.myWorld.objectsList addObject:bottom.model];
    
    //add left bound
    RectangleViewController* left = [[RectangleViewController alloc] initWithX:LEFT_X Y:LEFT_Y Width:LEFT_WIDTH Height:LEFT_HEIGHT Mass:INFINITY Type:bound Color:TRANSPARENT];
    [self.myWorld.objectsList addObject:left.model];
    
    //add right bound
    RectangleViewController* right = [[RectangleViewController alloc] initWithX:RIGHT_X Y:RIGHT_Y Width:RIGHT_WIDTH Height:RIGHT_HEIGHT Mass:INFINITY Type:bound Color:TRANSPARENT];
    [self.myWorld.objectsList addObject:right.model];

    //add objects
    GameObject* obj;
    for (UIViewController* con in self.childViewControllers) {
        if (con.view.superview == self.gamearea&&con.view.tag!=kGameObjectWolf) {
            if ([con isKindOfClass:[GameObject class]]) {
                obj = (GameObject*) con;
                //sign mass for the model
                double mass = GENERAL_MASS;
                if (obj.view.tag == kGameObjectBlock) {
                    mass = STRAW_MASS;
                }else if(obj.view.tag == GameBlockWood){
                    mass = WOOD_MASS;
                }else if(obj.view.tag == GameBlockIron){
                    mass = IRON_MASS;
                }else if(obj.view.tag == GameBlockStone){
                    mass = STONE_MASS;
                }else if(obj.view.tag == kGameObjectWind){
                    mass = WIND_MASS;
                }
            
                obj.model.mass = mass;
                obj.model.HP = mass;
                [self.myWorld.objectsList addObject:obj.model];
            }
        }
    }

}

- (void)removeGestureInPlatte{
    for (UIView* view in self.topBar.subviews) {
        if (view.tag == kGameObjectPig || view.tag == kGameObjectBlock) {
            for (UIGestureRecognizer* reg in view.gestureRecognizers) {
                [view removeGestureRecognizer:reg];
            }
        }
    }
}

- (void)addWindTypes{
    //[self addChildViewController:self.difProjectile];
    UITapGestureRecognizer *singleRedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWindType:)];
    [singleRedTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleRedTap.delegate = self;
    
    UITapGestureRecognizer *singleBlueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWindType:)];
    [singleBlueTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleBlueTap.delegate = self;

    UITapGestureRecognizer *singleGreenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWindType:)];
    [singleGreenTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleGreenTap.delegate = self;

    self.difProjectile.redWind.frame = CGRectMake(RED_X, WIND_Y, WIND_WIDTH, WIND_HEIGHT);
    self.difProjectile.blueWind.frame = CGRectMake(BLUE_X, WIND_Y, WIND_WIDTH, WIND_HEIGHT);
    self.difProjectile.greenWind.frame = CGRectMake(GREEN_X, WIND_Y, WIND_WIDTH, WIND_HEIGHT);
    
    [self.topBar addSubview:self.difProjectile.redWind];
    [self.topBar addSubview:self.difProjectile.greenWind];
    [self.topBar addSubview:self.difProjectile.blueWind];
    
    [self.difProjectile.redWind addGestureRecognizer:singleRedTap];
    [self.difProjectile.blueWind addGestureRecognizer:singleBlueTap];
    [self.difProjectile.greenWind addGestureRecognizer:singleGreenTap];
}

- (void)handleWindType:(UITapGestureRecognizer*)gesture{
    if (gesture.view.tag == RED_FLAG) {
        self.wolf.flag = WRED_FLAG;
    }else if(gesture.view.tag == BLUE_FLAG){
        self.wolf.flag = WBLUE_FLAG;
    }else if(gesture.view.tag == GREEN_FLAG){
        self.wolf.flag = WGREEN_FLAG;
    }
    
    [gesture.view removeFromSuperview];
}

- (void)addHearts{
    ((GamePig*)self.pig).isDie = NO;
    
    
    UIImage* heartImg = [UIImage imageNamed:@"heart.png"];
    UIImageView* heart_one = [[UIImageView alloc] initWithImage:heartImg];
    UIImageView* heart_two = [[UIImageView alloc] initWithImage:heartImg];
    UIImageView* heart_three = [[UIImageView alloc] initWithImage:heartImg];
    
    heart_one.frame = CGRectMake(50, 480, heartImg.size.width*1.5, heartImg.size.height*1.5);
    heart_two.frame = CGRectMake(140, 480, heartImg.size.width*1.5, heartImg.size.height*1.5);
    heart_three.frame = CGRectMake(230, 480, heartImg.size.width*1.5, heartImg.size.height*1.5);
    heart_one.tag = 20;
    heart_two.tag = 20;
    heart_three.tag = 20;
    
    ((GameWolf*)self.wolf).heartOne = heart_one;
    ((GameWolf*)self.wolf).heartTwo = heart_two;
    ((GameWolf*)self.wolf).heartThree = heart_three;
    ((GameWolf*)self.wolf).heartCount = 3;
    
    [self.gamearea addSubview:heart_one];
    [self.gamearea addSubview:heart_two];
    [self.gamearea addSubview:heart_three];
}


- (void)pigModify{
    for (UIGestureRecognizer* recog in self.pig.view.gestureRecognizers) {
        if (self.pig.view.superview == self.gamearea) {
            [self.pig.view removeGestureRecognizer:recog];
        }
    }
}

- (void)blockModify{
    for (UIView* view in self.gamearea.subviews) {
        if (view.tag>3 && view.tag<9) {
            for (UIGestureRecognizer* recog in view.gestureRecognizers) {
                [view removeGestureRecognizer:recog];
            }
        }
    }
}

- (void)wolfModify{
    self.wolf.view.frame = CGRectMake(WOLF_X, WOLF_Y, self.wolf.realWidth, self.wolf.realHeight);
    for (UIGestureRecognizer* recog in self.wolf.view.gestureRecognizers) {
        [self.wolf.view removeGestureRecognizer:recog];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWolfTap:)];
    [singleTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleTap.delegate = self;
    
    [self.wolf.view addGestureRecognizer:singleTap];

}
/**
    Add animation for wolf and wind and remove the heart after 2 secondes
 */
- (void)handleWolfTap:(UITapGestureRecognizer*)gesture{
    
    //cannot shoot before a collision
    for (Rectangle* rect in self.myWorld.objectsList) {
        if (rect.type == circle) {
            return;
        }
    }
    
    if (self.wolf.view.superview != self.gamearea) {
        return;
    }
    self.wind = [[GamePorjectile alloc] initWithX:ZERO Y:ZERO];
    if (self.wolf.flag == WRED_FLAG) {
        self.wind.animation = ((GamePorjectile*)self.wind).redWindAnimation;
    }else if (self.wolf.flag == WBLUE_FLAG){
        self.wind.animation = ((GamePorjectile*)self.wind).blueWindAnimation;
    }else if(self.wolf.flag == WGREEN_FLAG){
        self.wind.animation = ((GamePorjectile*)self.wind).greenWindAnimation;
    }
    
    //self.wind.animation = self.finalAnimation;
    //wolf animation
    self.wolf.animation.frame = self.wolf.view.frame;
    [self.wolf.view removeFromSuperview];
    [self.wolf.animation startAnimating];
    [self.gamearea addSubview:self.wolf.animation];
    //wind animation
    self.wind.animation.frame = CGRectMake(self.wolf.view.center.x + WOLF_ANI_OFFX, self.wolf.view.center.y - WOLF_ANI_OFFY, WOLF_ANI_W, WOLF_ANI_H);
    [self.wind.animation startAnimating];
    [self.gamearea addSubview:self.wind.animation];
    //suck animation
    ((GameWolf*)self.wolf).suckAnimation.frame = CGRectMake(self.wolf.view.center.x + WOLF_SUCK_OFFX, self.wolf.view.center.y - WOLF_SUCK_OFFY, WOLF_SUCK_W, WOLF_SUCK_H);
    [((GameWolf*)self.wolf).suckAnimation startAnimating];
    [self.gamearea addSubview:((GameWolf*)self.wolf).suckAnimation];
    
    [self performSelector:@selector(addWolfAndWind) withObject:nil afterDelay:WOLF_WIND_DELAY];
    
    if (((GameWolf*)self.wolf).heartCount == WOLF_LAST_LIFE) {
        [self performSelector:@selector(wolfHeartsBroke) withObject:nil afterDelay:WOLF_DIE_DELAY];
    }else{
        [self wolfHeartsBroke];
    }
    
    self.wolf.flag = WOLF_PLAIN_WIND;
}

- (void)wolfHeartsBroke{
    if(((GameWolf*)self.wolf).heartCount == 3){
        [((GameWolf*)self.wolf).heartThree removeFromSuperview];
        ((GameWolf*)self.wolf).heartCount--;
    }else if(((GameWolf*)self.wolf).heartCount==2){
        [((GameWolf*)self.wolf).heartTwo removeFromSuperview];
        ((GameWolf*)self.wolf).heartCount--;
    }else if(((GameWolf*)self.wolf).heartCount==1){
        [((GameWolf*)self.wolf).heartOne removeFromSuperview];
        ((GameWolf*)self.wolf).heartCount--;
    };
    
    //lose the game
    if (((GameWolf*)self.wolf).heartCount == ZERO && !((GamePig*)self.pig).isDie) {
        ((GameWolf*)self.wolf).dieAnimation.frame = self.wolf.view.frame;
        [self.wolf.view removeFromSuperview];
        [((GameWolf*)self.wolf).dieAnimation startAnimating];
        [self.gamearea addSubview:((GameWolf*)self.wolf).dieAnimation];
        [self reset];
        [self performSelector:@selector(loseTheGame) withObject:nil afterDelay:GAMEOVER_DELAY];
    }
}

- (void)loseTheGame{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Oh dear T_T"
                                                  message:@"Lose the Game, try again!"
                                                 delegate:nil
                                        cancelButtonTitle:@"Okay"
                                        otherButtonTitles:nil];
    [alert show];
    [self gameOver];

}

- (void)addWolfAndWind{
    [self.gamearea addSubview:self.wolf.view];
    self.wind.delegate = self;
    
    [self.wind assignModel];
    
    //[self.gamearea addSubview:self.wind.view];
    [self.myWorld.objectsList addObject:self.wind.model];
    self.wind.model.velocity = [Vector2D vectorWith:INIT_VELOCITY * (1-self.powerIndex)*sin(self.arrowRotation) y:INIT_VELOCITY * (1-self.powerIndex)*cos(self.arrowRotation)];
}


- (void)setPowerBar{
    UIImage* powerBarImg = [UIImage imageNamed:@"breath-bar.png"];
    UIImageView* powerBar = [[UIImageView alloc]initWithImage:powerBarImg];
    powerBar.frame = CGRectMake(BAR_X, BAR_Y, BAR_W,BAR_H);
    powerBar.tag = BAR_TAG;
    //powerBar.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [powerBar setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBarTap:)];
    [singleTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleTap.delegate = self;
    
    [powerBar addGestureRecognizer:singleTap];
    [self.gamearea addSubview:powerBar];
    
}

- (void)handleBarTap:(UITapGestureRecognizer*)gesture{
    CGPoint location =[gesture locationInView:gesture.view];
    self.powerIndex = location.y/350;
    //remove subviews first
    for (UIView* view in gesture.view.subviews) {
        [view removeFromSuperview];
    }
    
    //add new indicator
    CGFloat width = BAR_W;
    CGFloat height = BAR_H - location.y;
    UIView* indicator = [[UIView alloc] init];
    
    indicator.frame = CGRectMake(ZERO, location.y, width, height);
    [indicator setBackgroundColor:[UIColor redColor]];
    [gesture.view addSubview:indicator];
}

- (void)setDegree{
    UIImage* degreeImg = [UIImage imageNamed:@"direction-degree.png"];
    UIImageView* degree = [[UIImageView alloc]initWithImage:degreeImg];
    degree.tag = DEGREE_TAG;
    degree.frame = CGRectMake(self.wolf.view.center.x + DEGREE_OFFX, self.wolf.view.center.y-DEGREE_OFFY, self.wolf.view.frame.size.width-DEGREE_OFFWIDTH,self.wolf.view.frame.size.height*DEGREE_OFFHEIGHT);
    [self.gamearea addSubview:degree];
}

- (void)setArrow{
    [self.wolf.view removeFromSuperview];
    [self.gamearea addSubview:self.wolf.view];
    UIImage* arrowImg = [UIImage imageNamed:DIRECTION_PNG];
    UIImageView* arrow = [[UIImageView alloc]initWithImage:arrowImg];
    arrow.tag = ARROW_TAG;
    arrow.frame = CGRectMake(self.wolf.view.center.x + ARROW_OFFX, self.wolf.view.center.y - ARROW_OFFY, arrowImg.size.width,arrowImg.size.height);
    //arrow.center = CGPointMake(arrow.center.x, arrow.center.y + arrowImg.size.height/2);
    arrow.layer.anchorPoint = CGPointMake(ANCHOR_X, ANCHOR_Y);
    arrow.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer* rotate = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateArrow:)];
    //rotate.delegate = self;
    [arrow addGestureRecognizer:rotate];
    [self.gamearea addSubview:arrow];
    [self.wolf.view removeFromSuperview];
    [self.gamearea addSubview:self.wolf.view];
}


- (void)rotateArrow:(UIPanGestureRecognizer *)gesture{
    // MODIFIES: object model (rotation)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is rotated with a two-finger rotation gesture
    
    BOOL userWantToIncreaseAngle = NO;
    BOOL userWantToDecreaseAngle = NO;
    
    CGFloat blowAngle = atan2(gesture.view.transform.b, gesture.view.transform.a);
    self.arrowRotation = blowAngle;
    
    CGFloat delta = ZERO ;
    
    CGPoint newPosition = [gesture translationInView:gesture.view.superview];
    
    
    if (newPosition.y > ZERO ) {
        userWantToIncreaseAngle = YES;
    }
    if (newPosition.y < ZERO ){
        userWantToDecreaseAngle = YES;
    }
    
    if (userWantToIncreaseAngle && blowAngle < M_PI) {
        
        if((blowAngle + ANGEL_OFF) < M_PI)
            delta = ANGEL_OFF;
        
    }
    
    if (userWantToDecreaseAngle && blowAngle > ZERO) {
        if((blowAngle - ANGEL_OFF) > ZERO)
            delta = -ANGEL_OFF;
    }
    
    
    
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform,delta);
    
    
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
    
    
}



-(void)save{
    // REQUIRES: game in designer mode
    // EFFECTS: game objects are saved

    NSArray* filesName = [self getFileList];
    self.saveSheet = [[UIActionSheet alloc] initWithTitle:_SAVE
                        
                                                   delegate:self
                        
                                          cancelButtonTitle:nil
                        
                                     destructiveButtonTitle:nil
                        
                                          otherButtonTitles:nil];

    for (NSString* name in filesName) {
    
        [self.saveSheet addButtonWithTitle: name];
    
    }

    [self.saveSheet addButtonWithTitle: NEW_SAVE];

    self.saveSheet.actionSheetStyle = UIActionSheetStyleAutomatic;

    [self.saveSheet showFromBarButtonItem: self.saveButton animated:YES];

}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //EFFECTS: go to different actions accoding to buttonIndex
    //REQUIRES: in design mode
    [self.myWorld.timer invalidate];
    self.myWorld.timer = nil;
    
    if (buttonIndex<0) {//not include the origin button
        return;
    }
    
    
    if (actionSheet == self.saveSheet) {
        [self createFileWithIndex:buttonIndex ];
    }
    if (actionSheet == self.loadSheet) {
        [self loadFileWithIndex:buttonIndex levelInfo:nil];
    }
    if (actionSheet == self.deleteSheet) {
        [self deleteFileWithIndex:buttonIndex];
    }
}

-(NSString*)getStringOfTransform:(CGAffineTransform)transform{
    //EFFECTS: return transform information in string format
    NSString* str = EMPTYSTRING;
    CGFloat a = transform.a;
    CGFloat b = transform.b;
    CGFloat c = transform.c;
    CGFloat d = transform.d;
    CGFloat tx = transform.tx;
    CGFloat ty = transform.ty;
    str = [str stringByAppendingFormat:@"{%lf,%lf,%lf,%lf,%lf,%lf}",a,b,c,d,tx,ty];
    return str;
}

-(void)load{
    // MODIFIES: self (game objects)
    // REQUIRES: game in designer mode
    // EFFECTS: game objects are loaded
    NSArray* filesName = [self getFileList];
    self.loadSheet = [[UIActionSheet alloc] initWithTitle:_LOAD
                      
                                                 delegate:self
                      
                                        cancelButtonTitle:nil
                      
                                   destructiveButtonTitle:nil
                      
                                        otherButtonTitles:nil];
    
    for (NSString* name in filesName) {
        
        [self.loadSheet addButtonWithTitle: name];
        
    }
    
    self.loadSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [self.loadSheet showFromBarButtonItem: self.loadButton animated:YES];

}

-(void)delete{
    //EFFECTS : delete pointed files
    //REQUIRES: in design mode
    NSArray* filesName = [self getFileList];
    self.deleteSheet = [[UIActionSheet alloc] initWithTitle:WARNING
                      
                                                 delegate:self
                      
                                        cancelButtonTitle:nil
                      
                                   destructiveButtonTitle:nil
                      
                                        otherButtonTitles:nil];
    
    
    for (NSString* name in filesName) {
        
        [self.deleteSheet addButtonWithTitle: name];
        
    }
    
    self.deleteSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [self.deleteSheet showFromBarButtonItem: self.deleteButton animated:YES];
}


- (NSArray*)getFileList{
    //EFFECTS: reture a list of files name in Documents path
    NSFileManager *filemgr;
    NSArray *filelist;
    
    filemgr =[NSFileManager defaultManager];
    NSString* documentDirectryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    filelist = [filemgr contentsOfDirectoryAtPath:documentDirectryPath error:nil];
    
    return filelist;
}

- (void)createFileWithIndex:(NSInteger)index{
    //MODIFY: saving files
    //EFFECTS: create the file accoring to point index on actionsheet
    //REQUIRES: in design mode
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* appendFileName = [DICTIONARY_NAME stringByAppendingFormat:@"%d",index];
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:appendFileName];
     NSLog(@"%@\n", fileName);
    //[NSString stringWithFormat:@"%@/dictionay",
    //documentsDirectory];
    NSArray* subviewsArray = [[NSArray alloc] initWithArray:self.gamearea.subviews];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    int appendkey = ZERO;
    NSString* empty = EMPTYSTRING;
    
    for (UIView* view in subviewsArray) {
        if (view.tag > ZERO && view.tag<= GameBlockStone) {
            NSNumber* tag = [[NSNumber alloc] initWithInt:view.tag];
            NSNumber* X = [[NSNumber alloc] initWithFloat:view.center.x];
            NSNumber* Y = [[NSNumber alloc] initWithFloat:view.center.y];
            NSString* transform = [self getStringOfTransform:view.transform];
            NSArray* object = [[NSArray alloc] initWithObjects:tag,X,Y,transform, nil];
            NSString* key = [empty stringByAppendingFormat:@"%d",appendkey];//set string as key
            appendkey++;
            [dictionary setObject:object forKey:key];
        }
    }
    
    if([dictionary writeToFile:fileName atomically:YES]==NO){//save dictionary to file and check
        NSLog(@"Save Failed");
    }
}

- (void)loadFileWithIndex:(NSInteger)index levelInfo:(NSString*)level{
    //EFFECTS: load the file accoring to point index on actionsheet
    //REQUIRES: in design mode
    NSString* fileName;
    if (level == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:ZERO];
    
        NSString* appendFileName = [DICTIONARY_NAME stringByAppendingFormat:@"%d",index];
        //make a file name to write the data to using the documents directory:
        fileName = [documentsDirectory stringByAppendingPathComponent:appendFileName];
    }else{
        NSBundle *mainBundle = [NSBundle mainBundle];
        fileName   = [mainBundle pathForResource:level
                                                    ofType:@"plist"];
    }
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    
    Boolean isWolfLoaded = NO;//is wolf loaded to gamearea
    Boolean isPigLoaded = NO;// is wolf loaded into gamearea
    //int numOfBlocks = [dictionary count];//worst case: assume all objects are blocks
    /*
    if (!self.isSavedInThisGame) {//verify whether need to make space for all blocks
        [self getSpace:numOfBlocks];
    }*/

    
    for(UIView* view in self.gamearea.subviews){
        if (view.tag>3) {
            [view removeFromSuperview];
        }
    }
    
    for (UIViewController* con in self.childViewControllers) {
        if (con.view.superview == self.gamearea) {
            [con removeFromParentViewController];
        }
    }

    
    for (NSString* key in [dictionary allKeys]) {
        NSArray* object = [dictionary objectForKey:key];
        //load tag,x,y and transform
        int tag = [(NSNumber*)[object objectAtIndex:0] intValue];
        CGFloat X = [(NSNumber*)[object objectAtIndex:1] floatValue];
        CGFloat Y = [(NSNumber*)[object objectAtIndex:2] floatValue];
        NSString* transformStr = [object objectAtIndex:3];
        CGAffineTransform transform = CGAffineTransformFromString(transformStr);
        
        if (tag == kGameObjectWolf) {//load wolf
            isWolfLoaded = YES;
            
            if (self.wolf.view.superview == self.topBar) {
                [self.gamearea addSubview:self.wolf.view];
            }
            self.wolf.view.transform = transform;
            self.wolf.view.center = CGPointMake(X, Y);
            [self.wolf.view setBounds:CGRectMake(ZERO, ZERO, self.wolf.realWidth, self.wolf.realHeight)];
        }
        
        if (tag == kGameObjectPig) {//load pig
            isPigLoaded = YES;
            
            if (self.pig.view.superview == self.topBar) {
                [self.gamearea addSubview:self.pig.view];
            }
            self.pig.view.transform = transform;
            self.pig.view.center = CGPointMake(X, Y);
            [self.pig.view setBounds:CGRectMake(ZERO, ZERO, self.pig.realWidth, self.pig.realHeight)];
            [self.pig assignModel];
        }
        
        
        if (tag >= kGameObjectBlock) {//load block
                        
            //[self.gamearea addSubview:self.block.view];
            //self.block = self.block.son;
            GameBlock* block = [[GameBlock alloc] init];
            block.delegate = self;
           
            block.view.transform = transform;
            block.view.center = CGPointMake(X, Y);
            
            int ntag = 4 + (tag-1)%4; //this formulat is to caculate the needed tag
            block.view.tag = ntag;
            [GameBlock changeTexture:block.view];
            
            block.view.bounds = CGRectMake(ZERO, ZERO, block.realWidth, block.realHeight);
             [block assignModel];
            [[block.delegate getGameArea] addSubview:block.view];
            [block.delegate setGestures:block];
        }
        
        
    }
    
    if (!isWolfLoaded) {
        [self.wolf.view removeFromSuperview];
        self.wolf = [[GameWolf alloc] init];
        [self.wolf assignModel];
        self.wolf.delegate = self;
        [self.wolf.delegate setGestures:self.wolf];
        [[self.wolf.delegate getTopBar] addSubview:self.wolf.view];
    }
    
    if (!isPigLoaded) {
        [self.pig.view removeFromSuperview];
        self.pig = [[GamePig alloc] init];
        [self.pig assignModel];
        self.pig.delegate = self;
        [self.pig.delegate setGestures:self.pig];
        [[self.pig.delegate getTopBar] addSubview:self.pig.view];
    }
}

-(void)deleteFileWithIndex:(NSInteger)index{
    //MODIFY: saving files
    //EFFECTS: delete the file accoring to point index on actionsheet
    //REQUIRES: in design mode

    NSFileManager* fManager =[NSFileManager defaultManager];
    
    NSArray* filesName = [self getFileList];
    int count = [filesName count];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:ZERO];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:DICTIONARY_NAME];
    
    NSString* str = [path stringByAppendingFormat:@"%d", index];
    
    if ([fManager removeItemAtPath:str error:nil] == NO){
        NSLog(@"Unable to delete file.");
    }
    
    if (index == count) {//no need to move any file
        return;
    }
    
    for(int i = index+1;i <= count;i++){
      
        NSString* oldName = [path stringByAppendingFormat: @"%d",i];
        NSLog(@"%@", oldName);
        NSString* newName = [path stringByAppendingFormat: @"%d",i-1];
        if ([fManager moveItemAtPath:oldName toPath:newName error:nil] != YES){
            NSLog(@"DELETE FAIL!");
        };
    }

}

@end