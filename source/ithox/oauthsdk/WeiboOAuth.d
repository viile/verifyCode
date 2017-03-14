module ithox.oauthsdk.WeiboOAuth;

import ithox.oauthsdk.IOAuth;
import std.stdio;
import std.format;
import std.json;
import std.experimental.logger;

alias logInfo = log;
alias logErrorF = logf;

//Weibo登录
class WeiboOAuth : AbstractIthoxOAuth{


    enum VERSION = "2.0";

	private string _uid;

	enum string GET_OPENID_URL = "https://api.weibo.com/oauth2/get_token_info";
	///根据用户ID获取用户信息
	enum string GET_USER_INFO = "https://api.weibo.com/2/users/show.json";

	override string getAuthCodeURL(){
		return "https://api.weibo.com/oauth2/authorize";
	}

	override string getAccessTokenURL()
	{
		return "https://api.weibo.com/oauth2/access_token";
	}
	///获取accessToken

 override	string getAccessToken(string code, ref string uid)
	{
		import std.format;
		import std.uri;
		auto url = format("%s?grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s&state=%s&redirect_uri=%s",
						  this.getAccessTokenURL(), appId, appKey,code, state, encodeComponent(callback_url));
		import std.net.curl;
		/*
		{
			"access_token": "ACCESS_TOKEN",
			"expires_in": 1234,
			"remind_in":"798114",
			"uid":"12341234"
		}
		*/
		
		import std.string, std.array,std.json;
		string access_token = "";
		try{

		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
			string content = cast(string)post(url,["xx"], conn);
			debug(ITHOX_OAUTH_SDK)
			{
				logInfo("weibo:getAccessToken:", content);
			}
			JSONValue j = parseJSON(content);
			access_token = j["access_token"].str;
			uid = j["uid"].str;
			_uid = j["uid"].str;
		}catch(Exception e)
		{
			logf("weibo get access_token is error:%s", e.msg);
		}
		return access_token;
	}
	///获取用户唯一标示
	override string getOpenID(string access_token)
	{
		if(_uid.length !=0)
		{
			return _uid;
		}
		import std.net.curl, std.array, std.string;
		auto url = GET_OPENID_URL ~ "?access_token=" ~access_token;
		/*
		{
			"uid": 1073880650,
			"appkey": 1352222456,
			"scope": null,
			"create_at": 1352267591,
			"expire_in": 157679471
		}
		*/
		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
		 string re = cast(string)get(url, conn);
		debug(ITHOX_OAUTH_SDK)
		{
			logInfo("weibo:getOpenID:", re);
		}
		try{
			import std.string, std.array,std.json;

			JSONValue j = parseJSON(re);
			_uid = j["uid"].str;
		}catch(Exception e)
		{
			logErrorF("weibo get getOpenID is error:%s", re);
		}
		return _uid;
	}


	//enum string GET_USER_INFO = "https://api.weibo.com/2/users/show.json";

	override JSONValue getUserInfo(string[string] pars)
	{
		try{
			auto url = format("%s?access_token=%s&uid=%s", 
							  GET_USER_INFO, 
							  pars["access_token"],
							  pars["uid"]
							  );
			debug(ITHOX_OAUTH_SDK)
			{
				logInfo("weibo:getUserInfo:url:", url);
			}
			import std.net.curl;
		 auto conn = HTTP();
  		conn.handle.set(CurlOption.ssl_verifypeer, 0);
			string re = cast(string)get(url, conn);
			return parseJSON(re);
		}
		catch(Exception e)
		{
			log("weibo:getUserInfo:error:%s", e.msg);
			return JSONValue.init;
		}
	}

}