//
//  CompleteOrderViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/15.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CompleteOrderViewController.h"
#import "LocalizedString.h"
#import "CompleteOrderContentTableViewCell.h"
#import "SingleLabelHeaderView.h"
#import "Definition.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"

typedef enum : NSUInteger {
    SectionIndexDiscount,
    SectionIndexPayment,
    SectionIndexReceiver,
    SectionIndexTotal
} SectionIndex;

@interface CompleteOrderViewController ()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSMutableArray *arrayATM;

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)prepareData;
- (void)retrieveOrderDescription;
- (void)processOrderDescriptionData:(id)data;
- (void)refreshContent;

- (void)buttonConfirmPressed:(id)sender;
- (void)buttonLinkPressed:(id)sender;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation CompleteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.viewLabelBackground.layer setBorderWidth:1.0];
    [self.viewLabelBackground.layer setBorderColor:TMMainColor.CGColor];
    [self.labelTotalItem setTextColor:TMMainColor];
    
    [self.scrollView addSubview:self.viewOrderId];
    [self.scrollView addSubview:self.viewCash];
    [self.scrollView addSubview:self.viewEPoint];
    [self.scrollView addSubview:self.viewPoint];
    [self.scrollView addSubview:self.separator];
    [self.scrollView addSubview:self.labelOrderDescription];
    [self.scrollView addSubview:self.tableViewOrderContent];
    [self.scrollView addSubview:self.buttonConfirm];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
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
    
    CGFloat marginH = 8.0;
    CGFloat marginV = 8.0;
    CGFloat intervalV = 10.0;
    
    CGFloat originY = CGRectGetMaxY(self.viewLabelBackground.frame) + intervalV;
    
    CGFloat columnHeight = 40.0;
    CGFloat columnWidth = self.scrollView.frame.size.width - marginH * 2;
    if (self.viewOrderId)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewOrderId.frame = frame;
        originY = self.viewOrderId.frame.origin.y + self.viewOrderId.frame.size.height + intervalV;
    }
    if (self.viewCash)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewCash.frame = frame;
        originY = self.viewCash.frame.origin.y + self.viewCash.frame.size.height + intervalV;
    }
    if (self.viewEPoint)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewEPoint.frame = frame;
        originY = self.viewEPoint.frame.origin.y + self.viewEPoint.frame.size.height + intervalV;
    }
    if (self.viewPoint)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewPoint.frame = frame;
        originY = self.viewPoint.frame.origin.y + self.viewPoint.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 5.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelOrderDescription)
    {
        CGSize size = [self.labelOrderDescription suggestedFrameSizeToFitEntireStringConstraintedToWidth:columnWidth];
        CGRect frame = CGRectMake(0.0, 0.0, columnWidth, ceil(size.height));
        self.labelOrderDescription.frame = frame;
        originY = self.labelOrderDescription.frame.origin.y + self.labelOrderDescription.frame.size.height + intervalV;
    }
    if (self.tableViewOrderContent)
    {
        NSInteger totalSections = [self numberOfSectionsInTableView:self.tableViewOrderContent];
        CGFloat totalHeight = 0.0;
        for (NSInteger index = 0; index < totalSections; index++)
        {
            CGRect rectSection = [self.tableViewOrderContent rectForSection:index];
            NSLog(@"rectSection[%li][%4.2f,%4.2f]", (long)index, rectSection.size.width, rectSection.size.height);
            CGFloat height = rectSection.size.height;
            totalHeight += height;
        }
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, totalHeight);
        self.tableViewOrderContent.frame = frame;
        originY = self.tableViewOrderContent.frame.origin.y + self.tableViewOrderContent.frame.size.height + intervalV;
    }
    if (self.buttonConfirm)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.buttonConfirm.frame = frame;
        originY = self.buttonConfirm.frame.origin.y + self.buttonConfirm.frame.size.height + marginV;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
    
    if (self.viewLoading)
    {
        self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
    }
}

- (BorderedDoubleLabelView *)viewOrderId
{
    if (_viewOrderId == nil)
    {
        _viewOrderId = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewOrderId.layer setBorderWidth:0.0];
        [_viewOrderId.labelL setText:[LocalizedString OrderId]];
        [_viewOrderId.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewOrderId.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewOrderId;
}

- (BorderedDoubleLabelView *)viewCash
{
    if (_viewCash == nil)
    {
        _viewOrderId = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewOrderId.layer setBorderWidth:0.0];
        [_viewOrderId.labelL setText:[LocalizedString CashToPay]];
        [_viewOrderId.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewOrderId.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewCash;
}

- (BorderedDoubleLabelView *)viewEPoint
{
    if (_viewEPoint == nil)
    {
        _viewEPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewEPoint.layer setBorderWidth:0.0];
        [_viewEPoint.labelL setText:[LocalizedString DiscountByEPoint]];
        [_viewEPoint.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewEPoint.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewEPoint.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewEPoint.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewEPoint;
}

- (BorderedDoubleLabelView *)viewPoint
{
    if (_viewPoint == nil)
    {
        _viewPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPoint.layer setBorderWidth:0.0];
        [_viewPoint.labelL setText:[LocalizedString DiscountByPoint]];
        [_viewPoint.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewPoint.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewPoint.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewPoint.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewPoint;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
    }
    return _separator;
}

- (DTAttributedLabel *)labelOrderDescription
{
    if (_labelOrderDescription == nil)
    {
        _labelOrderDescription = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelOrderDescription.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelOrderDescription.shouldDrawLinks = YES;
        _labelOrderDescription.shouldDrawImages = YES;
        _labelOrderDescription.delegate = self;
        _labelOrderDescription.backgroundColor = [UIColor clearColor];
    }
    return _labelOrderDescription;
}

- (UITableView *)tableViewOrderContent
{
    if (_tableViewOrderContent == nil)
    {
        _tableViewOrderContent = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewOrderContent setShowsVerticalScrollIndicator:NO];
        [_tableViewOrderContent setShowsVerticalScrollIndicator:NO];
        [_tableViewOrderContent setDataSource:self];
        [_tableViewOrderContent setDelegate:self];
        [_tableViewOrderContent registerClass:[CompleteOrderContentTableViewCell class] forCellReuseIdentifier:CompleteOrderContentTableViewCellIdentifier];
        [_tableViewOrderContent registerClass:[SingleLabelHeaderView class] forCellReuseIdentifier:SingleLabelHeaderViewIdentifier];
    }
    return _tableViewOrderContent;
}

- (UIButton *)buttonConfirm
{
    if (_buttonConfirm == nil)
    {
        _buttonConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonConfirm setBackgroundColor:[UIColor orangeColor]];
        [_buttonConfirm.layer setCornerRadius:5.0];
        [_buttonConfirm setTitle:[LocalizedString Confirm] forState:UIControlStateNormal];
        [_buttonConfirm addTarget:self action:@selector(buttonConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
}

- (FullScreenLoadingView *)viewLoading
{
    if (_viewLoading == nil)
    {
        _viewLoading = [[FullScreenLoadingView alloc] initWithFrame:CGRectZero];
        [_viewLoading setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewLoading.alpha = 0.0;
    }
    return _viewLoading;
}

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

- (NSMutableArray *)arrayATM
{
    if (_arrayATM == nil)
    {
        _arrayATM = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayATM;
}

#pragma mark - Private Methods

- (void)showLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator startAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:1.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:1.0];
        }
    });
}

- (void)hideLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator stopAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:0.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:0.0];
        }
    });
}

- (void)prepareData
{
    NSNumber *totalCash = [NSNumber numberWithInteger:0];
    NSNumber *totalEPoint = [NSNumber numberWithInteger:0];
    NSNumber *totalPoint = [NSNumber numberWithInteger:0];
    if (self.dictionaryTotalCost)
    {
        NSNumber *number_total_cash = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_cash];
        if (number_total_cash && [number_total_cash isEqual:[NSNull null]] == NO)
        {
            totalCash = number_total_cash;
        }
        NSNumber *number_total_ePoint = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_ePoint];
        if (number_total_ePoint && [number_total_ePoint isEqual:[NSNull null]] == NO)
        {
            totalEPoint = number_total_ePoint;
        }
        NSNumber *number_total_Point = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_Point];
        if (number_total_Point && [number_total_Point isEqual:[NSNull null]] == NO)
        {
            totalPoint = number_total_Point;
        }
    }
    NSDictionary *attributesOrange = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributesBlack = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSAttributedString *stringDollar = [[NSAttributedString alloc] initWithString:[LocalizedString Dollars] attributes:attributesBlack];
    NSAttributedString *stringPoint = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:attributesBlack];
    if (self.viewCash)
    {
        NSString *stringCash = [self.numberFormatter stringFromNumber:totalCash];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringCash attributes:attributesOrange];
        [attrString appendAttributedString:stringDollar];
        [self.viewCash.labelR setAttributedText:attrString];
    }
    if (self.viewEPoint)
    {
        NSString *stringPoints = [self.numberFormatter stringFromNumber:totalEPoint];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringPoints attributes:attributesOrange];
        [attrString appendAttributedString:stringPoint];
        [self.viewEPoint.labelR setAttributedText:attrString];
    }
    if (self.viewPoint)
    {
        NSString *stringPoints = [self.numberFormatter stringFromNumber:totalPoint];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringPoints attributes:attributesOrange];
        [attrString appendAttributedString:stringPoint];
        [self.viewPoint.labelR setAttributedText:attrString];
    }
    
    if (self.dictionaryOrderData)
    {
        NSInteger itemCount = 0;
        NSArray *items = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_items];
        if (items)
        {
            itemCount = [items count];
        }
        NSString *stringTotalItem = [NSString stringWithFormat:[LocalizedString Total_I_product], (long)itemCount];
        self.labelTotalItem.text = stringTotalItem;
        
        NSString *cart_id = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_cart_id];
        if (cart_id && [cart_id isEqual:[NSNull null]] == NO)
        {
            self.viewOrderId.labelR.text = cart_id;
        }
        NSString *atm_bk_code = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_atm_bk_code];
        if (atm_bk_code)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//            [dictionary setObject:[LocalizedString ] forKey:<#(nonnull id<NSCopying>)#>]
        }
    }
}

- (void)retrieveOrderDescription
{
    [self showLoadingViewAnimated:YES];
    __weak CompleteOrderViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, @"6", SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveOrderDescription - string:\n%@", string);
            [weakSelf processOrderDescriptionData:resultObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf refreshContent];
            });
        }
        else
        {
            NSLog(@"error:\n%@", error);
            [weakSelf hideLoadingViewAnimated:YES];
        }
    }];
}

- (void)processOrderDescriptionData:(id)data
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
        if (result && [result integerValue] == 0)
        {
            // success
            NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
            if (content)
            {
                NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                self.labelOrderDescription.attributedString = attrString;
            }
        }
    }
}

- (void)refreshContent
{
    
}

#pragma mark - Actions

- (void)buttonConfirmPressed:(id)sender
{
    
}

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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = SectionIndexTotal;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case SectionIndexDiscount:
        {
            
        }
            break;
        case SectionIndexPayment:
        {
            
        }
            break;
        case SectionIndexReceiver:
        {
            
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompleteOrderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CompleteOrderContentTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
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
