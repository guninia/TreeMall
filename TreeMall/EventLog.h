//
//  EventLog.h
//  TreeMall
//
//  Created by symphox symphox on 2017/7/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * logPara_下一步 = @"下一步";
static NSString * logPara_列表一 = @"列表一 ";
static NSString * logPara_商品列表 = @"商品列表";
static NSString * logPara_網頁 = @"網頁";
static NSString * logPara_點擊 = @"點擊";
static NSString * logPara_成功 = @"成功";
static NSString * logPara_加入我的最愛 = @"加入我的最愛";
static NSString * logPara_加入購物車 = @"加入購物車";
static NSString * logPara_我的點數 = @"我的點數";
static NSString * logPara_我的折價券 = @"我的折價券";
static NSString * logPara_今日焦點 = @"今日焦點";
static NSString * logPara_優惠文字訊息 = @"優惠文字訊息";
static NSString * logPara_兌點推薦 = @"兌點推薦";
static NSString * logPara_折價券推薦 = @"折價券推薦";
static NSString * logPara_優惠通知 = @"優惠通知";
static NSString * logPara_優惠通知明細 = @"優惠通知明細";
static NSString * logPara_搜尋 = @"搜尋";
static NSString * logPara_首頁 = @"首頁";
static NSString * logPara_商品總覽 = @"商品總覽";
static NSString * logPara_購物車 = @"購物車";
static NSString * logPara_我的最愛 = @"我的最愛";
static NSString * logPara_會員 = @"會員";
static NSString * logPara_登入 = @"登入";
static NSString * logPara_Facebook帳號 = @"Facebook帳號";
static NSString * logPara_Google帳號 = @"Google帳號";
static NSString * logPara_同意會員條款 = @"同意會員條款";
static NSString * logPara_詳細內容 = @"詳細內容";
static NSString * logPara_加入會員 = @"加入會員";
static NSString * logPara_忘記密碼 = @"忘記密碼";
static NSString * logPara_警告 = @"警告";
static NSString * logPara_熱銷排行 = @"熱銷排行";
static NSString * logPara_商品資訊 = @"商品資訊";
static NSString * logPara_會員條款 = @"會員條款";
static NSString * logPara_請先同意會員條款 = @"請先同意會員條款";
static NSString * logPara_註冊成功 = @"註冊成功";
static NSString * logPara_介紹 = @"介紹";
static NSString * logPara_主選單 = @"主選單";
static NSString * logPara_下次再認證 = @"下次再認證";
static NSString * logPara_立即認證 = @"立即認證";
static NSString * logPara_國泰世華卡友認證 = @"國泰世華卡友認證";
static NSString * logPara_集團員工認證 = @"集團員工認證";
static NSString * logPara_國泰金控其他客戶 = @"國泰金控其他客戶";
static NSString * logPara_活動連結 = @"活動連結";
static NSString * logPara_刪除 = @"刪除";
static NSString * logPara_最近搜尋列表 = @"最近搜尋列表";
static NSString * logPara_熱門搜尋列表 = @"熱門搜尋列表";
static NSString * logPara_列表二 = @"列表二";
static NSString * logPara_列表三 = @"列表三";
static NSString * logPara_標題類別 = @"標題類別";
static NSString * logPara_類別清單 = @"類別清單";
static NSString * logPara_類別列表 = @"類別列表";
static NSString * logPara_排序 = @"排序";
static NSString * logPara_篩選 = @"篩選";
static NSString * logPara_兌換說明 = @"兌換說明";
static NSString * logPara_分期試算 = @"分期試算";
static NSString * logPara_直接購買 = @"直接購買";
static NSString * logPara_關閉 = @"關閉";
static NSString * logPara_加購商品 = @"加購商品";
static NSString * logPara_付款方式 = @"付款方式";
static NSString * logPara_詳細條款 = @"詳細條款";
static NSString * logPara_收貨人資訊 = @"收貨人資訊";
static NSString * logPara_選擇取貨超商 = @"選擇取貨超商";
static NSString * logPara_完成訂購 = @"完成訂購";
static NSString * logPara_信用卡資訊 = @"信用卡資訊";
static NSString * logPara_服務說明 = @"服務說明";
static NSString * logPara_確認付款 = @"確認付款";
static NSString * logPara_資訊 = @"資訊";
static NSString * logPara_修改 = @"修改";
static NSString * logPara_玩遊戲賺點數 = @"玩遊戲賺點數";
static NSString * logPara_我的訂單 = @"我的訂單";
static NSString * logPara_訂單處理中 = @"訂單處理中";
static NSString * logPara_訂單已出貨 = @"訂單已出貨";
static NSString * logPara_訂單退換貨 = @"訂單退換貨";
static NSString * logPara_外開網頁 = @"外開網頁";
static NSString * logPara_帳號資料維護 = @"帳號資料維護";
static NSString * logPara_登出 = @"登出";
static NSString * logPara_請點選同意條款 = @"請點選同意條款";
//static NSString * logPara_ = @"";

@interface EventLog : NSObject

+ (NSString *)twoString:(NSString *)first _:(NSString *)second;
+ (NSString *)threeString:(NSString *)first _:(NSString *)second _:(NSString *)third;
+ (NSString *)to_:(NSString *)first;
+ (NSString *)webViewWithName:(NSString *)first;
+ (NSString *)index:(NSInteger)indexPath _:(NSString *)first;
+ (NSString *)index:(NSInteger)indexPath _to_:(NSString *)first;
+ (NSString *)typeInString:(NSUInteger)type;
+ (NSString *)cartTypeInString:(NSUInteger)type;

@end
