#import "DFUserList.h"

@implementation DFUserList {
    NSMutableDictionary *_list;
}

+ (DFUserList *)sharedList {
    static DFUserList *sharedUserList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserList = [[self alloc] init];
    });
    return sharedUserList;
}

- (id)init {
    self = [super init];
    if (self) {
        _list = [NSMutableDictionary dictionaryWithCapacity:10];
    }

    return self;
}

- (NSString *)userNameByID:(NSString *)userID {
    return [_list objectForKey:userID];
}

- (void)mergeUserDict:(NSDictionary *)userDict {
    [_list addEntriesFromDictionary:userDict];
}

@end