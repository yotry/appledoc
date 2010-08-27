//
//  GBTestObjectsRegistry.m
//  appledoc
//
//  Created by Tomaz Kragelj on 26.7.10.
//  Copyright (C) 2010, Gentle Bytes. All rights reserved.
//

#import "GBApplicationSettingsProviding.h"
#import "GBDataObjects.h"
#import "GBTestObjectsRegistry.h"

@implementation GBTestObjectsRegistry

#pragma mark Common objects creation methods

+ (OCMockObject *)mockSettingsProvider {
	return [OCMockObject niceMockForProtocol:@protocol(GBApplicationSettingsProviding)];
}

#pragma mark GBIvarData creation methods

+ (GBIvarData *)ivarWithComponents:(NSString *)first, ... {
	va_list args;
	va_start(args, first);
	NSMutableArray *components = [NSMutableArray array];
	for (NSString *argument=first; argument!=nil; argument=va_arg(args, NSString*)) {
		[components addObject:argument];
	}
	va_end(args);
	return [GBIvarData ivarDataWithComponents:components];
}

#pragma mark GBMethodData creation methods

+ (GBMethodData *)instanceMethodWithArguments:(GBMethodArgument *)first,... {
	va_list args;
	va_start(args, first);
	NSMutableArray *arguments = [NSMutableArray array];
	for (GBMethodArgument *argument=first; argument!=nil; argument=va_arg(args, GBMethodArgument*)) {
		[arguments addObject:argument];
	}
	va_end(args);
	return [GBMethodData methodDataWithType:GBMethodTypeInstance result:[NSArray arrayWithObject:@"void"] arguments:arguments];
}

+ (GBMethodData *)classMethodWithArguments:(GBMethodArgument *)first,... {
	va_list args;
	va_start(args, first);
	NSMutableArray *arguments = [NSMutableArray array];
	for (GBMethodArgument *argument=first; argument!=nil; argument=va_arg(args, GBMethodArgument*)) {
		[arguments addObject:argument];
	}
	va_end(args);
	return [GBMethodData methodDataWithType:GBMethodTypeClass result:[NSArray arrayWithObject:@"void"] arguments:arguments];
}

+ (GBMethodData *)instanceMethodWithNames:(NSString *)first,... {
	va_list args;
	va_start(args, first);
	NSMutableArray *arguments = [NSMutableArray array];
	for (NSString *name=first; name!=nil; name=va_arg(args, NSString*)) {
		GBMethodArgument *argument = [self typedArgumentWithName:name];
		[arguments addObject:argument];
	}
	va_end(args);
	return [GBMethodData methodDataWithType:GBMethodTypeInstance result:[NSArray arrayWithObject:@"void"] arguments:arguments];
}

+ (GBMethodData *)classMethodWithNames:(NSString *)first,... {
	va_list args;
	va_start(args, first);
	NSMutableArray *arguments = [NSMutableArray array];
	for (NSString *name=first; name!=nil; name=va_arg(args, NSString*)) {
		GBMethodArgument *argument = [self typedArgumentWithName:name];
		[arguments addObject:argument];
	}
	va_end(args);
	return [GBMethodData methodDataWithType:GBMethodTypeClass result:[NSArray arrayWithObject:@"void"] arguments:arguments];
}

+ (GBMethodData *)propertyMethodWithArgument:(NSString *)name {
	GBMethodArgument *argument = [GBMethodArgument methodArgumentWithName:name];
	return [GBMethodData methodDataWithType:GBMethodTypeProperty result:[NSArray arrayWithObject:@"int"] arguments:[NSArray arrayWithObject:argument]];
}

+ (GBMethodArgument *)typedArgumentWithName:(NSString *)name {
	return [GBMethodArgument methodArgumentWithName:name types:[NSArray arrayWithObject:@"id"] var:name];
}

#pragma mark GBStore creation methods

+ (void)registerComment:(id)comment forObject:(GBModelBase *)object {
	[object setValue:comment forKey:@"_comment"];
}

+ (GBStore *)storeWithClassWithComment:(id)comment {
	GBClassData *class = [GBClassData classDataWithName:@"Class"];
	[self registerComment:comment forObject:class];
	return [self storeByPerformingSelector:@selector(registerClass:) withObject:class];
}

+ (GBStore *)storeWithCategoryWithComment:(id)comment {
	GBCategoryData *category = [GBCategoryData categoryDataWithName:@"Category" className:@"Class"];
	[self registerComment:comment forObject:category];
	return [self storeByPerformingSelector:@selector(registerCategory:) withObject:category];
}

+ (GBStore *)storeWithProtocolWithComment:(id)comment {
	GBProtocolData *protocol = [GBProtocolData protocolDataWithName:@"Protocol"];
	[self registerComment:comment forObject:protocol];
	return [self storeByPerformingSelector:@selector(registerProtocol:) withObject:protocol];
}

+ (GBStore *)storeByPerformingSelector:(SEL)selector withObject:(id)object {
	GBStore *result = [[GBStore alloc] init];
	[result performSelector:selector withObject:object];
	return result;
}

+ (GBMethodData *)instanceMethodWithName:(NSString *)name comment:(id)comment {
	GBMethodData *result = [self instanceMethodWithNames:name, nil];
	[self registerComment:comment forObject:result];
	return result;
}

@end
