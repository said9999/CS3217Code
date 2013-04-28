//
//  ViewController.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //create models
    World* myWorld = [[World alloc] init];
    
    RectangleViewController* rect = [[RectangleViewController alloc] initWithX:100 Y:700 Width:250 Height:80 Mass:200 Type:actor Color:RED];
    
    RectangleViewController* rect2 = [[RectangleViewController alloc] initWithX:10 Y:100 Width:200 Height:30 Mass:20 Type:actor Color: BLUE];
    RectangleViewController* rect3 = [[RectangleViewController alloc] initWithX:300 Y:300 Width:100 Height:120 Mass:20 Type:actor Color: GREEN];
    RectangleViewController* rect4 = [[RectangleViewController alloc] initWithX:200 Y:100 Width:100 Height:400 Mass:200 Type:actor Color: BLACK];
    RectangleViewController* rect5 = [[RectangleViewController alloc] initWithX:600 Y:10 Width:150 Height:150 Mass:20 Type:actor Color: YELLOW];
    RectangleViewController* rect6 = [[RectangleViewController alloc] initWithX:600 Y:200 Width:80 Height:500 Mass:20 Type:actor Color: GRAY];
    
    
    
    RectangleViewController* top = [[RectangleViewController alloc] initWithX:10 Y:-110 Width:800 Height:120 Mass:INT_MAX Type:bound Color:GRAY];
    RectangleViewController* buttom = [[RectangleViewController alloc] initWithX:-10 Y:1000 Width:1200 Height:1000 Mass:INFINITY Type:bound Color:GRAY];
    RectangleViewController* left = [[RectangleViewController alloc] initWithX:-100 Y:0 Width:110 Height:1024 Mass:INT_MAX Type:bound Color:GRAY];
    RectangleViewController* right = [[RectangleViewController alloc] initWithX:760 Y:0 Width:110 Height:1024 Mass:INT_MAX Type:bound Color:GRAY];
    //add model
    [myWorld.objectsList addObject:rect.model];
    [myWorld.objectsList addObject:buttom.model];
    
    [myWorld.objectsList addObject:top.model];
    [myWorld.objectsList addObject:right.model];
    [myWorld.objectsList addObject:left.model];
    [myWorld.objectsList addObject:rect2.model];
    [myWorld.objectsList addObject:rect3.model];
    [myWorld.objectsList addObject:rect4.model];
    [myWorld.objectsList addObject:rect5.model];
    [myWorld.objectsList addObject:rect6.model];
    //add views here

    [self.view addSubview:rect.view];
    [self.view addSubview:buttom.view];
    
    [self.view addSubview:top.view];
    [self.view addSubview:right.view];
    [self.view addSubview:left.view];
    [self.view addSubview:rect2.view];
    [self.view addSubview:rect3.view];
    [self.view addSubview:rect4.view];
    [self.view addSubview:rect5.view];
    [self.view addSubview:rect6.view];
     //start simulating
    [myWorld run];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
