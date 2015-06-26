/* rAF polyfill */
(function() {
    var lastTime = 0;
    var vendors = ['webkit', 'moz'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame =
          window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame) {
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
    }

    if (!window.cancelAnimationFrame) {
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
    }
}());
/* parallaxScroller */
(function ($) {
var $win = $(window),
	touchable = false,
	defaults = {
		'parallaxIntensity': 0,
		'singleBG': false
	};
	function log(data) {
		if(window.console) {
			console.log(data);
		}
	}
	$.fn.parallaxScroller = function (options) {
		var $this = this,
			settings = $.extend({}, defaults, options),
			fixedConTemplate = '<div class="fixedCon" data-section=""><img class="absImg" /></div>',
			$sections = $('.section'),
			$fixedCons,
			resizeEvent = 'resize',
			lastY = 0,
			scrolling = false;
		if (settings.parallaxIntensity > 10) {
			settings.parallaxIntensity = 10;
		}
		/* Create the containers for the background images */
		this
			.find('.section')
			.each(function (i) {
				$(this).attr('data-section', i);
				$this.prepend(fixedConTemplate);
			});
		$fixedCons = $('.fixedCon');
		$fixedCons.each(function (i) {
			$(this).attr('data-section', i);
		});
		if (settings.singleBG) {
			$('.fixedCon[data-section="0"]').addClass('singleBG inFocus');
			$('.section[data-section="0"]').addClass('inFocus');
		}
		function setfixedBackgrounds (section) {
			var $section = $('#' + section + 'Fixed');
			$('.absImg').each(function () {
				var $img = $(this),
					$itsSection = $('.section[data-section="' + $img.parent().attr('data-section') + '"]');
				if (!$itsSection.attr('data-background')) {
					return false;
				} else {
					$img.attr('src', $itsSection.attr('data-background'));
				}
			});
		}
		function setDimensions () {
			var totalHeight = Math.max($win.outerHeight(), 650),
				//totalWidth = Math.max($win.outerWidth(), 768);
				//totalWidth = Math.max($win.outerWidth(), 420);
				totalWidth = Math.max($win.outerWidth(), 320);
			touchable = ('ontouchstart' in window || (window.DocumentTouch && document instanceof DocumentTouch));
			if (touchable) {
				$this.addClass('isTouchDevice');
				resizeEvent = 'orientationchange';
			}
			$sections.css({
				'height': totalHeight,
				'width': totalWidth
			});
			if (settings.singleBG) {
				$('.singleBG').css({
					'height': totalHeight * ($sections.length),
					'width': totalWidth
				});
				$('.fixedCon')
					.not('.singleBG, .overlayCon')
					.css({
						'height':0,
						'width': totalWidth
					});

			} else {
				$fixedCons.each(function () {
					$(this).css({
						'height': totalHeight,
						'width': totalWidth
					});
				});
			}
			if (($('html').hasClass('ie') || touchable) && !settings.singleBG) {
				$fixedCons.each(function () {
					var $this = $(this),
						index = parseInt($this.attr('data-section'), 10);
					$this.css('top', index * totalHeight);
				});
			}
		}
		function setParallax () {
			$('.inFocus').each(function () {
				var $this = $(this),
					parallaxIntensity = settings.parallaxIntensity / 10 || 0;
					offsetTop = $this.offset().top,
					imagePos = ($win.scrollTop() - offsetTop) * parallaxIntensity,
					containerPos = (offsetTop - $win.scrollTop()),
					prefixes = ['-moz-', '-o-', '-webkit-', ''],
					cssObj = [];
				cssObj[0] = {};
				cssObj[1] = {};
				/* Ensure neccessary vendor prefixes used */
				$.each(prefixes, function (i) {
					cssObj[0][this + 'transform'] = 'translate3D(0px, ' + containerPos + 'px, 0px)';
					cssObj[1][this + 'transform'] = 'translate3D(0px, ' + imagePos + 'px, 0px)';
				});
				$('.fixedCon[data-section="' + $this.attr('data-section') + '"]')
					.css(cssObj[0])
					.find('.absImg')
					.css(cssObj[1]);
			});
		}
		function focusCheck () {
			var	screenTop = lastY,
				screenBottom = screenTop + $win.height();
			/* Hide/show sections and backgrounds to improve performance */
			if (settings.singleBG) {
				setParallax();
				scrolling = false;
				return false;
			}
			$sections.each(function () {
				var $thisSection = $(this),
					panelTop = $thisSection.offset().top,
					panelBottom = panelTop + $thisSection.height();
				if (screenBottom >= panelTop && (screenTop <= panelBottom)) {
					$thisSection.addClass('inFocus').removeClass('isHidden');
					$('.fixedCon[data-section="' + $thisSection.attr('data-section') + '"]').addClass('inFocus').removeClass('isHidden');
				} else {
					$thisSection.removeClass('inFocus').addClass('isHidden');
					$('.fixedCon[data-section="' + $thisSection.attr('data-section') + '"]').removeClass('inFocus').addClass('isHidden');
				}
			});
			setParallax();
			scrolling = false;
		}
		function getY () {
			lastY = $win.scrollTop();
			getScrolling();
		}
		function getScrolling () {
			if (!scrolling) {
				requestAnimationFrame(focusCheck);
			}
			scrolling = true;
		}
		function init () {
			setDimensions();
			setfixedBackgrounds();
			if ($this.hasClass('isTouchDevice')) {
				$win.on(resizeEvent, setDimensions);
				return false;
			} else {
				focusCheck();
				$win
					.on(resizeEvent, setDimensions)
					.on('scroll.parallax', getY);
			}
		}
		return this.ready(function () {
			init();
		});
	};
})(jQuery);