//
//  AdditionalProductCollectionViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@class AdditionalProductCollectionViewCell;

@protocol AdditionalProductCollectionViewCellDelegate <NSObject>

- (void)additionalProductCollectionViewCell:(AdditionalProductCollectionViewCell *)cell didSelectPurchaseBySender:(id)sender;

@end

static NSString *AdditionalProductCollectionViewCellIdentifier = @"AdditionalProductCollectionViewCellIdentifier";

@interface AdditionalProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <AdditionalProductCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TTTAttributedLabel *labelMarketing;
@property (nonatomic, strong) TTTAttributedLabel *labelName;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UIButton *buttonPurchase;

@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSDictionary *attributesText;
@property (nonatomic, strong) NSDictionary *attributesMarketName;

+ (CGFloat)cellHeightForWidth:(CGFloat)cellWidth containsMarketName:(NSString *)marketName productName:(NSString *)productName andPrice:(NSString *)price;

@end
