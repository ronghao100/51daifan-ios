#import <Foundation/Foundation.h>

#define TIMELINE_WIDTH_NORMAL 3.0f
#define COVER_VIEW_HEIGHT 150.0f
#define FOOTER_VIEW_HEIGHT 60.0f

#define DEFAULT_KEYBOARD_HEIGHT 216.0f
#define DEFAULT_PADDING 10.0f

#define DEFAULT_NAVIGATION_HEIGHT 44.0f
#define DEFAULT_BUTTON_HEIGHT 44.0f
#define DEFAULT_TEXTFIELD_HEIGHT 31.0f

#define NAME_LABEL_COLOR @"#5177D6"
#define SUBTITLE_LABEL_COLOR @"#999999"
#define COUNT_LABEL_COLOR @"#B7B7B7"
#define COUNT_NUMBER_COLOR @"#557DE6"
#define COMMENT_TEXT_COLOR @"#666666"
#define SEPARATOR_LINE_COLOR @"#D8E2E6"

#define kRESPONSE_ERROR @"error"
#define kRESPONSE_SUCCESS @"success"
#define kRESPONSE_USER @"user"
#define kRESPONSE_POSTS @"posts"
#define kRESPONSE_BOOKED_USER_ID @"bookedUidNames"

#define kKEYCHAIN_SERVICE @"51daifan"
#define kCURRENT_USER_ID @"current_user_id"
#define kCURRENT_USER_NAME @"current_user_name"
#define kCURRENT_USER_EMAIL @"current_user_email"

#define RESPONSE_NOT_SUCCESS 0
#define RESPONSE_SUCCESS 1

#define API_HOST @"http://51daifan.sinaapp.com"

#define API_POST_PATH @"/api/posts"
#define API_POST_NEW_LIST_PARAMETER @"?type=0"
#define API_POST_NEWER_LIST_PARAMETER @"?type=1&currentId=%ld"
#define API_POST_OLDER_LIST_PARAMETER @"?type=2&currentId=%ld"

#define API_LOGIN_PATH @"/api/login"
#define API_LOGIN_PARAMETER @"?email=%@&password=%@"

#define API_BOOK_PATH @"/api/book"
#define API_BOOK_PARAMETER @"?postId=%ld&food_owner_id=%ld&food_owner_name=%@&userId=%ld&userName=%@"

#define API_UNBOOK_PATH @"/api/undo-book"
#define API_UNBOOK_PARAMETER @"?postId=%ld&userId=%ld"