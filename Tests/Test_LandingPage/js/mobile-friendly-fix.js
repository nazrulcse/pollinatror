function detectmobile() {
	if (navigator.userAgent.match(/Android/i)
		|| navigator.userAgent.match(/webOS/i)
		|| navigator.userAgent.match(/iPhone/i)
		|| navigator.userAgent.match(/iPad/i)
		|| navigator.userAgent.match(/iPod/i)
		|| navigator.userAgent.match(/BlackBerry/i)
		|| navigator.userAgent.match(/Windows Phone/i)
	) {
		return true;
	}
	else {
		return false;
	}
}

$(document).ready(function () {
	if (detectmobile() == true) //It is mobile
	{
		$('.carouselArrow').css('padding-top', '20px');
		$('.socialIcon.youTubeIcon').css('margin-top', '5px');
	}
});