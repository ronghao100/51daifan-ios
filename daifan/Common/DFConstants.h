#import <Foundation/Foundation.h>

#define TIMELINE_WIDTH_NORMAL 3.0f
#define COVER_VIEW_HEIGHT 100.0f
#define FOOTER_VIEW_HEIGHT 80.0f

#define kRESPONSE_ERROR @"error"
#define kRESPONSE_SUCCESS @"success"
#define kRESPONSE_USER @"user"

#define kKEYCHAIN_SERVICE @"51daifan"

#define API_HOST @"http://51daifan.sinaapp.com"

#define API_POST_PATH @"/api/posts"
#define API_POST_NEW_LIST_PARAMETER @"?type=0"
#define API_POST_NEWER_LIST_PARAMETER @"?type=1&currentId=%d"
#define API_POST_OLDER_LIST_PARAMETER @"?type=2&currentId=%d"

#define API_LOGIN_PATH @"/api/login"
#define API_LOGIN_PARAMETER @"?email=%@&password=%@"