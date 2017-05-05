//
//  SingleMediaDetailSubViewController.m
//  Fiziko
//
//  Created by ryo on 7/3/16.
//  Copyright © 2016 ryo. All rights reserved.
//

#import "SingleMediaDetailSubViewController.h"
#import <UIImageView+WebCache.h>

@interface SingleMediaDetailSubViewController (){
}
@property (strong , nonatomic) IBOutlet UIImageView *imgvPhoto;
@property (strong , nonatomic) IBOutlet UIScrollView *sclView;
@end

@implementation SingleMediaDetailSubViewController
@synthesize strImageUrl,idxCount;

- (void)viewWillLayoutSubviews{
    [self resetZoomScale];
}

- (void)resetZoomScale{
    NSLog(@"zoom scale");
    CGSize imageViewSize = self.imgvPhoto.bounds.size;
    CGSize scrollViewSize = self.sclView.bounds.size;
    if(imageViewSize.width){
        double widthScale = scrollViewSize.width / imageViewSize.width;
        double heightScale = scrollViewSize.height / imageViewSize.height;
        
        self.sclView.minimumZoomScale = MIN(widthScale, heightScale);
        self.sclView.maximumZoomScale = self.sclView.minimumZoomScale * 4;
        self.sclView.zoomScale = 1.0;
        [self.sclView setZoomScale:self.sclView.minimumZoomScale  animated: NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(strImageUrl.length){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        tap.numberOfTapsRequired = 2;
        [self.sclView addGestureRecognizer:tap];
        //[self.imgvPhoto sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"demoSquare.png"] options:SDWebImageRetryFailed];
        //[CommonTool showHUD];
        [self.imgvPhoto sd_setImageWithURL:[NSURL URLWithString:strImageUrl]
                          placeholderImage:[UIImage imageNamed:@""]
                                   options:SDWebImageRetryFailed
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     //[CommonTool hideHUD];
                                     self.imgvPhoto.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                                     self.sclView.contentSize = self.imgvPhoto.bounds.size;
                                     [self resetZoomScale];
                                    
                                     if(![error code]){ }
                                     else{NSLog(@"errcode = %ld", (long)[error code]);}
                                 }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
 }


- (void)dealloc{
}


- (void)handleDoubleTap {
    if (_sclView.zoomScale > _sclView.minimumZoomScale) {
        [_sclView setZoomScale:_sclView.minimumZoomScale  animated: true];
    } else {
        [_sclView setZoomScale:_sclView.maximumZoomScale  animated: true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView * )scrollView{
    return [scrollView.subviews objectAtIndex:0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scoll did zoom");
    CGSize imageViewSize = _imgvPhoto.frame.size;
    CGSize scrollViewSize = _sclView.bounds.size;
        
    float verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    float horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
        
    scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

@end
