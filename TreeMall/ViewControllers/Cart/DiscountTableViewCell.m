//
//  DiscountTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DiscountTableViewCell.h"

@implementation DiscountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected)
//    {
//        self.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
    [self.buttonCheck setSelected:selected];
}

#pragma mark - Override

- (UIButton *)buttonCheck
{
    if (_buttonCheck == nil)
    {
        _buttonCheck = [[UIButton alloc] initWithFrame:CGRectZero];
        CGSize buttonSize = CGSizeMake(30.0, 30.0);
        UIImage *image = [UIImage imageNamed:@"ico_car_list_line"];
        if (image)
        {
            [_buttonCheck setImage:image forState:UIControlStateNormal];
            buttonSize = image.size;
        }
        UIImage *selectedImage = [UIImage imageNamed:@"ico_car_list"];
        if (selectedImage)
        {
            [_buttonCheck setImage:selectedImage forState:UIControlStateSelected];
        }
        CGRect frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);
        _buttonCheck.frame = frame;
    }
    return _buttonCheck;
}

@end
