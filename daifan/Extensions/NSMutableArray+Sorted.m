#import "NSMutableArray+Sorted.h"

@implementation NSMutableArray (Sorted)

- (void)insertOrReplaceObjectSorted:(id)anObject {
    NSUInteger index = [self indexForInsertObject:anObject];

    if (index == self.count) {
        [self addObject:anObject];
        return;
    }

    if ([anObject compare:[self objectAtIndex:index]] == NSOrderedSame) {
        [self replaceObjectAtIndex:index withObject:anObject];
    } else {
        [self insertObject:anObject atIndex:index];
    }
}

- (NSUInteger)indexForInsertObject:(id)anObject {
    NSUInteger leftIndex = 0;
    NSUInteger rightIndex = [self count];

    while (leftIndex < rightIndex) {
        NSUInteger midIndex = (leftIndex + rightIndex) / 2;

        id anotherObject = [self objectAtIndex:midIndex];
        if ([anObject compare:anotherObject] == NSOrderedAscending) {
            if (rightIndex == midIndex) {
                -- rightIndex;
            } else {
                rightIndex = midIndex;
            }
        } else {
            if (leftIndex == midIndex) {
                ++ leftIndex;
            } else {
                leftIndex = midIndex;
            }
        }
    }

    return leftIndex;
}

@end