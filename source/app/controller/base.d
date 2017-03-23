module app.controller.base; 

public import hunt;

import std.string;
import std.stdio;
import std.json;
import std.conv;
import app.config;
import app.exception;
import app.service;


class BaseController : Controller
{
	//mixin MakeController;
	final @property res()
	{
		return this.response;
	}

	final @property req()
	{
		return this.request;
	}

	this()
	{
		view.static_url = STATIC_URL;   		
		view.title = "";
		view.highlighted = "";
		view.pageLimit = 20;
		//view.setLayout!"default.html"();
	}

	void successJson(Response res,ref JSONValue data)
	{
		res.json(data);
		res.done();
	}

	void successJson(Response res)
	{
		JSONValue data;
		this.successJson(res,data);
	}

	void successJson(ref JSONValue data)
	{
		res.json(data);
		res.done();
	}

	void successJson(string msg)
	{
		JSONValue data;
		data["msg"] = msg;

		JSONValue returnData;
		returnData["data"] = data;
		res.json(returnData);
		res.done();
	}

	void successJson(string[string] info)
	{
		JSONValue data = JSONValue(info);
		data["error_code"] = 0;
		res.json(data);
		res.done();
	}
	void successJson()
	{
		JSONValue data;
		data["error_code"] = 0;
		res.json(data);
		res.done();
	}

	void errorJson(Response res,int code = 42700,string msg = "")
	{
		JSONValue json = JSONValue(["msg":msg]);
		json["code"] = code;
		json["error_code"] = code;
		json["msg"] = ErrorCodeHelper.getErrorMsg(cast(uint)code);
		log("return errorJson : ",json);
		res.json(json);
		res.done();
	}

	void errorJson(int code = 42700,string msg = "")
	{
		JSONValue json = JSONValue(["msg":msg]);
		json["code"] = code;
		json["error_code"] = code;
		json["msg"] = ErrorCodeHelper.getErrorMsg(cast(uint)code);
		log("return errorJson : ",json);
		res.json(json);
		res.done();
	}

	void checkParamsLength(string[] params...)
	{
		foreach(param;params)
		{
			log(param);
			if(!param.length)
				throwExceptionBuild!"Argument"();
		}
	}
	void clog(string[] params...)
	{
		int i = 0;
		foreach(param;params)
		{
			i++;
			log("param " ~ i.to!string ~" " ~ param);
		}
	}

	string getBody(Request req)
	{
		req.Body.rest(0);
		ubyte[] reqBody;
		req.Body.readAll((in ubyte[] data){
				reqBody ~= data;
				trace("length : ", data.length,cast(string)data);
				});
		return cast(string)reqBody;
	}


}

mixin template getParams()
{
	JSONValue _body = JSONValue.init;
	JSONValue jsonBody()
	{
		if(_body == JSONValue.init)
			_body= parseJSON(getBody(req));
		return _body;
	}
	bool jsonBody(string key)
	{
		if(req.method != "POST")return false;
		if(key in jsonBody)return true;
		return false;
	}
	string getParam(string key)
	{
		if(jsonBody(key))return _body[key].str;
		return req.get(key);
	}
}
