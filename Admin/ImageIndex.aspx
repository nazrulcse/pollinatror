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


<div id="fileupload">
    
 <input type="hidden" id="isLoading" value="true"/>
 <input type="hidden" id="isAdding" value="false" />
 <input type="hidden" id="deletingUrl" value=";"/>   
    <form id="multiUploadForm" action="FileTransferHandler.ashx" method="post" enctype="multipart/form-data">
        <div class="fileupload-buttonbar">
            <label class="fileinput-button">
                <span>Add files...</span>
                <input type="file" name="files[]" multiple="multiple" />
            </label>
           <button type="submit" class="start">Start upload</button>
            <button type="reset" class="cancel">Cancel upload</button>
            <button type="button" class="delete">Delete files</button>
			<div class="fileupload-progressbar"></div>
        </div>
    </form>
     <div class="fileupload-content" style="padding-top:10px; padding-bottom:15px">
            

         <div>
                <div style="float: left; margin-left: 2px; margin-top: 5px; font-size: 11px; font-weight: bold">Paste an image URL here</div>

                <div style="float: left; margin-left: 10px;">
                    <input type="text" style="width: 380px" id="txtPhotoUrl" />
                </div>

                <div id="addPhotoUrl" class="ui-button ui-corner-all" style="float: left; margin-left: 10px; margin-top: 2px; background: #e6e6e6; border: 1px solid #d3d3d3; padding: 3px 3px 3px 3px">
                    <span class="ui-button-icon-primary ui-icon ui-icon-plusthick" style="display: block;"></span>                     
                </div>
              <img id="loading" src="loading.gif" style="display: none;">
            </div>

            <div style="clear:both;margin-left: 172px;">
                <img id="photoImg"  style="display:none"/>
                <span id="validatorInputPhotoUrl" title="" class="message-error" style="display: none;"></span>
            </div>
            <div style="padding-top:20px">
                <table class="files"></table>
            </div>
    </div>
   
</div>

<script >
    var userFolder = getParameterByName('userFolder');
    var photoUrl = getParameterByName('photoUrl');
    var action = "FileTransferHandler.ashx?userFolder=" + userFolder + "&photoUrl=" + photoUrl;;
    $('#multiUploadForm').attr("action", action);

</script>


<script id="template-upload" type="text/x-jquery-tmpl">
    <tr class="template-upload{{if error}} ui-state-error{{/if}}">
        <td class="preview"></td>
        <td class="name">${getNameCustom(name)}</td>
        <td class="size">${sizef}</td>
        {{if error}}
            <td class="error" colspan="2">Error:
                {{if error === 'maxFileSize'}}File is too big
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else}}${error}
                {{/if}}
            </td>
        {{else}}
            <td class="progress"><div></div></td>
            <td class="start"><button>Start</button></td>
        {{/if}}
        <td class="cancel"><button>Cancel</button></td>
    </tr>
</script>
<script id="template-download" type="text/x-jquery-tmpl">
    <tr class="template-download{{if error}} ui-state-error{{/if}}">
        {{if error}}
            <td></td>
            <td class="name">${name}</td>
            <td class="size">${sizef}</td>
            <td class="error" colspan="2">Error:
                {{if error === 1}}File exceeds upload_max_filesize (php.ini directive)
                {{else error === 2}}File exceeds MAX_FILE_SIZE (HTML form directive)
                {{else error === 3}}File was only partially uploaded
                {{else error === 4}}No File was uploaded
                {{else error === 5}}Missing a temporary folder
                {{else error === 6}}Failed to write file to disk
                {{else error === 7}}File upload stopped by extension
                {{else error === 'maxFileSize'}}File is too big
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else error === 'uploadedBytes'}}Uploaded bytes exceed file size
                {{else error === 'emptyResult'}}Empty file upload result
                {{else}}${error}
                {{/if}}
            </td>
        {{else}}
            <td class="preview">
                {{if upload_url}}
                <input type="hidden" class="hiddenfield" value="${upload_url}"/>
                   {{/if}}
                {{if thumbnail_url}}
                    <a href="${url}" target="_blank"><img style="max-width:100px;max-height:100px" src="${thumbnail_url}"></a>
                {{/if}}
            </td>
            <td class="name">
                <a href="${url}"{{if thumbnail_url}} target="_blank"{{/if}}>${name}</a>
            </td>
          
            <td colspan="3"></td>
        {{/if}}
        <td class="delete">
            <button data-type="${delete_type}" data-url="${delete_url}">Delete</button>
        </td>
    </tr>
</script>

<script>
    $(function () {
        'use strict';

        // Load existing files:
        $.getJSON($('#fileupload form').prop('action'), function (files) {

            var fu = $('#fileupload').data('fileupload');
            if (files !== 'null' || files !== 'undefined') {
                fu._adjustMaxNumberOfFiles(-files.length);
            }
            fu._renderDownload(files)
                .appendTo($('#fileupload .files'))
                .fadeIn(function () {
                    // Fix for IE7 and lower:
                    $(this).show();                 
                });

            $('#fileupload').find("#isLoading").val(false);
            console.log("finish loading");
        });

        // Open download dialogs via iframes,
        // to prevent aborting current uploads:
        $('#fileupload .files a:not([target^=_blank])').live('click', function (e) {
            e.preventDefault();
            $('<iframe style="display:none;"></iframe>')
                .prop('src', this.href)
                .appendTo('body');
        });

    });


    function showErrMsg(validator, msg) {
        $(validator).css('display', 'inline');
        $(validator).text(msg);
        $('#txtPhotoUrl').focus();
        $("#addPhotoUrl").css("background", "#e6e6e6");
        $('#fileupload').find("#isAdding").val(false);
        $('#fileupload').find("#loading").css("display", "none");
        $('#txtPhotoUrl').removeAttr("disabled");
    }

    var isAdding;
    $('#addPhotoUrl').bind('click', function () {
        isAdding = $('#fileupload').find("#isAdding").val();

        console.log("addPhotoUrl :isAdding="+isAdding);     

        if (isAdding == true || isAdding == "true")
            return;

        $('#fileupload').find("#isAdding").val(true);
        $('#txtPhotoUrl').attr("disabled", "disabled");

        $("#addPhotoUrl").css("background", "#DFDCDC");      
        $('#fileupload').find("#loading").css("display", "inline");

        var validatorInputPhotoUrl = '#validatorInputPhotoUrl';
        $(validatorInputPhotoUrl).css("display", "none");

        var imgPhoto = '#photoImg';
        var url = $('#txtPhotoUrl').val().trim();

        if (url == '') {
            $("#addPhotoUrl").css("background", "#e6e6e6");
            $('#fileupload').find("#isAdding").val(false);
            $('#fileupload').find("#loading").css("display", "none");
            $('#txtPhotoUrl').removeAttr("disabled");
            return;
        }
       
        var validUrl = true;
        if (url.startsWith('UploadFiles')) {
            var rootServerPath = '<%=ResolveUrl("~")%>';
            url = rootServerPath + url;
        }

        //check url in add list or not
        var imgaddbefore = $('#fileupload').find('.files').find('.hiddenfield').filter(
            function (index) {
                return $(this).val() == decodeURIComponent(url);
            }
        );

        if (imgaddbefore.length > 0) {
            showErrMsg(validatorInputPhotoUrl, 'Photo URL was already added. Please select another.');
            $('#txtPhotoUrl').val('');
            return;
        }

        $(imgPhoto).attr('src', url);       

        $(imgPhoto).error(function () {
            validUrl = false;
            console.log('validUrl1:' + validUrl);
            showErrMsg(validatorInputPhotoUrl, 'Photo URL does not exist.');
        });

        if (validUrl) {
            $.ajax({
                url: 'FileTransferHandler.ashx?addPhotoUrl=' + url,
                method: 'GET',
            }).done(function (response) {
                var that = $('#fileupload').data('fileupload');
                data = jQuery.parseJSON(response);
                if (data && data.length > 0) {
                    that._renderDownload(data)
                    .css('display', 'none')
                    .appendTo($('#fileupload').find('.files'))
                    .fadeIn(function () {
                        // Fix for IE7 and lower:
                        $('#fileupload').show();
                    });
                    $('#txtPhotoUrl').val('');    
                }
                else {
                }
                $("#addPhotoUrl").css("background", "#e6e6e6");
                $('#fileupload').find("#isAdding").val(false);
                $('#fileupload').find("#loading").css("display", "none");
                $('#txtPhotoUrl').removeAttr("disabled");
            });
        }


    });

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        autoUpload: false,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png|bmp|ico|eps|svg|tga|tiff|wbmp|webp)$/i,
        maxFileSize: 5000000, // 5 MB
    })
    .bind('fileuploaddestroy', function (e, data) {
        var deleteUrl = data.url;

        $('#fileupload').find("#deletingUrl").val($('#fileupload').find("#deletingUrl").val() + deleteUrl + ";");
    })
    .bind('fileuploaddestroyed', function (e, data) {
        var deleteUrl = data.url;
        $('#fileupload').find("#deletingUrl").val($('#fileupload').find("#deletingUrl").val().replace(deleteUrl + ";", ""));
    });

</script>
</body> 
</html>