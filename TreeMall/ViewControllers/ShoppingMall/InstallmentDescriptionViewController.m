//
//  InstallmentDescriptionViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "InstallmentDescriptionViewController.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "LocalizedString.h"

@interface InstallmentDescriptionViewController ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

- (void)retrieveData;
- (BOOL)processData:(NSData *)data;
- (void)buttonLinkPressed:(id)sender;
- (void)buttonClosePressed:(id)sender;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation InstallmentDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.labelInstallmentTitle];
    for (UILabel *label in self.arrayLabels)
    {
        [self.scrollView addSubview:label];
    }
    [self.scrollView addSubview:self.labelCreditCardHint];
    [self.scrollView addSubview:self.separator];
    [self.scrollView addSubview:self.labelBankTitle];
    [self.scrollView addSubview:self.labelDescription];
    
    [self.view addSubview:self.buttonClose];
    
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
    CGFloat intervalV = 10.0;
    CGFloat originY = 0.0;
    
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
    
    if (self.labelInstallmentTitle)
    {
        CGSize sizeString = [self.labelInstallmentTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelInstallmentTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeString.width), ceil(sizeString.height));
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, sizeLabel.height);
        self.labelInstallmentTitle.frame = frame;
        originY = self.labelInstallmentTitle.frame.origin.y + self.labelInstallmentTitle.frame.size.height + intervalV;
    }
    
    for (UILabel *label in self.arrayLabels)
    {
        CGSize sizeString = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeString.width), ceil(sizeString.height));
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, sizeLabel.height);
        label.frame = frame;
        originY = label.frame.origin.y + label.frame.size.height + intervalV;
    }
    if (self.labelCreditCardHint)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelCreditCardHint.font, NSFontAttributeName, nil];
        CGSize sizeString = [self.labelCreditCardHint.text boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeString.width), ceil(sizeString.height));
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, sizeLabel.height);
        self.labelCreditCardHint.frame = frame;
        originY = self.labelCreditCardHint.frame.origin.y + self.labelCreditCardHint.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 1.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    
    if (self.labelBankTitle)
    {
        CGSize sizeString = [self.labelBankTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelBankTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeString.width), ceil(sizeString.height));
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, sizeLabel.height);
        self.labelBankTitle.frame = frame;
        originY = self.labelBankTitle.frame.origin.y + self.labelBankTitle.frame.size.height + intervalV;
    }
    
    if (self.labelDescription && [self.labelDescription isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width;
        CGSize size = [self.labelDescription suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(0.0, originY, maxWidth, ceil(size.height));
        self.labelDescription.frame = frame;
        originY = self.labelDescription.frame.origin.y + self.labelDescription.frame.size.height + intervalV;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

- (DTAttributedLabel *)labelDescription
{
    if (_labelDescription == nil)
    {
        if (_labelDescription == nil)
        {
            _labelDescription = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
            _labelDescription.layoutFrameHeightIsConstrainedByBounds = NO;
            _labelDescription.shouldDrawLinks = YES;
            _labelDescription.shouldDrawImages = YES;
            _labelDescription.delegate = self;
            _labelDescription.backgroundColor = [UIColor clearColor];
        }
    }
    return _labelDescription;
}

- (UILabel *)labelInstallmentTitle
{
    if (_labelInstallmentTitle == nil)
    {
        _labelInstallmentTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelInstallmentTitle setFont:font];
        [_labelInstallmentTitle setTextColor:[UIColor colorWithRed:(100.0/255.0) green:(170.0/255.0) blue:(80.0/255.0) alpha:1.0]];
        [_labelInstallmentTitle setBackgroundColor:[UIColor clearColor]];
        [_labelInstallmentTitle setText:[LocalizedString NoInterestInstallment]];
    }
    return _labelInstallmentTitle;
}

- (UILabel *)labelCreditCardHint
{
    if (_labelCreditCardHint == nil)
    {
        _labelCreditCardHint = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelCreditCardHint setFont:font];
        [_labelCreditCardHint setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelCreditCardHint setNumberOfLines:0];
        [_labelCreditCardHint setTextColor:[UIColor blackColor]];
        [_labelCreditCardHint setText:[LocalizedString CreditCardHint]];
    }
    return _labelCreditCardHint;
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

- (UILabel *)labelBankTitle
{
    if (_labelBankTitle == nil)
    {
        _labelBankTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelBankTitle setFont:font];
        [_labelBankTitle setTextColor:[UIColor colorWithRed:(100.0/255.0) green:(170.0/255.0) blue:(80.0/255.0) alpha:1.0]];
        [_labelBankTitle setBackgroundColor:[UIColor clearColor]];
        [_labelBankTitle setText:[LocalizedString InstallmentAvailableBank]];
    }
    return _labelBankTitle;
}

- (NSMutableArray *)arrayLabels
{
    if (_arrayLabels == nil)
    {
        _arrayLabels = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayLabels;
}

- (void)setArrayInstallment:(NSArray *)arrayInstallment
{
    _arrayInstallment = arrayInstallment;
    if (_arrayInstallment == nil)
    {
        for (UILabel *label in self.arrayLabels)
        {
            if (label.superview != nil)
            {
                [label removeFromSuperview];
            }
        }
        [self.arrayLabels removeAllObjects];
        return;
    }
    for (NSDictionary *dictionary in _arrayInstallment)
    {
        NSNumber *term = [dictionary objectForKey:SymphoxAPIParam_term];
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price];
        NSString *cathayOnly = [dictionary objectForKey:SymphoxAPIParam_cathay_only];
        if ((price == nil || [price isEqual:[NSNull null]]) || (term == nil || [term isEqual:[NSNull null]]))
        {
            continue;
        }
        NSString *priceString = [self.formatter stringFromNumber:price];
        if (priceString == nil)
            continue;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
        [attrString appendString:[LocalizedString Dollars]];
        
        NSString *stringTerm = [NSString stringWithFormat:@" Ｘ%li%@", (long)[term integerValue], [LocalizedString InstallmentTerm]];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:stringTerm attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil]]];
        
        if ([cathayOnly boolValue])
        {
            NSString *string = [LocalizedString CathayCardOnly];
            [attrString appendString:@" "];
            NSAttributedString *cathay = [[NSAttributedString alloc] initWithString:string attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
            [attrString appendAttributedString:cathay];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [label setFont:font];
        [label setAttributedText:attrString];
        [self.arrayLabels addObject:label];
    }
}

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _formatter;
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
    __weak InstallmentDescriptionViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, @"2", SymphoxAPIParam_type, nil];
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
                            self.labelDescription.attributedString = attrString;
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
