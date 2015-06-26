<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PollinatorInformation.aspx.cs" Inherits="Admin_PollinatorInformation" %>
<%@ Register Src="~/Controls/UploadMultiFiles.ascx" TagName="Upload" TagPrefix="uc" %>
<%@ Register Src="~/Controls/UploadSinglePhoto.ascx" TagName="SinglePhoto" TagPrefix="uc" %>
<%@ Register Src="~/Controls/YoutubeSingleVideo.ascx" TagName="SingleYoutube" TagPrefix="yb" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
    
    <link href="../css/bootstrap-modal.css" rel="stylesheet" />

    <script type="text/javascript">
        window._skel_config = {
            prefix: '../css/style',
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
    <asp:PlaceHolder ID="PlaceHolder3" runat="server">

        <%=Scripts.Render("~/js/skel.min.js") %>
        <%=Scripts.Render("~/Scripts/AjaxFileupload.js") %>   
    </asp:PlaceHolder>


    <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />

    </noscript>
    <style type="text/css">
        .infowindows
        {
            width: 275px;
            height: auto;
            max-height: 225px;
            overflow: hidden;
            position: relative;
        }

            .infowindows h2
            {
                font-family: Tahoma, Verdana, Arial;
                font-size: 15px;
                font-weight: bold;
                line-height: 100%;
                color: #3764A0;
                padding: 5px 0;
                margin: 0;
            }

            .infowindows hr
            {
                padding: 5px 0;
                margin: 0;
            }

            .infowindows .callout-link-bottom
            {
                background: #fff;
                margin: 0;
                padding: 0;
            }

        #searchmaps
        {
            padding: 5px 0;
        }

            #searchmaps #sq
            {
                width: 125px;
                height: 32px;
                float: left;
            }

            #searchmaps #btns
            {
                width: 50px;
                height: 32px;
                float: left;
                background: #fefefe;
                border: 1px solid #cccccc;
                font-family: Roboto,Arial,sans-serif;
                font-size: 10px;
                font-weight: bold;
            }
    </style>
     
    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>

    <script type="text/javascript">

        // global "map" variable
        var map = null;
        var marker = null;
        var geocoder;

        var infowindow = new google.maps.InfoWindow(
            {
                size: new google.maps.Size(150, 50)
            });

        // A function to create the marker and set up the event window function 
        function createMarker(latlng, name, html) {
            var contentString = html;
            var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                zIndex: Math.round(latlng.lat() * -100000) << 5
            });

            var ctlLat = '#<%= hdnLat.ClientID %>';
            var ctlLng = '#<%=hdnLng.ClientID %>';

            $(ctlLat).val(latlng.lat());
            $(ctlLng).val(latlng.lng());

            google.maps.event.addListener(marker, 'click', function () {
                $("#mapError").css("display", "none");
                infowindow.setContent(contentString);
                infowindow.open(map, marker);
            });
            google.maps.event.trigger(marker, 'click');
            return marker;
        }

        function codeAddress(addr) {

            var address = "<%=Address%>";

            var OrganizationName = "<%=PollinatorName%>";
            var html = "<div class='infowindows'>";
            if (OrganizationName != "") {
                html += "<h2>" + OrganizationName + "</h2><hr />";
            }
            if (address != "") {
                html += "<p>" + address + "</p>";
            }
            if (OrganizationName == "" && address == "") {
                html += "<h2>This is your location!</h2><hr />";
            }
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()">Go here!</a></li></ul>';
            html += "</div>";

            var ctlLat = '#<%=hdnLat.ClientID %>';
            var ctlLng = '#<%=hdnLng.ClientID %>';
            var lat = "";
            var lng = "";

            if (addr == '') {
                lat = $(ctlLat).val();
                lng = $(ctlLng).val();
            }


            if (lat != "" && lng != "") {
                var location = new google.maps.LatLng(lat, lng);
                map.setCenter(location);

                if (marker) {
                    marker.setMap(null);
                    marker = null;
                }
                marker = createMarker(location, "pollinator", html);
            }
            else {
                if (addr == '') {
                    addr = address;
                }
                geocoder.geocode({ 'address': addr }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        map.setCenter(results[0].geometry.location);

                        if (marker) {
                            marker.setMap(null);
                            marker = null;
                        }
                        marker = createMarker(results[0].geometry.location, "pollinator", html);
                    } else {
                        console.log('Geocode was not successful for the following reason: ' + status);
                    }
                });

            }
        }

        function initialize() {
            // create the map
            var myOptions = {
                zoom: 8,
                center: new google.maps.LatLng(43.907787, -79.359741),
                mapTypeControl: true,
                mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
                navigationControl: true,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            geocoder = new google.maps.Geocoder();

            map = new google.maps.Map(document.getElementById("map_canvas"),
                myOptions);

            if (getCookie("mousewwheel") == "1") {
                $("input[id='mousewwheel']").attr("checked", true);
                map.setOptions({ scrollwheel: true });
            }
            else {
                $("input[id='mousewwheel']").attr("checked", false);
                map.setOptions({ scrollwheel: false });
            }

            google.maps.event.addListener(map, 'click', function () {
                infowindow.close();
            });

            var address = "<%=Address%>";

            var OrganizationName = "<%=PollinatorName%>";
            var html = "<div class='infowindows'>";
            if (OrganizationName != "") {
                html += "<h2>" + OrganizationName + "</h2><hr />";
            }
            if (address != "") {
                html += "<p>" + address + "</p>";
            }
            if (OrganizationName == "" && address == "") {
                html += "<h2>This is your location!</h2><hr />";
            }
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()">Go here!</a></li></ul>';
            html += "</div>";

            var searchControlDiv = document.createElement('div');
            MapSearchControl(searchControlDiv);
            searchControlDiv.index = 0; // used for ordering
            map.controls[google.maps.ControlPosition.TOP_RIGHT].push(searchControlDiv);


            google.maps.event.addListener(map, 'click', function (event) {
                //call function to create marker
                if (marker) {
                    marker.setMap(null);
                    marker = null;
                }
                marker = createMarker(event.latLng, "pollinator", html);
            });
            codeAddress('');
        }
        new google.maps.event.addDomListener(window, 'load', initialize);
        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toGMTString();
            document.cookie = cname + "=" + cvalue + "; " + expires;
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
            }
            return "";
        }

        $(document).ready(function () {
            $("input[id='mousewwheel']").change(function () {
                if ($("input[id='mousewwheel']").attr('checked')) {
                    map.setOptions({ scrollwheel: true });
                    setCookie("mousewwheel", 1, 365);
                } else {
                    map.setOptions({ scrollwheel: false });
                    setCookie("mousewwheel", 0, 365);
                }
            });

            $(".close").click(function () {
                $(".alert").alert();
            });


        });

        function MapSearchControl(controlDiv) {
            controlDiv.style.padding = '';
            controlDiv.style.position = 'relative';
            controlDiv.id = "searchmaps";

            var searchbox = document.createElement('input');
            searchbox.type = "text";
            searchbox.id = "sq";
            controlDiv.appendChild(searchbox);

            var searchsubmit = document.createElement('input');
            searchsubmit.type = "button";
            searchsubmit.id = "btns";
            searchsubmit.value = "Search";
            controlDiv.appendChild(searchsubmit);

            google.maps.event.addDomListener(searchsubmit, 'click', function () {
                codeAddress($("#sq").val());
            });

            google.maps.event.addDomListener(searchbox, 'keydown', function (event) {
                if (event.which == 13) {
                    searchsubmit.focus();
                    codeAddress($("#sq").val());
                    return false;
                }
            });

        }


        function gohere() {

            //set position: lat, long
            var ctlLat = '<%=hdnLat.ClientID %>';
            var ctlLng = '<%=hdnLng.ClientID %>';
            var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);
            map.setOptions({ center: coordinate, zoom: 10 });
        }
        function goBack() {            
            var userLink = '<%=ResolveUrl("~/Admin/Users.aspx")%>?ShowLastestKeyword=1';
            window.location = userLink;         
        }

    </script>
   
         
    <div id="main-wrapper">
        <div class="container" style="padding-left:0px;margin-top: -110px">
            <br/><br/>
            
            <h2 style="margin-left:-5px">Register Information</h2>
            <p  style="margin-left:-4px">
<%--                <asp:HyperLink ID="BackLink" runat="server"
                    NavigateUrl="~/Admin/Users.aspx">&lt;&lt; Back to User List</asp:HyperLink>--%>
                
                <!--Bootstrap button style-->
                <button class="btn" onclick="javascript:goBack();return false;">
                    <i class="glyphicon glyphicon-backward"></i>
                    Back to List
                </button>
            </p>
            <div style="margin-left:-3px;width: 1009px">

             
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <%--<asp:Label ID="StatusMessage" runat="server" Text="<strong>Update successful!</strong>"></asp:Label>--%>
                        <strong style="color: #555">Update successful</strong>
                    </div>
                </asp:Panel>

                <asp:Panel runat="server" ID="panelErrorMessage" Visible="False">
                    <div class="alert alert-danger">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <strong style="color: red">There was an error in updating data!</strong>
                    </div>
                </asp:Panel>

             
            </div>
            
            <div style="width: 1046px;  margin-left:-20px; font-family: Verdana; font-size: 0.8em; border-collapse: collapse;">
                <div class="row" id="divRowRegNormal" style="margin-top: 20px; margin-bottom: 20px; margin-right: 20px;" runat="server">
                    <div class="12u">

                          <fieldset style="border: 1px #ccc solid;padding-bottom:20px">
                            <legend>Personal Information</legend>
                            
                            <div class="row half">
                                <div class="6u">
                                    First Name
                                   <asp:TextBox MaxLength="60" class="text" placeholder="First Name" ID="txtFirstName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="Update">First Name is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u">
                                    Last Name
                                    <asp:TextBox  MaxLength="60" class="text" placeholder="Last Name" ID="txtLastName" runat="server"></asp:TextBox>
                                    <%--  <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last Name is required." ToolTip="Last Name is required." ValidationGroup="Update">Last Name is required.</asp:RequiredFieldValidator> --%>
                                </div>
                            </div>


                            <div class="row half">
                                <div class="6u">
                                    Phone Number
                                    <asp:TextBox MaxLength="24" class="text" placeholder="Phone Number" ID="txtPhoneNumber" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPhoneNumber" ID="RegularExpressionValidator3"  ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone number." ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>
                                <div class="6u">
                                    Email Address
                                    <asp:TextBox  MaxLength="256" TextMode="Email" class="text" ID="txtEmail" runat="server" placeholder="Email Address"></asp:TextBox><%--TextMode="Email"--%>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="EmailRequired" runat="server" ControlToValidate="txtEmail" ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="Update">E-mail is required.</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display="Dynamic" CssClass="message-error" ID="RegularExpressionValidator1" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format, Example: me@example.com" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="row half" >
                                <div class="6u" >
                                    User Name
                                    <asp:TextBox ReadOnly="true" disabled class="text" BackColor="#dbdbdb" placeholder="User Name" ID="txtUserName" runat="server"></asp:TextBox>                                    
                                </div>
                                 <div class="6u"  >
                                    Type of Pollinator Location
                                    <asp:DropDownList  ID="drPollinatorType" Width="100%" runat="server" placeholder="Type of Pollinator Location">
                                        <asp:ListItem Value="0"><--Select one type of Pollinator Location--></asp:ListItem>                                     
                                    </asp:DropDownList>
                                     <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator5" runat="server" ControlToValidate="drPollinatorType" ErrorMessage="Select one Type of Pollinator Location" ToolTip="Select one Type of Pollinator Location" ValidationGroup="Update">Select one Type of Pollinator Location.</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            
                        </fieldset>

                        
                        <fieldset style="border: 1px #ccc solid;margin-top:20px">
                            <legend>Pollinator Information</legend>
                            <div class="row half">
                                <div class="6u">
                                    Organization Name
                                    <asp:TextBox MaxLength="100" ID="txtOrganizationName" runat="server" class="text" placeholder="Organization Name"></asp:TextBox>
                                </div>
                                <div class="6u">
                                    Size of Pollinator Location
                                    <asp:DropDownList  ID="drPollinatorSize" Width="100%" runat="server" placeholder="Size of Pollinator Location">
                                        <asp:ListItem Value="0"><--Select one size of Pollinator Location--></asp:ListItem>

                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator13" runat="server" ControlToValidate="drPollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row half">
                                <div class="6u">
                                    Landscape Street
                                     <asp:TextBox  MaxLength="100"  ID="txtLandscapeStreet" runat="server" class="text" placeholder="Landscape Street"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorLandscapeStreet" runat="server" ControlToValidate="txtLandscapeStreet" ErrorMessage="Landscape Street is required." ToolTip="Landscape Street is required." ValidationGroup="Update">Landscape Street is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u">
                                    Landscape City
                                    <asp:TextBox  MaxLength="30" ID="txtLandscapeCity" runat="server" class="text" placeholder="Landscape City"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorLandscapeCity" runat="server" ControlToValidate="txtLandscapeCity" ErrorMessage="Landscape City is required." ToolTip="Landscape City is required." ValidationGroup="Update">Landscape City is required.</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row half">
                                <div class="6u">
                                    Landscape State
                                    <asp:TextBox MaxLength="30" ID="txtLandscapeState" runat="server" class="text" placeholder="Landscape State"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorLandscapeState" runat="server" ControlToValidate="txtLandscapeState" ErrorMessage="Landscape State is required." ToolTip="Landscape State is required." ValidationGroup="Update">Landscape State is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u" style="display: inline-flexbox;">                                       
                                        <div style="float: left; width: 49%">
                                           Zip Code/Country Code
                                        <asp:TextBox MaxLength="10" ID="txtLandscapeZipcode" runat="server" class="text" placeholder="Zip Code/Country Code"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorLandscapeZipcode" runat="server" ControlToValidate="txtLandscapeZipcode" ErrorMessage="Zip Code/Country Code is required." ToolTip="Zip Code/Country Code is required." ValidationGroup="Update">Zip Code/Country Code is required.</asp:RequiredFieldValidator><br />
                                     <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtLandscapeZipcode" ID="RegularExpressionValidator5" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code!" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                          </div>

                                        <div style="float: right; width: 49%" title="Country">
                                            Country
                                            <asp:DropDownList ID="drCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                            <asp:ListItem Value="USA" Selected="True">USA</asp:ListItem>
                                            <asp:ListItem Value="Canada">Canada</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
                                        </asp:DropDownList>
                                        </div>
                                    </div>
                                <div class="6u">
                                    Landscape Zipcode
                                   
                                </div>
                            </div>
                            <div class="row half">

                                <div class="6u">
                                    Photo URL
                                   <asp:TextBox MaxLength="255" ID="txtPhotoUrl" runat="server" class="text" placeholder="Photo URL"></asp:TextBox>
                                   <img id="loading" src="../images/loading.gif" style="display: none;">
                                     <span id="validatorPhotoUrl" title="You can upload only jpg, jpeg, pdf, gif extensions files." class="message-error" style="display: none;">You can upload only jpg, jpeg, pdf, gif extensions files.</span>
                                </div>
                                <div class="6u">
                                    Youtube URL
                                   <asp:TextBox MaxLength="255" ID="txtYoutubeUrl" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                                    <img id="loadingVideo" src="../images/loading.gif" style="display: none;">
                                      <div class="during-upload" id="during-upload" style="display:none">
                                        <p><span id="percent-transferred" >Uploading</span></p>
                                        <p>
                                            <progress id="upload-progress" max="100" value="1" style="width:190px""></progress>
                                        </p>
                                      </div>
                                    <span id="validatorVideoUrl" title="You can upload only flv,mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files." class="message-error" style="display: none;">You can upload only jpg, jpeg, pdf, gif extensions files.</span>
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u">
                                    <label class="file-upload">
                                        <a class="button btn36" id="linAddPhoto" runat="server" style="width: 152px; font-size: 12px;">Add Photo</a>
                                        <img id="loadingNormal" src="../images/loading.gif" style="display: none;">
                                        <asp:FileUpload ID="fileToUploadNormal" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadPhoto('MainContent_txtPhotoUrl', 'MainContent_imgPhoto','loadingNormal', 'fileToUploadNormal', '#validatorPhotoUrl', 'MainContent_linAddPhoto');" />                                        
                                    </label>
                                    

                                </div>
                                <div class="6u">
                                      <label class="file-upload">
                                    <a class="button btn36" id="linAddVideo"  runat="server" style="width: 152px; font-size: 12px;">Add Video</a>
                                    <img id="loadingNormalVideo" src="../images/loading.gif" style="display: none;">
                                    <asp:FileUpload ID="fileToUploadNormalVideo" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadVideo('MainContent_txtYoutubeUrl', 'loadingNormalVideo', 'fileToUploadNormalVideo', '#validatorVideoUrl', 'MainContent_linAddVideo');" />
                                </label>
                                 
                            </div>
                             </div>

                             <div class="row half" >
                                <div class="6u" style="padding-bottom:5px">                                    
                                    <asp:Image ID="imgPhoto" ImageUrl="#"  style="width:100%" runat="server" CssClass="thumbnail2" />
                                </div>
                                <div class="6u" style="padding-bottom:5px">                                    
                                    <div id="divVideoPlayer" style="display:none;margin-top:-20px;"></div>
                                </div>                               
                            </div>
                        </fieldset>
                    </div>
                </div>

                <div class="row" id="divRowRegPremium" style="margin-top:20px; margin-bottom: 20px; margin-right: 20px;" runat="server">
                    <div class="12u">

                        <fieldset style="border: 1px #ccc solid;">
                            <legend>General Information</legend>
                           
                            <div class="row half">
                                <div class="6u">
                                    First Name
                                     <asp:TextBox MaxLength="60" class="text" placeholder="First Name" ID="txtFirstNameP" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtFirstNameP" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="Update">First Name is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u">
                                    Last Name
                                    <asp:TextBox class="text" MaxLength="60" placeholder="Last Name" ID="txtLastNameP" runat="server"></asp:TextBox>
                                    <%--<asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtLastNameP" ErrorMessage="Last Name is required." ToolTip="Last Name is required." ValidationGroup="Update">Last Name is required.</asp:RequiredFieldValidator>--%>
                                </div>
                            </div>

                            <div class="row half" runat="server" id="Div5">
                                <div class="6u">
                                    Organization Name
                                    <asp:TextBox MaxLength="100" ID="txtOrganizationNameP" runat="server" class="text" placeholder="Organization Name"></asp:TextBox>
                                    <%--<asp:RequiredFieldValidator CssClass="message-error"  ID="RequiredFieldValidatorOranizationName" runat="server" ControlToValidate="OranizationName" ErrorMessage="Oranization Name is required." ToolTip="Oranization Name is required." ValidationGroup="Update">*</asp:RequiredFieldValidator>--%>
                                </div>
                                <div class="6u">
                                    Website
                                  <asp:TextBox MaxLength="255" ID="txtWebsiteP" runat="server" class="text" placeholder="Website"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="validWebsite"  ControlToValidate="txtWebsiteP"  runat="server" ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Invalid url of website" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                    <%--<asp:RequiredFieldValidator CssClass="message-error"  ID="RequiredFieldValidatorOranizationName" runat="server" ControlToValidate="OranizationName" ErrorMessage="Oranization Name is required." ToolTip="Oranization Name is required." ValidationGroup="Update">*</asp:RequiredFieldValidator>--%>
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u">
                                    Phone Number
                                     <asp:TextBox MaxLength="24"  class="text" placeholder="Phone Number" ID="txtPhoneNumberP" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPhoneNumberP" ID="RegularExpressionValidator2"  ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone number." ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>
                                <div class="6u">
                                    Email Address
                                    <asp:TextBox MaxLength="256" TextMode="Email" class="text" ID="txtEmailP" runat="server" placeholder="Email Address"></asp:TextBox><%--TextMode="Email"--%>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtEmailP" ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="Update">E-mail is required.</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display="Dynamic" CssClass="message-error" ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmailP" ErrorMessage="Invalid Email Format, Example: me@example.com" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                             <div class="row half">
                                  <div class="6u" >
                                    User Name
                                    <asp:TextBox ReadOnly="true" disabled class="text" BackColor="#dbdbdb" placeholder="User Name" ID="txtUserNameP" runat="server"></asp:TextBox>                                    
                                </div>
                               <div class="6u" >
                                    Type of Pollinator Location
                                    <asp:DropDownList  ID="drPollinatorTypeP" Width="100%" runat="server" placeholder="Type of Pollinator Location">
                                        <asp:ListItem Value="0"><--Select one type of Pollinator Location--></asp:ListItem>                                      
                                    </asp:DropDownList>
                                   <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator14" runat="server" ControlToValidate="drPollinatorTypeP" ErrorMessage="Select one Type of Pollinator Location" ToolTip="Select one Type of Pollinator Location" ValidationGroup="Update">Select one Type of Pollinator Location.</asp:RequiredFieldValidator>
                                </div>
                            </div>
                         
                            <div class="row half">
                                <div class="6u" style="width: 100%;">                             
                                    <h4>Organization Description <%--<a href="#" class="fa fa-question-circle solo"><span>Question</span></a>--%></h4>                                    
                                    <asp:TextBox ID="txtOrganizationDescriptionP"  runat="server" class="text" TextMode="MultiLine" Rows="5"  placeholder="Message"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row half">
                                <div class="6u">
                                    Photo URL
                                    <asp:TextBox  MaxLength="255" ID="txtPhotoUrlP" runat="server"  class="text" placeholder="Photo URL" ></asp:TextBox>
                                </div>
                                <div class="6u">
                                    Youtube URL
                                      <asp:TextBox  MaxLength="255" ID="txtYoutubeUrlP" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>

                                </div>
                            </div>
                            <div class="row half"  style="margin-bottom:20px">
                                <div class="6u">
                                   <!-- <label class="file-upload">
                                        <a class="button btn36" id= 'linAddPhotoP' runat="server" style="width: 152px; font-size: 12px;">Add Photo</a>
                                        <img id="loadingPremium" src="../images/loading.gif" style="display: none;">
                                        <asp:FileUpload ID="fileToUploadPremium" runat="server" ClientIDMode="Static" onchange="javascript:return fileUpload('MainContent_txtPhotoUrlP', 'MainContent_imgPhotoP','loadingPremium', 'fileToUploadPremium', '#validatorPhotoUrl', 'MainContent_linAddPhotoP');" />                                          
                                    </label>
                                    <span id="validatorPhotoUrlP" title="You can upload only jpg, jpeg, pdf, gif extensions files." class="message-error" style="visibility: hidden;">You can upload only jpg, jpeg, pdf, gif extensions files.</span>-->

                                     <a href="#UploadPhoto_formimage" id="A3" onclick="SetControlToReturnPhotoUrl('<%=txtPhotoUrlP.ClientID %>');" class="btnUploadPhoto button btn36" style="font-size: 12px;">Upload Photo</a>

                                </div>
                                <div class="6u"><a href="#UploadPhoto_formvideo" id="a5" onclick="SetControlToReturnVideoUrl('<%=txtYoutubeUrlP.ClientID %>');" class="button btn36" style="font-size: 12px;">Upload Video</a> </div>
                            </div>

                            <div class="row half">

                               <!-- <div class="6u">
                                    <asp:Image ID="imgPhotoP" ImageUrl="#" runat="server" CssClass="thumbnail2" />
                                </div>  -->                             
                            </div>
                        </fieldset>

                          <fieldset style="border: 1px #ccc solid;margin-top:20px;padding-bottom:20px">
                            <legend>Pollinator Location</legend>
                                <div class="row half">

                                    <div class="6u">
                                        Organization Name
                                                                <asp:TextBox ID="txtOrganizationNameP2" runat="server" class="text" placeholder="Organization Name"></asp:TextBox>
                                        <%--<asp:RequiredFieldValidator CssClass="message-error"  ID="RequiredFieldValidatorOranizationName" runat="server" ControlToValidate="OranizationName" ErrorMessage="Oranization Name is required." ToolTip="Oranization Name is required." ValidationGroup="Update">*</asp:RequiredFieldValidator>--%>
                                    </div>
                                    <div class="6u">
                                        Size of Pollinator Location
                                        <asp:DropDownList  ID="drPollinatorSizeP" Width="100%" runat="server" placeholder="Size of Pollinator Location">
                                            <asp:ListItem Value="0"><--Select one size of Pollinator Location--></asp:ListItem>
                                            <asp:ListItem Value="1"> Small planter or balcony (30 square feet or less) </asp:ListItem>
                                            <asp:ListItem Value="2"> Small garden (30 to 100 square feet) </asp:ListItem>
                                            <asp:ListItem Value="3"> Large garden (100 to 1000 square feet) </asp:ListItem>
                                            <asp:ListItem Value="4"> Small Yard (1000 to 5000 square feet) </asp:ListItem>
                                            <asp:ListItem Value="5"> Medium Yard (1/2 Acre or less) </asp:ListItem>
                                            <asp:ListItem Value="6"> Large Yard (1 Acre or less) </asp:ListItem>
                                            <asp:ListItem Value="7"> Field (1 to 5 Acres) </asp:ListItem>
                                            <asp:ListItem Value="8"> Large Field (5 to 10 Acres) </asp:ListItem>
                                            <asp:ListItem Value="9"> I Dont Know </asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator15" runat="server" ControlToValidate="drPollinatorSizeP" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="Update">Select one Size of Pollinator Location.</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                    
                                <div class="row half">
                                    <div class="6u">
                                        Landscape Street
                                         <asp:TextBox MaxLength="100" ID="txtLandscapeStreetP" runat="server" class="text" placeholder="Landscape Street"></asp:TextBox>
                                        <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtLandscapeStreetP" ErrorMessage="Landscape Street is required." ToolTip="Landscape Street is required." ValidationGroup="Update">Landscape Street is required.</asp:RequiredFieldValidator>
                                    </div>
                                    <div class="6u">
                                        Landscape City
                                         <asp:TextBox MaxLength="30" ID="txtLandscapeCityP" runat="server" class="text" placeholder="Landscape City"></asp:TextBox>
                                        <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtLandscapeCityP" ErrorMessage="Landscape City is required." ToolTip="Landscape City is required." ValidationGroup="Update">Landscape City is required.</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="row half">
                                    <div class="6u">
                                        Landscape State
                                         <asp:TextBox MaxLength="30" ID="txtLandscapeStateP" runat="server" class="text" placeholder="Landscape State"></asp:TextBox>
                                        <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtLandscapeStateP" ErrorMessage="Landscape State is required." ToolTip="Landscape State is required." ValidationGroup="Update">Landscape State is required.</asp:RequiredFieldValidator>
                                    </div>

                                      <div class="6u" style="display: inline-flexbox;">                                       
                                        <div style="float: left; width: 49%">
                                           Zip Code/Country Code
                                        <asp:TextBox  MaxLength="10" ID="txtLandscapeZipcodeP" runat="server" class="text" placeholder="Zip Code/Country Code"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtLandscapeZipcodeP" ErrorMessage="Code/Country Code is required." ToolTip="Code/Country Code is required." ValidationGroup="Update">Zip Code/Country is required.</asp:RequiredFieldValidator>
                                            <br />
                                       <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtLandscapeZipcodeP" ID="RegularExpressionValidator6" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code!" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                          </div>

                                        <div style="float: right; width: 49%" title="Country">
                                            Country
                                            <asp:DropDownList ID="drCountryP" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                            <asp:ListItem Value="USA" Selected="True">USA</asp:ListItem>
                                            <asp:ListItem Value="Canada">Canada</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
                                        </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                               <!-- <div class="row half">
                                    <div class="6u" style="width: 100%; font-weight: bold;">
                                        <input type="checkbox" id="cbxUseAsBillingAddress" onclick="Check_cbxUseAsBillingAddress();" title="Check on to copy infomation at bellow section to Billing Address setion">
                                        <label for="cbxUseAsBillingAddress" style="display: inline;font-size:12px" >Use as Billing Address</label>
                                    </div>
                                </div>-->
                                <div class="row half">
                                    <div class="6u" style="width: 100%;">
                                        <%-- font-weight: bold;font-size: initial;--%>
                                        <%--<asp:Label ID="Label2" runat="server" Text="Label">Billing Address</asp:Label>--%>
                                        <label style="font-size:15px">Billing Address</label>
                                    </div>
                                </div>
                                <div class="row half">
                                    <div class="6u">
                                        Address
                                        <asp:TextBox  MaxLength="100" ID="txtBillingAddress" runat="server" class="text" placeholder="Address"></asp:TextBox>
                                        <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtBillingAddress" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="Update">Address is required.</asp:RequiredFieldValidator>
                                    </div>
                                    <div class="6u">
                                        City
                                        <asp:TextBox  MaxLength="30" ID="txtBillingCity" runat="server" class="text" placeholder="City"></asp:TextBox>
                                        <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtBillingCity" ErrorMessage="City is required." ToolTip="City is required." ValidationGroup="Update">City is required.</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="row half">
                                    <div class="6u">
                                        State
                                        <asp:TextBox  MaxLength="30" ID="txtBillingState" runat="server" class="text" placeholder="State"></asp:TextBox>
                                        <asp:RequiredFieldValidator  SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtBillingState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="Update">State is required.</asp:RequiredFieldValidator>
                                    </div>
                                     <div class="6u" ">
                                       

                                            Zip Code/Country Code
                                            <asp:TextBox  MaxLength="10" ID="txtBillingZipcode" runat="server" class="text" placeholder="Zip Code/Country Code"></asp:TextBox>
                                            <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtBillingZipcode" ErrorMessage="Zip Code/Country Code is required." ToolTip="Zip Code/Country Code is required." ValidationGroup="Update">Zip code is required.</asp:RequiredFieldValidator><br />
                                             <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtBillingZipcode" ID="RegularExpressionValidator4" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code!" ValidationGroup="Update"></asp:RegularExpressionValidator>
    
                                    </div>
                                </div>
                          
                                <%--  <div class="row half">
                                    <div class="-3u 6u">
                                        <fieldset>
                                            <legend>Payment Information</legend>
                                            <div class="row half">
                                                <div class="6u">Full Name<asp:TextBox MaxLength="255" ID="txtPaymentFullName" runat="server" class="text" placeholder="Full Name"></asp:TextBox>
                                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorPaymentFullName" runat="server" ControlToValidate="txtPaymentFullName" ErrorMessage="Full Name is required." ToolTip="Full Name is required." ValidationGroup="Update">Full name is required.</asp:RequiredFieldValidator>
                                                </div>
                                                <div class="6u">Address<asp:TextBox MaxLength="130" ID="txtPaymentAddress" runat="server" class="text" placeholder="Address"></asp:TextBox>
                                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorPaymentAddress" runat="server" ControlToValidate="txtPaymentAddress" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="Update">Address is required.</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="row half" >
                                                <div class="6u">State<asp:TextBox  MaxLength="30" ID="txtPaymentState" runat="server" class="text" placeholder="State"></asp:TextBox>
                                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorPaymentState" runat="server" ControlToValidate="txtPaymentState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="Update">State is required.</asp:RequiredFieldValidator>
                                                </div>
                                                <div class="6u" >CC Number<asp:TextBox  MaxLength="10" ID="txtPaymentZipcode" runat="server" class="text" placeholder="CC Number"></asp:TextBox>
                                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorPaymentZipcode" runat="server" ControlToValidate="txtPaymentZipcode" ErrorMessage="CC Number is required." ToolTip="CC Number is required." ValidationGroup="Update">CC Number is required.<br/></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator style="display:block" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPaymentZipcode" ID="RegularExpressionValidator4" ValidationExpression="(\d)*" runat="server" ErrorMessage="Invalid CC Number!" ValidationGroup="Update">Invalid CC Number!</asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="row half">
                                                <div class="12u" align="center">
                                                    <!-- PayPal Logo -->
                                                    <a href="https://www.paypal.com/webapps/mpp/paypal-popup" title="How PayPal Works" onclick="javascript:window.open('https://www.paypal.com/webapps/mpp/paypal-popup','WIPaypal','toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, width=1060, height=700'); return false;">
                                                        <img src="https://www.paypalobjects.com/webstatic/mktg/logo/AM_mc_vs_dc_ae.jpg" border="0" alt="PayPal Acceptance Mark"></a><!-- PayPal Logo -->
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>
                                </div>--%>



                        </fieldset>
                    </div>
                </div>
                
                 <div class="switch-mousewwheel" style="margin-top: 10px; margin-left: 17px; margin-right: 20px;">
                    <strong><label  ID="lblPickLocation" style="font-size:12px">Pick a location for Pollinator on Map</label> </strong>
                        <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static"   />
                <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static" />
                  
                        <span  id ="mapError" class ="message-error" style="display:none" title="Please pick a location for Pollinator on Map.">Please pick a location for Pollinator on Map.</span>
                     
                    <label for="mousewwheel"><input type="checkbox" id="mousewwheel" value="1"> Use mousewheel to zoom Map</label> 
                </div>
                <div id="map_canvas" style="margin-top: 5px; margin-left: 17px;margin-right: 20px; height: 420px"></div>

                <div style="margin-top: 20px; margin-left: 17px; margin-right: 20px;">
                    <div class="12u">
                        <div class="6u" style="font-size:12px">
                          						
                            <asp:CheckBox ID="IsApproved" runat="server" CssClass="flat-checkbox" style="float: left" /><label style="float: left" for="<%= IsApproved.ClientID %>"><strong style="color:rgb(36,137,197)">Approve pollinator to make public on map</strong></label>
                            <br/>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-top: 20px; margin-bottom: 20px;" runat="server">
                    <div class="12u" style="margin-left:-5px">
                        <div class="6u">
                            <%--                           <asp:LinkButton ID="btnUpdate" runat="server" class="button btn11" Text="Update" OnClick="btnUpdate_Click" />
                            <asp:LinkButton ID="btnDelete" runat="server" class="button btn11" Text="Delete" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete?');" />--%>
                            <button type="button" id="btnUpdate" onclick="if (!checkUpdate()) return;"  causesvalidation="True" validationgroup="Update" class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnUpdate_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Update</span>
                            </button>
                            
<%--                            <button type="button" id="btnUpdate" onclick="if (!checkUpdate()) return;"  causesvalidation="True" validationgroup="Update" class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnUpdate_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Update</span>
                            </button>--%>
                           
                            <button type="button" id="btnDelete" onclick="javascript:$('#divConfirmDelete').modal('show');" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                              runat="server">
                                <i class="glyphicon glyphicon-trash"></i>
                                <span>Delete</span>
                            </button>

<%--                            <button type="button" id="btnDelete" onclick="if (confirm('Are you sure you want to delete?'))"  onserverclick="btnDelete_Click" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                              runat="server">
                                <i class="glyphicon glyphicon-trash"></i>
                                <span>Delete</span>
                            </button>--%>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div id="divConfirmApprove" class="modal fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" 
                  aria-hidden="true">×</button>
            <h3 id="H1">Pollinator Approval</h3>
            <div style="width: 100%;text-align: center">
                <img src="../Images/Bee_Friendly_Farmer_Logo.png"/>
            </div>
       </div>
       <div class="modal-body">
           The pollinator is not approved yet. Do you want to approve it?
            <div class="modal-footer">
                <button id="btnApprove" runat="server" class="btn btn-success" aria-hidden="true" type="button" onclick="$('#divConfirmApprove').modal('hide'); approvePollinator();" onserverclick="btnUpdate_Click">OK</button>
                <%--<asp:Button runat="server" ID="btnConfirmDeleteYes" CssClass="btn btn-danger" aria-hidden="true" Text="Yes" OnClick="btnDelete_Click" CausesValidation="False" />--%>
                <button class="btn btn-warning" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
         </div>
    </div>

    <div id="divConfirmDelete" class="modal fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" 
                  aria-hidden="true">×</button>
            <h3 id="myModalLabel">Delete Confirmation</h3>
       </div>
       <div class="modal-body">
           Are you sure you want to delete?
            <div class="modal-footer">
                <button class="btn btn-danger" runat="server" aria-hidden="true" type="button" onclick="$('#divConfirmDelete').modal('hide');" onserverclick="btnDelete_Click">Yes</button>
                <%--<asp:Button runat="server" ID="btnConfirmDeleteYes" CssClass="btn btn-danger" aria-hidden="true" Text="Yes" OnClick="btnDelete_Click" CausesValidation="False" />--%>
                <button class="btn btn-info" data-dismiss="modal" aria-hidden="true">No</button>
            </div>
         </div>
    </div>

     <script type="text/javascript">

         function Check_cbxUseAsBillingAddress() {

             var txtLandscapeStreet = '#<%=txtLandscapeStreetP.ClientID %>';
            var txtLandscapeCity = '#<%= txtLandscapeCityP.ClientID %>';
            var txtLandscapeState = '#<%= txtLandscapeStateP.ClientID %>';
            var txtLandscapeZipcode = '#<%= txtLandscapeZipcodeP.ClientID %>';

            var txtBillingAddress = '#<%= txtBillingAddress.ClientID %>';
            var txtBillingCity = '#<%= txtBillingCity.ClientID %>';
            var txtBillingState = '#<%= txtBillingState.ClientID %>';
            var txtBillingZipcode = '#<%= txtBillingZipcode.ClientID %>';

            if ($('#cbxUseAsBillingAddress').prop('checked')) {
                $(txtBillingAddress).val($(txtLandscapeStreet).val());
                $(txtBillingCity).val($(txtLandscapeCity).val());
                $(txtBillingState).val($(txtLandscapeState).val());
                $(txtBillingZipcode).val($(txtLandscapeZipcode).val());
            }
        }

        function approvePollinator() {
            var ctlIsApproved = '#<%=IsApproved.ClientID %>';
            //Set checked
            $(ctlIsApproved).prop('checked', true);

            //Refresh check status
            $(ctlIsApproved).iCheck({
                checkboxClass: 'icheckbox_square-blue',
                radioClass: 'iradio_square-blue',
                increaseArea: '20%'
            });

            //Go back to update data
            checkUpdate();
        }

        function checkUpdate() {
            var ctlIsApproved = '#<%=IsApproved.ClientID %>';
            var isApproved = $(ctlIsApproved).attr("checked");

            if (!isApproved) {
                $('#divConfirmApprove').modal('show');

                //When popup is shown, press Enter to approve immediately
                $("body").live('keydown', function (e) {
                    var keyCode = (window.event) ? e.which : e.keyCode;

                    if (keyCode == 13) {
                        $('#<%= btnApprove.ClientID %>').click();
                        e.preventDefault();
                    }
                });

                return false;

                //var confirmSave = confirm("You update information without approved. Click 'OK' to continue. Click 'Cancel' to return ");

                //if (!confirmSave)
                //    return false;
            }
            else {
                var ctlLat = '#<%=hdnLat.ClientID %>';
                var ctlLng = '#<%=hdnLng.ClientID %>';
                var lat = $(ctlLat).val();
                var lng = $(ctlLng).val();

                if (lat == "" || lng == "") {
                    $("#mapError").css("display", "inline");
                    var el = document.getElementById('lblPickLocation');
                    el.scrollIntoView(true);
                    return false;
                }
            }

            var btnUpdate = '#<%=btnUpdate.ClientID %>';

            if (Page_ClientValidate("Update")) {
                if (btnUpdate)
                    $(btnUpdate).attr("disabled", "disabled");
            }

            return true;
        }

        // Upload single photo
        var txtPhotoUrl = '#<%=txtPhotoUrl.ClientID %>';
         var imgPhoto = '<%=imgPhoto.ClientID %>';
         var linAddPhoto = '<%=linAddPhoto.ClientID %>';;
         var fileToUploadID = '<%=fileToUploadNormal.ClientID %>';
         var dontDeletePreImage = '<%=dontDeletePreImage.ClientID %>';
         var validatorInputPhotoUrl = '#validatorPhotoUrl';
         // End Upload single photo

         // Upload multi files
         function SetControlToReturnPhotoUrl(returnControlID) {
             $('#returnUploadUrlimage').val(returnControlID);
         }

         function SetControlToReturnVideoUrl(returnControlID) {
             $('#returnUploadUrlvideo').val(returnControlID);
         }
         // End Upload multi files

         //Upload single video
         var txtYoutubeUrl = '#<%= txtYoutubeUrl.ClientID%>';
        var validatorInputVideoUrl = '#validatorVideoUrl';

    </script>

    <input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
    <uc:SinglePhoto runat="server" ID="SinglePhoto"  />

    <uc:Upload runat="server" ID="mulUploadImage"  />
    <uc:Upload runat="server" ID="mulUploadVideo" FileType="video" /> 
  
    <yb:SingleYoutube runat="server" ID="SingleYoutube"  />

    <style type="text/css">
        .flat-checkbox input
        {
            margin-top: -3px;
        }

        .flat-checkbox div
        {
            margin-top: -3px;
        }

        .row
        {
            margin-right: 18px;
            margin-left: -25px;
        }

            .row.half
            {
                padding-left: 5px;
            }

        form input.text, form select, form textarea
        {
            margin-top: 5px;
            margin-bottom: 5px;
            -webkit-appearance: scrollbarbutton-down;
        }

        .message-error
        {
            font-size: 1em;
        }

        legend
        {
            font-size: 18px;
            width: auto;
            border-bottom: 0px;
        }

        fieldset
        {
            margin-left: -8px;
            padding-left: 12px;
        }
    </style>
</asp:Content>
