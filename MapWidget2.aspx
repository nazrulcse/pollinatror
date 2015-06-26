<%@ Page Title="View Map" Language="C#" AutoEventWireup="true" CodeFile="MapWidget.aspx.cs" Inherits="MapWidget" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta name="viewport" content="width=device-width" />
    <title></title>
</head>
<body>
    <form runat="server">
        <asp:ScriptManager runat="server">
        <Scripts>
            <%--To learn more about bundling scripts in ScriptManager see http://go.microsoft.com/fwlink/?LinkID=272931&clcid=0x409 --%>
            <%--Framework scripts--%>
            <asp:ScriptReference Name="MsAjaxBundle" />
            <asp:ScriptReference Name="jquery" />
            <asp:ScriptReference Name="jquery.ui.combined" />
            <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
            <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
            <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
            <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
            <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
            <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
            <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
            <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
            <asp:ScriptReference Name="WebFormsBundle" />
            <%--Site scripts--%>
        </Scripts>
    </asp:ScriptManager>

        <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
        <script src="<%= ResolveUrl("~/Scripts/markerclusterer.js") %>" type="text/javascript"></script>
        <script type="text/javascript">
            var sponsorlink = <%=SponsorJson%>;
            var typejson = <%=PollinatorTypeJson%>;
            var sizejson = <%=PollinatorSizeJson%>;
            var countryjson = <%=CountryJson%>;

            var widget = true;
            var link = "<%=Request.Url.GetLeftPart(UriPartial.Authority)%>";
            flag_open_list = false;

            $(document).ready(function () {

                $body = $("body");

                $(document).on({
                    ajaxStart: function() { $body.addClass("loading");    },
                    ajaxStop: function() { $body.removeClass("loading"); }
                });

                resizemap();
                $("#mapwidget-tool-box").click(function () {
                    if (!flag_open_list) {
                        flag_open_list = true;
                        resizemap();
                        $("#mapwidget-tool-box").hide();
                        $(".map-search").show();
                    }
                });
                $(".mapwidget-map-tool-icon-close").click(function () {
                    if (flag_open_list) {
                        flag_open_list = false;
                        resizemap();
                        $("#mapwidget-tool-box").show();
                        $(".map-search").hide();
                    }

                });
            });

            function resizemap() {
                if(!flag_open_list) {
                    $("#map-canvas").css("width", $( window ).width() - 16 + "px");
                } else {
                    $("#map-canvas").css("width", $( window ).width() - 216 + "px");
                }
                $("#map-search-result").css("height", $( window ).height() - 27 + "px");
            }

            $( window ).resize(function() {
                resizemap();
            });
            // This variable will be used in googlemap.js
            var rootServerPath= '<%=ResolveUrl("~")%>';

        </script>
        <script src="Scripts/googlemap.js" type="text/javascript"></script>

        <script src="Scripts/common.js" type="text/javascript"></script>

        <script src="js/config.js"></script>
        <script src="js/skel.min.js"></script>
        <style type="text/css">
body {
    padding: 0;
    margin: 0;
}
#map-canvas {
height: 100%; width: 100%;
background: url("/Images/loading-large.gif") no-repeat center center #eee;
float: left;
position: absolute;
z-index: 10;
}
.map-tools {
position: absolute;
z-index: 11;
float: left;
background: #F0F0F0;
right: 0;
height: 100%;
}
.infowindows {
    width: 255px;
    height: auto;
    max-height: 325px;
    overflow: hidden;
    position: relative;
}
#map-sponsor {
max-height: 100px;
max-width: 640px;
}
.map-search {
border-left: 2px solid #E0E0E0;
display: none;
width: 216px;
height: 100%;
}
#map-search-result {
z-index:10;
float: left;
height: 0;
overflow: auto;
width: 214px;
position: absolute;
top: 27px;
}
#map-search-result ul {
padding: 0;
margin: 0;
}

hr {
    height: 1px;
}

#map-search-result li {
background: #fff;
padding: 2px 5px;
line-height: 100%;
border-bottom: 1px solid #E0E0E0;
border-right: 1px solid #E0E0E0;
}
#map-search-result li:hover {
background: #0073EA;
}
#map-search-result li:hover > a {
color: #fff;
text-decoration: none;
}
#map-search-result li > a {
color: #555;
font: 12px/13px arial,tahoma,helvetica,sans-serif;
text-decoration: none;
}

#mapwidget-tool-box {
position: absolute;
background: #F0F0F0;
padding: 0px; margin: 0px;
text-align: left;
overflow: hidden; z-index: 12;
right: 0px; height: 100%;
width: 16px;
 top: 0px;
cursor: pointer;
 font-size: 1px;
}
.map-tool-icon {
position: absolute; display: block; padding: 0px; margin: 0px; overflow: hidden; text-align: center; font-size: 1px; cursor: pointer; z-index: 1; visibility: visible; height: 16px; width: 16px; top: 0px; left: 0px; background-image: url('//d3o96a3f9o7chl.cloudfront.net/libraries/ext-3.2.1/resources/images/gray/panel/tool-sprites.gif'); background-position: 0 -180px;
}

#mapwidget-tool-box-close {
margin: 0px;
z-index: 11;
height: 27px;
width: 214px;
visibility: visible;
position: relative;
background: #F6F6F6;
border-bottom: 2px solid #99BBE8;
border-right: 1px solid #99BBE8;
}
#mapwidget-tool-box-close label {
color: #3764A0;
font: 12px/13px arial,tahoma,helvetica,sans-serif;
font-weight: bold;
padding: 7px;
}
.mapwidget-map-tool-icon-close {
cursor: pointer;
display: block;
height: 15px;
position: absolute;
top: 0;
right: 5px;
width: 15px;
z-index: 2;
background-image: url("//d3o96a3f9o7chl.cloudfront.net/libraries/ext-3.2.1/resources/images/gray/panel/tool-sprites.gif");
background-position: 0 -165px;
margin-top: 5px;
}

.googft-info-window {
width: 325px;
height: auto;
max-height: 325px;
overflow-x: hidden;
overflow-y: auto;
position: relative;
margin-bottom: 30px;
}
.googft-info-window a {
color: #3764A0;
}
.pollinator-size {
color: #a42e2e;
}
h2.info-window-header {
font-family: Tahoma, Verdana, Arial;
font-size: 15px;
font-weight: bold;
line-height: 100%;
color: #3764A0;
padding: 0;
margin: 0;
}
.googft-info-window p {
font-family: Tahoma, Verdana, Arial;
font-size: 12px;
line-height: 100%;
}

.googft-info-window strong {
font-weight: 700;
}

.callout-link-bottom {
background: #fff;
border-top: 1px solid #ccc;
bottom: 0;
margin: 5px 0 0;
padding: 0;
position: absolute;
width: 100%;
}
.callout-link-bottom a {
line-height: 100%;
text-decoration: none;
}

.callout-link-bottom li {
 display: inline-block;
 padding: 0 15px 0 0;
}

.googft-info-window ul.info {
    padding:0;
    margin: 0;
}

.googft-info-window p.img {
}

.googft-info-window p.desc {
clear: both;
white-space: pre-line;
padding: 3px 0;
margin: 0;
line-height: 150%;
}

.googft-info-window li {
clear: both;
overflow: hidden;
white-space: nowrap;
padding: 0;
margin: 0;
line-height: 150%;
}

.googft-info-window img {
max-width: 350px;
max-height: 100px;
}
#searchmaps {
    margin: 0 25px 0 10px;
}
#searchmaps #sq {
width: 125px;
height: 30px;
float:left;
margin: 5px 0 6px;
padding: 0;
}

#linkpopout {
width: 32px;
background: url('Images/popout.png') center center no-repeat #fefefe;
height: 32px;
float:left;
border: 1px solid #cccccc;
font-family: Roboto,Arial,sans-serif;
font-size: 10px;
font-weight: bold;
margin: 5px -10px 6px 10px;
cursor: pointer;
}
#searchmaps #btns {
width: 50px;
height: 32px;
float:left;
background: #fefefe;
border: 1px solid #cccccc;
font-family: Roboto,Arial,sans-serif;
font-size: 10px;
font-weight: bold;
margin: 5px 0 6px;
}



/* Start by setting display:none to make this hidden.
   Then we position it in relation to the viewport window
   with position:fixed. Width, height, top and left speak
   for themselves. Background we set to 80% white with
   our animation centered, and no-repeating */
.modal {
    display:    none;
    position:   fixed;
    z-index:    1000;
    top:        0;
    left:       0;
    height:     100%;
    width:      100%;
    background: rgba( 255, 255, 255, .8 )
                url('http://i.stack.imgur.com/FhHRx.gif')
                50% 50%
                no-repeat;
}

/* When the body has the loading class, we turn
   the scrollbar off with overflow:hidden */
body.loading {
    overflow: hidden;
}

/* Anytime the body has the loading class, our
   modal element will be visible */
body.loading .modal {
    display: block;
}

        </style>
        <script type="text/javascript" src="js/jquery.multiple.select.js"></script>
        <link rel="stylesheet" href="css/multiple-select.css" />
    </form>
    <div style="padding-right: 20px;"><div id="map-canvas"></div></div>

    <div class="map-tools">
        <div class="map-search">
            <div id="mapwidget-tool-box-close">
                <label id="orgtitle">Organization</label>
                <div class="mapwidget-map-tool-icon-close"></div>
            </div>
            <div id="map-search-result"></div>
        </div>
        <div id="mapwidget-tool-box">
            <div class="map-tool-icon"></div>
        </div>
    </div>
    <div style="clear: both"></div>

    <div style="z-index:10; position: absolute; bottom: 30px; left: 10px;">
        <select name="PollinatorType" id="PollinatorType" placeholder="Sort" position="top" multiple="multiple" style="width:226px;">
		    <option value="premium">Bee Friendly Farmers</option>
	    </select>
    </div>
    <div style="z-index:10; position: absolute; bottom: 30px; left: 255px;"><a target="_blank" href="<%=Request.Url.GetLeftPart(UriPartial.Authority)+ResolveUrl("~/")%">Register Now!</a></div>

    <div class="modal"><!-- Place at bottom of page --></div>
</body>
</html>
