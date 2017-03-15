module app.exception;

import app.controller.base;
import app.service.errorCode;

import std.net.curl : CurlException;
import std.experimental.logger;
import std.json : JSONException;
import core.memory;

alias IllegalUserNameException = IllegalNickNameException;

class DBServerErroCodeException  : Exception
{
	this(uint erro,string msg, string file = __FILE__, size_t line = __LINE__,
			Throwable next = null) @nogc @safe pure nothrow
	{
		errocode = erro;
		super(msg, file, line, next);
	}

	uint errocode;
}

pragma(inline, true)
	void throwExceptionBuild(string name = "", string file = __FILE__, size_t line = __LINE__ )(string msg = "")
{
	throw new DBServerErroCodeException(ErrorCodeHelper.getErrorCode(name), msg,file,line);
}

pragma(inline, true)
	void throwExceptionBuild(string file = __FILE__, size_t line = __LINE__ )(uint errocode,string msg = "")
{
	throw new DBServerErroCodeException(errocode, msg,file,line);
}

void runCatchException(BaseController controller, void delegate() fun)
{
	void sendErro(EXCEP)(EXCEP excep,int errocode)
	{
		warning(excep.toString());
		controller.errorJson(controller.res,errocode,controller.req.path);

		// NOTES: FREE the Exception
		excep.destroy;
		GC.free(cast(void *)excep);
	}

	try{
		fun();
	} 
	catch(DBServerErroCodeException e){
		sendErro(e,e.errocode);
	}
	catch(Exception e){
		sendErro(e,ErrorCodeHelper.ErrorCode.Argument);
	} 

}



