module ithox.captcha.captcha;

import std.random;
import dmagick.Image;
import dmagick.DrawingContext;
import dmagick.Geometry;
import dmagick.Color;

import std.experimental.logger.core;

///验证码使用到的字符串
package enum ITHOX_CAPTCHA_CHARACTER = "abcdefghkmnprstuvwyzABCDEFGHKLMNPRSTUVWYZ23456789";
///颜色库
package enum string[] ITHOX_CAPTCHA_COLOR = ["#FF4040", "#F08080", "#4B0082", "#9B30FF", "#8B5A00", "#7FFF00", "#48D1CC", "#00C5CD", "#AB82FF", "#8B2323"];
///字体
package enum string[] ITHOX_CAPTCHA_FONT = ["Candice", "Ravie"];


class IthoxCaptcha{
	private {
		///宽
		int _width = 117;
		///高
		int _height = 42;

		///背景色
		string _background = "#E2E9F6";
		///验证码长度
		ubyte _length = 4;
		///字体大小
		int _fontSize = 15;
		///验证码
		string _code ="donglei";
		///
		size_t _fontWeight = 10;

		///图片
		Image image;
		///
		DrawingContext draw;
	}

	this()
	{
	}

	this(int width, int height)
	{
		this();
		this._width = width;
		this._height = height;
	}

	@property void width(int _width)
	{
		this._width = _width;
	}
	///宽度
	@property int width()
	{
		return this._width;
	}

	@property void height(int _h)
	{
		this._height = _h;
	}
	@property int height()
	{
		return this._height;
	}
	@property void fontSize(int _h)
	{
		this._fontSize = _h;
	}
	@property int fontSize()
	{
		return this._fontSize;
	}
	@property void fontWeight(size_t _h)
	{
		this._fontWeight = _h;
	}
	@property size_t fontWeight()
	{
		return this._fontWeight;
	}

	@property void background(string _background)
	{
		this._background = _background;
	}
	@property string background()
	{
		return this._background;
	}

	@property string code()
	{
		return this._code;
	}



	@property void length(ubyte _length)
	{
		this._length = _length;
	}
	@property ubyte length()
	{
		return this._length;
	}


	///输出图片 base64 压缩的图片image_format =  jpg png
	void[] render(string image_format = "gif")
	{
		assert(image !is null, "call drawCode function before save");
		image.quantize();
		return image.toBlob(image_format, 4);
	}

	///输出图片 base64 压缩的图片image_format =  jpg png
	string renderBase64(string image_format = "gif")
	{
		import std.base64;
		auto encode64 = Base64.encode(cast(ubyte[])render(image_format));
		import std.format;
		return format("data:%s;base64,%s", getImageContentType(image_format),cast(string)encode64);
	}

	//输出到图片
	public void save(string fileName)
	{
		assert(image !is null, "call drawCode function before save");
		image.write(fileName);
	}
	//生图
	public void drawCode()
	{
		this._code = "";
		randCode();
		this.draw = new DrawingContext();
		image = new Image(Geometry(_width, _height),new Color(_background));
		//image.addNoise(NoiseType.MultiplicativeGaussianNoise);

		//draw line
		for(int i =0; i < uniform(5, 20); i ++)
		{
			draw.line(uniform(1, _width), uniform(1, _height), uniform(1, _width), uniform(1, _height));
                        draw.fill(new Color(ITHOX_CAPTCHA_COLOR[uniform(0, ITHOX_CAPTCHA_COLOR.length)]));
			//draw.fill(new Color("#bad2ed"));
		}
		//draw code
		int per_width = _width / _length;
		int half_height = _height / 2 + _fontSize / 2;

		for(int i = 0; i < _length; i ++)
		{
			draw.fontSize(_fontSize);
			draw.fontWeight(_fontWeight);
			draw.fontStyle(uniform(0, 2) == 0 ? StyleType.ItalicStyle : StyleType.NormalStyle);
			draw.font(ITHOX_CAPTCHA_FONT[uniform(0, ITHOX_CAPTCHA_FONT.length)]);
			draw.fill(new Color(ITHOX_CAPTCHA_COLOR[uniform(0, ITHOX_CAPTCHA_COLOR.length)]));
			//draw.fill(new Color("#766ace"));

			draw.text(per_width * i + uniform(0, (per_width) / 3), half_height + uniform(-1, 1) * uniform(0, 10), this._code[i] ~ "");
		}

		draw.draw(image); 
	}
	///生成随机吗
	private void randCode()
	{
		for(ubyte i = 0; i< this._length; i++)
		{
			this._code ~= ITHOX_CAPTCHA_CHARACTER[uniform(0, 49)];
		}
	}
	
	///获取图片类型
	string getImageContentType(string ext)
	{
		 switch(ext)
		{
			case "gif":
				return "image/gif";
			case "png":
				return "image/png";
			case "jpg":
				return "image/jpg";
			case "webp":
				return "image/webp";
			default:
				assert(false, "Unsupport image type");
		}
	}

}


unittest{
	auto captcha = new IthoxCaptcha(100, 50);
	captcha.render();
	import std.experimental.logger.core;
	logf("width is %s code is %s", captcha.width, captcha.code);
}
