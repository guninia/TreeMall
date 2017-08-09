//
//  APIDefinition.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#ifndef APIDefinition_h
#define APIDefinition_h

#import <Foundation/Foundation.h>

#ifdef DEBUG
static NSString *SymphoxAPIDomain = @"http://sapi.symphox.com.tw/treeMall/";
#else
static NSString *SymphoxAPIDomain = @"https://api.symphox.com.tw/treeMall/";
#endif

static NSString *SymphoxAPI__token = @"api/portal/app/token";
static NSString *SymphoxAPI__homepage = @"api/onlineService.do";
static NSString *SymphoxAPI__getHotSaleProducts = @"api/eiffel/amway/default";
static NSString *SymphoxAPI__promotion = @"api/onlineService.do";
static NSString *SymphoxAPI__register = @"api/portal/app/member/register";
static NSString *SymphoxAPI__login = @"api/portal/app/member/identify";
static NSString *SymphoxAPI__terms = @"api/onlineService.do";
static NSString *SymphoxAPI__forgetPassword = @"api/portal/app/member/password/forget";
static NSString *SymphoxAPI__mobileVerification = @"api/portal/app/member/verify/mobile";
static NSString *SymphoxAPI__authenticationCreditCard = @"authId/bank.do";
static NSString *SymphoxAPI__authenticationEmployee = @"authId/employee.do";
static NSString *SymphoxAPI__authenticationCathayCustomer = @"authId/cathay.do";
static NSString *SymphoxAPI__editContacts = @"contacts/edit.do";
static NSString *SymphoxAPI__editBasicInfo = @"memberInfo/edit.do";
static NSString *SymphoxAPI__MainCategories = @"api/onlineService.do";
static NSString *SymphoxAPI__Subcategories = @"api/portal/app/mall/hall";
static NSString *SymphoxAPI__Search = @"api/eiffel/search/treemall";
static NSString *SymphoxAPI__mainCategoryNameMapping = @"api/onlineService.do";
static NSString *SymphoxAPI__hotKeywords = @"api/portal/app/mall/keyword";
static NSString *SymphoxAPI__memberInformation = @"api/portal/app/member/info";
static NSString *SymphoxAPI__memberPoint = @"api/portal/app/member/point";
static NSString *SymphoxAPI__memberCoupon = @"api/portal/app/member/ecoupon";
static NSString *SymphoxAPI__productDetail = @"api/portal/app/mall/product";
static NSString *SymphoxAPI__memberOrder = @"api/portal/app/member/order";
static NSString *SymphoxAPI__emailAuth = @"api/portal/app/member/verify/email";
static NSString *SymphoxAPI__changePassword = @"api/portal/app/member/password/update";
static NSString *SymphoxAPI__newsletter = @"api/portal/app/member/edm";
static NSString *SymphoxAPI__subscribeNewsletter = @"api/portal/app/member/edm/update";
static NSString *SymphoxAPI__orderNumberOfStatus = @"api/portal/app/member/order/status";
static NSString *SymphoxAPI__checkProductAvailable = @"api/eiffel/appShoppingCart/addToCart";
static NSString *SymphoxAPI__renewProductConditions = @"api/eiffel/appShoppingCart/goToCart";
static NSString *SymphoxAPI__checkAdditionalPurchase = @"api/eiffel/appShoppingCart/additionalPurchase";
static NSString *SymphoxAPI__finalCheckProductsInCart = @"api/eiffel/appShoppingCart/checkCart";
static NSString *SymphoxAPI__getBuyNowDeliveryInfo = @"api/eiffel/appOrder/oneClickBuyDelivery";
static NSString *SymphoxAPI__checkPayment = @"api/eiffel/appShoppingCart/checkPayment";
static NSString *SymphoxAPI__getDeliverInfo = @"api/eiffel/appOrder/delivery";
static NSString *SymphoxAPI__getContactInfo = @"api/portal/app/member/contact";
static NSString *SymphoxAPI__getDistrictInfo = @"api/eiffel/treemall/zipInfo";
static NSString *SymphoxAPI__getCarrierInfo = @"api/eiffel/goods/typeInfo";
static NSString *SymphoxAPI__getOneClickBuyContactInfo = @"api/eiffel/appOrder/oneClickBuyDelivery";
static NSString *SymphoxAPI__activateOCB = @"https://www.cathaybk.com.tw/cathaybk/card/event/2012/card_news1010701.asp";
static NSString *SymphoxAPI__buildOrder = @"api/eiffel/orders/createOrder";
static NSString *SymphoxAPI__getDeliveryProgress = @"api/portal/app/member/order/delivery";
static NSString *SymphoxAPI__checkDelivery = @"api/eiffel/appOrder/checkDelivery";
static NSString *SymphoxAPI__sendPushInfo = @"api/onlineService.do";
static NSString *SymphoxAPI__feedbackPointDetailPage = @"http://www.treemall.com.tw/event/140310howpoint/index_2.shtml#a01";
static NSString *SymphoxAPI__storePickupDescription = @"http://www.treemall.com.tw/event/24H_160101/160101_con_list.shtml";
static NSString *SymphoxAPI__OrderDetailWebpage = @"https://www.treemall.com.tw/member/index";

#define SymphoxAPI_token [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__token]
#define SymphoxAPI_homepage [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__homepage]
#define SymphoxAPI_getHotSaleProducts [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getHotSaleProducts]
#define SymphoxAPI_promotion [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__promotion]
#define SymphoxAPI_register [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__register]
#define SymphoxAPI_login [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__login]
#define SymphoxAPI_terms [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__terms]
#define SymphoxAPI_forgetPassword [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__forgetPassword]
#define SymphoxAPI_mobileVerification [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__mobileVerification]
#define SymphoxAPI_authenticationCreditCard [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__authenticationCreditCard]
#define SymphoxAPI_authenticationEmployee [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__authenticationEmployee]
#define SymphoxAPI_authenticationCathayCustomer [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__authenticationCathayCustomer]
#define SymphoxAPI_editContacts [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__editContacts]
#define SymphoxAPI_editBasicInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__editBasicInfo]
#define SymphoxAPI_MainCategories [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__MainCategories]
#define SymphoxAPI_Subcategories [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__Subcategories]
#define SymphoxAPI_Search [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__Search]
#define SymphoxAPI_mainCategoryNameMapping [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__mainCategoryNameMapping]
#define SymphoxAPI_hotKeywords [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__hotKeywords]
#define SymphoxAPI_memberInformation [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__memberInformation]
#define SymphoxAPI_memberPoint [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__memberPoint]
#define SymphoxAPI_memberCoupon [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__memberCoupon]
#define SymphoxAPI_productDetail [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__productDetail]
#define SymphoxAPI_memberOrder [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__memberOrder]
#define SymphoxAPI_emailAuth [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__emailAuth]
#define SymphoxAPI_changePassword [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__changePassword]
#define SymphoxAPI_newsletter [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__newsletter]
#define SymphoxAPI_subscribeNewsletter [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__subscribeNewsletter]
#define SymphoxAPI_orderNumberOfStatus [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__orderNumberOfStatus]
#define SymphoxAPI_checkProductAvailable [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__checkProductAvailable]
#define SymphoxAPI_renewProductConditions [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__renewProductConditions]
#define SymphoxAPI_checkAdditionalPurchase [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__checkAdditionalPurchase]
#define SymphoxAPI_finalCheckProductsInCart [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__finalCheckProductsInCart]
#define SymphoxAPI_getBuyNowDeliveryInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getBuyNowDeliveryInfo]
#define SymphoxAPI_checkPayment [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__checkPayment]
#define SymphoxAPI_getDeliverInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getDeliverInfo]
#define SymphoxAPI_getContactInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getContactInfo]
#define SymphoxAPI_getDistrictInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getDistrictInfo]
#define SymphoxAPI_getCarrierInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getCarrierInfo]
#define SymphoxAPI_getOneClickBuyContactInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getOneClickBuyContactInfo]
#define SymphoxAPI_activateOCB SymphoxAPI__activateOCB
#define SymphoxAPI_buildOrder [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__buildOrder]
#define SymphoxAPI_getDeliveryProgress [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__getDeliveryProgress]
#define SymphoxAPI_checkDelivery [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__checkDelivery]
#define SymphoxAPI_sendPushInfo [NSString stringWithFormat:@"%@%@", SymphoxAPIDomain, SymphoxAPI__sendPushInfo]
#define SymphoxAPI_feedbackPointDetailPage SymphoxAPI__feedbackPointDetailPage
#define SymphoxAPI_storePickupDescription SymphoxAPI__storePickupDescription
#define SymphoxAPI_OrderDetailWebpage SymphoxAPI__OrderDetailWebpage


static NSString *SymphoxAPIParam_key = @"sym-api-key";
static NSString *SymphoxAPIParam_token = @"sym-api-token";
static NSString *SymphoxAPIParam_txid = @"txid";
static NSString *SymphoxAPIParam_id = @"id";
static NSString *SymphoxAPIParam_result = @"result";
static NSString *SymphoxAPIParam_productBanner = @"productBanner";
static NSString *SymphoxAPIParam_img = @"img";
static NSString *SymphoxAPIParam_link = @"link";
static NSString *SymphoxAPIParam_type = @"type";
static NSString *SymphoxAPIParam_serviceText = @"serviceText";
static NSString *SymphoxAPIParam_toDayFocus = @"toDayFocus";
static NSString *SymphoxAPIParam_now = @"now";
static NSString *SymphoxAPIParam_serviceMessage = @"serviceMessage";
static NSString *SymphoxAPIParam_name = @"name";
static NSString *SymphoxAPIParam_originName = @"originName";
static NSString *SymphoxAPIParam_tips = @"tips";
static NSString *SymphoxAPIParam_content = @"content";
static NSString *SymphoxAPIParam_account = @"account";
static NSString *SymphoxAPIParam_password = @"password";
static NSString *SymphoxAPIParam_check_pwd = @"check_pwd";
static NSString *SymphoxAPIParam_mobile = @"mobile";
static NSString *SymphoxAPIParam_verify_code = @"verify_code";
static NSString *SymphoxAPIParam_ip = @"ip";
static NSString *SymphoxAPIParam_status_id = @"status_id";
static NSString *SymphoxAPIParam_status_desc = @"status_desc";
static NSString *SymphoxAPIParam_server_desc = @"server_desc";
static NSString *SymphoxAPIParam_user_num = @"user_num";
static NSString *SymphoxAPIParam_sex = @"sex";
static NSString *SymphoxAPIParamValue_m = @"m";
static NSString *SymphoxAPIParamValue_f = @"f";
static NSString *SymphoxAPIParam_epoint = @"epoint";
static NSString *SymphoxAPIParam_ecoupon = @"ecoupon";
static NSString *SymphoxAPIParam_send_email = @"send_email";
static NSString *SymphoxAPIParam_send_sms = @"send_sms";
static NSString *SymphoxAPIParam_email = @"email";
static NSString *SymphoxAPIParam_mallHall = @"mallHall";
static NSString *SymphoxAPIParam_hall_id = @"hall_id";
static NSString *SymphoxAPIParam_layer = @"layer";
static NSString *SymphoxAPIParam_keywords = @"keywords";
static NSString *SymphoxAPIParam_product_num = @"product_num";
static NSString *SymphoxAPIParam_carrier_type = @"carrier_type";
static NSString *SymphoxAPIParam_delivery_store = @"delivery_store";
static NSString *SymphoxAPIParam_cpse_id = @"cpse_id";
static NSString *SymphoxAPIParam_cpnhl_id = @"cpnhl_id";
static NSString *SymphoxAPIParam_cpte_id = @"cpte_id";
static NSString *SymphoxAPIParam_cptm_id = @"cptm_id";
static NSString *SymphoxAPIParam_ecoupon_type = @"ecoupon_type";
static NSString *SymphoxAPIParam_point_from = @"point_from";
static NSString *SymphoxAPIParam_point_to = @"point_to";
static NSString *SymphoxAPIParam_price_from = @"price_from";
static NSString *SymphoxAPIParam_price_to = @"price_to";
static NSString *SymphoxAPIParam_payment_type = @"payment_type";
static NSString *SymphoxAPIParam_sort_type = @"sort_type";
static NSString *SymphoxAPIParam_page = @"page";
static NSString *SymphoxAPIParam_page_count = @"page_count";
static NSString *SymphoxAPIParam_productDetailList = @"productDetailList";
static NSString *SymphoxAPIParam_seekInstallmentList = @"seekInstallmentList";
static NSString *SymphoxAPIParam_installment_num = @"installment_num";
static NSString *SymphoxAPIParam_installment_price = @"installment_price";
static NSString *SymphoxAPIParam_cathaycard_only = @"cathaycard_only";
static NSString *SymphoxAPIParam_cpro_num = @"cpro_num";
static NSString *SymphoxAPIParam_cpdt_num = @"cpdt_num";
static NSString *SymphoxAPIParam_cpro_price = @"cpro_price";
static NSString *SymphoxAPIParam_cpdt_name = @"cpdt_name";
static NSString *SymphoxAPIParam_market_name = @"market_name";
static NSString *SymphoxAPIParam_quick = @"quick";
static NSString *SymphoxAPIParam_cpro_type = @"cpro_type";
static NSString *SymphoxAPIParam_point01 = @"point01";
static NSString *SymphoxAPIParam_price02 = @"price02";
static NSString *SymphoxAPIParam_point02 = @"point02";
static NSString *SymphoxAPIParam_price03 = @"price03";
static NSString *SymphoxAPIParam_prod_pic_url = @"prod_pic_url";
static NSString *SymphoxAPIParam_is_delivery_store = @"is_delivery_store";
static NSString *SymphoxAPIParam_freepoint = @"freepoint";
static NSString *SymphoxAPIParam_chk_tactic_click = @"chk_tactic_click";
static NSString *SymphoxAPIParam_tactic_click_category = @"tactic_click_category";
static NSString *SymphoxAPIParam_tactic_click_discount = @"tactic_click_discount";
static NSString *SymphoxAPIParam_chk_discount_hall = @"chk_discount_hall";
static NSString *SymphoxAPIParam_discount_hall_percentage = @"discount_hall_percentage";
static NSString *SymphoxAPIParam_normal_cart = @"normal_cart";
static NSString *SymphoxAPIParam_to_store_cart = @"to_store_cart";
static NSString *SymphoxAPIParam_fast_delivery_cart = @"fast_delivery_cart";
static NSString *SymphoxAPIParam_single_shopping_cart = @"single_shopping_cart";
static NSString *SymphoxAPIParam_size = @"size";
static NSString *SymphoxAPIParam_total_size = @"total_size";
static NSString *SymphoxAPIParam_total_page = @"total_page";
static NSString *SymphoxAPIParam_min_price = @"min_price";
static NSString *SymphoxAPIParam_max_price = @"max_price";
static NSString *SymphoxAPIParam_min_point = @"min_point";
static NSString *SymphoxAPIParam_max_point = @"max_point";
static NSString *SymphoxAPIParam_display_name = @"display_name";
static NSString *SymphoxAPIParam_document_num = @"document_num";
static NSString *SymphoxAPIParam_hall = @"hall";
static NSString *SymphoxAPIParam_categoryLv1 = @"categoryLv1";
static NSString *SymphoxAPIParam_hallMap = @"hallMap";
static NSString *SymphoxAPIParamValue_N = @"N";
static NSString *SymphoxAPIParamValue_Y = @"Y";
static NSString *SymphoxAPIParam_auth_status = @"auth_status";
static NSString *SymphoxAPIParamValue_000 = @"000";
static NSString *SymphoxAPIParamValue_100 = @"100";
static NSString *SymphoxAPIParamValue_800 = @"800";
static NSString *SymphoxAPIParam_user_id = @"user_id";
static NSString *SymphoxAPIParam_birthday = @"birthday";
static NSString *SymphoxAPIParam_email_member = @"email_member";
static NSString *SymphoxAPIParam_email_status = @"email_status";
static NSString *SymphoxAPIParam_inv_title = @"inv_title";
static NSString *SymphoxAPIParam_inv_type = @"inv_type";
static NSString *SymphoxAPIParam_new_member = @"new_member";
static NSString *SymphoxAPIParam_ocb_status = @"ocb_status";
static NSString *SymphoxAPIParamValue_T = @"T";
static NSString *SymphoxAPIParamValue_E = @"E";
static NSString *SymphoxAPIParam_ocb_url = @"ocb_url";
static NSString *SymphoxAPIParam_pwd_status = @"pwd_status";
static NSString *SymphoxAPIParam_tax_id = @"tax_id";
static NSString *SymphoxAPIParam_tel_area = @"tel_area";
static NSString *SymphoxAPIParam_tel_ex = @"tel_ex";
static NSString *SymphoxAPIParam_tel_num = @"tel_num";
static NSString *SymphoxAPIParam_zip = @"zip";
static NSString *SymphoxAPIParam_address = @"address";
static NSString *SymphoxAPIParam_ad_text = @"ad_text";
static NSString *SymphoxAPIParam_ad_url = @"ad_url";
static NSString *SymphoxAPIParam_exp_point = @"exp_point";
static NSString *SymphoxAPIParam_point = @"point";
static NSString *SymphoxAPIParam_status = @"status";
static NSString *SymphoxAPIParamValue_NotUsed_cht = @"未使用";
static NSString *SymphoxAPIParamValue_AlreadyUsed_cht = @"已使用";
static NSString *SymphoxAPIParamValue_Expired_cht = @"過期";
static NSString *SymphoxAPIParam_sort_column = @"sort_column";
static NSString *SymphoxAPIParamValue_worth = @"worth";
static NSString *SymphoxAPIParamValue_end_date = @"end_date";
static NSString *SymphoxAPIParam_sort_order = @"sort_order";
static NSString *SymphoxAPIParamValue_asc = @"asc";
static NSString *SymphoxAPIParamValue_desc = @"desc";
static NSString *SymphoxAPIParam_qty = @"qty";
static NSString *SymphoxAPIParam_amount = @"amount";
static NSString *SymphoxAPIParam_list = @"list";
static NSString *SymphoxAPIParam_worth = @"worth";
static NSString *SymphoxAPIParam_order_id = @"order_id";
static NSString *SymphoxAPIParam_campaign_url = @"campaign_url";
static NSString *SymphoxAPIParam_description = @"description";
static NSString *SymphoxAPIParam_start_date = @"start_date";
static NSString *SymphoxAPIParam_end_date = @"end_date";
static NSString *SymphoxAPIParam_product = @"product";
static NSString *SymphoxAPIParam_remark = @"remark";
static NSString *SymphoxAPIParam_free_point = @"free_point";
static NSString *SymphoxAPIParam_market_price = @"market_price";
static NSString *SymphoxAPIParam_is_quick = @"is_quick";
static NSString *SymphoxAPIParam_is_store = @"is_store";
static NSString *SymphoxAPIParam_discount = @"discount";
static NSString *SymphoxAPIParam_hall_discount = @"hall_discount";
static NSString *SymphoxAPIParam_campaign_discount = @"campaign_discount";
static NSString *SymphoxAPIParam_message = @"message";
static NSString *SymphoxAPIParam_price = @"price";
static NSString *SymphoxAPIParam_01 = @"01";
static NSString *SymphoxAPIParam_02 = @"02";
static NSString *SymphoxAPIParam_03 = @"03";
static NSString *SymphoxAPIParam_cash = @"cash";
static NSString *SymphoxAPIParam_text = @"text";
static NSString *SymphoxAPIParam_img_url = @"img_url";
static NSString *SymphoxAPIParam_specification = @"specification";
static NSString *SymphoxAPIParam_attention = @"attention";
static NSString *SymphoxAPIParam_standard = @"standard";
static NSString *SymphoxAPIParam_installment = @"installment";
static NSString *SymphoxAPIParam_term = @"term";
static NSString *SymphoxAPIParam_cathay_only = @"cathay_only";
static NSString *SymphoxAPIParam_shopping = @"shopping";
static NSString *SymphoxAPIParam_time = @"time";
static NSString *SymphoxAPIParam_delivery_type = @"delivery_type";
static NSString *SymphoxAPIParam_cart_id = @"cart_id";
static NSString *SymphoxAPIParam_cart_day = @"cart_day";
static NSString *SymphoxAPIParam_platform = @"platform";
static NSString *SymphoxAPIParam_order = @"order";
static NSString *SymphoxAPIParam_trade_mode = @"trade_mode";
static NSString *SymphoxAPIParam_delivery = @"delivery";
static NSString *SymphoxAPIParam_step = @"step";
static NSString *SymphoxAPIParam_item = @"item";
static NSString *SymphoxAPIParam_old_pwd = @"old_pwd";
static NSString *SymphoxAPIParam_subscribe = @"subscribe";
static NSString *SymphoxAPIParam_edm_id = @"edm_id";
static NSString *SymphoxAPIParam_cart_item_order = @"cart_item_order";
static NSString *SymphoxAPIParam_cart_type = @"cart_type";
static NSString *SymphoxAPIParam_payment_mode = @"payment_mode";
static NSString *SymphoxAPIError_E301 = @"E301";
static NSString *SymphoxAPIParam_cart_item = @"cart_item";
static NSString *SymphoxAPIParam_account_result = @"account_result";
static NSString *SymphoxAPIParam_total_Point = @"total_Point";
static NSString *SymphoxAPIParam_total_cash = @"total_cash";
static NSString *SymphoxAPIParam_total_cathay_cash = @"total_cathay_cash";
static NSString *SymphoxAPIParam_total_ePoint = @"total_ePoint";
static NSString *SymphoxAPIParam_cathay_cash = @"cathay_cash";
static NSString *SymphoxAPIParam_cpdt_marketing = @"cpdt_marketing";
static NSString *SymphoxAPIParam_cpdt_owner_num = @"cpdt_owner_num";
static NSString *SymphoxAPIParam_group_id = @"group_id";
static NSString *SymphoxAPIParam_max_sell_qty = @"max_sell_qty";
static NSString *SymphoxAPIParam_ori_cash = @"ori_cash";
static NSString *SymphoxAPIParam_ori_point = @"ori_point";
static NSString *SymphoxAPIParam_payment_mode_list = @"payment_mode_list";
static NSString *SymphoxAPIParam_cm_id = @"cm_id";
static NSString *SymphoxAPIParam_coupon_discount = @"coupon_discount";
static NSString *SymphoxAPIParam_cpoint = @"cpoint";
static NSString *SymphoxAPIParam_discount_detail_desc = @"discount_detail_desc";
static NSString *SymphoxAPIParam_discount_type_desc = @"discount_type_desc";
static NSString *SymphoxAPIParam_eacc_num = @"eacc_num";
static NSString *SymphoxAPIParam_used_payment_mode = @"used_payment_mode";
static NSString *SymphoxAPIParam_total_point = @"total_point";
static NSString *SymphoxAPIParam_additional_purchase = @"additional_purchase";
static NSString *SymphoxAPIParam_begin_time = @"begin_time";
static NSString *SymphoxAPIParam_end_time = @"end_time";
static NSString *SymphoxAPIParam_rank = @"rank";
static NSString *SymphoxAPIParam_pic_link = @"pic_link";
static NSString *SymphoxAPIParam_cpdt_price = @"cpdt_price";
static NSString *SymphoxAPIParam_cprg_num = @"cprg_num";
static NSString *SymphoxAPIParam_storage = @"storage";
static NSString *SymphoxAPIParam_trade_id = @"trade_id";
static NSString *SymphoxAPIParam_one_click_buy_member_delivery = @"one_click_buy_member_delivery";
static NSString *SymphoxAPIParam_installment_map = @"installment_map";
static NSString *SymphoxAPIParam_installment_term = @"installment_term";
static NSString *SymphoxAPIParam_installment_amount = @"installment_amount";
static NSString *SymphoxAPIParam_day_area_code = @"day_area_code";
static NSString *SymphoxAPIParam_day_tel = @"day_tel";
static NSString *SymphoxAPIParam_day_extension = @"day_extension";
static NSString *SymphoxAPIParam_night_area_code = @"night_area_code";
static NSString *SymphoxAPIParam_night_tel = @"night_tel";
static NSString *SymphoxAPIParam_night_extension = @"night_extension";
static NSString *SymphoxAPIParam_addr = @"addr";
static NSString *SymphoxAPIParam_cell_phone = @"cell_phone";
static NSString *SymphoxAPIParam_order_num = @"order_num";
static NSString *SymphoxAPIParam_contact_num = @"contact_num";
static NSString *SymphoxAPIParam_contact_seq = @"contact_seq";
static NSString *SymphoxAPIParam_contact_name = @"contact_name";
static NSString *SymphoxAPIParam_contact_tel = @"contact_tel";
static NSString *SymphoxAPIParam_contact_mtel = @"contact_mtel";
static NSString *SymphoxAPIParam_contact_addr = @"contact_addr";
static NSString *SymphoxAPIParam_contact_zip = @"contact_zip";
static NSString *SymphoxAPIParam_contact_attn_status = @"contact_attn_status";
static NSString *SymphoxAPIParam_contact_member_status = @"contact_member_status";
static NSString *SymphoxAPIParam_cellphone = @"cellphone";
static NSString *SymphoxAPIParam_inv_name = @"inv_name";
static NSString *SymphoxAPIParam_inv_tel = @"inv_tel";
static NSString *SymphoxAPIParam_inv_zip = @"inv_zip";
static NSString *SymphoxAPIParam_inv_address = @"inv_address";
static NSString *SymphoxAPIParam_inv_regno = @"inv_regno";
static NSString *SymphoxAPIParam_notes = @"notes";
static NSString *SymphoxAPIParam_inpoban = @"inpoban";
static NSString *SymphoxAPIValue_inpoban1 = @"51811";
static NSString *SymphoxAPIValue_inpoban2 = @"919";
static NSString *SymphoxAPIValue_inpoban3 = @"8455";
static NSString *SymphoxAPIParam_icarrier_type = @"icarrier_type";
static NSString *SymphoxAPIValue_icarrier_member = @"EG0031";
static NSString *SymphoxAPIValue_icarrier_naturalperson = @"CQ0001";
static NSString *SymphoxAPIValue_icarrier_cellphone_barcode = @"3J0002";
static NSString *SymphoxAPIParam_icarrier_id = @"icarrier_id";
static NSString *SymphoxAPIParam_store_id = @"store_id";
static NSString *SymphoxAPIParam_store_name = @"store_name";
static NSString *SymphoxAPIParam_store_addr = @"store_addr";
static NSString *SymphoxAPIParam_store_tel = @"store_tel";
static NSString *SymphoxAPIParam_time_slice = @"time_slice";
static NSString *SymphoxAPIParam_is_invoice_order = @"is_invoice_order";
static NSString *SymphoxAPIParam_carrier = @"carrier";
static NSString *SymphoxAPIParam_is_mask = @"is_mask";
static NSString *SymphoxAPIParam_as_shipping = @"as_shipping";
static NSString *SymphoxAPIParam_zip_city = @"zip_city";
static NSString *SymphoxAPIParam_townList = @"townList";
static NSString *SymphoxAPIParam_zip_town = @"zip_town";
static NSString *SymphoxAPIParam_zip_num = @"zip_num";
static NSString *SymphoxAPIParam_cpro_carrier = @"cpro_carrier";
static NSString *SymphoxAPIParam_cpdt_nums = @"cpdt_nums";
static NSString *SymphoxAPIParam_goods = @"goods";
static NSString *SymphoxAPIParam_shopping_delivery = @"shopping_delivery";
static NSString *SymphoxAPIParam_auth_amount = @"auth_amount";
static NSString *SymphoxAPIParam_card_no = @"card_no";
static NSString *SymphoxAPIParam_card_expired_date = @"card_expired_date";
static NSString *SymphoxAPIParam_card_cvc2 = @"card_cvc2";
static NSString *SymphoxAPIParam_shopping_order_term = @"shopping_order_term";
static NSString *SymphoxAPIParam_login_date = @"login_date";
static NSString *SymphoxAPIParam_login_ip = @"login_ip";
static NSString *SymphoxAPIParam_press_date = @"press_date";
static NSString *SymphoxAPIParam_shopping_payment = @"shopping_payment";
static NSString *SymphoxAPIParam_used_eacc_num = @"used_eacc_num";
static NSString *SymphoxAPIParam_order_items = @"order_items";
static NSString *SymphoxAPIParam_items = @"items";
static NSString *SymphoxAPIParam_atm_bk_code = @"atm_bk_code";
static NSString *SymphoxAPIParam_atm_code = @"atm_code";
static NSString *SymphoxAPIParam_atm_deadline = @"atm_deadline";
static NSString *SymphoxAPIParam_messageUi = @"messageUi";
static NSString *SymphoxAPIParam_timeStr = @"timeStr";
static NSString *SymphoxAPIParam_msgType = @"msgType";
static NSString *SymphoxAPIParam_hallId = @"hallId";
static NSString *SymphoxAPIParam_hallName = @"hallName";
static NSString *SymphoxAPIParam_pure_price = @"pure_price";
static NSString *SymphoxAPIParam_pure_point = @"pure_point";
static NSString *SymphoxAPIParam_mix_price = @"mix_price";
static NSString *SymphoxAPIParam_mix_point = @"mix_point";
static NSString *SymphoxAPIParam_can_used_cart = @"can_used_cart";
static NSString *SymphoxAPIParam_storeid = @"storeid";
static NSString *SymphoxAPIParam_storename = @"storename";
static NSString *SymphoxAPIParam_url = @"url";
static NSString *SymphoxAPIParam_is_wh = @"is_wh";
static NSString *SymphoxAPIParam_inv_bind = @"inv_bind";
static NSString *SymphoxAPIParam_device_id = @"device_id";
static NSString *SymphoxAPIParam_device_token = @"device_token";
static NSString *SymphoxAPIParam_user_sn = @"user_sn";
static NSString *SymphoxAPIParam_device_type = @"device_type";
static NSString *SymphoxAPIParam_keyWord = @"keyWord";
static NSString *SymphoxAPIParam_discount_cash_desc = @"discount_cash_desc";
static NSString *SymphoxAPIParam_tot_dis_coupon_qty = @"tot_dis_coupon_qty";
static NSString *SymphoxAPIParam_tot_dis_coupon_worth = @"tot_dis_coupon_worth";
static NSString *SymphoxAPIParam_tot_dis_other_cash = @"tot_dis_other_cash";
static NSString *SymphoxAPIParam_tot_dis_cash = @"tot_dis_cash";
static NSString *SymphoxAPIParam_provision = @"provision";
static NSString *SymphoxAPIParam_real_cpdt_num = @"real_cpdt_num";
static NSString *SymphoxAPIParam_tmp_point = @"tmp_point";
static NSString *SymphoxAPIParam_delivery_limit = @"delivery_limit";
static NSString *SymphoxAPIParam_reach_limit = @"reach_limit";
static NSString *SymphoxAPIParam_raise = @"raise";
static NSString *SymphoxAPIParam_multiple = @"multiple";
static NSString *SymphoxAPIParam_location = @"location";

typedef enum : NSUInteger {
    TermTypeMemberTerms,
    TermTypeExchangeDescription,
    TermTypeInstallmentBank,
    TermTypeShippingAndWarrenty,
    TermTypeEcommertialTerm,
    TermTypeInvoiceCreate,
    TermTypePurchaseComplete,
    TermTypeTotal
} TermType;

#endif /* APIDefinition_h */
