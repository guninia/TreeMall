//
//  ProductTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountLabelView.h"
#import <TTTAttributedLabel.h>

static NSString *ProductTableViewCellIdentifier = @"ProductTableViewCell";

static NSString *ProductTableViewCellTagText = @"ProductTableViewCellText";

@class ProductTableViewCell;

@protocol ProductTableViewCellDelegate <NSObject>

- (void)productTableViewCell:(ProductTableViewCell *)cell didSelectToAddToCartBySender:(id)sender;

@end

@interface ProductTableViewCell : UITableViewCell
{
    UIView *_viewContainer;
}

@property (nonatomic, weak) id <ProductTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrayViewTags;
@property (nonatomic, strong) NSArray *arrayTagsData;
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) DiscountLabelView *viewDiscount;
@property (nonatomic, strong) UIImageView *imageViewProduct;
@property (nonatomic, strong) TTTAttributedLabel *labelMarketing;
@property (nonatomic, strong) TTTAttributedLabel *labelProductName;
@property (nonatomic, strong) UIView *viewSeparator;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UILabel *labelSeparator;
@property (nonatomic, strong) UILabel *labelPoint;
@property (nonatomic, strong) UIButton *buttonCart;
@property (nonatomic, strong) NSString *marketingText;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *point;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSDictionary *attributesMarketing;
@property (nonatomic, strong) NSDictionary *attributesProductName;

@end
