#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PostMessageInterface : NSObject

@property (nonatomic, strong) NSMutableDictionary *adUnitInfo;

- (void)setCoppa:(BOOL)isCoppa;
- (void)setYob:(NSString *)yob;
- (void)setGender:(NSString *)gender;
- (void)addSegment:(NSString *)value key:(NSString *)key;
- (void)setSegment:(NSString *)value key:(NSString *)key;

- (NSString *)toJSONString;

@end
