<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ShareMap.aspx.cs" Inherits="ShareMap" EnableEventValidation="false" %>

<%@ Register Src="~/Controls/RegisterUser.ascx" TagName="Register" TagPrefix="uc" %>
<%@ Register Src="~/Controls/MapViewControl.ascx" TagName="MapViewControl" TagPrefix="uc" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <link rel="stylesheet" href="<%= ResolveUrl("~/css/google-map.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/css/multiple-select.css") %>" />
    <link href="<%= ResolveUrl("~/Content/SiteUpload.css") %>" rel="stylesheet" type="text/css" />

    <script src="https://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/js/jquery.multiple.select.js")%>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/Scripts/AjaxFileupload.js")%>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/Scripts/common.js")%>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/Scripts/banners.js")%>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/js/jquery.zclip.js")%>" type="text/javascript"></script>

    <script type="text/javascript">
        window._skel_config = {
            prefix: '<%= ResolveUrl("~/css/style")%>',
            preloadStyleSheets: true,
            resetCSS: true,
            boxModel: 'border',
            grid: { gutters: 30 },
            breakpoints: {
                wide: { range: '1200-', containers: 1140, grid: { gutters: 50 } },
                narrow: { range: '481-1199', containers: 960 },
                mobile: { range: '-480', containers: 960 }
            }
        };
    </script>
    <script src="<%= ResolveUrl("~/js/config.js") %>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/js/skel.min.js") %>" type="text/javascript"></script>
    <noscript>
        <link rel="stylesheet" href="<%= ResolveUrl("~/css/skel-noscript.css")%>" />
    </noscript>
    <script type="text/javascript" language="javascript">

        // This variable will be used in javascript to determer root path on server
        var rootServerPath = '<%=ResolveUrl("~")%>';

        $(document).ready(function () {
            var Chrome = false;
            if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
                Chrome = true;
                //  $('.registerSelect').addClass('dropdownlist');
            }
            else if (navigator.userAgent.toLowerCase().indexOf('mozilla') > -1) {
                //  $('.registerSelect').addClass('dropdownlistFirefox');
            }
            $('.registerSelect').addClass('dropdownlist');

            //new line when Enter press
            $('textarea').keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    var position = this.selectionStart;
                    var curValue = $(this).val();
                    var newvalue = [curValue.slice(0, position), '\r\n', curValue.slice(position)].join('');
                    $(this).val(newvalue);
                    $(this).selectRange(position + 1);
                }
            });

            $.fn.selectRange = function (start, end) {
                if (!end) end = start;
                return this.each(function () {
                    if (this.setSelectionRange) {
                        this.focus();
                        this.setSelectionRange(start, end);
                    } else if (this.createTextRange) {
                        var range = this.createTextRange();
                        range.collapse(true);
                        range.moveEnd('character', end);
                        range.moveStart('character', start);
                        range.select();
                    }
                });
            };
            //end new line

            $('a#copyembedcode').zclip({
                path: '<%= ResolveUrl("~/Scripts/ZeroClipboard.swf")%>',
                copy: function () { return $('#embedcode').text(); },
                beforeCopy: function () {
                    $('#embedcode').css('background', '#cc0');
                    $(this).removeClass("btn24");
                    $(this).addClass("btn23");
                },
                afterCopy: function () {
                    $('#embedcode').css('background', '#ccf');
                    $(this).removeClass("btn23");
                    $(this).addClass("btn24");
                }
            });

            //Support placeholder HTML5 for all Internet Explorer versions older than 9
            if ($.browser.msie && parseInt($.browser.version) <= 9) {
                // here goes some code for all Internet Explorer versions older than 9
                $('[placeholder]').focus(function () {
                    var input = $(this);
                    if (input.val() == input.attr('placeholder')) {
                        input.val('');
                        input.removeClass('placeholder');
                    }
                }).blur(function () {
                    var input = $(this);
                    if (input.val() == '' || input.val() == input.attr('placeholder')) {
                        input.addClass('placeholder');
                        input.val(input.attr('placeholder'));
                    }
                }).blur().parents('form').submit(function () {
                    $(this).find('[placeholder]').each(function () {
                        var input = $(this);
                        if (input.val() == input.attr('placeholder')) {
                            input.val('');
                        }
                    })
                });
            }
        });

        var banners = [
            new banner('Share', 'http://pollinator.org/SHARE.htm', '<%=ResolveUrl("~/Images/logo/sharelogo.png")%>', '30/04/2119', 'top'),
            new banner('AmericanHort logo for PPT', 'http://americanhort.org/', '<%=ResolveUrl("~/Images/logo/Hort.jpg")%>', '30/04/2119', 'top'),
            new banner('APGA_Combo-logo-Web', 'http://www.publicgardens.org/', '<%=ResolveUrl("~/Images/logo/APGA_Combo-logo-Web.png")%>', '30/04/2119', 'top'),
            new banner('APGALogo', 'http://www.nwf.org/', '<%=ResolveUrl("~/Images/logo/NWF.jpg")%>', '30/04/2119', 'top'),
            new banner('ASTA_logo', 'http://www.amseed.org/', '<%=ResolveUrl("~/Images/logo/ASTA_logo.png")%>', '30/04/2119', 'top'),
            new banner('KG-ResourceLogo_4c', 'http://www.kidsgardening.org/', '<%=ResolveUrl("~/Images/logo/KG-ResourceLogo_4c.jpg")%>', '30/04/2119', 'top'),
            new banner('NGA2015_4c', 'http://www.garden.org/', '<%=ResolveUrl("~/Images/logo/NGA2015_4c.jpg")%>', '30/04/2119', 'top'),
			new banner('WHC', 'http://www.wildlifehc.org/', '<%=ResolveUrl("~/Images/logo/logowhy.png")%>', '30/04/2119', 'top'),
			new banner('naba', 'http://www.naba.org/', '<%=ResolveUrl("~/Images/logo/aba.png")%>', '30/04/2119', 'top'),
			new banner('Share', 'http://pollinator.org/', '<%=ResolveUrl("~/Images/logo/pollinator.png")%>', '30/04/2119', 'top'),
			new banner('wild', 'http://www.wildones.org/', '<%=ResolveUrl("~/Images/logo/wild.png")%>', '30/04/2119', 'top'),
			new banner('lbjf', 'https://www.wildflower.org/', '<%=ResolveUrl("~/Images/logo/lbj.png")%>', '30/04/2119', 'top'),
			new banner('neef', 'http://www.neefusa.org/', '<%=ResolveUrl("~/Images/logo/NEEFers.png")%>', '30/04/2119', 'top'),
			new banner('cpl', 'http://captainplanetfoundation.org/', '<%=ResolveUrl("~/Images/logo/cpl.png")%>', '30/04/2119', 'top'),
			new banner('saf', 'http://www.safnow.org/', '<%=ResolveUrl("~/Images/logo/saf.png")%>', '30/04/2119', 'top'),
      new banner('AFE', 'http://endowment.org/', '<%=ResolveUrl("~/Images/logo/AFE.png")%>', '30/04/2119', 'top'),
      new banner('AIB', 'http://www.americainbloom.org/', '<%=ResolveUrl("~/Images/logo/AIB.png")%>', '30/04/2119', 'top'),
      new banner('Burts Bees', 'http://burtsbees.com/', '<%=ResolveUrl("~/Images/logo/burtbees.png")%>', '30/04/2119', 'top'),
      new banner('HGSA', 'http://www.ezfromseed.org/', '<%=ResolveUrl("~/Images/logo/HGSA.png")%>', '30/04/2119', 'top'),
      new banner('KAB', 'http://www.kab.org', '<%=ResolveUrl("~/Images/logo/KAB.png")%>', '30/04/2119', 'top'),
      new banner('NGC', 'http://www.gardenclub.org/', '<%=ResolveUrl("~/Images/logo/NGCI.png")%>', '30/04/2119', 'top'),
      new banner('NRPA', 'http://www.nrpa.org/', '<%=ResolveUrl("~/Images/logo/NPRA.png")%>', '30/04/2119', 'top'),
      new banner('usda', 'http://www.usda.gov/', '<%=ResolveUrl("~/Images/logo/usda.png")%>', '30/04/2119', 'top'),
      new banner('usfs', 'http://www.fs.fed.us/', '<%=ResolveUrl("~/Images/logo/usfs.png")%>', '30/04/2119', 'top'),
      new banner('xerces', 'http://www.xerces.org/', '<%=ResolveUrl("~/Images/logo/xerces.png")%>', '30/04/2119', 'top'),
       ]
    </script>

    <style>
        div.swb img
        {
            max-width: 215px !important;
            height:120px;
        }
    </style>
    <div id="content" class="content full">
        <div class="containerbt">
            <div class="rowbt">
                <div class="col-md-9">
                    <h3 class="title" style="font-size: 24px;"><span id="bff">Welcome to the S.H.A.R.E. Map</span></h3>
                    <p>
                       Register your pollinator habitat below. It's free and easy!  Explore other pollinator friendly SHARE landscapes all over the globe!  The organization’s logos shown are registering their pollinator habitat on the map, too.  Be a part of the movement now!
                    </p>
                    <div id="map" class="tab-pane">
                    </div>
                </div>


                <!-- Start Sidebar -->
                <div class="col-md-3 right-sidebar sidebar" style="padding-right: 30px">
                    <div class="project-centre widget sidebar-widget">
                        <h3 class="title" style="font-size: 18px; font-weight: normal">Partners</h3>
                        <div align="left" style="min-height: 140px;">
                            <script type="text/javascript">
                                show_banners('top');

                            </script>
                        </div>
                    </div>

                </div>

            </div>

            <div class="row">
                <uc:MapViewControl ID="MapViewControl" runat="server" />
            </div>
        </div>

        <a name="register-form"></a>

        <uc:Register ID="Register1" runat="server" />

    </div>

    <a href="#x" class="overlay" id="embed_popup"></a>
    <div id="embedpopup" class="popup" style="width: 510px; height: 210px">
        <h4>Embed Code</h4>
        <div contenteditable="true" id="embedcode" style="text-align: left; line-height: 150%; border: 1px solid #ccc; word-wrap: break-word; white-space: normal; padding: 5px; width: 480px; height: 90px; font-family: monospace; font-size: 12px; display: block">&lt;iframe width="560" height="315" src="<%=Request.Url.GetLeftPart(UriPartial.Authority) +ResolveUrl("~/MapWidget")%>" frameborder="0"&gt;&lt;/iframe&gt;</div>
        <p style="text-align: center; padding: 10px 0"><a id="copyembedcode" href="#x" style="min-width: 200px; color: #fff; font-size: 14px; font-family: Arial;" class="submit button btn24">Copy to Clipboard</a></p>
        <a class="popup-close" href="#close"></a>
    </div>


</asp:Content>
