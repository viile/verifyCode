import std.stdio;
import ithox.captcha;
import std.experimental.logger.core;

void main()
{
	writeln("Edit source/app.d to start your project.");
	string str = "sdfasdf";
	auto res = createVerification(str);
	writeln(res);
}

string createVerification(string codeNum, int width = 120, int height = 40,
		ubyte font_num = 4, int font_size = 24)
{

	auto captcha = new IthoxCaptcha(width, height);
	writeln(captcha);
	captcha.length = font_num;
	captcha.fontSize = font_size;
	captcha.drawCode();
	codeNum = captcha.code;
	return cast(string) captcha.render("gif");
}
