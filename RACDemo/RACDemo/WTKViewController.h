//
//  WTKViewController.h
//  RACDemo
//
//  Created by 王同科 on 16/8/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface WTKViewController : UIViewController

@property(nonatomic,strong)RACSubject *delegateSubject;


@end
