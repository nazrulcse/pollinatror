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

    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

    <!--start map-->
    <style type="text/css">
        #map_canvas
        {
            margin-top: 5px;
            margin-left: 0;
            height: 420px;
            width: 1046px;
        }

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


            var ctlLat = '#<%=hdnLat.ClientID %>';
            var ctlLng = '#<%=hdnLng.ClientID %>';
            var lat = "";
            var lng = "";

            if (addr == '') {
                lat = $(ctlLat).val();
                lng = $(ctlLng).val();
            }

            var address = "<%=Address%>";
            var orgDesc = "<%=organizationDescription %>"

            var OrganizationName = "<%=PollinatorName%>";
            var html = "<div class='infowindows'>";
            if (OrganizationName != "") {
                html += "<h2>" + OrganizationName.replace(/(<([^>]+)>)/ig, "") + "</h2><hr />";
            }
            if (address != "") {
                html += "<p>" + address.replace(/(<([^>]+)>)/ig, "") + "</p>";
            }

            if (lat == "" || lng == "") {
                html += '<p style="color: #f00; font-size: 12px; text-align: justify;">The pin for the pollinator has not yet saved. Please locate it or let it map automatically based on street/city as below, then click "Update" to save the pin.</p>';
            }

            if (OrganizationName == "" && address == "") {
                html += "<h2>This is your location!</h2><hr />";
            }
            if (orgDesc != "") {
                html += "<p>" + orgDesc.replace(/(<([^>]+)>)/ig, "") + "</p>"
            }
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';
            html += "</div>";

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
                        map.setCenter(new google.maps.LatLng(40.5, -101.5));
                        map.setZoom(3);

                        if (marker) {
                            marker.setMap(null);
                            marker = null;
                        }
                        marker = createMarker(new google.maps.LatLng(40.5, -101.5), "pollinator", html);
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
            var orgDesc = "<%=organizationDescription %>";
            var OrganizationName = "<%=PollinatorName%>";
            console.log(orgDesc);
            var html = "<div class='infowindows'>";
            if (OrganizationName != "") {
                html += "<h2>" + OrganizationName.replace(/(<([^>]+)>)/ig, "") + "</h2><hr />";
            }
            if (address != "") {
                html += "<p>" + address.replace(/(<([^>]+)>)/ig, "") + "</p><hr />";
            }
            if (OrganizationName == "" && address == "") {
                html += "<h2>This is your location!</h2><hr />";
            }
            if (orgDesc != "") {
                html += "<p>" + orgDesc.replace(/(<([^>]+)>)/ig, "") + "</p>"
            }
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';
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
        //end map

        function goBack() {
            var userLink = '<%=ResolveUrl("~/Admin/Users")%>?ShowLastestKeyword=1';
            window.location = userLink;
        }

        $(document).ready(function () {

            if (navigator.userAgent.toLowerCase().indexOf('chrome') == -1 && navigator.userAgent.toLowerCase().indexOf('mozilla') > -1) {
                $('select').css('padding-top', '1.5em');
            }

            $(".close").click(function () {
                $(".alert").alert();
            });


            //map
            $("input[id='mousewwheel']").change(function () {
                if ($("input[id='mousewwheel']").attr('checked')) {
                    map.setOptions({ scrollwheel: true });
                    setCookie("mousewwheel", 1, 365);
                } else {
                    map.setOptions({ scrollwheel: false });
                    setCookie("mousewwheel", 0, 365);
                }
            });

            //End map
        });

     
    </script>
   
         
    <div class="admincontainer">
        <div style="padding-left: 3px;padding-right: 3px;" >

            <h2 style="margin-left:0px">Register Information</h2>
            <p  style="margin-left:0px">

                <!--Bootstrap button style-->
                <button class="btn" onclick="javascript:goBack();return false;">
                    <i class="glyphicon glyphicon-backward"></i>
                    Back to List
                </button>
            </p>

            <div style="margin-left:0px;width: 1046px">
             
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>                      
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
            
            <div style="width: 1039px;  margin-left:7px; font-family: Verdana; font-size: 0.8em; border-collapse: collapse;">
                 <div id="divRowRegNormal" style="margin-top: 20px; margin-bottom: 20px;" runat="server">
                    <div class="12u">

                        <fieldset style="border: 1px #ccc solid;padding-bottom:20px">
                            <legend>General Information</legend>
                            
                             <div class="row half" style="margin-top:20px">
                                <div class="6u">
                                    Full Name
                                    <asp:TextBox MaxLength="60" class="text" placeholder="First Name" ID="txtFirstName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="RequiredFieldValidatorFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Full Name is required." ToolTip="Full Name is required." ValidationGroup="Update">Full Name is required.</asp:RequiredFieldValidator>
                                </div>

                                <div class="6u">
                                    Phone Number
                                    <asp:TextBox MaxLength="24" class="text" placeholder="Phone Number" ID="txtPhoneNumber" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPhoneNumber" ID="RegularExpressionValidator3"  ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone Number." ValidationGroup="Update"></asp:RegularExpressionValidator>                         
                                </div>

                            </div>

                            <div class="row half">
                                <div class="6u">
                                    Email Address
                                    <asp:TextBox  MaxLength="256"  class="text" ID="txtEmail" runat="server" placeholder="Email Address"></asp:TextBox><%--TextMode="Email"--%>
                                    <asp:RequiredFieldValidator SetFocusOnError="true" Display="Dynamic" CssClass="message-error" ID="EmailRequired" runat="server" ControlToValidate="txtEmail" ErrorMessage="E-mail Address is required." ToolTip="E-mail Address is required." ValidationGroup="Update">E-mail Address is required.</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display="Dynamic" CssClass="message-error" ID="RegularExpressionValidator1" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>

                                <div class="6u">
                                    Type of Pollinator Location
                                    <asp:DropDownList  ID="drPollinatorType" Width="100%" runat="server" placeholder="Type of Pollinator Location">                                     
                                    </asp:DropDownList>
                                     <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator5" runat="server" ControlToValidate="drPollinatorType" ErrorMessage="Select one Type of Pollinator Location" ToolTip="Select one Type of Pollinator Location" ValidationGroup="Update">Select one Type of Pollinator Location.</asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="row half" >
                                <div class="6u" >
                                    Username
                                    <asp:TextBox readonly TabIndex="-1" class="text" BackColor="#dbdbdb" placeholder="Username" ID="txtUserName" runat="server"></asp:TextBox>                                    
                                </div>

                                <div class="6u"  >
                                    Password
                                    <asp:TextBox MaxLength="128" ID="txtPassword" runat="server" TextMode="Password" class="text password-strength-meter" ToolTip="" placeholder="Password"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPassword" ID="revPassword" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            
                        </fieldset>
                        
                        <fieldset style="border: 1px #ccc solid;margin-top:20px">
                            <legend>Pollinator Information</legend>

                              <div class="row half" style="margin-top:20px">
                                <div class="6u">
                                    Organization Name
                                    <asp:TextBox ID="txtOrganizationName" runat="server" class="text" MaxLength="100" orgDesc="" placeholder="Organization Name"></asp:TextBox>
                                </div>

                                <div class="6u">
                                    Size of Pollinator Location
                                    <asp:DropDownList  ID="drPollinatorSize" Width="100%" runat="server" placeholder="Size of Pollinator Location">                               
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator InitialValue="0" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator13" runat="server" ControlToValidate="drPollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u" style="width: 100%;">                             
                                    Organization Description                                    
                                    <asp:TextBox ID="orgDescription"  runat="server" class="text" TextMode="MultiLine" Rows="5"  placeholder="Organization Description"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u">
                                    Landscape Street
                                     <asp:TextBox  MaxLength="100"  ID="txtLandscapeStreet" runat="server" class="text" placeholder="Landscape Street"></asp:TextBox>
                                   
                                </div>
                                <div class="6u">
                                    Landscape City
                                    <asp:TextBox  MaxLength="30" ID="txtLandscapeCity" runat="server" class="text" placeholder="Landscape City"></asp:TextBox>
                                    
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u">
                                    Landscape State
                                    <asp:TextBox MaxLength="30" ID="txtLandscapeState" runat="server" class="text" placeholder="Landscape State"></asp:TextBox>
                                    
                                </div>


                                <div class="6u" >                                       
                                    <div style="float: left; width: 49%">
                                        Zip Code/Country Code
                                            <asp:TextBox MaxLength="10" ID="txtLandscapeZipcode" runat="server" class="text" placeholder="Zip Code/Country Code"></asp:TextBox>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtLandscapeZipcode" ID="RegularExpressionValidator5" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code!" ValidationGroup="Update"></asp:RegularExpressionValidator>
                                        </div>

                                    <div style="float: right; width: 49%" title="Country">
                                        Country
                                        <asp:DropDownList ID="drCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">                                          
                                        </asp:DropDownList>
                                    </div>

                                 </div>
                                
                            </div>

                            <div class="row half">

                                <div class="6u">
                                    Photo URL
                                   <asp:TextBox MaxLength="255" ID="txtPhotoUrl" runat="server" BackColor="#dbdbdb" class="text" placeholder="Photo URL"></asp:TextBox>
                                   <asp:Label id="numPhoto" runat="server"></asp:Label>
                                   <img id="loading" src="../images/loading.gif" style="display: none;">
                                    <span id="validatorPhotoUrl" class="message-error" style="display: none;"></span>
                                </div>

                                <div class="6u">
                                    Youtube URL
                                   <asp:TextBox MaxLength="255" ID="txtYoutubeUrl" BackColor="#dbdbdb" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                                    <asp:Label id="numVideo" runat="server"></asp:Label>
                                    <img id="loadingVideo" src="../images/loading.gif" style="display: none;">
                                      <div class="during-upload" id="during-upload" style="display:none">
                                        <p><span id="percent-transferred" >Uploading</span></p>
                                        <p>
                                            <progress id="upload-progress" max="100" value="1" style="width:190px""></progress>
                                        </p>
                                      </div>
                                    <span id="validatorVideoUrl" class="message-error" style="display: none;"></span>
                                </div>
                            </div>

                            <div class="row half">
                                <div class="6u">
                                     <a href="#Upload_formimage" id="A2"  onclick="openPopup()" class="btnUploadPhoto button btn36" style="font-size: 12px;">Photos</a>
                                </div>

                                <div class="6u">
                                      <a href="#Upload_formvideo" id="A1"  onclick="openPopup()" class="button btn36" style="font-size: 12px;">Videos</a>
                                </div>
                             </div>

                            <div class="row half" >
                                <div class="6u" style="padding-bottom:5px">                                    
                                    <asp:Image ID="imgPhoto" ImageUrl="#" runat="server" CssClass="thumbnail2" />
                                </div>
                                <div class="6u" style="padding-bottom:5px">                                    
                                    <div id="divVideoPlayer" style="display:none;margin-top:-20px;"></div>
                                </div>                               
                            </div>

                        </fieldset>

                    </div>
                 </div>        
            </div>

             <div style ="margin-top:10px;font-family: Verdana; font-size: 0.9em;">
    
                <div class="switch-mousewwheel">
                    <strong><label  ID="lblPickLocation" style="font-size:13px">Pick a location for Pollinator on Map</label> </strong>
                        <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static"   />
                        <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static" />
                  
                        <span  id ="mapError" class ="message-error" style="display:none" title="Please pick a location for Pollinator on Map.">Please pick a location for Pollinator on Map.</span>
                     
                    <label for="mousewwheel" style="font-size:12px"><input type="checkbox" id="mousewwheel" value="1"> Use mousewheel to zoom Map</label> 
                </div>
                    
                <div  id="map_canvas"></div>              

                <div style="margin-top: 20px;">
                    <div class="12u">
                        <div class="6u" style="font-size:12px">
                          						
                            <asp:CheckBox ID="IsApproved" runat="server" CssClass="flat-checkbox" style="float: left" /><label style="float: left;font-size:13px" for="<%= IsApproved.ClientID %>"><strong style="color:rgb(36,137,197)">Approve pollinator to make public on map</strong></label>
                            <br/>
                        </div>
                    </div>
                </div>
  
            </div>
            <div style="margin-top: 20px; font-family: Verdana; font-size: 0.9em;" >
                <div class="12u" >
                    <div class="6u" >
                        <button type="button" id="btnUpdate" causesvalidation="True" validationgroup="Update" class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                            runat="server" onserverclick="btnUpdate_Click">
                            <i class="glyphicon glyphicon-edit"></i>
                            <span style="font-size: 1em;">Update</span>
                        </button>

                        <button type="button" id="btnDelete" onclick="javascript:$('#divConfirmDelete').modal('show');" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                            runat="server">
                            <i class="glyphicon glyphicon-trash"></i>
                            <span>Delete</span>
                        </button>

                    </div>
                </div>
            </div>     
    </div>
    
        <div id="divConfirmApprove" class="modal fade">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" 
                      aria-hidden="true">×</button>
                <h3 id="H1">Confirm and update/approve pollinator</h3>
                <div style="width: 100%;text-align: center">
                    <img src="../Images/Bee_Friendly_Farmer_Logo.png"/>
                </div>
           </div>
           <div class="modal-body">
               Pollinator is not approved before updating. Do you want to approve it?
                <div class="modal-footer">
                    <%--<button id="btnApprove" runat="server" class="btn btn-success" aria-hidden="true" type="button" onclick="$('#divConfirmApprove').modal('hide'); approvePollinator();" onserverclick="btnUpdate_Click">OK</button>--%>
                    <button id="btnApprove" runat="server" class="btn btn-success" aria-hidden="true" type="button" onclick="$('#divConfirmApprove').modal('hide');  if (!approvePollinator()) return;" onserverclick="btnUpdate_Click">Yes, approve!</button>
                    <button id="btnUpdateWithoutApprove" runat="server" class="btn btn-warning" aria-hidden="true" type="button" onclick="$('#divConfirmApprove').modal('hide'); if (!updatePollinator()) return;" onserverclick="btnUpdate_Click">No, just update!</button>
                    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">No</button>
                </div>
             </div>
        </div>
    </div>

     <script type="text/javascript">
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
             }
             else {
                 return updatePollinator();
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
             return updatePollinator();
         }

         function updatePollinator() {
            
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
             

             var btnUpdate = '#<%=btnUpdate.ClientID %>';

             if (Page_ClientValidate("Update")) {
                 if (btnUpdate)
                     $(btnUpdate).attr("disabled", "disabled");
             }

             return true;
         }

         // Photo
         var txtPhotoUrl;
         var imgPhoto;
         var linAddPhoto;
         var fileToUploadID;
         var dontDeletePreImage;
         var validatorInputPhotoUrl;
         var loadingImage;
         var numPhoto;
      
         txtPhotoUrl = '#<%=txtPhotoUrl.ClientID %>';
         imgPhoto = '<%=imgPhoto.ClientID %>';
         validatorInputPhotoUrl = '#validatorPhotoUrlP';
         numPhoto = '#<%=numPhoto.ClientID%>';
         // End Photo


         //Video
         var txtYoutubeUrl;
         var validatorInputVideoUrl;
         var divVideoPlayer;
         var loadingVideo;
         var duringupload = "#during-upload";
         var uploadprogress = "#upload-progress";
         var percenttransferred = "#percent-transferred";
         var numVideo;
         txtYoutubeUrl = '#<%=txtYoutubeUrl.ClientID%>';
         validatorInputVideoUrl = '#validatorVideoUrlP';
         divVideoPlayer = '#divVideoPlayerP';
         loadingVideo = '#loadingVideoP';
         linAddVideo = '';
         numVideo = '#<%=numVideo.ClientID%>';
         //End video
    
    </script>

    <input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
    <uc:SinglePhoto runat="server" ID="SinglePhoto"  />

    <uc:Upload runat="server" ID="mulUploadImage"  />
    <uc:Upload runat="server" ID="mulUploadVideo" FileType="video" /> 
  
    <yb:SingleYoutube runat="server" ID="SingleYoutube"  />

     <script type="text/javascript">

         displayVideoOnChange(txtYoutubeUrl, true);
      
    </script>
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
            margin-bottom: 0px;
        }

        fieldset
        {
            margin-left: -8px;
            padding-left: 12px;
            padding-right:16px;
        }
    </style>

</asp:Content>