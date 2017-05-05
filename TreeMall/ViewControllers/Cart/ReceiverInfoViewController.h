//
//  ReceiverInfoViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/1.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenLoadingView.h"
#import "ReceiverInfoCell.h"
#import "SingleLabelHeaderView.h"
#import "TMInfoManager.h"
#import <DTCoreText.h>

@interface ReceiverInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ReceiverInfoCellDelegate, DTAttributedTextContentViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *labelDeliverTitle;
@property (nonatomic, weak) IBOutlet UIButton *buttonContactList;
@property (nonatomic, weak) IBOutlet UIView *separator;
@property (nonatomic, weak) IBOutlet UILabel *labelInvoiceTitle;

@property (nonatomic, strong) UITableView *tableViewInfo;
@property (nonatomic, strong) UITableView *tableViewInvoice;
@property (nonatomic, strong) UIButton *buttonNext;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;

@property (nonatomic, strong) NSMutableArray *arrayDeliveryList;

@property (nonatomic, strong) NSMutableDictionary *currentDeliveryTarget;
@property (nonatomic, strong) NSMutableArray *arrayCity;
@property (nonatomic, strong) NSMutableDictionary *dictionaryRegionsForCity;
@property (nonatomic, strong) NSMutableDictionary *dictionaryZipForRegion;
@property (nonatomic, strong) NSMutableDictionary *dictionaryCityForZip;
@property (nonatomic, strong) NSMutableDictionary *dictionaryRegionForZip;
@property (nonatomic, strong) NSMutableArray *arrayDeliverTime;
@property (nonatomic, strong) NSMutableArray *arraySectionContent;
@property (nonatomic, strong) NSMutableArray *arrayInvoiceSection;

@property (nonatomic, assign) CartType type;
@property (nonatomic, assign) BOOL canSelectDeliverTime;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentRegion;
@property (nonatomic, assign) NSInteger selectedDeliverTimeIndex;
@property (nonatomic, strong) NSDictionary *dictionaryInstallment;
@property (nonatomic, strong) NSString *invoiceDescription;
@property (nonatomic, strong) DTAttributedLabel *labelInvoiceDescription;

@end
