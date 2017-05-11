//
//  IntroduceViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/11.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) NSMutableArray *arrayImages;

- (void)prepareImages;
- (void)updateContentForPage:(NSInteger)page;

- (void)buttonStartPressed:(id)sender;

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareImages];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:YES];
    
    [self.buttonStart setBackgroundColor:[UIColor orangeColor]];
    [self.buttonStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonStart.layer setCornerRadius:5.0];
    [self.buttonStart setAlpha:0.0];
    [self.buttonStart addTarget:self action:@selector(buttonStartPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pageControl setNumberOfPages:[self.arrayImages count]];
    [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
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
    
    CGFloat originY = self.scrollView.frame.size.height * 4 / 5;
    
    CGFloat intervalV = 10.0;
    
    if (self.buttonStart)
    {
        CGRect frame = self.buttonStart.frame;
        frame.origin.y = originY;
        self.buttonStart.frame = frame;
        originY = self.buttonStart.frame.origin.y + self.buttonStart.frame.size.height + intervalV;
    }
    if (self.pageControl)
    {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = originY;
        self.pageControl.frame = frame;
        originY = self.pageControl.frame.origin.y + self.pageControl.frame.size.height + intervalV;
    }
    
    for (NSInteger index = 0; index < [self.arrayImages count]; index++)
    {
        UIImageView *imageView = [self.arrayImages objectAtIndex:index];
        CGRect frame = CGRectMake(index * self.scrollView.frame.size.width, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        imageView.frame = frame;
    }
    
    CGSize contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.arrayImages count], self.scrollView.frame.size.height);
    [self.scrollView setContentSize:contentSize];
}

- (NSMutableArray *)arrayImages
{
    if (_arrayImages == nil)
    {
        _arrayImages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayImages;
}

#pragma mark - Private Methods

- (void)prepareImages
{
    UIImage *image1 = [UIImage imageNamed:@"intro_1_1080x1920"];
    if (image1)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
        [self.scrollView addSubview:imageView];
        [self.arrayImages addObject:imageView];
    }
    UIImage *image2 = [UIImage imageNamed:@"intro_2_1080x1920"];
    if (image2)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image2];
        [self.scrollView addSubview:imageView];
        [self.arrayImages addObject:imageView];
    }
    UIImage *image3 = [UIImage imageNamed:@"intro_3_1080x1920"];
    if (image3)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image3];
        [self.scrollView addSubview:imageView];
        [self.arrayImages addObject:imageView];
    }
    
}

- (void)updateContentForPage:(NSInteger)page
{
    __weak IntroduceViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.pageControl setCurrentPage:page];
        
        if (page == [self.arrayImages count] - 1)
        {
            // Should show button
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                weakSelf.buttonStart.alpha = 1.0;
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                weakSelf.buttonStart.alpha = 0.0;
            } completion:nil];
        }
    });
}

#pragma mark - Actions

- (void)buttonStartPressed:(id)sender
{
    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat pageFactor = targetContentOffset->x / scrollView.frame.size.width;
    NSInteger page = [[NSNumber numberWithDouble:pageFactor] integerValue];
    
    [self updateContentForPage:page];
}

@end
