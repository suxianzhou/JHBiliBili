//
//  FindViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "FindViewModel.h"
@interface FindViewModel ()
@property (nonatomic, strong) NSMutableArray<FindDataModel*>* rankArr;
@property (nonatomic, strong) NSMutableArray<FindImgDataModel*>* rankImgArr;
@end

@implementation FindViewModel

- (NSInteger)rankArrConut{
    return self.rankArr.count;
}

- (NSString*)keyWordForRow:(NSInteger)row{
    return self.rankArr[row].keyword;
}
- (NSString*)statusWordForRow:(NSInteger)row{
    return self.rankArr[row].status;
}
- (NSURL*)rankCoverForNum:(NSInteger)num{
    return [NSURL URLWithString:self.rankImgArr[num].cover];
}
- (NSString*)coverKeyWordForNum:(NSInteger)num{
    return self.rankImgArr[num].keyword;
}
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [FindNetManager GetRankCompletionHandler:^(FindModel* responseObj, NSError *error) {
        [self.rankArr removeAllObjects];
        self.rankArr = [responseObj.list mutableCopy];
        [ArchiverObj archiveWithObj:responseObj];
        [FindNetManager GetRankImgCompletionHandler:^(FindImgModel* responseObj1, NSError *error) {
            [self.rankImgArr removeAllObjects];
            self.rankImgArr = [responseObj1.recommend mutableCopy];
            [ArchiverObj archiveWithObj:responseObj1];
            complete(error);
        }];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray<FindImgDataModel *> *)rankImgArr{
    if (_rankImgArr == nil) {
        FindImgModel* model = [ArchiverObj UnArchiveWithClass:[FindImgModel class]];
        if (model != nil) {
            _rankImgArr = [model.recommend mutableCopy];
        }else{
            _rankImgArr = [NSMutableArray array];
        }
    }
    return _rankImgArr;
}

- (NSMutableArray<FindDataModel *> *)rankArr{
    if (_rankArr == nil) {
        FindModel* model = [ArchiverObj UnArchiveWithClass:[FindModel class]];
        if (model == nil) {
            _rankArr = [NSMutableArray array];
        }else{
            _rankArr = [model.list mutableCopy];
        }
    }
    return _rankArr;
}
@end
