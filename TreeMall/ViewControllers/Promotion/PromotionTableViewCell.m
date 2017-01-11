//
//  PromotionTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PromotionTableViewCell.h"
#import "APIDefinition.h"

@interface PromotionTableViewCell ()

- (void)renewContent;

@end

@implementation PromotionTableViewCell

#pragma mark - Constructor

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _dictionaryData = nil;
        _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewMask setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        [_viewMask setHidden:YES];
        [self.contentView addSubview:_viewMask];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Actions

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Override

- (void)setDictionaryData:(NSDictionary *)dictionaryData
{
    BOOL shouldRenewContent = NO;
    if (_dictionaryData != nil)
    {
        NSString *currentIdentifier = [_dictionaryData objectForKey:SymphoxAPIParam_id];
        NSString *identifier = [dictionaryData objectForKey:SymphoxAPIParam_id];
        if ([currentIdentifier isEqualToString:identifier] == NO)
        {
            _dictionaryData = dictionaryData;
            shouldRenewContent = YES;
        }
    }
    else
    {
        _dictionaryData = dictionaryData;
        shouldRenewContent = YES;
    }
    if (shouldRenewContent)
    {
        [self renewContent];
    }
}

#pragma mark - Private Methods

- (void)renewContent
{
    // TO DO:
}

@end
