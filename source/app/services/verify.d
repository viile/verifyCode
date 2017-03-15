module app.service.verify;

import app.service;

import ithox.captcha;
import std.experimental.logger.core;

class Verify
{
	int width = 120;
	int height = 40;
	ubyte fontNum = 4;
	int fontSize = 24;
	string type = "gif";

	this()
	{
	
	}
	this(int width,int height,ubyte fontNum,int font_size)
	{
		this.width = width;
		this.height = height;
		this.fontNum = fontNum;
		this.fontSize = fontSize;
	}


	string createVerification(ref string codeNum)
	{
		auto captcha = new IthoxCaptcha(width, height);
		captcha.length = fontNum;
		captcha.fontSize = fontSize;
		captcha.drawCode();
		codeNum = captcha.code;
		return cast(string) captcha.render(type);
	}
}
