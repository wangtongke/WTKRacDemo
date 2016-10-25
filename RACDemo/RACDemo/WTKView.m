//
//  WTKView.m
//  RACDemo
//
//  Created by 王同科 on 16/8/30.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@implementation WTKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor    = [UIColor redColor];
        UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame               = CGRectMake(20, 30, 80, 30);
        btn.backgroundColor     = [UIColor blueColor];
        btn.tag = 100;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
//    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//        
//        
//        
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            
//            [subscriber sendNext:@"123"];
//            
//            return [RACDisposable disposableWithBlock:^{
//                
//            }];
//        }];
//    }];
//    btn.rac_command = command;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
