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
	mixin getParams;
	this()
	{
	}

	@Action void homePage()
	{
		successJson();
	}

	@Action void verify()
	{
		auto identity = req.get("identity");
		string code;
		auto verifi = new Verify();
		string verfication = verifi.createVerification(code);
		memcache.set("VERIFY_IMG_"~identity,code.toUpper,300);
		log("identity : ",identity," code : ",code);
		res.setHeader("Content-Type","image/gif");
		res.setContext(verfication);
	}

	@Action void check()
	{
		auto identity = getParam("identity");
		auto code = getParam("code");
		string cache = memcache.get("VERIFY_IMG_"~identity);
		log("identity : ",identity," code : ",code," cache : ",cache);
		if(code.toUpper == cache){
			memcache.del(identity);
			successJson();
			return;
		}
		errorJson();
	}
}
