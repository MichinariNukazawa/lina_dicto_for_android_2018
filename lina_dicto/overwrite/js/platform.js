'use strict';

module.exports = class Platform{
	static init()
	{
		return true;
	}

	static get_platform_name()
	{
		return "android";
	}
};

