//
//  FullScreenSelectNumberView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/1.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "FullScreenSelectNumberView.h"
#import "Definition.h"
#import "LocalizedString.h"

@interface FullScreenSelectNumberView ()

@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *buttonMinus;
@property (nonatomic, strong) UIButton *buttonPlus;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIButton *buttonConfirm;
@property (nonatomic, strong) UIButton *buttonClose;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIView *viewDescriptionBackground;
@property (nonatomic, strong) UILabel *labelDescription;

- (void)updateText;
- (void)reset;

- (void)buttonMinusPressed:(id)sender;
- (void)buttonPlusPressed:(id)sender;
- (void)buttonConfirmPressed:(id)sender;
- (void)buttonClosePressed:(id)sender;

@end

@implementation FullScreenSelectNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.toolBar];
        [self.viewContainer addSubview:self.viewDescriptionBackground];
        [self.viewContainer addSubview:self.labelDescription];
        [self.viewContainer addSubview:self.labelText];
        [self.viewContainer addSubview:self.buttonMinus];
        [self.viewContainer addSubview:self.buttonPlus];
        [self.viewContainer addSubview:self.buttonConfirm];
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:self.labelTitle];
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonClose];
        closeItem.width = [self.buttonClose imageForState:UIControlStateNormal].size.width;
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        spaceItem.width = 0.0;
        NSArray *items = [NSArray arrayWithObjects:spaceItem, titleItem, flexItem, closeItem, spaceItem, nil];
        [self.toolBar setItems:items];
        
        [self.layer setCornerRadius:10.0];
        [self.layer setMasksToBounds:YES];
        [self reset];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize containerSize = CGSizeMake(280.0, 160.0);
    CGRect containerFrame = CGRectMake((self.frame.size.width - containerSize.width)/2, (self.frame.size.height - containerSize.height)/2, containerSize.width, containerSize.height);
    self.viewContainer.frame = containerFrame;
    
    CGFloat intervalV = 10.0;
    CGFloat originY = 0.0;
    if (self.toolBar)
    {
        CGRect frame = CGRectMake(0.0, originY, containerFrame.size.width, 44.0);
        self.toolBar.frame = frame;
        originY = CGRectGetMaxY(self.toolBar.frame) + intervalV;
        
        if (self.labelTitle)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 180.0, CGRectGetHeight(self.toolBar.frame));
            self.labelTitle.frame = frame;
        }
        if (self.buttonClose)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            self.buttonClose.frame = frame;
        }
        [self.toolBar setNeedsLayout];
    }
    if (self.labelDescription && [self.labelDescription isHidden] == NO)
    {
        originY = CGRectGetMaxY(self.toolBar.frame);
        CGFloat marginH = 10.0;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.labelDescription.lineBreakMode;
        style.alignment = self.labelDescription.textAlignment;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelDescription.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGSize sizeText = [self.labelDescription.text boundingRectWithSize:CGSizeMake(containerFrame.size.width - marginH * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height + 4));
        CGRect frame = CGRectMake((containerFrame.size.width - sizeLabel.width)/2, originY, sizeLabel.width, sizeLabel.height);
        self.labelDescription.frame = frame;
        
        if (self.viewDescriptionBackground && [self.viewDescriptionBackground isHidden] == NO)
        {
            CGRect viewFrame = CGRectMake(0.0, originY, containerFrame.size.width, sizeLabel.height);
            self.viewDescriptionBackground.frame = viewFrame;
        }
    }
    
    CGFloat actionButtonWidth = 40.0;
    CGFloat labelWidth = 120.0;
    CGFloat totalWidth = actionButtonWidth * 2 + labelWidth;
    CGFloat buttonOriginX = (self.viewContainer.frame.size.width - totalWidth)/2;
    CGFloat marginH = buttonOriginX;
    if (self.buttonMinus)
    {
        CGRect frame = CGRectMake(buttonOriginX, originY, actionButtonWidth, actionButtonWidth);
        self.buttonMinus.frame = frame;
        buttonOriginX = CGRectGetMaxX(self.buttonMinus.frame) - self.buttonMinus.layer.borderWidth;
    }
    if (self.labelText)
    {
        CGRect frame = CGRectMake(buttonOriginX, originY, labelWidth, actionButtonWidth);
        self.labelText.frame = frame;
        buttonOriginX = CGRectGetMaxX(self.labelText.frame) - self.labelText.layer.borderWidth;
    }
    if (self.buttonPlus)
    {
        CGRect frame = CGRectMake(buttonOriginX, originY, actionButtonWidth, actionButtonWidth);
        self.buttonPlus.frame = frame;
        originY = CGRectGetMaxY(self.buttonPlus.frame) + intervalV;
    }
    if (self.buttonConfirm)
    {
        CGRect frame = CGRectMake(marginH, originY, totalWidth, 40.0);
        self.buttonConfirm.frame = frame;
    }
}

- (UIView *)viewContainer;
{
    if (_viewContainer == nil)
    {
        _viewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewContainer setBackgroundColor:[UIColor whiteColor]];
        [_viewContainer.layer setCornerRadius:8.0];
        [_viewContainer.layer setMasksToBounds:YES];
    }
    return _viewContainer;
}

- (UIToolbar *)toolBar
{
    if (_toolBar == nil)
    {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        [_toolBar setBarTintColor:TMMainColor];
    }
    return _toolBar;
}

- (UIButton *)buttonMinus
{
    if (_buttonMinus == nil)
    {
        _buttonMinus = [[UIButton alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_buttonMinus.titleLabel setFont:font];
        [_buttonMinus setBackgroundColor:[UIColor clearColor]];
        [_buttonMinus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonMinus.layer setBorderColor:[_buttonMinus titleColorForState:UIControlStateNormal].CGColor];
        [_buttonMinus.layer setBorderWidth:1.0];
        [_buttonMinus setTitle:@"−" forState:UIControlStateNormal];
        [_buttonMinus addTarget:self action:@selector(buttonMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonMinus;
}

- (UIButton *)buttonPlus
{
    if (_buttonPlus == nil)
    {
        _buttonPlus = [[UIButton alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_buttonPlus.titleLabel setFont:font];
        [_buttonPlus setBackgroundColor:[UIColor clearColor]];
        [_buttonPlus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonPlus.layer setBorderColor:[_buttonPlus titleColorForState:UIControlStateNormal].CGColor];
        [_buttonPlus.layer setBorderWidth:1.0];
        [_buttonPlus setTitle:@"＋" forState:UIControlStateNormal];
        [_buttonPlus addTarget:self action:@selector(buttonPlusPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonPlus;
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelText setFont:font];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        [_labelText setTextColor:[UIColor grayColor]];
        [_labelText.layer setBorderColor:_labelText.textColor.CGColor];
        [_labelText.layer setBorderWidth:1.0];
        [_labelText setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelText;
}

- (UIButton *)buttonConfirm
{
    if (_buttonConfirm == nil)
    {
        _buttonConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonConfirm.layer setCornerRadius:5.0];
        [_buttonConfirm setBackgroundColor:[UIColor orangeColor]];
        [_buttonConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonConfirm setTitle:[LocalizedString Confirm] forState:UIControlStateNormal];
        [_buttonConfirm addTarget:self action:@selector(buttonConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
}

- (UIButton *)buttonClose
{
    if (_buttonClose == nil)
    {
        _buttonClose = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_buttonClose setImage:image forState:UIControlStateNormal];
        [_buttonClose setTintColor:[UIColor whiteColor]];
        [_buttonClose setBackgroundColor:[UIColor clearColor]];
        [_buttonClose addTarget:self action:@selector(buttonClosePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonClose;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:20.0];
        [_labelTitle setFont:font];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor whiteColor]];
        [_labelTitle setText:[LocalizedString PleaseSelectQuantity]];
    }
    return _labelTitle;
}

- (UIView *)viewDescriptionBackground
{
    if (_viewDescriptionBackground == nil)
    {
        _viewDescriptionBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewDescriptionBackground setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _viewDescriptionBackground;
}

- (UILabel *)labelDescription
{
    if (_labelDescription == nil)
    {
        _labelDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:10.0];
        [_labelDescription setFont:font];
        [_labelDescription setBackgroundColor:[UIColor clearColor]];
        [_labelDescription setTextColor:[UIColor blackColor]];
        [_labelDescription setNumberOfLines:0];
        [_labelDescription setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelDescription setTextAlignment:NSTextAlignmentLeft];
    }
    return _labelDescription;
}

- (void)setTips:(NSString *)tips
{
    _tips = tips;
    __weak FullScreenSelectNumberView *weakSelf = self;
    if (_tips == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labelDescription.text = @"";
            [weakSelf.labelDescription setHidden:YES];
            [weakSelf.viewDescriptionBackground setHidden:YES];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labelDescription.text = _tips;
            [weakSelf.labelDescription setHidden:NO];
            [weakSelf.viewDescriptionBackground setHidden:NO];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsLayout];
    });
}

#pragma mark - Private Methods

- (void)updateText
{
    [self.labelText setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentValue]];
}

- (void)reset
{
    self.tag = NSIntegerMax;
    self.maxValue = 1;
    self.minValue = 1;
    self.currentValue = 1;
    __weak FullScreenSelectNumberView *weakSelf = self;
    self.tips = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateText];
        [weakSelf setNeedsLayout];
    });
}

#pragma mark - Public Methods

- (void)show
{
    __weak FullScreenSelectNumberView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateText];
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            weakSelf.alpha = 1.0;
        } completion:nil];
    });
}

- (void)close
{
    __weak FullScreenSelectNumberView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished){
            [weakSelf reset];
        }];
    });
    
}

#pragma mark - Actions

- (void)buttonMinusPressed:(id)sender
{
    if (self.currentValue > self.minValue)
    {
        self.currentValue -= 1;
    }
    __weak FullScreenSelectNumberView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateText];
    });
}

- (void)buttonPlusPressed:(id)sender
{
    if (self.currentValue < self.maxValue)
    {
        self.currentValue += 1;
    }
    __weak FullScreenSelectNumberView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateText];
    });
}

- (void)buttonClosePressed:(id)sender
{
    [self close];
}

- (void)buttonConfirmPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreenSelectNumberView:didSelectNumberAsString:)])
    {
        NSString *string = [NSString stringWithFormat:@"%lu", (unsigned long)self.currentValue];
        [_delegate fullScreenSelectNumberView:self didSelectNumberAsString:string];
    }
    [self close];
}

@end
