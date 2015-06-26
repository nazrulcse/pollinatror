<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UploadMultiFiles.ascx.cs" Inherits="Controls_UploadMultiFiles" %>
<a href="#x" class="overlay" id="Upload_form<%=FileType%>"></a>
<div class="popup" style="width: 900px; height: 500px; max-height: 600px; resize: both; overflow: auto;">
    <iframe id='uploadiframe' src="../Modules/Upload/index.html?userFolder=<%=UserFolder%>" runat="server" style="width: 98%; height: 80%;"></iframe>
    <div style="text-align: center">
        <div style="text-align: center">
            <a id="doneUploadPopup<%=FileType%>" href="#close" class="submit button btn12" style="font-family: Verdana; color: white; font-size: 14px">Done</a>
        </div>
    </div>
    <a id="closeUploadPopup<%=FileType%>" class="popup-close" href="#close"></a>

    <div id="divConfirmStartUpload<%=FileType%>" class="ConfirmClose" style="display: none">
        <div class="ConfirmClose-header">

            <h2 class="info-window-header">Confirmation</h2>
            <hr />
        </div>
        <div class="ConfirmClose-body">
            <div class="lblConfirm">Files are added but not upload yet. Do you want to upload before closing form?</div>
            <div class="ConfirmClose-footer">
                <input type="button" id="btnYes" value="Yes" class="btn btnYes">
                <input type="button" id="btnNo" value="No" class="btn btnNo">
                <input type="button" id="btnCancel" value="Cancel" class="btn btnCancel">
            </div>
        </div>
    </div>


    <div id="divConfirmWaitUpload<%=FileType%>" class="ConfirmClose" style="display: none">
        <div class="ConfirmClose-header">

            <h2 class="info-window-header">Confirmation</h2>
            <hr />
        </div>
        <div class="ConfirmClose-body">
            <div class="lblConfirm">Uploading is in progress. Click "Yes" to stay in, click "No" to close the form?</div>
            <div class="ConfirmClose-footer">
                <input type="button" id="btnWaitUpload" value="Yes" class="btn btnYes">
                <input type="button" id="btnDontWaitUpload" value="No" class="btn btnNo">
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="userFolder<%=FileType%>" value="" />

<style>
    .ConfirmClose
    {
        border: 1px solid #aaaaaa/*{borderColorHeader}*/;
        background: #E7E7E7;
        background: -webkit-linear-gradient(#E7E7E7, #BBBBBB); /* For Safari 5.1 to 6.0 */
        background: -o-linear-gradient(#E7E7E7, #BBBBBB); /* For Opera 11.1 to 12.0 */
        background: -moz-linear-gradient(#E7E7E7, #BBBBBB); /* For Firefox 3.6 to 15 */
        background: linear-gradient(#E7E7E7, #BBBBBB); /* Standard syntax */
        
        background: -webkit-gradient(linear, left top, left bottom, from(#E7E7E7), to(#BBBBBB));
        background: -ms-linear-gradient(#E7E7E7, #BBBBBB);
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E7E7E7', endColorstr='#BBBBBB');
        zoom: 1;
        z-index: 10007;
        position: absolute;
        left: 275px;
        top: 150px;
        border-radius: 4px;
        width: 350px;
        padding: 10px;
    }

    .ConfirmClose-body
    {
        margin-top: 22px;
        margin-bottom: 2px;
    }

    .ConfirmClose-footer
    {
        text-align: right;
        -webkit-border-radius: 0 0 6px 6px;
        -moz-border-radius: 0 0 6px 6px;
        border-radius: 0 0 6px 6px;
    }

    .ConfirmClose .info-window-header
    {
        font-family: Tahoma, Verdana, Arial;
        font-size: 16px;
        font-weight: bold;
        line-height: 100%;
        color: black;
        margin-top: 4px;
        margin-bottom: -8px;
    }

    .ConfirmClose hr
    {
        border: 0;
        border-top: 1px solid #eee;
        margin-top: 20px;
        margin-bottom: 20px;
    }

     .ConfirmClose .lblConfirm
    {
         font-family: Tahoma, Verdana, Arial;
         font-size: 15px;
         padding-bottom:16px;
         text-align: left;
    }

    .ConfirmClose .btn
    {
        font-family: Tahoma, Verdana, Arial;
        display: inline-block;
        padding: 6px 12px;
        margin-bottom: 0;
        font-size: 14px;
        font-weight: normal;
        line-height: 1.428571429;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        cursor: pointer;
        border: 1px solid transparent;
        border-radius: 5px;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        -o-user-select: none;
        user-select: none;
    }

    .ConfirmClose .btn:hover, .btn:focus
    {
        color: #333;
        text-decoration: none;
    }


    .btnYes
    {
        color: #fff;
        background-color: #5cb85c;
        background-image: -webkit-linear-gradient(top,#5cb85c 0,#419641 100%);
        background-image: linear-gradient(to bottom,#5cb85c 0,#419641 100%);
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff5cb85c',endColorstr='#ff419641',GradientType=0);
        background-repeat: repeat-x;
        border-color: #3e8f3e;
    }

    

    .btnYes:hover, .btnYes:focus
    {
        background-color: #419641;
        background-position: 0 -15px;
    }

    .btnYes:hover, .btnYes:focus, .btnYes:active, .btnYes.active
    {
        color: #fff;
        background-color: #47a447;
        border-color: #398439;
    }

    .btnNo
    {
        color: #fff;
         background-color: #f0ad4e;
        background-image: -webkit-linear-gradient(top,#f0ad4e 0,#eb9316 100%);
        background-image: linear-gradient(to bottom,#f0ad4e 0,#eb9316 100%);
        background-repeat: repeat-x;
        border-color: #e38d13;
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fff0ad4e',endColorstr='#ffeb9316',GradientType=0);  
    }

    .btnNo:hover, .btnNo:focus
    {
        background-color: #eb9316;
        background-position: 0 -15px;
    }

    .btnNo:hover, .btnNo:focus, .btnNo:active, .btnNo.active
    {
        color: #fff;
        background-color: #ed9c28;
        border-color: #d58512;
    }

    .btnCancel
    {
        text-shadow: 0 1px 0 #fff;
        background-color: #fff;
        background-image: -webkit-linear-gradient(top,#fff 0,#e0e0e0 100%);
        background-image: linear-gradient(to bottom,#fff 0,#e0e0e0 100%);
        background-repeat: repeat-x;
        border-color: #dbdbdb;
        border-color: #ccc;
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff',endColorstr='#ffe0e0e0',GradientType=0);
    }

    .btnCancel:hover, .btnCancelfocus
    {
        background-color: #e0e0e0;
        background-position: 0 -15px;
    }

    .btnCancel:hover, .btnCancel:focus, .btnCancel:active, .btnCancel.active
    {
        color: #333;
        background-color: #ebebeb;
        border-color: #adadad;
    }
</style>

<script>
    //lock parent when popup show
    $('#UploadPhoto_form<%=FileType%>').on('click', function (e) {
        e.preventDefault();
    });

    $('#doneUploadPopup<%=FileType%>').on('click', function (e) {
        ClosePopUp(e, '<%=FileType%>', '#<%=uploadiframe.ClientID%>');
    });

    $('#closeUploadPopup<%=FileType%>').on('click', function (e) {

        ClosePopUp(e, '<%=FileType%>', '#<%=uploadiframe.ClientID%>');
    });

    $('#divConfirmStartUpload<%=FileType%> #btnYes').on('click', function (e) {
        var fileType = '<%=FileType%>';
        CloseConfirmStartUpload(e, fileType);

        var frameId = '#<%=uploadiframe.ClientID%>';
        $(frameId).contents().find('body').find("#startUpload").click();
    });

    $('#divConfirmStartUpload<%=FileType%> #btnNo').on('click', function (e) {
        var fileType = '<%=FileType%>';
        CloseConfirmStartUpload(e, fileType);

        var frameId = '#<%=uploadiframe.ClientID%>';

        var numStartButton = 0;
        $(frameId).contents().find('body').find("td.start").each(function () {
            if ($($(this)[0].firstElementChild).css("display") != "none") {
                numStartButton++;
            }
        });

        var numProgessButton = $(frameId).contents().find('body').find(".progress").length - numStartButton;
        if (numProgessButton == 0) {
            $(frameId).contents().find('body').find(".processing").each(function () {
                if ($(this).css("display") != "none") {
                    numProgessButton++;
                }
            });
        }

        if (numProgessButton > 0) {
            $('#divConfirmWaitUpload' + fileType).css('display', 'block');
        }
        else {
            window.location = window.location + "#close";
            doClosePopup(fileType, frameId);

        }
    });


    $('#divConfirmStartUpload<%=FileType%> #btnCancel').on('click', function (e) {
        var fileType = '<%=FileType%>';
        CloseConfirmStartUpload(e, fileType);
    });

    function CloseConfirmStartUpload(e, fileType) {
        $('#divConfirmStartUpload' + fileType).css('display', 'none');
    }

    $('#divConfirmWaitUpload<%=FileType%> #btnWaitUpload').on('click', function (e) {
        var fileType = '<%=FileType%>';
        CloseConfirmWaitUpload(e, fileType);
    });

    $('#divConfirmWaitUpload<%=FileType%> #btnDontWaitUpload').on('click', function (e) {
        var fileType = '<%=FileType%>';
        CloseConfirmWaitUpload(e, fileType);

        window.location = window.location + "#close";
        var frameId = '#<%=uploadiframe.ClientID%>';
        doClosePopup(fileType, frameId);
    });

    function CloseConfirmWaitUpload(e, fileType) {
        $('#divConfirmWaitUpload' + fileType).css('display', 'none');
    }

    function ClosePopUp(e, fileType, frameId) {

        isClickOpenPopup = false;
        isClickClosePopup = true;

        var isLoading = $(frameId).contents().find('body').find("#isLoading").val();
        if (isLoading == true || isLoading == "true") {
            return;
        }

        var numStartButton = 0;
        $(frameId).contents().find('body').find("td.start").each(function () {
            if ($($(this)[0].firstElementChild).css("display") != "none") {
                numStartButton++;
            }
        });

        if (numStartButton > 0) {
            e.preventDefault();
            $('#divConfirmStartUpload' + fileType).css('display', 'block');
            return;
        }
        else {
            var numProgessButton = $(frameId).contents().find('body').find(".progress").length;
            if (numProgessButton == 0) {
                $(frameId).contents().find('body').find(".processing").each(function () {
                    if ($(this).css("display") != "none") {
                        numProgessButton++;
                    }
                });
            }

            if (numProgessButton > 0) {
                e.preventDefault();
                $('#divConfirmWaitUpload' + fileType).css('display', 'block');
                return;
            }

        }
        doClosePopup(fileType, frameId);
    }

    function doClosePopup(fileType, frameId) {
        GetUploadFilePath(fileType, frameId);

        if ($(frameId).contents().find('body').find("#validatorInputVideoUrl")) {
            $(frameId).contents().find('body').find("#validatorInputVideoUrl").css('display', 'none');
        }
        if ($(frameId).contents().find('body').find("#validatorInputPhotoUrl")) {
            $(frameId).contents().find('body').find("#validatorInputPhotoUrl").css('display', 'none');
        }
    }

    //get list files
    function GetUploadFilePath(fileType, frameId) {
        var isAdding = $(frameId).contents().find('body').find("#isAdding").val();
        if (isAdding == true || isAdding == "true") {
            setTimeout(function () {
                GetUploadFilePath(fileType, frameId);
            }, 1000);

            return;
        }

        if (fileType == 'image') {
            var linkImgs = $(frameId).contents().find('.files').find('.hiddenfield');
            var deletingUrl = $(frameId).contents().find('body').find('#deletingUrl').val();
            var photoUrl = "";
            for (var i = 0; i < linkImgs.length; i++) {
                var obj = linkImgs[i];
                var url = $(obj).val();
                if (deletingUrl.indexOf(url) < 0) {
                    photoUrl = photoUrl + "; " + url;
                }


            }
            if (photoUrl.length > 0)
                photoUrl = photoUrl.substr(1);

            $(txtPhotoUrl).val(photoUrl);
            displayImageOnChange($(txtPhotoUrl), true);

            var dataTransfer = JSON.stringify({
                userFolder: '<%=UserFolder%>'
            });
            var url = '<%=ResolveUrl("~/Modules/Upload/UpdateUrlsToDB.ashx")%>';
            url = url + '?userFolder=' + $('#userFolder<%=FileType%>').val();
            url = url + '&userID=<%=UserID%>';
            url = url + '&photoUrl=' + photoUrl;

            $.ajax({
                type: "POST",
                url: url,
                data: dataTransfer,
                success: function (data, status) {
                },
                error: function (data, status, e) {
                    console.log("Transfer data to webservice UpdateUrlsToDB be error: " + status);
                }
            });

        }
        else {
            var linkObjectVideos = $(frameId).contents().find('body').find('object');
            var deletingVideoId = $(frameId).contents().find('body').find('#deletingVideoId').val();

            var videoUrl = "";
            for (var i = 0; i < linkObjectVideos.length; i++) {
                var obj = linkObjectVideos[i];
                var thisUrl = $(obj).find('embed').attr('src').replace("v/", "watch?v=");
                var videoId = linkifyYouTubeURLs(thisUrl);
                if (deletingVideoId.indexOf(videoId) < 0) {
                    videoUrl = videoUrl + "; " + thisUrl;
                }
            }

            if (videoUrl.length > 0)
                videoUrl = videoUrl.substr(1);

            if (txtYoutubeUrl)
                $(txtYoutubeUrl).val(videoUrl);

            displayVideoWithOutValidate(txtYoutubeUrl, true);

            var dataTransfer = JSON.stringify({
                userFolder: '<%=UserFolder%>'
            });

            var url = '<%=ResolveUrl("~/Modules/Upload/UpdateUrlsToDB.ashx")%>';
            url = url + '?userFolder=' + $('#userFolder<%=FileType%>').val();
            url = url + '&userID=<%=UserID%>';
            url = url + '&youtubeUrl=' + videoUrl;

            $.ajax({
                type: "POST",
                url: url,
                data: dataTransfer,
                success: function (data, status) {
                },
                error: function (data, status, e) {
                    console.log("Transfer data to webservice UpdateUrlsToDB be error: " + status);
                }
            });
        }
    }

    var isClickOpenPopup = false;
    var isClickClosePopup = false;
    if (window.history && window.history.pushState) {

        $(window).on('popstate', function () {
            var hashLocation = location.hash;
            console.log("hashLocation:" + hashLocation, ",isClickClosePopup=" + isClickClosePopup);
            if (hashLocation == "") {
                console.log("none");
                history.back();
            }
            else if (hashLocation.indexOf("Upload") > -1 && !isClickOpenPopup) {
                console.log("click back OpenPopup");
                history.back();
            }
            //else if (hashLocation.indexOf("close") > -1 && !isClickClosePopup) {
            //    history.back();
            //}

            setTimeout(function () {
                isClickOpenPopup = false;
                isClickClosePopup = false;
            }, 1000);

        });
    }

    function openPopup() {
        isClickOpenPopup = true;
        isClickClosePopup = false;
        if ($(validatorInputPhotoUrl))
            $(validatorInputPhotoUrl).css("display", "none");
        if ($(validatorInputVideoUrl))
            $(validatorInputVideoUrl).css("display", "none");
    }


</script>
