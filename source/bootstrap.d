import hunt;
import app.config;

import std.file;
import app.controller;
public import hunt.router.build; 
public import hunt.http.request;  

void main()
{
	auto app = Application.getInstance();
	app.run();
}
