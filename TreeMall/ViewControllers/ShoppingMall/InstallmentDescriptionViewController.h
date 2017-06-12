//
//  InstallmentDescriptionViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>

@interface InstallmentDescriptionViewController : UIViewController <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelInstallmentTitle;
@property (nonatomic, strong) UILabel *labelCreditCardHint;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UILabel *labelBankTitle;
@property (nonatomic, strong) DTAttributedLabel *labelDescription;
@property (nonatomic, strong) NSMutableArray *arrayLabels;
@property (nonatomic, strong) NSArray *arrayInstallment;

@property (nonatomic, strong) UIButton *buttonClose;

@end
