//
//  ViewController.m
//  scrollview
//
//  Created by Hehuimin on 2018/4/19.
//  Copyright © 2018年 haoshiqi. All rights reserved.
//

#import "ViewController.h"
#import "HMScrollView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *data = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]];
    HMScrollView *scrollView = [[HMScrollView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 160)];
    [scrollView setupUI:data delegate:self];
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

