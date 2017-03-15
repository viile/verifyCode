module app.config;

import std.conv;	
import std.datetime;
import std.experimental.logger;
import hunt.application;
import tinyredis.redis:Redis;
import collie.libmemcache4d.memcache;

string STATIC_URL;
string REDIS_HOST;
ushort REDIS_PORT;
string LOGLEVEL;
string LOGPATH;
string MEMCACHED_HOST;
ushort MEMCACHED_PORT;

//mysql
string MYSQL_HOST;
ushort MYSQL_PORT;
string MYSQL_USERNAME;
string MYSQL_PASSWORD;
string MYSQL_DBNAME;
string MYSQL_CHARSET;

Redis _redis;
FileLogger _logger;
Memcache _memcache;

Redis redis()
{
	if( _redis is null )
	{   
		_redis = new Redis(cast(string)REDIS_HOST,cast(ushort)REDIS_PORT);
	}   

	return _redis;
}

FileLogger logger( string logFile = null )
{

	if ( !(logFile is null) )
	{   
		string path = cast(string)LOGPATH ~ logFile  ~ ".log";
		_logger = new FileLogger(path); 
	}   
	else if ( _logger is null )
	{   
		Date st = cast(Date)Clock.currTime();
		string date = to!string(st.year) ~ to!string(cast(int)st.month) ~ to!string(st.day);
		string path = cast(string)LOGPATH ~ "log_" ~ date  ~ ".log";
		_logger = new FileLogger(path);
	}   
	return _logger;
}

@property Memcache memcache()
{
	if ( _memcache is null )
	{
		_memcache = new Memcache(cast(string)MEMCACHED_HOST, cast(ushort)MEMCACHED_PORT);
	}

	return _memcache;
}

static this()
{
	auto conf = Config.app.config;

	STATIC_URL = conf.http.static_url.value();

	REDIS_HOST = conf.redis.host.value();
	REDIS_PORT = to!ushort(conf.redis.port.value());

	LOGLEVEL = conf.log.level.value();
	LOGPATH = conf.log.path.value();

	MYSQL_PORT = conf.mysql.port.as!short;
	MYSQL_HOST = conf.mysql.host.value;
	MYSQL_USERNAME = conf.mysql.username.value;
	MYSQL_PASSWORD = conf.mysql.password.value;
	MYSQL_DBNAME = conf.mysql.dbname.value;
	MYSQL_CHARSET = conf.mysql.charset.value;

	MEMCACHED_HOST = conf.memcached.host.value();	
	MEMCACHED_PORT = to!ushort(conf.memcached.port.value());
}

