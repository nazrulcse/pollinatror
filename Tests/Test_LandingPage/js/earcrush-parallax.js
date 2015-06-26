var EC = {
    isScrolling: false,
    resizeEvent: ($('.ecWrap').hasClass('isTouchDevice')) ? 'orientationchange.ec' : 'resize.ec',
    lastY: 0,
    setFade: function (section) {
        var $this = $(section),
                screenTop = EC.lastY,
                screenHeight = $(window).height(),
                screenBottom = screenTop + screenHeight,
                sectionTop = $this.offset().top,
                sectionBottom = sectionTop + $this.outerHeight(),
                fadePercent = (sectionBottom - screenTop) / screenHeight;
        if (fadePercent < 0 || fadePercent > 2) {
            return false;
        }
        if (fadePercent >= 0 && fadePercent <= 1) {
            $this
                    .removeClass('isHidden')
                    .css({
                        'opacity': fadePercent
                    });
        } else if (fadePercent > 1 && fadePercent <= 2) {
            fadePercent = (screenBottom - sectionTop) / screenHeight;
            $this
                    .removeClass('isHidden')
                    .css({
                        'opacity': fadePercent
                    });
        }
    },
    checkFade: function () {
        $('.section').each(function () {
            EC.setFade(this);
        });
        EC.setOverlayParallax();
        EC.isScrolling = false;
    },
    setOverlayParallax: function () {
        var $overlay = $('.overlayCon'),
                $win = $(window),
                offsetTop = $('#intro').offset().top,
                containerPos = ($win.scrollTop() - offsetTop) * 0.7,
                imagePos = (offsetTop - $win.scrollTop()),
                prefixes = ['-moz-', '-o-', '-webkit-', ''],
                cssObj = [];
        cssObj[0] = {};
        cssObj[1] = {};
        /* Ensure neccessary vendor prefixes used */
        $.each(prefixes, function (i) {
            cssObj[0][this + 'transform'] = 'translate3D(0px, ' + imagePos + 'px, 0px)';
            cssObj[1][this + 'transform'] = 'translate3D(0px, ' + containerPos + 'px, 0px)';
        });
        $overlay
                .css(cssObj[0])
                .find('.absImg')
                .css(cssObj[1]);
    },
    setOverlayDimensions: function () {
        var $win = $(window),
                totalHeight = Math.max($win.outerHeight(), 650),
                totalWidth = Math.max($win.outerWidth(), 768),
                $sections = $('.section');
        $('.overlayCon').css({
            'width': totalWidth,
            'height': totalHeight * ($sections.length)
        });
    },
    setOverlayBG: function () {
        var $overlay = $('.overlayCon'),
                imagePath = $overlay.attr('data-background');
        $overlay.find('.absImg').attr('src', imagePath);
		alert('debug');
    },
    getY: function () {
        EC.lastY = $(window).scrollTop();
        EC.getIsScrolling();
    },
    getIsScrolling: function () {
        if (!EC.isScrolling) {
            requestAnimationFrame(EC.checkFade);
        }
        EC.isScrolling = true;
    },
    changeSlide: function (e, direction, goTo) {
        var $targ = $(e.target),
                carouselNum = $targ.attr('data-carousel'),
                $carouselSlide = $('#carousel' + carouselNum).find('.carouselSlideHolder'),
                slideAt = $.trim($carouselSlide.attr('class').replace('carouselSlideHolder', '')),
                slideNum = parseInt(slideAt.substr(slideAt.length - 1), 10),
                nextSlide = (direction === 'forward') ? slideAt.replace(slideNum, slideNum + 1) : slideAt.replace(slideNum, slideNum - 1);
        if ($targ.is('.indicator') && goTo) {
            nextSlide = goTo;
        }
        if (nextSlide === 'slide5' && direction === 'forward') {
            nextSlide = 'slide1';
        } else if (nextSlide === 'slide0' && direction === 'backward') {
            nextSlide = 'slide4';
        }
        $carouselSlide
                .removeClass(slideAt)
                .addClass(nextSlide);
        /* Indicators */
        $('#carousel' + carouselNum)
                .find('.indicator[data-slide=' + slideAt + ']')
                .removeClass('activeIndicator');
        $('#carousel' + carouselNum)
                .find('.indicator[data-slide=' + nextSlide + ']')
                .addClass('activeIndicator');
    },
    formValidator: function () {
        var $email = $('#ecEmail'),
                emailRE = /^[a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$/,
                success = false;
        if ($email.val() && emailRE.test($email.val())) {
            success = true;
        }
        return success;
    },
    submission: function () {
        var success = EC.formValidator(),
                formTimeout;
        $('.formBlock').removeClass('showForm');
        if (success) {
            $('.formBlock').addClass('showSuccess');
            formTimeout = setTimeout(hideEmailForm, 3000);
        } else {
            $('.formBlock').addClass('showError');
        }
        return success;
    },
    scrollToSection: function (e) {
        var $targ = $(e.target),
                destination = $('#' + $targ.attr('data-target')).offset().top - 70;
        $('html, body').animate({
            scrollTop: destination
        }, 750);
    },
    hideEmailForm: function () {
        var clearClassesTimer = setTimeout(function () {
            $('.formBlock')
                    .addClass('initialPos')
                    .removeClass('showForm showSuccess showError');
        }, 1010);
        $('.formBlock').addClass('formHidden');
    },
    showEmailForm: function () {
        var formOutTimer;
        $('.formBlock')
                .removeClass('showSuccess showError formHidden initialPos')
                .addClass('showForm');
    },
    init: function () {
        /* Create overlay based on timeout, so plugin has a chance to intitialize first */
        var overlayTemplate = $('.overlayCon');
        $(window).on('load', function () {
            $('body').find('.singleBG').after(overlayTemplate);
            EC.setOverlayDimensions();
            EC.setOverlayBG();
            $('.singleBG, .overlayCon')
                    .find('.absImg')
                    .addClass('isShown');
            if ($('.ecWrap').hasClass('isTouchDevice')) {
                return false;
            } else {
                $(window).on('scroll.ec', EC.getY);
            }
        });
        $('.carouselArrowRight').on('click.ec', function (e) {
            EC.changeSlide(e, 'forward');
        });
        $('.carouselArrowLeft').on('click.ec', function (e) {
            EC.changeSlide(e, 'backward');
        });
        $('.indicator').on('click.ec', function (e) {
            var goingTo = $(this).attr('data-slide');
            EC.changeSlide(e, '', goingTo);
        });
        $(window).on(EC.resizeEvent, EC.setOverlayDimensions);
        $('#ecMailing').on('submit.ec', EC.submission);
        $('.formClose').on('click.ec', EC.hideEmailForm);
        $('.scrollToTrigger').on('click.ec', EC.scrollToSection);
        $('.formTrigger').on('click.ec', EC.showEmailForm);
    },
    isAppleDevice: function () {
        if (navigator && navigator.userAgent && navigator.userAgent !== null)
        {
            var strUserAgent = navigator.userAgent.toLowerCase();
            var arrMatches = strUserAgent.match(/(iphone|ipod|ipad)/);
            if (arrMatches !== null)
                return true;
        }

        return false;
    },
    detectMobile: function () {
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
};
(function () {
    EC.init();
    /* Detect apple device */
    if (EC.isAppleDevice()) {
        $('body').addClass('browser-safari');
    }
    /*CSS bug fix for arrow position lading page on mobile screen*/
    if (EC.detectMobile() === true) {
        $('.carouselArrow').css('padding-top', '20px');
    }
})();

