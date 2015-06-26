<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ZoomInThumbnail.ascx.cs" Inherits="ZoomInThumbnail" %>

<!--This control is used to preview thumbnail image on hover using bootstrap style-->
<style type='text/css'>
#imgPreviewWithStyles {
    z-index: 999;
    border: none;
    background: #333 url(http://preloaders.net/preloaders/35/Fading%20lines.gif) no-repeat center;
    padding: 15px;
}
/* Text below image */
#imgPreviewWithStyles span {
    color: white;
    text-align: center;
    display: block;
    padding: 10px 0 3px 0;
}
  </style>

<script type='text/javascript'>//<![CDATA[ 
    $(function () {
        $container = $('<div/>').attr('id', 'imgPreviewWithStyles').append("<img style='max-width:400px;max-height:400px'/>").hide().css('position', 'absolute').appendTo('body'),

        $img = $('img', $container),
            $('a.hover-image:not(.brand)').mousemove(function (e) {
                $container.css({
                    top: e.pageY + 10 + 'px',
                    left: e.pageX + 10 + 'px'
                });

            }).hover(function () {

                var link = this;
                $container.show();
                $img.load(function () {
                    $img.addClass('img-rounded');
                    $img.show();
                }).attr('src', $(link).prop('href'));

            }, function () {

                $container.hide();
                $img.unbind('load').attr('src', '').hide();
            });
    });//]]>  

</script>