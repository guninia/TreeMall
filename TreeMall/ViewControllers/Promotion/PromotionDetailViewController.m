//
//  PromotionDetailViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/27.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "LocalizedString.h"
#import "APIDefinition.h"
#import <UIImageView+WebCache.h>
#import "WebViewViewController.h"

@interface PromotionDetailViewController ()

- (void)buttonActionPressed:(id)sender;

@end

@implementation PromotionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.labelTitle];
    [self.scrollView addSubview:self.buttonAction];
    [self.scrollView addSubview:self.separator];
    [self.scrollView addSubview:self.labelContent];
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

#pragma mark - Override

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat marginV = 10.0;
    CGFloat marginH = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = marginV;
    
    if (self.scrollView)
    {
        self.scrollView.frame = self.view.bounds;
    }
    
    CGFloat maxWidth = self.scrollView.frame.size.width - marginH * 2;
    
    if (self.imageView && [self.imageView isHidden] == NO)
    {
        CGRect frame = CGRectMake(marginH, originY, maxWidth, ceil(maxWidth * 480 / 888));
        self.imageView.frame = frame;
        originY = self.imageView.frame.origin.y + self.imageView.frame.size.height + intervalV;
    }
    if (self.labelTitle && [self.labelTitle isHidden] == NO)
    {
        CGSize sizeText = [self.labelTitle.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil] context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, maxWidth, sizeLabel.height);
        self.labelTitle.frame = frame;
        originY = self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height + intervalV;
    }
    if (self.buttonAction && [self.buttonAction isHidden] == NO)
    {
        CGRect frame = CGRectMake(marginH, originY, maxWidth, 40.0);
        self.buttonAction.frame = frame;
        originY = self.buttonAction.frame.origin.y + self.buttonAction.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(marginH, originY, maxWidth, 1.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelContent && [self.labelContent isHidden] == NO)
    {
        CGSize sizeText = [self.labelContent.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelContent.font, NSFontAttributeName, nil] context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, maxWidth, sizeLabel.height);
        self.labelContent.frame = frame;
        originY = self.labelContent.frame.origin.y + self.labelContent.frame.size.height + marginV;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelTitle setFont:font];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setNumberOfLines:0];
        [_labelTitle setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return _labelTitle;
}

- (UIButton *)buttonAction
{
    if (_buttonAction == nil)
    {
        _buttonAction = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAction setBackgroundColor:[UIColor orangeColor]];
        [_buttonAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonAction setTitle:[LocalizedString ActionLink] forState:UIControlStateNormal];
        [_buttonAction.layer setCornerRadius:5.0];
        [_buttonAction addTarget:self action:@selector(buttonActionPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAction;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _separator;
}

- (UILabel *)labelContent
{
    if (_labelContent == nil)
    {
        _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelContent setFont:font];
        [_labelContent setBackgroundColor:[UIColor clearColor]];
        [_labelContent setTextColor:[UIColor grayColor]];
        [_labelContent setNumberOfLines:0];
        [_labelContent setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return _labelContent;
}

- (void)setDictionaryData:(NSDictionary *)dictionaryData
{
    _dictionaryData = dictionaryData;
    NSString *img = [dictionaryData objectForKey:SymphoxAPIParam_img];
    if (img && [img length] > 0)
    {
        UIImage *placeholder = [UIImage imageNamed:@"transparent"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:placeholder options:SDWebImageAllowInvalidSSLCertificates];
    }
    else
    {
        self.imageView.hidden = YES;
    }
    NSString *name = [dictionaryData objectForKey:SymphoxAPIParam_name];
    if (name && [name length] > 0)
    {
        self.labelTitle.text = name;
    }
    else
    {
        self.labelTitle.hidden = YES;
    }
    NSString *link = [dictionaryData objectForKey:SymphoxAPIParam_link];
    if (link && [link length] > 0)
    {
        self.buttonAction.hidden = NO;
    }
    else
    {
        self.buttonAction.hidden = YES;
    }
    NSString *content = [dictionaryData objectForKey:SymphoxAPIParam_content];
    if (content && [content length] > 0)
    {
        self.labelContent.text = content;
    }
    else
    {
        self.labelContent.hidden = YES;
    }
    [self.view setNeedsLayout];
}

#pragma mark - Actions

- (void)buttonActionPressed:(id)sender
{
    NSString *link = [self.dictionaryData objectForKey:SymphoxAPIParam_link];
    NSLog(@"self.dictionaryData[%p] - link[%@]", self.dictionaryData, link);
    if (link && [link length] > 0)
    {
//        WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
//        viewController.urlString = link;
//        [self.navigationController pushViewController:viewController animated:YES];
        NSURL *url = [NSURL URLWithString:link];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
