//
//  DMTaskTracksView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTaskTracksModel.h"

@interface DMTaskTracksView : UIView
@property (nonatomic, strong) NSMutableArray<DMTaskTracksModel *> *taskTracks;
@end
