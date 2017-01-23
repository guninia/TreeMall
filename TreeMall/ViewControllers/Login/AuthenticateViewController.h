//
//  AuthenticateViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticateViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDescription;
@property (nonatomic, strong) IBOutlet UIButton *buttonAuthenticate;
@property (nonatomic, strong) IBOutlet UIButton *buttonClose;
@property (nonatomic, strong) NSString *textDescription;
@property (nonatomic, strong) NSString *textContent;

@end
