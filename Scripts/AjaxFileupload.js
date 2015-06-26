/* File Created: May 25, 2012 */



jQuery.extend({


    createUploadIframe: function (id, uri) {
        //create frame
        var frameId = 'jUploadFrame' + id;
        var iframeHtml = '<iframe id="' + frameId + '" name="' + frameId + '" style="position:absolute; top:-9999px; left:-9999px"';
        if (window.ActiveXObject) {
            if (typeof uri == 'boolean') {
                iframeHtml += ' src="' + 'javascript:false' + '"';

            }
            else if (typeof uri == 'string') {
                iframeHtml += ' src="' + uri + '"';

            }
        }
        iframeHtml += ' />';
        jQuery(iframeHtml).appendTo(document.body);

        return jQuery('#' + frameId).get(0);
    },
    createUploadForm: function (id, fileElementId, data) {
        //create form	
        var formId = 'jUploadForm' + id;
        var fileId = 'jUploadFile' + id;
        var form = jQuery('<form  action="" method="POST" name="' + formId + '" id="' + formId + '" enctype="multipart/form-data"></form>');
        if (data) {
            for (var i in data) {
                jQuery('<input type="hidden" name="' + i + '" value="' + data[i] + '" />').appendTo(form);
            }
        }
        var oldElement = jQuery('#' + fileElementId);
        var newElement = jQuery(oldElement).clone();
        jQuery(oldElement).attr('id', fileId);
        jQuery(oldElement).before(newElement);
        jQuery(oldElement).appendTo(form);



        //set attributes
        jQuery(form).css('position', 'absolute');
        jQuery(form).css('top', '-1200px');
        jQuery(form).css('left', '-1200px');
        jQuery(form).appendTo('body');
        return form;
    },
    handleError: function (s, xhr, status, e) {
        // If a local callback was specified, fire it
        if (s.error) {
            s.error.call(s.context || window, xhr, status, e);
        }

        // Fire the global callback
        if (s.global) {
            (s.context ? jQuery(s.context) : jQuery.event).trigger("ajaxError", [xhr, s, e]);
        }
    },

    ajaxFileUpload: function (s) {
        // TODO introduce global settings, allowing the client to modify them for all requests, not only timeout		
        s = jQuery.extend({}, jQuery.ajaxSettings, s);
        var id = new Date().getTime()
        var form = jQuery.createUploadForm(id, s.fileElementId, (typeof (s.data) == 'undefined' ? false : s.data));
        var io = jQuery.createUploadIframe(id, s.secureuri);
        var frameId = 'jUploadFrame' + id;
        var formId = 'jUploadForm' + id;
        // Watch for a new set of requests
        if (s.global && !jQuery.active++) {
            jQuery.event.trigger("ajaxStart");
        }
        var requestDone = false;
        // Create the request object
        var xml = {}


        if (s.global)
            jQuery.event.trigger("ajaxSend", [xml, s]);

        // Wait for a response to come back
        var uploadCallback = function (isTimeout) {
            var io = document.getElementById(frameId);
            try {
                if (io.contentWindow) {
                    xml.responseText = io.contentWindow.document.body ? io.contentWindow.document.body.innerHTML : null;
                    xml.responseXML = io.contentWindow.document.XMLDocument ? io.contentWindow.document.XMLDocument : io.contentWindow.document;

                } else if (io.contentDocument) {
                    xml.responseText = io.contentDocument.document.body ? io.contentDocument.document.body.innerHTML : null;
                    xml.responseXML = io.contentDocument.document.XMLDocument ? io.contentDocument.document.XMLDocument : io.contentDocument.document;
                }
            } catch (e) {
                jQuery.handleError(s, xml, null, e);
            }
            if (xml || isTimeout == "timeout") {
                requestDone = true;
                var status;
                try {
                    status = isTimeout != "timeout" ? "success" : "error";
                    // Make sure that the request was successful or notmodified
                    if (status != "error") {
                        // process the data (runs the xml through httpData regardless of callback)
                        var data = jQuery.uploadHttpData(xml, s.dataType);
                        // If a local callback was specified, fire it and pass it the data
                        if (s.success)
                            s.success(data, status);

                        // Fire the global callback
                        if (s.global)
                            jQuery.event.trigger("ajaxSuccess", [xml, s]);
                    } else
                        jQuery.handleError(s, xml, status);
                } catch (e) {
                    status = "error";
                    jQuery.handleError(s, xml, status, e);
                }

                // The request was completed
                if (s.global)
                    jQuery.event.trigger("ajaxComplete", [xml, s]);

                // Handle the global AJAX counter
                if (s.global && ! --jQuery.active)
                    jQuery.event.trigger("ajaxStop");

                // Process result
                if (s.complete)
                    s.complete(xml, status);

                jQuery(io).unbind()

                setTimeout(function () {
                    try {
                        jQuery(io).remove();
                        jQuery(form).remove();

                    } catch (e) {
                        jQuery.handleError(s, xml, null, e);
                    }

                }, 100)

                xml = null

            }
        }
        // Timeout checker
        if (s.timeout > 0) {
            setTimeout(function () {
                // Check to see if the request is still happening
                if (!requestDone) uploadCallback("timeout");
            }, s.timeout);
        }
        try {

            var form = jQuery('#' + formId);
            jQuery(form).attr('action', s.url);
            jQuery(form).attr('method', 'POST');
            jQuery(form).attr('target', frameId);
            if (form.encoding) {
                jQuery(form).attr('encoding', 'multipart/form-data');
            }
            else {
                jQuery(form).attr('enctype', 'multipart/form-data');
            }
            jQuery(form).submit();

        } catch (e) {
            jQuery.handleError(s, xml, null, e);
        }

        jQuery('#' + frameId).load(uploadCallback);
        return { abort: function () { } };

    },

    uploadHttpData: function (r, type) {
        var data = !type;
        data = type == "xml" || data ? r.responseXML : r.responseText;
        // If the type is "script", eval it in global context
        if (type == "script")
            jQuery.globalEval(data);
        // Get the JavaScript object, if JSON is used.
        if (type == "json")
            eval("data = " + data);
        // evaluate scripts within html
        if (type == "html")
            jQuery("<div>").html(data).evalScripts();

        return data;
    }
})

// check extension of file to be upload
function checkFileExtension(file, uploadType) {
    var flag = true;
    var extension = file.substr((file.lastIndexOf('.') + 1)).toLowerCase();

    if (uploadType == 'video') {
        flag = true;

        switch (extension) {
            case 'flv':
            case 'mp4':
            case 'avi':
            case 'mpg':
            case 'm4v':
            case 'mov':
            case 'wmv':
            case 'swf':
            case 'rm':
            case 'ram':
            case 'ogg':
            case 'webm':
            case 'mpeg':
                //  case 'docx':
                flag = true;
                break;
            default:
                flag = false;

        }
    }
    else {
        switch (extension) {
            case 'jpg':
            case 'jpeg':
            case 'png':
            case 'gif':
            case 'bmp':
            case 'ico':
            case 'eps':
            case 'svg':
            case 'tga':
            case 'tiff':
            case 'wbmp':
            case 'webp':
                flag = true;
                break;
            default:
                flag = false;
        }
    }

    return flag;
}

//get file path from client system
function getNameFromPath(strFilepath) {

    var objRE = new RegExp(/([^\/\\]+)$/);
    var strName = objRE.exec(strFilepath);

    if (strName == null) {
        return null;
    }
    else {
        return strName[0];
    }

}
function showError(validator, message) {
    if (validator) {
        $(validator).text(message);
        $(validator).attr('title', message);
        $(validator).css("display", "inline");
    }
    else
        alert(message);
}
// Asynchronous file upload process
function ajaxFileUpload(rootServerPath, txtphotoUrlID, imgLoading, fileToUploadID, validatorPhotoUrl, imgPhoto, linAddPhoto, dontDeletePreImage, userFolder) {

    var fileToUpload = getNameFromPath($('#' + fileToUploadID).val());
    var filename = '';
    if (fileToUpload) {
        filename = fileToUpload.substr(0, (fileToUpload.lastIndexOf('.')));
    }

    if (validatorPhotoUrl) {
        $(validatorPhotoUrl).text('');
        $(validatorPhotoUrl).css("display", "none");
    }

    if (checkFileExtension(fileToUpload, 'photo')) {

        var flag = true;
        if (filename != "" && filename != null) {
            if (flag == true) {
                $("#" + imgLoading).bind("ajaxStart", function () {
                    $("#" + imgLoading).css("display", "inline");
                    $('#' + fileToUploadID).attr("disabled", "disabled");
                })

                var oldPath = '';
                if (dontDeletePreImage && $('#' + dontDeletePreImage).val() == "0") {
                    oldPath = $('#' + txtphotoUrlID).val();
                }
                var url = rootServerPath + 'Handlers/FileUpload.ashx?oldPath=' + oldPath;

                if (userFolder) {
                    url = url + '&userFolder=' + userFolder;
                }
                alert(url);
                $.ajaxFileUpload({
                    url: url,
                    secureuri: false,
                    fileElementId: fileToUploadID,
                    dataType: 'json',

                    success: function (data, status) {
                        $("#" + imgLoading).unbind("ajaxStart ajaxStop");
                        if (typeof (data.error) != 'undefined') {
                            if (data.error != '') {

                                showError(validatorPhotoUrl, data.error);
                            } else {
                                $('#' + fileToUploadID).val("");
                                var photoPath = data.serverpath + '/' + data.upfile;
                                $('#' + txtphotoUrlID).val(photoPath);
                                if (dontDeletePreImage)
                                    $('#' + dontDeletePreImage).val("0");
                                if (imgPhoto) {
                                    var imgUrl = rootServerPath + photoPath;
                                    $('#' + imgPhoto).attr('src', imgUrl);
                                    $('#' + imgPhoto).css('display', 'inline');
                                }
                                if (linAddPhoto)
                                    $('#' + linAddPhoto).text('Change photo');

                            }
                        }
                        $("#" + imgLoading).css("display", "none");
                        $('#' + fileToUploadID).removeAttr("disabled");
                    },
                    error: function (data, status, e) {
                        $("#" + imgLoading).unbind("ajaxStart ajaxStop");
                        $("#" + imgLoading).css("display", "none");
                        $('#' + fileToUploadID).removeAttr("disabled");
                        showError(validatorPhotoUrl, data.responseText);
                    },

                });
            }
            else {
                $("#" + imgLoading).css("display", "none");
                $('#' + fileToUploadID).removeAttr("disabled");
                showError(validatorPhotoUrl, 'file ' + filename + ' already exist');
                return false;
            }
        }
    }
    else {
        showError(validatorPhotoUrl, 'You can upload only files with the following extensions: jpg, jpeg, png, bmp, ico, eps, svg, tga, tiff, wbmp, webp');
        if (imgPhoto) {

            $('#' + imgPhoto).attr('src', '');
            $('#' + imgPhoto).css('display', 'none');
        }
        if (linAddPhoto)
            $('#' + linAddPhoto).text('Add photo');

    }
    return false;

}

var INITIAL_STATUS_POLLING_INTERVAL_MS = 15 * 1000;

function ajaxFileUploadVideo(rootServerPath, txtVideoUrlID, imgLoading, fileToUploadID, uploadType, validatorVideoUrl, linAddVideo, divVideo, videoPlayerScriptTemplate, maxSize) {
    var fileToUpload = getNameFromPath($('#' + fileToUploadID).val());
    var filename = fileToUpload.substr(0, (fileToUpload.lastIndexOf('.')));

    //clear old data
    if (validatorVideoUrl) {
        $(validatorVideoUrl).text('');
        $(validatorVideoUrl).css("display", "none");
    }

    $('#' + txtVideoUrlID).val("");
    if (divVideo)
        $(divVideo).empty();

    if (checkFileExtension(fileToUpload, uploadType)) {

        if (maxSize) {
            var fileSize = 0;
            if (navigator.appName == "Microsoft Internet Explorer") {                  
                var filepath = $('#' + fileToUploadID)[0].value;
                try{
                    var filesystem = new ActiveXObject('Scripting.FileSystemObject');
                    fileSize = filesystem.getFile(filepath).size;
                }
                catch(err) {                
                }
            }
            else
                fileSize = $('#' + fileToUploadID)[0].files[0].size;

            if (fileSize >= maxSize * 1024 * 1024) {
                showError(validatorVideoUrl, "Please upload a file has size smaller than " + maxSize + " MB");
                return;
            }
        }
        if (filename != "" && filename != null) {
            $("#" + imgLoading).bind("ajaxStart", function (event) {
                $("#" + imgLoading).css("display", "inline");
                $('#' + fileToUploadID).attr("disabled", "disabled");


            });

            var uploadId = createGuid();
            $(duringupload).css("display", "inline");
            $.ajaxFileUpload({
                url: rootServerPath + 'Handlers/FileUpload.ashx?uploadId=' + uploadId,
                secureuri: false,
                fileElementId: fileToUploadID,
                dataType: 'json',
                success: function (data, status) {
                    $("#" + imgLoading).unbind("ajaxStart ajaxStop");
                    if (typeof (data.error) != 'undefined') {
                        if (data.error != '') {
                            $("#" + imgLoading).css("display", "none");
                            $('#' + fileToUploadID).removeAttr("disabled");
                            console.log('success, data.error:');
                            $(duringupload).css("display", "none");
                            showError(validatorVideoUrl, data.error);
                        } else {
                            $('#' + fileToUploadID).val("");
                            var videoId = data.upfile;
                            setTimeout(function () {
                                checkVideoStatus(rootServerPath, videoId, INITIAL_STATUS_POLLING_INTERVAL_MS, fileToUploadID, imgLoading, txtVideoUrlID, validatorVideoUrl, linAddVideo, divVideo, videoPlayerScriptTemplate);
                            }, INITIAL_STATUS_POLLING_INTERVAL_MS * 3);

                        }
                    }
                },

                error: function (data, status, e) {
                    $("#" + imgLoading).unbind("ajaxStart ajaxStop");
                    $("#" + imgLoading).css("display", "none");
                    $('#' + fileToUploadID).removeAttr("disabled");
                    console.log('call error method');
                    $(duringupload).css("display", "none");
                    showError(validatorVideoUrl, data.responseText);

                }
            });
            $(uploadprogress).attr({
                value: 1,
                max: 100
            });
            $(percenttransferred).text("UPLOADING 1%");
            setTimeout(function () {
                GetVideoUpLoadProgess(rootServerPath, uploadId, INITIAL_STATUS_POLLING_INTERVAL_MS / 5);
            }, INITIAL_STATUS_POLLING_INTERVAL_MS * 2);
        }

    }
    else {
        showError(validatorVideoUrl, 'You can upload only flv, mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files.');
        $(uploadprogress).css("display", "none");
        $(percenttransferred).css("display", "none");
        $('#' + fileToUploadID).removeAttr("disabled");
        $('#' + txtVideoUrlID).val('');
        if (divVideo) {
            $('#' + divVideo).css('display', 'none');
        }
        if (linAddVideo)
            $('#' + linAddVideo).text('Add video');

    }
    return false;

}

function createGuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function GetVideoUpLoadProgess(rootServerPath, uploadId, waitForNextPoll) {
    $.ajax({
        url: rootServerPath + 'Handlers/GetYoutubeUploadProgess.ashx?uploadId=' + uploadId,
        method: 'GET',
    }).done(function (response) {
        console.log("GetVideoUpLoadProgess " + uploadId + " : " + response);

        if (response != "100") {
            var prePogress = parseInt($(uploadprogress).attr("value"));
            var curPogress = parseInt(response);
            console.log("prePogress=" + prePogress + ", curPogress=" + curPogress);
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

            $(uploadprogress).attr({
                value: curPogress,
                max: 100
            });
            $(percent - transferred).text("UPLOADING " + curPogress + "%");
            setTimeout(function () {
                GetVideoUpLoadProgess(rootServerPath, uploadId, waitForNextPoll * 1.2);
            }, waitForNextPoll);

        }
        else /*if (response == "100")*/ {
            $(uploadprogress).attr({
                value: 100,
                max: 100
            });
            $(percenttransferred).text("UPLOADING 100%");

            setTimeout(function () {
                $(uploadprogress).attr({
                    value: 1,
                    max: 100
                });
                processingProgress = 2;
                $(percenttransferred).text("PROCESSING " + processingProgress + "%");

            }, 2000);
        }
    });
}

var processingProgress = 0;
function checkVideoStatus(rootServerPath, videoId, waitForNextPoll, fileToUploadID, imgLoading, txtVideoUrlID, validatorVideoUrl, linAddVideo, divVideo, videoPlayerScriptTemplate) {
    $.ajax({
        url: rootServerPath + 'Handlers/CheckYoutubeStatus.ashx?v=' + videoId,
        method: 'GET',
    }).done(function (response) {
        var obj = jQuery.parseJSON(response);
        var error = obj.error;
        if (error) {
            console.log("checkVideoStatus error");
            $("#" + imgLoading).css("display", "none");
            $(duringupload).css("display", "none");
            $('#' + fileToUploadID).removeAttr("disabled");
            showError(validatorVideoUrl, error);
            return;
        }

        var uploadStatusName = obj.uploadStatusName;
        var uploadStatusValue = obj.uploadStatusValue;
        var rejectionReason;

        if (uploadStatusName == 'rejected' || uploadStatusName == 'failed') {
            $(duringupload).css("display", "none");
            $("#" + imgLoading).css("display", "none");
            $('#' + fileToUploadID).removeAttr("disabled");

            rejectionReason = "Video is being " + uploadStatusName + " as a " + uploadStatusValue;
            showError(validatorVideoUrl, rejectionReason);

            if (linAddVideo)
                $('#' + linAddVideo).text('Add video');
        }
        else {
            if (uploadStatusName == 'processing') {
                if (processingProgress < 50)
                    processingProgress = processingProgress + 2;
                else
                    processingProgress++;

                if (processingProgress == 100)
                    processingProgress = 90;

                $(uploadprogress).attr({
                    value: processingProgress,
                    max: 100
                });
                $(percenttransferred).text("PROCESSING " + processingProgress + "%");

                setTimeout(function () {
                    checkVideoStatus(rootServerPath, videoId, waitForNextPoll * 1.1, fileToUploadID, imgLoading, txtVideoUrlID, validatorVideoUrl, linAddVideo, divVideo, videoPlayerScriptTemplate);
                }, waitForNextPoll);

            } else {
                if (uploadStatusName == 'processed') {
                    $(uploadprogress).attr({
                        value: 100,
                        max: 100
                    });
                    $(percenttransferred).text("PROCESSING 100%");

                    var youtubeUrl = "https://www.youtube.com/watch?v=" + videoId;
                    $('#' + txtVideoUrlID).val(youtubeUrl);

                    if (videoPlayerScriptTemplate && divVideo) {
                        youtubeUrl = youtubeUrl.replace('watch?v=', 'v/');
                        videoPlayerScript = videoPlayerScriptTemplate.replace(/{youtubeURL}/g, youtubeUrl);
                        $(divVideo).empty();
                        $(divVideo).append($(videoPlayerScript));
                        $(divVideo).css('display', 'block');
                    }
                    if (linAddVideo)
                        $('#' + linAddVideo).text('Change video');

                    $("#" + imgLoading).unbind("ajaxStart ajaxStop");
                    $("#" + imgLoading).css("display", "none");
                    $('#' + fileToUploadID).removeAttr("disabled");

                    setTimeout(function () {
                        $(duringupload).css("display", "none");
                    }, 1000);
                }

            }
        }
    });
}

// Extract the YouTube ID 
function linkifyYouTubeURLs(text) {
    //var youtubePattern = /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube(?:-nocookie)?\.com\S*[^\w\s-])([\w-]{11})(?=[^\w-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/ig;
    var youtubePattern = /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com(?:\/embed\/|\/v\/|\/watch\?v=|\/ytscreeningroom\?v=|\/feeds\/api\/videos\/|\/user\S*[^\w\-\s]|\S*[^\w\-\s]))([\w\-]{11})[?=&+%\w-]*/ig;
    return text.replace(youtubePattern, '$1');
}


$.youtubeVideoExists = function (url, callback) {

    var v = linkifyYouTubeURLs(url);
    if (v === null) {
        callback(false);

        return;
    }

    $.get('https://gdata.youtube.com/feeds/api/videos/' + v + '?v=2&alt=jsonc&callback=?', function (data) {
        callback(typeof data.data !== 'undefined');
    }, 'jsonp');
};

$.youtubeVideoExists2 = function (url, callback) {

    var v = linkifyYouTubeURLs(url);
    if (v === null) {
        callback(false, url);

        return;
    }

    $.get('https://gdata.youtube.com/feeds/api/videos/' + v + '?v=2&alt=jsonc&callback=?', function (data) {
        callback(typeof data.data !== 'undefined',url);
    }, 'jsonp');
};


if (typeof String.prototype.startsWith != 'function') {
    // see below for better implementation!
    String.prototype.startsWith = function (str) {
        return this.indexOf(str) == 0;
    };
}