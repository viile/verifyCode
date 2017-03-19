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

	@Action void verifyGet()
	{
		auto identity = req.get("identity");
		string code;
		auto verifi = new Verify();
		string verfication = verifi.createVerification(code);
		memcache.set(identity,code.toUpper,300);
		log("identity : ",identity," code : ",code);
		res.setHeader("Content-Type","image/gif");
		res.setContext(verfication);
	}
	@Action void verifyPost()
	{
		auto identity = req.post("identity");
		string code;
		auto verifi = new Verify();
		string verfication = verifi.createVerification(code);
		memcache.set(identity,code.toUpper,300);
		log("identity : ",identity," code : ",code);
		res.setHeader("Content-Type","image/gif");
		res.setContext(verfication);
	}

	@Action void check()
	{
		auto identity = req.post("identity");
		auto code = req.post("code");

		string cache = memcache.get(identity);
		log("identity : ",identity," code : ",code," cache : ",cache);

		if(code.toUpper == cache){
			memcache.del(identity);
			successJson();
			return;
		}
		errorJson();
	}
}
