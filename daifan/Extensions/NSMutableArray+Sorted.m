#import "NSMutableArray+Sorted.h"

@implementation NSMutableArray (Sorted)

- (void)insertObjectSorted:(id)anObject {
    [self insertObject:anObject atIndex:[self indexForInsertObject:anObject]];
}

- (NSUInteger)indexForInsertObject:(id)anObject {
    NSUInteger leftIndex = 0;
    NSUInteger rightIndex = [self count];

    while (leftIndex < rightIndex) {
        NSUInteger midIndex = (leftIndex + rightIndex) / 2;

        id anotherObject = [self objectAtIndex:midIndex];
        if ([anObject compare:anotherObject] == NSOrderedAscending) {
            rightIndex = midIndex;
        } else {
            leftIndex = midIndex;
        }
    }

    return leftIndex;
}

@end