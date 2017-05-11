//
//  ExchangeDescriptionViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ExchangeDescriptionViewController.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "LocalizedString.h"

@interface ExchangeDescriptionViewController ()

- (void)retrieveData;
- (BOOL)processData:(NSData *)data;
- (void)buttonLinkPressed:(id)sender;
- (void)buttonClosePressed:(id)sender;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation ExchangeDescriptionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _type = DescriptionViewTypeExchange;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.label];
    if (self.navigationController == nil)
    {
        [self.view addSubview:self.buttonClose];
    }
    [self retrieveData];
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
    
    CGFloat marginH = 20.0;
    CGFloat marginV = 20.0;
    
    if (self.buttonClose)
    {
        CGSize size = CGSizeMake(40.0, 40.0);
        CGRect frame = CGRectMake(self.view.frame.size.width - size.width, 0.0, size.width, size.height);
        self.buttonClose.frame = frame;
    }
    
    if (self.scrollView)
    {
        CGFloat originY = CGRectGetMaxY(self.buttonClose.frame);
        self.scrollView.frame = CGRectMake(marginH, originY, self.view.frame.size.width - marginH * 2, self.view.frame.size.height - marginV - originY);
    }
    
    if (self.label && [self.label isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width;
        CGSize size = [self.label suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(0.0, 0.0, maxWidth, ceil(size.height));
        self.label.frame = frame;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.label.frame.size.height)];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

- (DTAttributedLabel *)label
{
    if (_label == nil)
    {
        if (_label == nil)
        {
            _label = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
            _label.layoutFrameHeightIsConstrainedByBounds = NO;
            _label.shouldDrawLinks = YES;
            _label.shouldDrawImages = YES;
            _label.delegate = self;
            _label.backgroundColor = [UIColor clearColor];
        }
    }
    return _label;
}

- (UIButton *)buttonClose
{
    if (_buttonClose == nil)
    {
        _buttonClose = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonClose setBackgroundColor:[UIColor clearColor]];
        UIImage *image = [UIImage imageNamed:@"car_popup_close"];
        if (image)
        {
            [_buttonClose setImage:image forState:UIControlStateNormal];
        }
        [_buttonClose addTarget:self action:@selector(buttonClosePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonClose;
}

#pragma mark - Private Methods

- (void)retrieveData
{
    NSString *type = nil;
    switch (self.type) {
        case DescriptionViewTypeEcommercial:
        {
            type = @"4";
        }
            break;
        default:
        {
            type = @"1";
        }
            break;
    }
    __weak ExchangeDescriptionViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, type, SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveData - string:\n%@", string);
            if ([self processData:resultObject])
            {
                [self.view setNeedsLayout];
            }
        }
        else
        {
            NSLog(@"error:\n%@", error);
        }
        
    }];
}

- (BOOL)processData:(NSData *)data
{
    BOOL success = NO;
    if ([data isKindOfClass:[NSData class]])
    {
        NSData *sourceData = (NSData *)data;
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:sourceData options:0 error:&error];
        if (error == nil && jsonObject)
        {
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)jsonObject;
                NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
                if (result && [result integerValue] == 0)
                {
                    NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
                    if (content && [content isEqual:[NSNull null]] == NO && [content length] > 0)
                    {
                        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                        if (attrString)
                        {
                            self.label.attributedString = attrString;
                            success = YES;
                        }
                    }
                }
            }
        }
    }
    return success;
}

#pragma mark - Actions

- (void)buttonLinkPressed:(id)sender
{
    if ([sender isKindOfClass:[DTLinkButton class]] == NO)
        return;
    DTLinkButton *buttonLink = (DTLinkButton *)sender;
    NSURL *url = buttonLink.URL;
    if (url == nil)
        return;
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)buttonClosePressed:(id)sender
{
    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gestureRecognizer view];
        button.highlighted = NO;
        
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionOpenInSafari = [UIAlertAction actionWithTitle:[LocalizedString OpenInSafari] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:button.URL];
            }];
            UIAlertAction *actionCopyLink = [UIAlertAction actionWithTitle:[LocalizedString CopyLink] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSString *urlString = [button.URL absoluteString];
                if (urlString)
                {
                    [[UIPasteboard generalPasteboard] setString:[button.URL absoluteString]];
                }
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:actionOpenInSafari];
            [alertController addAction:actionCopyLink];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(buttonLinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

@end
