//
//  ViewController.m
//  scrollview
//
//  Created by Hehuimin on 2018/4/19.
//  Copyright © 2018年 haoshiqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, copy) NSArray *cells;
@property (nonatomic, assign) CGFloat sizeScall;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cells = @[@1, @2, @3,@1, @2, @3,@1, @2, @3,@1];
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame)-30,200)];
    self.scrollview.contentSize = CGSizeMake((CGRectGetWidth(self.view.frame) -30)* self.cells.count, 40);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.clipsToBounds = NO;
    self.scrollview.bounces = NO;
    [self.view addSubview:self.scrollview];
    
    _sizeScall = 0.6;
    
    for (int i = 0; i < self.cells.count; i++) {
        CGFloat width = CGRectGetWidth(self.view.frame) - 40;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * (width + 10), 0, width, 200)];
        view.backgroundColor = [UIColor redColor];
        view.tag = i + 10;
        [self.scrollview addSubview:view];
        if (i > 0) {
            view.transform = CGAffineTransformMakeScale(1, _sizeScall);
            CGRect frame = view.frame;
            frame.origin.y = 0;
            view.frame = frame;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale > 9) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    NSLog(@"------------%f", scale);
    
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    CGFloat transScale = (1- _sizeScall);
    
    CGFloat leftTransScale  = leftScale * transScale;
    CGFloat rightTransScale = rightScale * transScale;

    UIView *view1 = (UIView *)[self.view viewWithTag:leftIndex + 10];
    UIView *view2 = (UIView *)[self.view viewWithTag:rightIndex + 10];
    
    view1.transform = CGAffineTransformMakeScale(1, _sizeScall + leftTransScale);
    view2.transform = CGAffineTransformMakeScale(1, _sizeScall + rightTransScale);
    
    CGRect frame1 = view1.frame;
    CGRect frame2 = view2.frame;
    frame1.origin.y = 0;
    frame2.origin.y = 0;
    view1.frame = frame1;
    view2.frame = frame2;
}

@end

