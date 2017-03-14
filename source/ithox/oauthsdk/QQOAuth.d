module ithox.oauthsdk.QQOAuth;

import ithox.oauthsdk.IOAuth;

import std.string, std.array,std.json;
import std.format;
import std.experimental.logger;

alias logInfo = log;
alias logErrorF = logf;

//QQ登录
class QQOAuth : AbstractIthoxOAuth{


    enum VERSION = "2.0";


     enum string GET_OPENID_URL = "https://graph.qq.com/oauth2.0/me";

	 enum string GET_USER_INFO = "https://graph.qq.com/user/get_user_info";

	 override string getAuthCodeURL(){
		  return "https://graph.qq.com/oauth2.0/authorize";
	  }

	 override string getAccessTokenURL()
	  {
		  return "https://graph.qq.com/oauth2.0/token";
	  }
	 ///获取accessToken
	override string getAccessToken(string code, ref string refresh_token)
	 {
		 import std.format;
		 import std.uri;
		 auto url = format("%s?grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s&state=%s&redirect_uri=%s",
						   this.getAccessTokenURL(), appId, appKey,code, state, encodeComponent(callback_url));
		 import std.net.curl;
		 //access_token=8E493C4DE48690A9025230A2AFC41658&expires_in=7776000&refresh_token=00000A86980A0935295F07C22B94A8E6
		auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
		 string content = cast(string)get(url, conn);
		 debug(ITHOX_OAUTH_SDK)
		 {
			 logInfo("QQ:getAccessToken:", content);
		 }
		 import std.string, std.array;
		 string access_token = "";
		 foreach(t;content.split('&'))
		 {
			 if(t.indexOf("access_token=")!= -1)
			 {
				 access_token = t[13 .. $];
				 continue;
			 }
			 else if(t.indexOf("refresh_token") != -1)
			 {
				 refresh_token = t[14 .. $];
				 continue;
			 }
		 }
		 return access_token;
	 }
	///获取用户唯一标示
	override string getOpenID(string access_token)
	 {
		 import std.net.curl, std.array, std.string;
		 auto url = GET_OPENID_URL ~ "?access_token=" ~access_token;
		 //callback( {"client_id":"101268543","openid":"A4A46E9B25DA6BACDEC60A454FB1CDE0"} );
		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
  		string re = cast(string)get(url,conn);
		// auto re = q{callback( {"client_id":"101268543","openid":"A4A46E9B25DA6BACDEC60A454FB1CDE0"} )};
		 debug(ITHOX_OAUTH_SDK)
		 {
			 logInfo("QQ:getOpenID:", re);
		 }
		 auto start = re.indexOf("{");
		 auto end = re.lastIndexOf("}");
		 return re[start .. end+1];
	 }

	override JSONValue getUserInfo(string[string] pars)
	{
		try{
			auto url = format("%s?access_token=%s&oauth_consumer_key=%s&openid=%s", 
							  GET_USER_INFO, 
							  pars["access_token"],
							  pars["appid"],
							  pars["openid"]
							 );
			debug(ITHOX_OAUTH_SDK)
			{
				logInfo("QQ:getUserInfo:url:", url);
			}
			import std.net.curl;
		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
			string re = cast(string)get(url, conn);
			return parseJSON(re);
		}
		catch(Exception e)
		{
			log("QQOAuth:getUserInfo:error:%s", e.msg);
			return JSONValue.init;
		}
	}
	
}