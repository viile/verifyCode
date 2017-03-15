module app.controller.index;

import std.stdio;
import std.json;
import std.conv;
import std.string;
import std.uni;

import app.controller.base;
import app.config;
import app.service;

class IndexController : BaseController 
{
	mixin MakeController;
	this()
	{
	}

	@Action void homePage()
	{
		successJson();
	}

	@Action void verification()
	{
		auto token = req.getCookieValue("token");
		string codeNum;
		auto verifi = new Verify();
		string verfication = verifi.createVerification(codeNum);
		memcache.set(token,codeNum.toUpper,300);
		log(token,codeNum);
		res.setHeader("Content-Type","image/gif");
		res.setContext(verfication);
	}

	@Action void verify()
	{
		auto token = req.post("token");
		auto code = req.post("code");

		if(code.toUpper == memcache.get(token)){
			memcache.del(token);
			successJson();
			return;
		}
		errorJson();
	}
}
