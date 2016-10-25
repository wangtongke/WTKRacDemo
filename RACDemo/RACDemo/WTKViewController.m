//
//  WTKViewController.m
//  RACDemo
//
//  Created by 王同科 on 16/8/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKViewController.h"

@interface WTKViewController ()

@end

@implementation WTKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegateSubject    = [RACSubject subject];
}
- (IBAction)CLICK:(id)sender {
    
//    通知上一个控制器，
    
    if(self.delegateSubject){
        [self.delegateSubject sendNext:@"传值"];
    }
        
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
