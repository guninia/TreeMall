//
//  TermsViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>

@interface TermsViewController : UIViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIView *separator;
@property (nonatomic, strong) DTAttributedTextView *textViewTerms;

@end
