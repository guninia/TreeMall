//
//  SingleMediaDetailViewController.m
//  Fiziko
//
//  Created by Ryo on 6/4/16.
//  Copyright © 2016 ryo. All rights reserved.
//

#import "SingleMediaDetailViewController.h"
#import "AppDelegate.h"
#import "SingleMediaDetailSubViewController.h"

@interface SingleMediaDetailViewController (){
    IBOutlet UIPageViewController *pvController;
    IBOutlet UIView *viewBase;
}

- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation SingleMediaDetailViewController
@synthesize aryData,idxStart;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Create page view controller
    NSDictionary *options = @{
                              UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin) ,
                              UIPageViewControllerOptionInterPageSpacingKey : @(50.0)
                              };
    pvController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                 options:options];
    
    pvController.dataSource = self;
    pvController.delegate = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:idxStart?idxStart:0];
    NSArray *viewControllers = @[startingViewController];
    [pvController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    pvController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:pvController];
    [viewBase addSubview:pvController.view];
    [pvController didMoveToParentViewController:self];
}

- (void)viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)closeButtonPressed:(id)sender
{
    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SingleMediaDetailSubViewController*) viewController).idxCount;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((SingleMediaDetailSubViewController*) viewController).idxCount;
    if ((index == [aryData count]-1) || (index == NSNotFound))
    {
            return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    NSLog(@"index=%ld",(long)index);
    
    // Create a new view controller and pass suitable data.
    SingleMediaDetailSubViewController *VC = [SingleMediaDetailSubViewController new];
    
    VC.strImageUrl = aryData[index];
    VC.idxCount = index;

    return VC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {

}

//換頁完成呼叫, 會告知動畫目前UIPageViewController, 翻頁動畫是否有跑, 上一頁的UIViewController, 是否有翻頁
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return UIPageViewControllerSpineLocationNone;
}

#pragma mark - option

/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return aryData.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
*/
@end
