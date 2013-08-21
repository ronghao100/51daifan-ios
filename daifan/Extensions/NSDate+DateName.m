#import "NSDate+DateName.h"


@implementation NSDate (DateName)

+ (NSDate *)tomorrow {
    return [[NSDate date] dateByAddingDays:1];
}

+ (NSDate *)today {
    return [NSDate date];
}

+ (NSDate *)yesterday {
    return [[NSDate date] dateByAddingDays:-1];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:days];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

@end