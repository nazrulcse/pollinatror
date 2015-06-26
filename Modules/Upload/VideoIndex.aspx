<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<html lang="en" class="no-js">
<head>
    <meta charset="utf-8">
    <title>jQuery File Upload Example</title>
    <!--[if lt IE 9]>
<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/themes/base/jquery-ui.css" id="theme">
    <link rel="stylesheet" href="jquery.fileupload-ui.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js"></script>
    <script src="//ajax.aspnetcdn.com/ajax/jquery.templates/beta1/jquery.tmpl.min.js"></script>

    <script src="jquery.iframe-transport.js"></script>
    <script src="jquery.fileupload.js"></script>
    <script src="jquery.fileupload-ui.js"></script>
    <script src="application.js"></script>
    <script src="../../Scripts/AjaxFileupload.js"></script>
    <div id="fileuploadVideo">
        <input type="hidden" id="isLoading" value="true" />
        <input type="hidden" id="isAdding" value="flase" />
        <input type="hidden" id="deletingVideoId" value=";" />
        <form id="multiUploadForm" action="FileTransferHandler.ashx" method="post" enctype="multipart/form-data">
            <div class="fileupload-buttonbar">
                <label class="fileinput-button">
                    <span>Add files...</span>
                    <input type="file" name="files[]" multiple="multiple" />
                </label>
                <button type="submit" id="startUpload" class="start">Start upload</button>
                <button type="button" class="delete">Delete files</button>

            </div>
        </form>
        <div class="fileupload-content" style="padding-top: 10px; padding-bottom: 15px">
            <div>
                <div style="float: left;"><span class="circle">OR</span></div>
                <div style="float: left; padding-top: 6px; font-size: 11px; font-weight: bold">Paste Youtube URL here</div>

                <div style="float: left; margin-left: 10px;">
                    <input type="text" style="width: 380px" id="txtYoutubeUrl" />
                </div>

                <div id="addYoutubeUrl" class="ui-button ui-corner-all" style="float: left; margin-left: 10px; margin-top: 2px; background: #e6e6e6; border: 1px solid #d3d3d3; padding: 3px 3px 3px 3px">
                    <span class="ui-button-icon-primary ui-icon ui-icon-plusthick" style="display: block;"></span>
                </div>
                <img id="loading" src="loading.gif" style="display: none;">
            </div>
            <div style="clear: both; margin-left: 196px;">
                <span id="validatorInputVideoUrl" title="" class="message-error" style="display: none;"></span>
            </div>
            <div style="padding-top: 20px">
                <table class="files"></table>
            </div>
            <div id="uploadNote" style="font-style: italic; font-size: 11px; color: gray; display: none">
                Please wait for upload process to complete. Keep in mind that your upload might fail if you try to upload big video file size, duplicated video, or any unknown invalid file type. We highly recommend that if your video was already uploaded before or existed on Youtube, please copy the link and paste in Youtube URL.

            </div>
        </div>
    </div>

    <script>
        var userFolder = getParameterByName('userFolder');
        var youtubeUrl = getParameterByName('youtubeUrl');
        var action = "FileTransferHandler.ashx?userFolder=" + userFolder + "&youtubeUrl=" + youtubeUrl;
        $('#multiUploadForm').attr("action", action);
    </script>

    <script id="template-upload" type="text/x-jquery-tmpl">
        <tr class="template-upload{{if error}} ui-state-error{{/if}}">
            <td class="preview"></td>
            <td class="name">${getNameCustom(name)}</td>
            <td class="size">${sizef}</td>
            {{if error}}
            <td class="error" colspan="2">Error:
                {{if error === 'maxFileSize'}}File is too big (exceeded <%=ConfigurationManager.AppSettings["FileSize"]%> MB)
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else}}${error}
                {{/if}}
            </td>
            {{else}}
            <td class="progress">
                <div></div>
            </td>
            <td class="start">
                <button>Start</button></td>
            {{/if}}
       
    </script>
    <script id="template-download" type="text/x-jquery-tmpl">
        <tr class="template-download{{if error}} ui-state-error{{/if}}">
            {{if error}}
            <td></td>
            <td class="name">${name}</td>
            <td class="error" colspan="2">Error:
                {{if error === 1}}File exceeds upload_max_filesize (php.ini directive)
                {{else error === 2}}File exceeds MAX_FILE_SIZE (HTML form directive)
                {{else error === 3}}File was only partially uploaded
                {{else error === 4}}No File was uploaded
                {{else error === 5}}Missing a temporary folder
                {{else error === 6}}Failed to write file to disk
                {{else error === 7}}File upload stopped by extension
                {{else error === 'maxFileSize'}}File is too big (exceeded <%=ConfigurationManager.AppSettings["FileSize"]%> MB)
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else error === 'uploadedBytes'}}Uploaded bytes exceed file size
                {{else error === 'emptyResult'}}Empty file upload result
                {{else}}${error}
                {{/if}}
            </td>
            {{else}}
              <td class="preview" width="200px">{{if thumbnail_url}}
            
                    <img style="max-width: 150px; max-height: 100px" src="${thumbnail_url}">
                  <div id='percent-processing${videoId}' class="processing" style="display: none">PROCESSING</div>
                  {{else}}
                  <object width="100%" height="120">
                      <param name="movie" value="http://www.youtube.com/v/${videoId}"></param>
                      <param name="allowFullScreen" value="true"></param>
                      <param name="allowscriptaccess" value="always"></param>
                      <param name="wmode" value="opaque"></param>
                      <embed id="video-source" src="http://www.youtube.com/v/${videoId}" type="application/x-shockwave-flash" width="100%" height="120" allowscriptaccess="always" allowfullscreen="true" wmode="opaque"></embed>
                  </object>
                  {{/if}}
              </td>
            <td class="name" id="name${videoId}">${name}
            </td>
            <td colspan="3"></td>
            {{/if}}
              <td class="delete">
                  <button data-type="${delete_type}" data-url="${delete_url}">Delete</button>
                  <div style="margin-top: -35px; margin-left: 35px">
                      <img id="deleting${videoId}" src="loading.gif" style="display: none">
                  </div>

              </td>
        </tr>
    </script>

    <script>

        $(function () {
            'use strict';

            // Load existing files:
            $.getJSON($('#fileuploadVideo form').prop('action'), function (files) {

                var fu = $('#fileuploadVideo').data('fileupload');
                if (files !== 'null' || files !== 'undefined') {
                    fu._adjustMaxNumberOfFiles(-files.length);
                }
                fu._renderDownload(files)
                    .appendTo($('#fileuploadVideo .files'))
                    .fadeIn(function () {
                        // Fix for IE7 and lower:
                        $(this).show();
                    });

                $('#fileuploadVideo').find("#isLoading").val(false);
                var isLoading = $('#fileuploadVideo').find("#isLoading").val();           
            });

            // Open download dialogs via iframes,
            // to prevent aborting current uploads:
            $('#fileuploadVideo .files a:not([target^=_blank])').live('click', function (e) {
                e.preventDefault();
                $('<iframe style="display:none;"></iframe>')
                    .prop('src', this.href)
                    .appendTo('body');
            });

        });

        function showErrMsg(validator, msg) {
            $(validator).css('display', 'inline');
            $(validator).text(msg);
            $('#txtYoutubeUrl').focus();
            $("#addYoutubeUrl").css("background", "#e6e6e6");
            $('#fileuploadVideo').find("#isAdding").val(false);
            $('#fileuploadVideo').find("#loading").css("display", "none");
            $('#txtYoutubeUrl').removeAttr("disabled");
        }

        var isAdding;
        $('#addYoutubeUrl').bind('click', function () {
            isAdding = $('#fileuploadVideo').find("#isAdding").val();

            if (isAdding == true || isAdding == "true")
                return;

            $('#fileuploadVideo').find("#isAdding").val(true);
            $('#txtYoutubeUrl').attr("disabled", "disabled");

            $("#addYoutubeUrl").css("background", "#DFDCDC");
            $('#fileuploadVideo').find("#loading").css("display", "inline");

            var validatorInputVideoUrl = '#validatorInputVideoUrl';
            $(validatorInputVideoUrl).css("display", "none");

            var url = $('#txtYoutubeUrl').val().trim();
            if (url == '') {
                $("#addYoutubeUrl").css("background", "#e6e6e6");
                $('#fileuploadVideo').find("#isAdding").val(false);
                $('#fileuploadVideo').find("#loading").css("display", "none");
                $('#txtYoutubeUrl').removeAttr("disabled");
                return;
            }

            //check url in add list or not
            var youtubeaddbefore = $('#fileuploadVideo').find('.files').find('object').filter(
                function (index) {
                    var addVideoId = linkifyYouTubeURLs(url);    
                    return $(this).find('embed').attr('src').indexOf(addVideoId) > -1;
                }
            );

            if (youtubeaddbefore.length > 0) {
                showErrMsg(validatorInputVideoUrl, "YouTube URL was already added. Please select another.");
                $('#txtYoutubeUrl').val('');
                return;
            }

            $.youtubeVideoExists(url, function (existVideo) {
                if (existVideo) {
                    $.ajax({
                        url: 'FileTransferHandler.ashx?addVideoUrl=' + url,
                        method: 'GET',
                    }).done(function (response) {
                        var that = $('#fileuploadVideo').data('fileupload');
                        data = jQuery.parseJSON(response);
                        if (data) {
                            that._renderDownload(data)
                           .css('display', 'none')
                           .appendTo($('#fileuploadVideo').find('.files'))
                           .fadeIn(function () {
                               // Fix for IE7 and lower:
                               $('#fileuploadVideo').show();
                           });
                            $('#txtYoutubeUrl').val('');
                        }
                        else {
                            //TO DO                               
                        }
                        $("#addYoutubeUrl").css("background", "#e6e6e6");
                        $('#fileuploadVideo').find("#isAdding").val(false);
                        $('#fileuploadVideo').find("#loading").css("display", "none");
                        $('#txtYoutubeUrl').removeAttr("disabled");
                    });

                }
                else {
                    showErrMsg(validatorInputVideoUrl, "Video URL does not exist, or not valid youtube URL");
                }
            });


        });

        var uploadId;
        var processingProgress = 1;

        // Initialize the jQuery File Upload widget:
        $('#fileuploadVideo').fileupload({
            autoUpload: false,
            acceptFileTypes: /(\.|\/)(flv|mp4|avi|mpg|m4v|mov|wmv|swf|rm|ram|ogg|webm|mpeg)$/i,
            maxFileSize: 52428800, // 50 MB
        })
        .bind('fileuploadadd', function (e, data) {
            uploadId = createGuid();
            var action = $('#multiUploadForm').attr("action");
            action = action + "&uploadId=" + uploadId;
            $('#multiUploadForm').attr("action", action);

            var lastFile = $('#fileuploadVideo').find('.files tr:last').get(0);
            if (lastFile)
                lastFile.scrollIntoView();
        })
        .bind('fileuploadsend', function (e, data) {
            setTimeout(function () {
                GetVideoUpLoadProgessM(data, uploadId, INITIAL_STATUS_POLLING_INTERVAL_MS / 5);
            }, INITIAL_STATUS_POLLING_INTERVAL_MS * 2);

        })
        .bind('fileuploaddone', function (e, data) {
            var responseText = data.jqXHR.responseText;
            var obj = jQuery.parseJSON(responseText);
            videoId = obj[0].videoId;

            setTimeout(function () {
                processingProgress = 1;
                $("#percent-processing" + videoId).css("display", "block");
                $("#percent-processing" + videoId).text("PROCESSING " + processingProgress + "%");
                checkVideoStatusM(data, videoId, INITIAL_STATUS_POLLING_INTERVAL_MS);
            }, 1000);
        })

        .bind('fileuploaddestroy', function (e, data) {
            var deleteUrl = data.url;
            var videoId = getParameterByUrlAndName(deleteUrl, 'v');
            $("#fileuploadVideo").find("#deleting" + videoId).css("display", "inline");

            $("#fileuploadVideo").find("#deletingVideoId").val($('#fileuploadVideo').find("#deletingVideoId").val() + videoId + ";");
        })
        .bind('fileuploaddestroyed', function (e, data) {
            var deleteUrl = data.url;
            var videoId = getParameterByUrlAndName(deleteUrl, 'v');
            $("#fileuploadVideo").find("#deleting" + videoId).css("display", "none");

            $('#fileuploadVideo').find("#deletingVideoId").val($('#fileuploadVideo').find("#deletingVideoId").val().replace(videoId + ";", ""));
        })
        .bind('fileuploadstart', function (e) {
            $('#fileuploadVideo').find('#uploadNote').css("display", "inline");
            $('#fileuploadVideo').find('#fileuploadVideo').find('.progress').append("<div id='percent-transferred'>INITIALIZING...</div>");
        });


        function GetVideoUpLoadProgessM(data, uploadId, waitForNextPoll) {
            $.ajax({
                url: '<%=ResolveUrl("~/Handlers/GetYoutubeUploadProgess.ashx")%>?uploadId=' + uploadId,
                method: 'GET',
            }).done(function (response) {       

                if (response != "100") {
                    var prePogress = parseInt($('.ui-progressbar').progressbar("value"));
                    if (prePogress == 100)
                        prePogress = 0;
                    var curPogress = parseInt(response);
      
                    if (prePogress >= curPogress && prePogress < 60) {
                        if (prePogress < 30)
                            curPogress = prePogress + 3;
                        else
                            curPogress = prePogress + 2;
                    }
                    else {
                        if (prePogress == 3)
                            curPogress = 5;
                        else if (prePogress >= curPogress)
                            curPogress = prePogress;
                    }

                    data.context.find('.ui-progressbar').progressbar(
                        'value',
                        curPogress
                    );

                    $("#percent-transferred").text("UPLOADING " + curPogress + "%");
                    setTimeout(function () {
                        GetVideoUpLoadProgessM(data, uploadId, waitForNextPoll * 1.2);
                    }, waitForNextPoll);

                }
                else /*if (response == "100")*/ {
                    data.context.find('.ui-progressbar').progressbar(
                    'value',
                        100
                    );

                    $("#percent-transferred").text("UPLOADING 100%");

                }
            });
        }

        function checkVideoStatusM(data, videoId, waitForNextPoll) {
            $.ajax({
                url: '<%=ResolveUrl("~/Handlers/CheckYoutubeStatus.ashx")%>?v=' + videoId,
                method: 'GET',
            }).done(function (response) {
                var obj = jQuery.parseJSON(response);
                var error = obj.error;
                if (error) {
                    console.log("checkVideoStatus error:" + error);
                    var tdShowError = $("#name" + videoId);
                    $(tdShowError).text(error);
                    $(tdShowError).attr("class", "error");
                    var trShowError = $(tdShowError).parent();
                    $(trShowError).addClass("ui-state-error");
                    $("#percent-processing" + videoId).css("display", "none");
                    return;
                }

                var uploadStatusName = obj.uploadStatusName;
                var uploadStatusValue = obj.uploadStatusValue;
                var rejectionReason;
          
                if (uploadStatusName == 'rejected' || uploadStatusName == 'failed') {
                    $("#during-upload").css("display", "none");
                    rejectionReason = "Video is being " + uploadStatusName + " as a " + uploadStatusValue;

                    var tdShowError = $("#name" + videoId);
                    $(tdShowError).text(rejectionReason);
                    $(tdShowError).attr("class", "error");
                    var trShowError = $(tdShowError).parent();
                    $(trShowError).addClass("ui-state-error");
                    $("#percent-processing" + videoId).css("display", "none");

                }
                else {
                    if (uploadStatusName == 'processing') {
                        if (processingProgress < 50)
                            processingProgress = processingProgress + 2;
                        else
                            processingProgress++;

                        if (processingProgress == 100)
                            processingProgress = 90;

                        $("#percent-processing" + videoId).text("PROCESSING " + processingProgress + "%");

                        setTimeout(function () {
                            checkVideoStatusM(data, videoId, waitForNextPoll * 1.1);
                        }, waitForNextPoll);

                    } else {
                        if (uploadStatusName == 'processed') {
                            $("#percent-processing" + videoId).text("PROCESSING 100%");

                            var td = $("#percent-processing" + videoId).parent();
                            $(td).empty();
                            var videoTemplate = "<object width='100%' height='120'>" +
                                               "<param name='movie' value='http://www.youtube.com/v/{videoId}'></param>" +
                                               "<param name='allowFullScreen' value='true'></param>" +
                                               "<param name='allowscriptaccess' value='always'></param>" +
                                               "<param name='wmode' value='opaque'></param>" +
                                               "<embed id='video-source' src='http://www.youtube.com/v/{videoId}' type='application/x-shockwave-flash' width='100%' height='120' allowscriptaccess='always' allowfullscreen='true' wmode='opaque'>" +
                                               "</embed>" +
                                               "</object>";

                            var videoPlayerScript = videoTemplate.replace(/{videoId}/g, videoId);
                            $(td).append(videoPlayerScript);

                            setTimeout(function () {
                                $("#percent-processing" + videoId).css("display", "none");
                            }, 1000);
                        }

                    }
                }
            });
        }


    </script>
</body>
</html>