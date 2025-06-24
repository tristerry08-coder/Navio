#import "Bridging.h"

#include "base/logging.hpp"
#include "editor/server_api.hpp"
#include "platform/platform.hpp"
#include "private.h"

#import "MWMAuthorizationCommon.h"

using namespace osm;

@implementation Bridging


+ (void)saveOauthTokenFrom:(NSString * _Nonnull)oauthCode
{
  NSString *oauthToken = @(OsmOAuth::ServerAuth().FinishAuthorization([oauthCode UTF8String]).c_str());
  OsmOAuth::ServerAuth().SetAuthToken([oauthToken UTF8String]);
  osm_auth_ios::AuthorizationStoreCredentials([oauthToken UTF8String]);
}


@end
