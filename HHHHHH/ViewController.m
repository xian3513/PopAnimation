//
//  ViewController.m
//  HHHHHH
//
//  Created by kt on 15/5/11.
//  Copyright (c) 2015年 kt. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
@interface ViewController ()
@property (nonatomic,strong) CALayer *popLayer;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIView *showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self accessPopLayer];
//    [self performSelector:@selector(removePopAnimation) withObject:nil afterDelay:1.5];
    
    //[self decayButton];
    //[self performSelector:@selector(springView) withObject:nil afterDelay:2];
    
    //[self test];
    [self performSelector:@selector(test) withObject:nil afterDelay:1];
}

- (void)test {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.showView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.showView.backgroundColor = [UIColor cyanColor];
   // self.showView.center = self.view.center;
    [self.view addSubview:self.showView];
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(250, 10)];
    springAnimation.springBounciness = 25;
    //springAnimation.springSpeed = 20;
    [self.showView pop_addAnimation:springAnimation forKey:@"center"];
}

- (void)springView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.showView.backgroundColor = [UIColor cyanColor];
    self.showView.center = self.view.center;
    [self.view addSubview:self.showView];
    
    //尺寸动画
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    sizeAnimation.springSpeed         = 0.f;
    sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
    [self.showView pop_addAnimation:sizeAnimation forKey:nil];
}

- (void)decayButton {
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.button.backgroundColor = [UIColor redColor];
    self.button.layer.cornerRadius = 50;
    self.button.layer.masksToBounds = YES;
    self.button.center = self.view.center;
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.button addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.view];
    panGesture.view.center = CGPointMake(panGesture.view.center.x+translation.x, panGesture.view.center.y+translation.y);
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(panGesture.state == UIGestureRecognizerStateEnded) {
        //获取当前加速度
        CGPoint velocity = [panGesture velocityInView:self.view];
        NSLog(@"%@",NSStringFromCGPoint(velocity));
        //初始化POP的decay（衰减）动画
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];//计算位移
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [panGesture.view.layer pop_addAnimation:decayAnimation forKey:nil];
    }
}

- (void)buttonEvent:(UIButton *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)accessPopLayer {
    self.popLayer = [CALayer layer];
    self.popLayer.frame = CGRectMake(100, 100, 100, 100);
    self.popLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.popLayer];
    POPBasicAnimation *popAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    popAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 400)];
    popAnimation.duration = 4.0f;
    popAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.popLayer pop_addAnimation:popAnimation forKey:nil];
}

- (void)removePopAnimation {
    [self.popLayer pop_removeAllAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
