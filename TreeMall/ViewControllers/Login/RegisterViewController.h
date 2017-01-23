//
//  RegisterViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UITextField *textFieldEmail;
@property (nonatomic, strong) IBOutlet UITextField *textFieldPhone;
@property (nonatomic, strong) IBOutlet UILabel *labelPhone;
@property (nonatomic, strong) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, strong) IBOutlet UITextField *textFieldConfirm;
@property (nonatomic, strong) IBOutlet UIButton *buttonNext;

@property (nonatomic, strong) NSMutableDictionary *dictionaryRegister;

@end
