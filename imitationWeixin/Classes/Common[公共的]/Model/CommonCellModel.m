//
//  CommonCellModel.m
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/16.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import "CommonCellModel.h"

@implementation CommonCellModel

- (instancetype) initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //使用此KVC方法能给成员变量赋值，前提是传进来的dict的key和成员变量同名，成员变量名与dict的key值不同或者成员变量与dict键值对数量不同时均会崩溃。如果数量不同或者希望保持名字不同，就self.a = [dict valueForKey:@"b"];一个个传值。
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype) CommonCellWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
