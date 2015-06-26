<%@ Control Language="C#" AutoEventWireup="true"%>
<style>
    .invalidVideo li {
    padding-left: 12px; 

    }
</style>
<script type="text/javascript">

    if (!divVideoPlayer)
        divVideoPlayer = '#divVideoPlayer';
    if (!loadingVideo)
        loadingVideo = '#loadingVideo';

    var videoPlayerScriptTemplate = "" +
            "<object width='100%' height='250'>" +
            "<param name='movie' value='{youtubeURL}'></param>" +
            "<param name='allowFullScreen' value='true'></param>" +
            "<param name='allowscriptaccess' value='always'></param>" +
            "<param name='wmode' value='opaque'></param>" +
            "<embed id='video-source' src='{youtubeURL}' type='application/x-shockwave-flash' width='100%' height='250' allowscriptaccess='always' allowfullscreen='true' wmode='opaque'>" +
            "</embed>" +
            "</object>";

     
    function fileUploadVideo(txtphotoUrlID, imgLoading, fileToUploadID, validatorVideoUrl, linAddVideo) {
        var rootServerPath = '<%=ResolveUrl("~")%>';
        var maxSize = '<%=ConfigurationManager.AppSettings["FileSize"]%>';
        ajaxFileUploadVideo(rootServerPath, txtphotoUrlID, imgLoading, fileToUploadID, 'video', validatorVideoUrl, linAddVideo, '#divVideoPlayer', videoPlayerScriptTemplate, maxSize);
    }

   
    function displayVideoWithOutValidate(txtControl, multiControl) {
        if (multiControl == null)
            multiControl = false;
        
        var youtubeUrls = $(txtControl).val();
        if (youtubeUrls != "") {
            var displayVideoUrl;
            if (multiControl) {
                var arrYoutubuUrl = youtubeUrls.split(';')
                var countVideo = arrYoutubuUrl.length;
                if (numVideo && numVideo != '') {
                    if (countVideo > 1) {
                        $(numVideo).text("(" + countVideo + " videos)");
                    }
                    else {
                        $(numVideo).text("(" + countVideo + " video)");
                    }

                    $(numVideo).css("display", "block");
                }

                displayVideoUrl = arrYoutubuUrl[0];
            }
            else {
                displayVideoUrl = youtubeUrls;
            }

            displayVideoUrl = displayVideoUrl.replace('watch?v=', 'v/');

            var videoPlayerScript = videoPlayerScriptTemplate.replace(/{youtubeURL}/g, displayVideoUrl);
            $(divVideoPlayer).empty();
            $(divVideoPlayer).append($(videoPlayerScript));
            $(divVideoPlayer).css("display", "block");
        }
        else {
            if (numVideo)
                $(numVideo).css("display", "none");
            $(divVideoPlayer).empty();
            $(divVideoPlayer).css('display', 'none');
        }
    }

    function displayVideoOnChange(txtControl, multiControl) {

        if (multiControl == null)
            multiControl = false;

        $(validatorInputVideoUrl).css("display", "none");
        try {
            var youtubeUrls = $(txtControl).val();

            if (youtubeUrls == "") {
                $(divVideoPlayer).css('display', 'none');
                if (multiControl && numVideo)
                    $(numVideo).css("display", "none");
                if (linAddVideo && linAddVideo != '' && !multiControl)
                    $('#' + linAddVideo).text('Add video');
                return;
            }
   
            $(loadingVideo).css("display", "inline");

            if (!multiControl) {
                var youtubeUrl = youtubeUrls;
                $.youtubeVideoExists(youtubeUrl, function (existVideo) {                     
                    if (existVideo) {
                        if (linAddVideo && linAddVideo != '') {
                            $('#' + linAddVideo).text('Change video');
                        }
                        youtubeUrl = youtubeUrl.replace('watch?v=', 'v/');
                        videoPlayerScript = videoPlayerScriptTemplate.replace(/{youtubeURL}/g, youtubeUrl);
                        $(divVideoPlayer).empty();
                        $(divVideoPlayer).append($(videoPlayerScript));
                        $(divVideoPlayer).css('display', 'block');
                    }
                    else {
                        $(validatorInputVideoUrl).css("display", "inline");
                        $(validatorInputVideoUrl).text('Youtube URL "' + youtubeUrl + '" does not exist');
                        $(divVideoPlayer).css('display', 'none');
                        if (linAddVideo && linAddVideo != '' && !multiControl) {
                            $('#' + linAddVideo).text('Add video');
                        }
                    }                                                                   
                });
            }
            else {
                    
                var arrYoutubuUrl = youtubeUrls.split(';')
                var youtubeUrl;
          
                var hasViewVideo = false;
                var notValidUrl = '';

                var countVideo = arrYoutubuUrl.length;
                if (countVideo > 1) {
                    $(numVideo).text("(" + countVideo + " videos)");
                }
                else
                    $(numVideo).text("(" + countVideo + " video)");

                $(numVideo).css("display", "block");
                for (var i = 0; i < countVideo; i++) {
                    var youtubeUrl = arrYoutubuUrl[i];
                    $.youtubeVideoExists(youtubeUrl, function (existVideo) {          
                        if (existVideo) {
                            if (!hasViewVideo) {
                                hasViewVideo = true;
                                if (linAddVideo && linAddVideo != '' && !multiControl) {
                                    $('#' + linAddVideo).text('Change video');
                                }
                                youtubeUrl = youtubeUrl.replace('watch?v=', 'v/');
                                videoPlayerScript = videoPlayerScriptTemplate.replace(/{youtubeURL}/g, youtubeUrl);
                                $(divVideoPlayer).empty();
                                $(divVideoPlayer).append($(videoPlayerScript));
                                $(divVideoPlayer).css('display', 'block');
                            }
                        }
                        else {
                            notValidUrl = notValidUrl + "<li>" + youtubeUrl+"</li>";
                        }                       
                    });
                }//end for    

                setTimeout(function () {
                    if (notValidUrl.length > 0) {                       
                        $(validatorInputVideoUrl).css("display", "inline");
                        $(validatorInputVideoUrl).addClass("invalidVideo");
                        $(validatorInputVideoUrl).html("Youtube URL below does not exist: " + notValidUrl);
                    } 
                }, 700 * countVideo);
            }
            $(loadingVideo).css("display", "none");     
        }
        catch (e) {
            console.log(e);
            $(loadingVideo).css("display", "none");
        }
    }
</script>