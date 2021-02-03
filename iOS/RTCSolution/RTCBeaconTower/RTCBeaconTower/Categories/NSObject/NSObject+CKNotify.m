
#import "NSObject+CKNotify.h"
#import <objc/runtime.h>

static char CKNotifyObserverMapKey;

@interface _CKNotifyObserverMap_ : NSObject
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation _CKNotifyObserverMap_
- (id)init {
    if ((self = [super init])) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [self removeAllObservers];
}

- (void)setObserver:(id)observer forKey:(NSString *)key object:(id)object {
    NSMapTable *map = self.dict[key];
    object = object ?: self;
    if (!map) {
        map = [NSMapTable weakToStrongObjectsMapTable];
        [map setObject:observer forKey:object];
        [self.dict setObject:map forKey:key];
    } else {
        id oldObserver = [map objectForKey:object];
        if (oldObserver) {
            [[NSNotificationCenter defaultCenter] removeObserver:oldObserver];
        }
        [map setObject:observer forKey:object];
    }
}

- (id)observerForKey:(NSString *)key object:(id)object {
    NSMapTable *table = self.dict[key];
    return table ? [table objectForKey:object] : nil;
}

- (void)removeAllObservers {
    NSArray *allValues = self.dict.allValues;
    for (NSMapTable *map in allValues) {
        for (id observer in map.objectEnumerator) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
    }
    [self.dict removeAllObjects];
}

- (void)removeObserverForKey:(NSString *)key object:(id)object {
    NSMapTable *map = [self.dict objectForKey:key];
    if (!map) {
        return;
    }
    if (object) {
        id observer = [map objectForKey:object];
        if (!observer) {
            return;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        [map removeObjectForKey:object];
        if (map.count == 0) {
            [self.dict removeObjectForKey:key];
        }
    } else {
        for (id observer in map.objectEnumerator) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        [self.dict removeObjectForKey:key];
    }
}

- (BOOL)isEmpty {
    return self.dict.count == 0;
}

@end

@implementation NSObject (CKNotify)
static char CKNotifyObserverMapKey;

#pragma mark - Observe notifaction
- (id)observeNotificationByName:(NSString *)name withNotifyBlock:(CKNotifyBlock)block {
    return [self observeNotificationByName:name withObject:nil notifyBlock:block];
}

- (id)observeNotificationByName:(NSString *)name withObject:(id)object notifyBlock:(CKNotifyBlock)block {
    NSOperationQueue *op = [NSOperationQueue mainQueue];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:op usingBlock:block];
    _CKNotifyObserverMap_ *map = objc_getAssociatedObject(self, &CKNotifyObserverMapKey);
    if (!map) {
        map = [[_CKNotifyObserverMap_ alloc] init];
        objc_setAssociatedObject(self, &CKNotifyObserverMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [map setObserver:observer forKey:name object:object];
    return observer;
}

- (id)observeNotificationByName:(NSString *)name withSelector:(SEL)selector {
    return [self observeNotificationByName:name withObject:nil selector:selector];
}

- (id)observeNotificationByName:(NSString *)name withObject:(id)object selector:(SEL)selector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    __weak typeof(self) weakSelf = self;
    return [self observeNotificationByName:name withObject:object notifyBlock:^(NSNotification *note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf performSelector:selector withObject:note];
    }];
#pragma clang diagnostic pop
 }

- (BOOL)isObservedNotificationByName:(NSString *)name {
    _CKNotifyObserverMap_ *map = objc_getAssociatedObject(self, &CKNotifyObserverMapKey);
    if (map) {
        if ([map observerForKey:name object:nil]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Remove notifaction observer
- (void)removeAllObservedNotifications {
    _CKNotifyObserverMap_ *dic = objc_getAssociatedObject(self, &CKNotifyObserverMapKey);
    if (dic) {
        [dic removeAllObservedNotifications];
        objc_setAssociatedObject(self, &CKNotifyObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)removeObservedNotificationByName:(NSString *)name {
    return [self removeObservedNotificationByName:name object:nil];
}

- (void)removeObservedNotificationByName:(NSString *)name object:(id)object {
    _CKNotifyObserverMap_ *dic = objc_getAssociatedObject(self, &CKNotifyObserverMapKey);
    if (dic) {
        [dic removeObserverForKey:name object:object];
        if ([dic isEmpty]) {
            objc_setAssociatedObject(self, &CKNotifyObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
#pragma mark - Deprecated
- (void)listenNotificationByName:(NSString *)name withNotifyBlock:(void(^)(NSNotification *note, id weakSelf))block {
    [self listenNotificationByName:name withObject:nil notifyBlock:block];
}

- (void)listenNotificationByName:(NSString *)name withObject:(id)object notifyBlock:(void(^)(NSNotification *note, id weakSelf))block {
    __weak typeof(self) weakSelf = self;
    [self observeNotificationByName:name withObject:object notifyBlock:^(NSNotification *note) {
        block(note, weakSelf);
    }];
}

- (BOOL)isListenedNotificationByName:(NSString *)name {
    return [self isObservedNotificationByName:name];
}

@end
