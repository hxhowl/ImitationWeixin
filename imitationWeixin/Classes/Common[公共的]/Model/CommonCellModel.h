//
//  CommonCellModel.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/16.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonCellModel : NSObject
@property(nonatomic, copy) NSString *iconItem;
@property(nonatomic, copy) NSString *labelItem;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) CommonCellWithDict:(NSDictionary *)dict;


@end
