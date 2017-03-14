module ithox.oauthsdk.WeixinOAuth;


import ithox.oauthsdk.IOAuth;
import std.stdio;
import std.format;
import std.json;
import std.experimental.logger;

alias logInfo = log;
alias logErrorF = logf;

//Weixin登录
class WeixinOAuth : AbstractIthoxOAuth{


    enum VERSION = "2.0";

	private string _uid;


	override string getAuthCodeURL(){
		return "https://open.weixin.qq.com/connect/qrconnect";
	}

	override string getAccessTokenURL()
	{
		return "https://api.weixin.qq.com/sns/oauth2/access_token";
	}

	override string getAuthorizeURL()
	{
		auto data = [
			"response_type" : "code",
            "appid" : appId,
            "redirect_uri" : callback_url,
            "state" :state,
            "scope" : apiScope
		];

		return this.getAuthCodeURL()  ~ "?" ~ http_build_query(data)~"#wechat_redirect";
	}
	///获取accessToken
	override string getAccessToken(string code, ref string openid, ref string unionid, ref string refresh_token)
	{
		import std.format;
		import std.uri;
		//https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
		auto url = format("%s?grant_type=authorization_code&appid=%s&secret=%s&code=%s",
						  this.getAccessTokenURL(), appId, appKey,code);
		import std.net.curl;
		/*
		{ 
			"access_token":"ACCESS_TOKEN", 
			"expires_in":7200, 
			"refresh_token":"REFRESH_TOKEN",
			"openid":"OPENID", 
			"scope":"SCOPE",
			"unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL" //可选
		}
		*/
		logInfo("url:", url);

		import std.string, std.array,std.json;
		string access_token = "";
		try{
		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
			string content = cast(string)post(url,["xx"], conn);
			debug(ITHOX_OAUTH_SDK)
			{
				logInfo("weixin:getAccessToken:", content);
			}
			JSONValue j = parseJSON(content);
			access_token = j["access_token"].str;
			openid = j["openid"].str;
			_uid = j["openid"].str;
			refresh_token = j["refresh_token"].str;

			try{
				//有可能不存在
				unionid = j["unionid"].str;
			}catch(Exception e)
			{
				logErrorF("weixin get unionid is error:%s", e.msg);
			}

		}catch(Exception e)
		{
			logErrorF("weixin get access_token is error:%s", e.msg);
		}
		
		return access_token;
	}
	///获取用户唯一标示
	override string getOpenID(string access_token)
	{
		return _uid;
	}

	enum string GET_USER_INFO = "https://api.weixin.qq.com/sns/userinfo";

	override JSONValue getUserInfo(string[string] pars)
	{
		try{
			auto url = format("%s?access_token=%s&openid=%s", 
							  GET_USER_INFO, 
							  pars["access_token"],
							  pars["openid"]
							  );
			debug(ITHOX_OAUTH_SDK)
			{
				log("weixin:getUserInfo:url:", url);
			}
			import std.net.curl;
		 	auto conn = HTTP();
  			conn.handle.set(CurlOption.ssl_verifypeer, 0);
			string re = cast(string)get(url, conn);
			return parseJSON(re);
		}
		catch(Exception e)
		{
			log("weixin:getUserInfo:error:%s", e.msg);
			return JSONValue.init;
		}
	}

}