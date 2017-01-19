//
//  ForgetPasswordViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UITextField *textFieldAccount;
@property (nonatomic, strong) IBOutlet UITextField *textFieldPhone;
@property (nonatomic, strong) IBOutlet UILabel *labelDescription;
@property (nonatomic, strong) IBOutlet UIButton *buttonConfirm;

@end
