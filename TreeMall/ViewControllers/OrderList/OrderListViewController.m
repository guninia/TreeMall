//
//  OrderListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderListViewController.h"
#import "LocalizedString.h"
#import "OrderTableViewCell.h"

@interface OrderListViewController ()

- (void)segmentedControlStateValueChanged:(id)sender;
- (void)buttonSearchPressed:(id)sender;
- (void)buttonOrderTimePressed:(id)sender;
- (void)buttonShipTypePressed:(id)sender;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString MyOrder];
    
    [self.view addSubview:self.viewSegmentedBackground];
    [self.viewSegmentedBackground addSubview:self.segmentedControlState];
    [self.view addSubview:self.viewSearchBackground];
    [self.viewSearchBackground addSubview:self.textFieldSearch];
    [self.view addSubview:self.viewButtonBackground];
    [self.viewButtonBackground addSubview:self.buttonOrderTime];
    [self.viewButtonBackground addSubview:self.separator];
    [self.viewButtonBackground addSubview:self.buttonShipType];
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
    
    CGFloat marginT = 10.0;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    
    CGFloat originY = marginT;
    
    if (self.viewSegmentedBackground)
    {
        CGRect frame = CGRectMake(marginL, originY, (self.view.frame.size.width - (marginL + marginR)), 40.0);
        self.viewSegmentedBackground.frame = frame;
        [self.viewSegmentedBackground.layer setCornerRadius:(self.viewSegmentedBackground.frame.size.height / 2)];
        originY = self.viewSegmentedBackground.frame.origin.y + self.viewSegmentedBackground.frame.size.height + 10.0;
        if (self.segmentedControlState)
        {
            [self.segmentedControlState setFrame:self.viewSegmentedBackground.bounds];
        }
    }
    
    if (self.viewSearchBackground)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.viewSearchBackground.frame = frame;
        originY = self.viewSearchBackground.frame.origin.y + self.viewSearchBackground.frame.size.height + 5.0;
        
        if (self.textFieldSearch)
        {
            CGRect frame = CGRectInset(self.viewSearchBackground.bounds, 20.0, 0.0);
            self.textFieldSearch.frame = frame;
        }
    }
    
    if (self.viewButtonBackground)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.viewButtonBackground.frame = frame;
        originY = self.viewButtonBackground.frame.origin.y + self.viewButtonBackground.frame.size.height;
        
        CGFloat separatorWidth = 1.0;
        CGFloat buttonWidth = ceil((self.viewButtonBackground.frame.size.width - separatorWidth)/2);
        CGFloat originX = 0.0;
        if (self.buttonOrderTime)
        {
            CGRect buttonFrame = CGRectMake(originX, 0.0, buttonWidth, self.viewButtonBackground.frame.size.height);
            self.buttonOrderTime.frame = buttonFrame;
            originX = self.buttonOrderTime.frame.origin.x + self.buttonOrderTime.frame.size.width;
        }
        if (self.separator)
        {
            CGFloat height = self.viewButtonBackground.frame.size.height * 3 / 5;
            CGRect separatorFrame = CGRectMake(originX, (self.viewButtonBackground.frame.size.height - height)/2, separatorWidth, height);
            self.separator.frame = separatorFrame;
            originX = self.separator.frame.origin.x + self.separator.frame.size.width;
        }
        if (self.buttonShipType)
        {
            CGRect buttonFrame = CGRectMake(originX, 0.0, buttonWidth, self.viewButtonBackground.frame.size.height);
            self.buttonShipType.frame = buttonFrame;
        }
    }
    
}

- (UIView *)viewSegmentedBackground
{
    if (_viewSegmentedBackground == nil)
    {
        _viewSegmentedBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewSegmentedBackground.layer setBorderWidth:1.0];
        [_viewSegmentedBackground.layer setBorderColor:self.segmentedControlState.tintColor.CGColor];
        [_viewSegmentedBackground setClipsToBounds:YES];
    }
    return _viewSegmentedBackground;
}

- (UISegmentedControl *)segmentedControlState
{
    if (_segmentedControlState == nil)
    {
        NSArray *items = [NSArray arrayWithObjects:[LocalizedString All], [LocalizedString Processing], [LocalizedString Shipping], [LocalizedString Return], nil];
        _segmentedControlState = [[UISegmentedControl alloc] initWithItems:items];
        [_segmentedControlState addTarget:self action:@selector(segmentedControlStateValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControlState;
}

- (UIView *)viewSearchBackground
{
    if (_viewSearchBackground == nil)
    {
        _viewSearchBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewSearchBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewSearchBackground;
}

- (UITextField *)textFieldSearch
{
    if (_textFieldSearch == nil)
    {
        _textFieldSearch = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textFieldSearch setBackgroundColor:[UIColor clearColor]];
        [_textFieldSearch setPlaceholder:[LocalizedString PleaseInputProductName]];
        [_textFieldSearch setDelegate:self];
        UIImage *image = [[UIImage imageNamed:@"sho_btn_mag"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (image)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
            [button setTintColor:[UIColor grayColor]];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
            _textFieldSearch.rightView = button;
            _textFieldSearch.rightViewMode = UITextFieldViewModeAlways;
        }
        [_textFieldSearch setKeyboardType:UIKeyboardTypeDefault];
        [_textFieldSearch setReturnKeyType:UIReturnKeySearch];
    }
    return _textFieldSearch;
}

- (UIView *)viewButtonBackground
{
    if (_viewButtonBackground == nil)
    {
        _viewButtonBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewButtonBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewButtonBackground;
}

- (DropdownListButton *)buttonOrderTime
{
    if (_buttonOrderTime == nil)
    {
        _buttonOrderTime = [[DropdownListButton alloc] initWithFrame:CGRectZero];
        _buttonOrderTime.label.text = [LocalizedString OrderTime];
        [_buttonOrderTime addTarget:self action:@selector(buttonOrderTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOrderTime;
}

- (DropdownListButton *)buttonShipType
{
    if (_buttonShipType == nil)
    {
        _buttonShipType = [[DropdownListButton alloc] initWithFrame:CGRectZero];
        _buttonShipType.label.text = [LocalizedString ShipType];
        [_buttonShipType addTarget:self action:@selector(buttonShipTypePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonShipType;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor grayColor]];
    }
    return _separator;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:OrderTableViewCellIdentifier];
    }
    return _tableView;
}

#pragma mark - Actions

- (void)segmentedControlStateValueChanged:(id)sender
{
    
}

- (void)buttonSearchPressed:(id)sender
{
    NSString *text = self.textFieldSearch.text;
    if ([text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputProductName] preferredStyle:UIAlertControllerStyleAlert];
        __weak OrderListViewController *weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf.textFieldSearch setText:@""];
            if ([weakSelf.textFieldSearch canBecomeFirstResponder])
            {
                [weakSelf.textFieldSearch becomeFirstResponder];
            }
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    else
    {
        // Should start search.
    }
    [self.textFieldSearch resignFirstResponder];
}

- (void)buttonOrderTimePressed:(id)sender
{
    
}

- (void)buttonShipTypePressed:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    if ([text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputProductName] preferredStyle:UIAlertControllerStyleAlert];
        __weak OrderListViewController *weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf.textFieldSearch setText:@""];
            if ([weakSelf.textFieldSearch canBecomeFirstResponder])
            {
                [weakSelf.textFieldSearch becomeFirstResponder];
            }
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        // Should start search.
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate


@end
