//
//  HMScrollView.m
//  ScrollView
//
//  Created by Hehuimin on 2018/5/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HMScrollView.h"

#define kScrollViewWidth ([UIScreen mainScreen].bounds.size.width <= 320 ? 270 : 310)
static const CGFloat kScrollViewHeight = 130;

@interface HMScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, assign) CGFloat sizeScale;
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UILabel *labelNumber;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation HMScrollView

- (void)setupUI:(NSArray *)data delegate:(id)delegate
{
    self.data = data;
    self.sizeScale = 0.8;
    [self addSubview:self.viewBg];
    
    if (self.data.count == 1) {
        [self.viewBg addSubview:self.scrollview];
        CGFloat marginX = (CGRectGetWidth(self.viewBg.frame) - kScrollViewWidth) / 2;
        CGFloat margin_viewBg_x = CGRectGetMinX(self.viewBg.frame) / 2;
        self.scrollview.frame = CGRectMake(marginX - margin_viewBg_x, (CGRectGetHeight(self.frame) - kScrollViewHeight) / 2, kScrollViewWidth , kScrollViewHeight);
        [self oneCard:delegate];
    }else {
        [self.viewBg addSubview:self.scrollview];
        [self.viewBg addSubview:self.labelNumber];
        [self setupConstraints];
        
        for (int i = 0; i < self.data.count; i++) {
            CGFloat width = kScrollViewWidth - 10;
            UIView *view = (UIView *)[self.scrollview viewWithTag:i + 10];
            if (!view) {
                view = [[UIView alloc] init];
            }
            view.backgroundColor = self.data[i];
            view.tag = i + 10;
            view.frame = CGRectMake(i * (width + 10), 0, width, kScrollViewHeight);
            
            [self.scrollview addSubview:view];
            if (i > 0) {
                view.transform = CGAffineTransformMakeScale(1, self.sizeScale);
                CGRect frame = view.frame;
                frame.origin.y = 0;
                view.frame = frame;
            }
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTagGesture:)];
            [view addGestureRecognizer:tapGesture];
        }
    }
}

- (void)oneCard:(id)delegate
{
    UIView *view = [[UIView alloc] init];
    view.tag = 10;
    [self.scrollview addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.scrollview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScrollViewWidth - 10]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScrollViewHeight]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTagGesture:)];
    [view addGestureRecognizer:tapGesture];
}

- (UIView *)viewBg
{
    if (!_viewBg) {
        _viewBg = [[UIView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15, CGRectGetHeight(self.frame))];
        _viewBg.clipsToBounds = YES;
    }
    return _viewBg;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(2, (CGRectGetHeight(self.frame) - kScrollViewHeight) / 2, kScrollViewWidth , kScrollViewHeight)];
        _scrollview.contentSize = CGSizeMake(kScrollViewWidth * self.data.count, CGRectGetHeight(_scrollview.frame));
        _scrollview.pagingEnabled = YES;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.clipsToBounds = NO;
        _scrollview.bounces = NO;
        _scrollview.delegate = self;
    }
    return _scrollview;
}

- (UILabel *)labelNumber
{
    if (!_labelNumber) {
        _labelNumber = [[UILabel alloc] init];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelNumber.textColor = [UIColor blackColor];
        _labelNumber.attributedText = [self numerAttributedString:@"1"];

    }
    return _labelNumber;
}

- (NSAttributedString *)numerAttributedString:(NSString *)num {
    NSString *string = [NSString stringWithFormat:@"/%ld", self.data.count];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", num, string]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, num.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, num.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(num.length, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(num.length, string.length)];
    return attributedString;
}

- (void)setupConstraints
{
    self.labelNumber.translatesAutoresizingMaskIntoConstraints = NO;
    
    // labelNumber
    [self.viewBg addConstraint:[NSLayoutConstraint
                                constraintWithItem:self.viewBg
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.labelNumber
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:11]];
    [self.viewBg addConstraint:[NSLayoutConstraint
                                constraintWithItem:self.viewBg
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.labelNumber
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:13]];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale > self.data.count) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    CGFloat transScale = (1- self.sizeScale);
    
    CGFloat leftTransScale  = leftScale * transScale;
    CGFloat rightTransScale = rightScale * transScale;
    
    UIView *view1 = (UIView *)[self viewWithTag:leftIndex + 10];
    UIView *view2 = (UIView *)[self viewWithTag:rightIndex + 10];
    
    view1.transform = CGAffineTransformMakeScale(1, self.sizeScale + leftTransScale);
    view2.transform = CGAffineTransformMakeScale(1, self.sizeScale + rightTransScale);
    
    CGRect frame1 = view1.frame;
    CGRect frame2 = view2.frame;
    frame1.origin.y = 0;
    frame2.origin.y = 0;
    view1.frame = frame1;
    view2.frame = frame2;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.labelNumber.attributedText = [self numerAttributedString:@(index + 1).description];
}

#pragma mark - UITapGestureRecognizer

- (void)onTagGesture:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"%ld", tapGesture.view.tag - 10);
}

// 把右边view的事件传递给下一个scrollview
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event ];
    if (hitView == self.viewBg) {
        return self.scrollview;
    }else {
        return hitView;
    }
}

@end
