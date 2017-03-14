module ithox.oauthsdk.IOAuth;

public import std.experimental.logger;
import std.json;
//interface
interface IthoxOAuth{

	///refresh_token 在qq是refresh_token 在微信中是uid
	string getAccessToken(string code, ref string ref_value);

	string getAuthorizeURL();

}

abstract class AbstractIthoxOAuth : IthoxOAuth
{

     string getAuthCodeURL() ;
     string getAccessTokenURL();

	 string getOpenID(string access_token);
	 ///获取用户信息
	 import std.json;
	 JSONValue getUserInfo(string[string] pars)
	 {
		 return JSONValue.init;
	 }
	string getAccessToken(string code, ref string ref_value)
	{
		return string.init;
	}
	string getAccessToken(string code, ref string ref_value, ref string ref_value1)
	{
		return string.init;
	}

	string getAccessToken(string code, ref string ref_value, ref string ref_value1, ref string ref_value2)
	{
		return string.init;
	}
	string appId;
	string appKey;

	string callback_url;
	string respone_code = "code";
	string state = string.init;
	string display = "default";
	string apiScope;

	
	string getAuthorizeURL()
	{
		auto data = [
			"response_type" : "code",
            "client_id" : appId,
            "redirect_uri" : callback_url,
            "state" :state,
            "scope" : apiScope
		];

		return this.getAuthCodeURL()  ~ "?" ~ http_build_query(data);
	}
}


string http_build_query(string[string] data)
{
	import std.stdio, std.uri;
	string[] need_md5;
	foreach(string i,string v ; data)
	{
		need_md5 ~= i ~ "=" ~ encodeComponent(v);
	}
	import std.array;
	return need_md5.join('&');
}