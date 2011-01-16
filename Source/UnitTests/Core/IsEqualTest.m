//
//  OCHamcrest - IsEqualTest.m
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

    // Inherited
#import "AbstractMatcherTest.h"

    // OCHamcrest
#define HC_SHORTHAND
#import <OCHamcrest/HCAssertThat.h>
#import <OCHamcrest/HCIsEqual.h>
#import <OCHamcrest/HCIsNot.h>


@interface FakeArgument : NSObject
@end

@implementation FakeArgument
- (NSString*) description  { return @"ARGUMENT DESCRIPTION"; }
@end

//--------------------------------------------------------------------------------------------------

@interface AlwaysEqual : NSObject
@end

@implementation AlwaysEqual
- (BOOL) isEqual:(id)anObject  { return YES; }
@end

//--------------------------------------------------------------------------------------------------

@interface NeverEqual : NSObject
@end

@implementation NeverEqual
- (BOOL) isEqual:(id)anObject  { return NO; }
@end

//--------------------------------------------------------------------------------------------------

@interface IsEqualTest : AbstractMatcherTest
@end

@implementation IsEqualTest

- (id<HCMatcher>) createMatcher
{
    return equalTo(@"irrelevant");
}


- (void) testComparesObjectsUsingIsEqualMethod
{
    assertThat(@"hi", equalTo(@"hi"));
    assertThat(@"bye", isNot(equalTo(@"hi")));
}


- (void) testCanCompareNilValues
{
    assertThat(nil, equalTo(nil));

    assertThat(nil, isNot(equalTo(@"hi")));
    assertThat(@"hi", isNot(equalTo(nil)));
}


- (void) testHonorsIsEqualImplementationEvenWithNilValues
{
    assertThat([[[AlwaysEqual alloc] init] autorelease], equalTo(nil));
    assertThat([[[NeverEqual alloc] init] autorelease], isNot(equalTo(nil)));
}


- (void) testIncludesTheResultOfCallingDescriptionOnItsArgumentInTheDescription
{
    assertDescription(@"<ARGUMENT DESCRIPTION>", equalTo([[[FakeArgument alloc] init] autorelease]));
}


- (void) testReturnsAnObviousDescriptionIfCreatedWithANestedMatcherByMistake
{
    id innerMatcher = equalTo(@"NestedMatcher");
    assertDescription(([[NSArray arrayWithObjects:@"<", [innerMatcher description], @">", nil]
                            componentsJoinedByString:@""]),
                      equalTo(innerMatcher));
}


- (void) testReturnsGoodDescriptionIfCreatedWithNilReference
{
    assertDescription(@"nil", equalTo(nil));
}


- (void) testSuccessfulMatchDoesNotGenerateMismatchDescription
{
    assertNoMismatchDescription(equalTo(@"hi"), @"hi");
}


- (void) testMismatchDescriptionShowsActualArgument
{
    assertMismatchDescription(@"was \"bad\"",
                              equalTo(@"good"),
                              @"bad");
}


- (void) testDescribeMismatch
{
    assertDescribeMismatch(@"was \"bad\"",
                           equalTo(@"good"),
                           @"bad");
}

@end
