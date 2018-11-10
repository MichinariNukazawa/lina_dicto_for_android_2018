'use strict';

class ExternalBrowser{
	static is_enable(){
		return true;
	}

	static get_google_translate_url(keyword, src_lang, dst_lang)
	{
		const link = 'https://translate.google.co.jp'
			+ '/#' + src_lang
			+ '/' + dst_lang
			+ '/' + encodeURIComponent(keyword);
		return link;
	}

	static create_onclick_google_translate(keyword, src_lang, dst_lang)
	{
		let element = document.createElement('a');
		element.innerText = '(goto google translate)';

		element.classList.add('goto-google-translate-button');

		const link = this.get_google_translate_url(keyword, src_lang, dst_lang);
		element.setAttribute('href', link);

		return element;
	}

};

