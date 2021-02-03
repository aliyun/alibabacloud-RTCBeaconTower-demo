

#import <Foundation/Foundation.h>

typedef void (^CKNotifyBlock)(NSNotification *note);

@interface NSObject (CKNotify)

///监听通知（如果self被释放，将会自动清除通知不需要手动停止监听；返回observer对象）
- (id)observeNotificationByName:(NSString *)name withNotifyBlock:(CKNotifyBlock)block;
- (id)observeNotificationByName:(NSString *)name withObject:(id)object notifyBlock:(CKNotifyBlock)block;
- (id)observeNotificationByName:(NSString *)name withSelector:(SEL)selector;
- (id)observeNotificationByName:(NSString *)name withObject:(id)object selector:(SEL)selector;
- (BOOL)isObservedNotificationByName:(NSString *)name;

///主动停止通知监听
- (void)removeAllObservedNotifications;
- (void)removeObservedNotificationByName:(NSString *)name;
- (void)removeObservedNotificationByName:(NSString *)name object:(id)object;

#pragma mark - Deprecated
- (void)listenNotificationByName:(NSString *)name withNotifyBlock:(void(^)(NSNotification *note, id weakSelf))block __deprecated_msg("Use observeNotificationByName:withNotifyBlock:");
- (void)listenNotificationByName:(NSString *)name withObject:(id)object notifyBlock:(void(^)(NSNotification *note, id weakSelf))block __deprecated_msg("Use observeNotificationByName:withObject:notifyBlock:");
- (BOOL)isListenedNotificationByName:(NSString *)name __deprecated_msg("Use isObservedNotificationByName:");
@end

