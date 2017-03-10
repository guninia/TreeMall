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
static NSString *SymphoxAPI_token = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/token";
static NSString *SymphoxAPI_homepage = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_promotion = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_register = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/register";
static NSString *SymphoxAPI_login = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/identify";
static NSString *SymphoxAPI_terms = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_forgetPassword = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/password/forget";
static NSString *SymphoxAPI_mobileVerification = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/verify/mobile";
static NSString *SymphoxAPI_authenticationCreditCard = @"http://tomcat8.mdevelop.com/TreeMall/authId/bank.do";
static NSString *SymphoxAPI_authenticationEmployee = @"http://tomcat8.mdevelop.com/TreeMall/authId/employee.do";
static NSString *SymphoxAPI_authenticationCathayCustomer = @"http://tomcat8.mdevelop.com/TreeMall/authId/cathay.do";
static NSString *SymphoxAPI_MainCategories = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_Subcategories = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/mall/hall";
static NSString *SymphoxAPI_Search = @"http://tomcat8.mdevelop.com/TreeMall/api/eiffel/search/treemall";
static NSString *SymphoxAPI_mainCategoryNameMapping = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_hotKeywords = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/mall/keyword";
static NSString *SymphoxAPI_memberInformation = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/info";
static NSString *SymphoxAPI_memberPoint = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/point";
static NSString *SymphoxAPI_memberCoupon = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/ecoupon";
static NSString *SymphoxAPI_productDetail = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/mall/product";

#else
static NSString *SymphoxAPI_token = @"https://api.symphox.com.tw/portal/app/token";
#endif

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

static NSString *SymphoxAPIError_E301 = @"E301";

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
