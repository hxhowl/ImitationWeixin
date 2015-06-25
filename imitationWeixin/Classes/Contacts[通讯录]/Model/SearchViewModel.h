//
//  SearchViewModel.h
//  imitationWeixin
//
//  Created by 黄 晨鹏 on 15/6/17.
//  Copyright (c) 2015年 mikado_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface SearchViewModel : NSObject
singleton_interface(SearchViewModel)
@property(nonatomic, copy) NSString *searchFieldText;
@end
