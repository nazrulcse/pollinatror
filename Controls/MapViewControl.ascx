<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MapViewControl.ascx.cs" Inherits="Controls_MapViewControl" %>
<link href="<%= ResolveUrl("~/css/jquery.bxslider.css") %>" rel="stylesheet" type="text/css" />
<script src="<%= ResolveUrl("~/Scripts/markerclusterer.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/Scripts/GoogleMap.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/js/jquery.bxslider.min.js") %>" type="text/javascript"></script>


<script type="text/javascript">
    var orgjson = <%=OrgListJson%>;
    var sponsorlink = <%=SponsorJson%>;
    var typejson = <%=PollinatorTypeJson%>;
    var sizejson = <%=PollinatorSizeJson%>;
    var countryjson = <%=CountryJson%>;       
    
</script>

<div class="12u">
    <section>
        <div class="switch-mousewwheel">
            <input type="checkbox" id="mousewwheel" value="1">
            <label for="mousewwheel">Use mousewheel to zoom map</label>
        </div>
        <div class="share-map" style="clear: both">
            <div class="map-view">
                <div id="map-canvas"></div>
                  <span style="float: left; margin: 25px 0 0 10px">
                <img id="imgLoadOnSelect" src="<%= ResolveUrl("~/Images/icon-loading.gif")%>"  style="display: none;" />
            </span>
            </div>

            <div class="map-tools">
                <div class="map-search">
                    <input type="hidden" id="isSearching" value="false"/>
                    <div id="tool-box-close">
                        <label>Advanced Search</label>
                        <div class="map-tool-icon-close"></div>
                    </div>
                    <div id="searchCondition">
                        <div class="search">
                            <span class="fa fa-search"></span>
                            <input name="txtSearchPolAdv" type="search" maxlength="60" id="txtSearchPolAdv" placeholder="Search Pollinator Sites">
                        </div>

                        <div id="userType" class="userType">
                            <input type="checkbox" id="chkShare" onchange="doSearch();"><label for="chkShare">SHARE&nbsp;</label>&nbsp;
                            <input type="checkbox" id="chkBFF" onchange="doSearch();"><label for="chkBFF">BFF</label>
                        </div>

                        <div class="filterFindOut">
                            <div class="filterOutTitle">
                                Available Filters
                            </div>
                            <div style="margin-bottom:10px">
                                <select name="ddlFilterFindOut" id="ddlFilterFindOut" multiple="multiple"  style="width:270px;">                                
                            </select>
                            </div>
                        </div>
                    </div>

                    <div id="Div1">
                        <label id="orgtitle">Organization</label>
                    </div>
                    <div id="map-search-result"></div>
                </div>

                <div id="tool-box">
                    <div class="map-tool-icon"></div>
                </div>
            </div>
        </div>

        <div style="clear: both"></div>

        <div style="width: 1046px">
            <div style="width: auto; float: left; padding-top: 20px">
                <span style="font-weight: 600; font-size: 16px">Sort the map by category </span>
                <a id="btnSelectAll" onclick="showAllPolinatorType()" class="button btn1" style="padding: 0.2em 0.5em 0.2em 0.5em">Show All</a>
            </div>

            <div align="right">
                <ul class="social" style=" width: 500px; margin-top: 10px;">
                    <li style="width: 120px" title="Add embed code"><a href="#embed_popup" id="show_embed_popup" style="color: #559; font-size: 14px; font-family: Verdana; font-weight: bold; width: 150px; background: none;">
                        <asp:Image ID="Image2" runat="server" ImageUrl="~/Images/icon_embed.jpg" AlternateText="icon_embed." border="0" />

                    </a></li>
                    <li title="Share now!"><a class="fa fa-share-alt solo" href="#"><span>Share</span></a>
                        <ul class="fallback">
                            <li title="Share on Facebook"><a class="fa fa-facebook solo" href="#" onclick="window.open('http://www.facebook.com/sharer.php?u=<%= PageURL %>','S.H.A.RE - Get on the Map Today!','width=600,height=400')"><span>Facebook</span></a></li>
                            <li title="Share on Twitter"><a class="fa fa-twitter solo" href="#" onclick="window.open('http://twitter.com/share?url=<%= PageURL %>&amp;text=S.H.A.RE - Get on the Map Today!','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Twitter</span></a></li>
                            <li title="Share on Google plus"><a class="fa fa-google-plus solo" href="#" onclick="window.open('https://plus.google.com/share?url=<%= PageURL %>','S.H.A.RE - Get on the Map Today!','width=600,height=400')"><span>Google+</span></a></li>
                            <li title="Share on LinkedIn">
                                <a class="fa fa-linkedin solo" href="http://www.linkedin.com/shareArticle?mini=true&url=<%= PageURL %>" target="_blank"><span>LinkedIn</span></a>
                            </li>
                            <li title="Share on Pinterest"><a class="fa fa-pinterest solo" href="javascript:void((function()%7Bvar%20e=document.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','http://assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);document.body.appendChild(e)%7D)());" target="_blank"><span>Pinterest</span></a></li>
                            <li title="Send from Gmail"><a class="fa fa-envelope solo" href="mailto:?Subject=S.H.A.RE - Get on the Map Today!&Body=I%20saw%20this%20and%20thought%20of%20you!%20 <%= PageURL %>" target="_blank"><span>Email</span></a></li>
                        </ul>
                    </li>
                    <li title="Share on Facebook"><a class="fa fa-facebook solo" href="#" onclick="window.open('http://www.facebook.com/sharer.php?u=<%= PageURL %>','S.H.A.RE - Get on the Map Today!','width=600,height=400')"><span>Facebook</span></a></li>
                    <li title="Share on Twitter"><a class="fa fa-twitter solo" href="#" onclick="window.open('http://twitter.com/share?url=<%= PageURL %>&amp;text=S.H.A.RE - Get on the Map Today!','S.H.A.RE - Get on the Map Today!','width=600,height=400')"><span>Twitter</span></a></li>
                    <%--  <li><a class="fa fa-dribbble solo" href="http://dribbble.com/n33"><span>Dribbble</span></a></li>
                                <li><a class="fa fa-linkedin solo" href="#"><span>LinkedIn</span></a></li>--%>
                    <li title="Share on Google plus"><a class="fa fa-google-plus solo" href="#" onclick="window.open('https://plus.google.com/share?url=<%= PageURL %>','S.H.A.RE - Get on the Map Today!','width=600,height=400')"><span>Google+</span></a></li>
                </ul>
            </div>

            <div style="clear: both"></div>
        </div>

        <div class="polytypeFilter" >
            <ul class="bxslider">                                              
            </ul>
        </div>

    </section>
</div>
<div class="popup user-help-popup">
    <a href="javascript:close_user_help_popup();" class="popup-close"></a>
    <div class="ie-popup-content">
        For the best experience, please use a modern web browser such as Chrome, Firefox or Safari to register for the SHARE Map
    </div>
</div>
<script type="text/javascript">
    if (getInternetExplorerVersion() != -1) {
        $(".user-help-popup").css('visibility', 'visible');
    }
    function close_user_help_popup() {
        $(".user-help-popup").css('visibility', 'hidden');
    }

    function getInternetExplorerVersion()
    {
        var rv = -1;
        if (navigator.appName == 'Microsoft Internet Explorer')
        {
            var ua = navigator.userAgent;
            var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
            if (re.exec(ua) != null)
                rv = parseFloat( RegExp.$1 );
        }
        else if (navigator.appName == 'Netscape')
        {
            var ua = navigator.userAgent;
            var re  = new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})");
            if (re.exec(ua) != null)
                rv = parseFloat( RegExp.$1 );
        }
        return rv;
    }
</script>