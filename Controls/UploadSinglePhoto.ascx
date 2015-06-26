<script type="text/javascript">

    function displayImageFirstLoad(txtControl) {
        if ($(txtControl).val() != "") {
            $('#' + imgPhoto).css('display', 'inline');
        }
        else {
            $('#' + imgPhoto).css("display", "none");
        }

    }


    function displayImageOnChange(txtControl, multiControl) {      
        $(validatorInputPhotoUrl).css("display", "none");

        var photoUrls = $(txtControl).val();
        if (photoUrls == "") {
            $('#' + imgPhoto).css("display", "none");
            if (linAddPhoto && !multiControl && linAddPhoto != '')
                $('#' + linAddPhoto).text('Add photo');


            if (multiControl && numVideo)
                $(numPhoto).css("display", "none");
            return;
        }
        $('#' + imgPhoto).css("display", "none");

        var url;
        if (multiControl) {
            var arrUrl = photoUrls.split(';');
            url = arrUrl[0];
            if (arrUrl.length > 1) {
                $(numPhoto).text("(" + arrUrl.length + " photos)");
            }
            else
                $(numPhoto).text("(" + arrUrl.length + " photo)");
            $(numPhoto).css("display", "block");
        }
        else {
            url = photoUrls;
        }
        url = $.trim(url);
        if (url.indexOf('UploadFiles')>-1) {
            var rootServerPath = '<%=ResolveUrl("~")%>';
            url = rootServerPath + url;
        }
        $('#' + imgPhoto).attr('src', url);
        var imgsrc = $('#' + imgPhoto).attr('src');
        $('#' + imgPhoto).css("display", "inline");

        $('#' + imgPhoto).error(function () {
            $(validatorInputPhotoUrl).css("display", "inline");
            $(validatorInputPhotoUrl).text('Photo URL "' + url + '" does not exist');
            $(validatorInputPhotoUrl).attr("title", $(validatorInputPhotoUrl).text());
            $('#' + imgPhoto).css("display", "none");
        });

    }

    function fileUploadPhoto(txtphotoUrlID, imgPhoto, imgLoading, fileToUploadID, validatorPhotoUrl, linAddPhoto, userFolder) {
        $(validatorPhotoUrl).css("display", "none");
        $('#' + imgPhoto).css("display", "none");

        var rootServerPath = '<%=ResolveUrl("~")%>';
        ajaxFileUpload(rootServerPath, txtphotoUrlID, imgLoading, fileToUploadID, validatorPhotoUrl, imgPhoto, linAddPhoto, dontDeletePreImage, userFolder);
    }

</script>