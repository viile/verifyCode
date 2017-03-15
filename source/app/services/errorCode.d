module app.service.errorCode;

import std.traits;
import std.conv;

class ErrorCodeHelper
{
	static public enum ErrorCode : uint{
		ParamesError = 62000,
		SignError = 62001,
		TokenError = 62002,
		UserError = 62003,
		CodeError = 62004,
		Argument    = 61000,
		ExistUser   = 61001,
		NotExistUser    = 61002,
		PasswdError     = 61003,
		PasswdNotSame   = 61004,
		ExistPhone      = 61005,
		TimeOut         = 61006,
		NoPremission    = 61007,
		WrongVerify     = 61008,
		PhoneIsEmpty    = 61009,
		WrongNumber     = 61010,
		MailIsEmpty     = 61011,
		WrongMail       = 61012,
		PasswordTooLongOrTooShort = 61013,
		HandleFailed    = 61014,
		RemindExpire        = 61015,
		SamePhoneNum    = 61016,
		ExistEmail      = 61017,
		IllegalNickName = 61018,
		NickNameExist   = 61019,
		AppidError      = 61020,
		RefreshTokenError = 61021,
		Unknow          = 61022,
		ExistDeviceId   = 61023,
		ServeridError   = 61024,
		NetworkError    = 61025,
		IllegalFrom      = 60101,
		TooManyTimes     = 60103,
		NotSetupPasswd   = 60304,
		BeautyNumberExist = 60305,
		BeautyNumberNotExist = 60306,
		LoginErrorFiveTimes  = 60307,
		UserNotBind = 60308,
		IsNotAdmin = 60309,
		IsAlreadyAdmin       = 60310,
		IsAlreadyReset       = 60311,
		BirthdayError        = 60312,
		BirthdayNotSet       = 60313,
		HeightNotSet         = 60314,
		TagExist = 40001,
		ParentTagNotExist = 40002,
	};

	static public string getErrorMsg(uint errorCode)
	{
		try
		{
			return ErrorMessage.get(cast(ErrorCode)errorCode,null);
		}
		catch(Exception e)
		{
			return null;
		}
	}
	static public uint getErrorCode(string key)
	{
		foreach(k;EnumMembers!ErrorCode){
			if(k.to!string == key)
				return cast(uint)k;
		}
		return 42705;
	}
	static public enum string[ErrorCode] ErrorMessage = [
		ErrorCode.ParamesError : "参数错误",
		ErrorCode.SignError:    "签名错误",
		ErrorCode.TokenError:   "token过期请重新登录",
		ErrorCode.UserError:    "用户被禁用",
		ErrorCode.CodeError:    "code过期",
		ErrorCode.Argument         :"参数错误",             //60000
		ErrorCode.ExistUser        :"已存在用户名", //60001
		ErrorCode.NotExistUser     :"不存在用户名",         //60002
		ErrorCode.PasswdError      :"密码错误",     //60003
		ErrorCode.PasswdNotSame    :"密码不一致",           //60004
		ErrorCode.ExistPhone       :"手机号已存在",         //60005
		ErrorCode.TimeOut            :"操作超时",       //60006
		ErrorCode.NoPremission     :"无权限",                       //60007
		ErrorCode.WrongVerify      :"验证码错误",           // 60008
		ErrorCode.PhoneIsEmpty     :"手机号为空",           // 60009
		ErrorCode.WrongNumber      :"手机号错误",           // 60010
		ErrorCode.MailIsEmpty      :"邮箱为空",                                     // 60011
		ErrorCode.WrongMail        :"邮箱错误",                     // 60012                
		ErrorCode.PasswordTooLongOrTooShort  :"密码过长或过短", // 60013
		ErrorCode.HandleFailed     :"操作失败",             // 60014
		ErrorCode.RemindExpire     :"重置过期",                     // 60015
		ErrorCode.SamePhoneNum     :"号码未改变",
		ErrorCode.ExistEmail       :"已存在的邮箱",
		ErrorCode.IllegalNickName  :"非法的昵称",
		ErrorCode.NickNameExist    :"昵称已存在",
		ErrorCode.AppidError       :"Appid不存在",
		ErrorCode.NetworkError     :"网络出错",
		ErrorCode.ServeridError    :"serverid不存在",
		ErrorCode.RefreshTokenError :"刷新的token错误",
		ErrorCode.Unknow           :"未知错误", // 70000
		ErrorCode.ExistDeviceId    :"设备号已存在", // 70000
		ErrorCode.IllegalFrom      :"发送来源不正确",
		ErrorCode.TooManyTimes     :"发送次数过多",   
		ErrorCode.NotSetupPasswd   :"未设置密码",
		ErrorCode.BeautyNumberExist :"靓号已存在",
		ErrorCode.BeautyNumberNotExist : "不存在的靓号",
		ErrorCode.LoginErrorFiveTimes: "因错误次数过多，帐号已锁定，请稍后再尝试",
		ErrorCode.UserNotBind      : "用户未被绑定",
		ErrorCode.IsNotAdmin       : "错误的管理员",
		ErrorCode.IsAlreadyAdmin   : "待操作的用户是管理员",
		ErrorCode.IsAlreadyReset   :"已修改密码",
		ErrorCode.TagExist : "标签已存在",
		ErrorCode.ParentTagNotExist : "父标签不存在",
		];  

}

import std.exception : basicExceptionCtors;

mixin(buildErroCodeException!(ErrorCodeHelper.ErrorCode)());

private:
string buildErroCodeException(T)()
{
	string str = "mixin ExceptionBuild!(\"ErrorCode\");\n";
	foreach(memberName; __traits(derivedMembers,T))
	{
		str ~= "mixin ExceptionBuild!(\"" ~ memberName ~ "\", \"ErrorCode\");\n";

	}
	return str;
}

mixin template ExceptionBuild(string name, string parent = "")
{
	enum buildStr = "class " ~ name ~ "Exception : " ~ parent ~ "Exception { \n\t" ~ "mixin basicExceptionCtors;\n }";
	mixin(buildStr);
}
