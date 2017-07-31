//
//  TermsViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "TermsViewController.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "Definition.h"
#import "LocalizedString.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface TermsViewController () {
    id<GAITracker> gaTracker;
}

- (void)retrieveData;
- (BOOL)processData:(id)data;

@end

@implementation TermsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _type = @"0";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString JoinMember];
    
    [_labelTitle setTextColor:TMMainColor];
    
    [self.view addSubview:self.textViewTerms];
//    [_textViewTerms setScrollEnabled:YES];
    if (self.content == nil)
    {
        [self retrieveData];
    }

    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    // GA screen log
    [gaTracker set:kGAIScreenName value:self.title];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    
    CGFloat marginH = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = CGRectGetMaxY(self.separator.frame) + intervalV;
    if (self.textViewTerms)
    {
        CGRect frame = CGRectMake(marginH, originY, self.view.frame.size.width - marginH * 2, self.view.frame.size.height - originY);
        self.textViewTerms.frame = frame;
    }
}

- (void)setContent:(NSString *)content
{
    _content = content;
    [_textViewTerms setAttributedString:[self attributedStringFromHTML:_content forSnippetUsingiOS6Attributes:NO]];
}

- (DTAttributedTextView *)textViewTerms
{
    if (_textViewTerms == nil)
    {
        _textViewTerms = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
    }
    return _textViewTerms;
}

#pragma mark - Private Methods

- (void)retrieveData
{
    __weak TermsViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, @"0", SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveData - string:\n%@", string);
            if ([weakSelf processData:resultObject] == NO)
            {
                NSLog(@"Cannot process terms data.");
            }
        }
        else
        {
            NSLog(@"error:\n%@", error);
        }
        
    }];
}

- (NSAttributedString *)attributedStringFromHTML:(NSString *)html forSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes
{
    // Load HTML data
    if (html == nil)
        return nil;
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    
    if (useiOS6Attributes)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:DTUseiOS6Attributes];
    }
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

- (BOOL)processData:(id)data
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
                    if (content)
                    {
                        self.content = content;
                        success = YES;
                    }
                }
            }
        }
    }
    return success;
}

@end
