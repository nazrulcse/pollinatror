<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterUserStep2.ascx.cs" Inherits="Controls_RegisterUserStep2" %>

<%@ Register Src="~/Controls/UploadSinglePhoto.ascx" TagName="SinglePhoto" TagPrefix="uc" %>
<%@ Register Src="~/Controls/UploadMultiFiles.ascx" TagName="Upload" TagPrefix="uc" %>
<%@ Register Src="~/Controls/YoutubeSingleVideo.ascx" TagName="SingleYoutube" TagPrefix="yb" %>
<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>
<%@ Register Src="PasswordStrength.ascx" TagName="PasswordStrength" TagPrefix="uc" %>

<!--BEGIN: Javascript plug-in for validating password strength-->

<!--BEGIN: Jquery plug-in for validating password strength-->

<div class="registercontainer" id="step2">
    <div class="header">
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="2" Percent="25" />
        <h1> Register Your Pollinator Site </h1>
    </div>
    <div class="content">
        <div class="rowbot">
           <h3>Basic Info</h3>
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="60" class="text" ToolTip="Required" placeholder="Full Name" ID="txtFullName" runat="server" required></asp:TextBox>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreFirstName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full Name is required" ToolTip="Full Name is required" ValidationGroup="RegisterUserStep1"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revPreFirstName" ControlToValidate="txtFullName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid Full Name" ValidationGroup="RegisterUserStep1"></asp:RegularExpressionValidator>
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="256" class="text" ID="txtEmail" runat="server" ToolTip="" placeholder="Email Address" TextMode="Email" ></asp:TextBox>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="validEmail" ControlToValidate="txtEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="RegisterUserStep1"></asp:RegularExpressionValidator>

        </div>
          <div class="rownor">

             <input type="checkbox" id="cbxAccept" checked>
            <label for="cbxAccept" style="display: inline">I accept the SHARE Privacy Policy <a style="color:blue" href="#PolicyPopup"> HERE</a></label>
             <br />
           <asp:CustomValidator ID="chkAgreeValidator" runat="server" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ValidationGroup="RegisterUserStep1"
    ClientValidationFunction="checkAgreement">Please accept the Pollinator Partnership Privacy Policy before registering
    </asp:CustomValidator>

        </div>
    </div>

    <%--Show Policy modal poupup --%>

    <a href="#x" class="overlay" id="PolicyPopup"></a>
    <div class="popup" >
        <div style="width: auto; text-align: center;padding:15px">
           <h3>SHARE Privacy Policy </h3>
        </div>
         <div style="width: auto; text-align: left">
We only have access to/collect information that you voluntarily give us via email or other direct contact from you. You will not be contacted without your permission; your information is confidential, and we will not sell or rent this information to anyone.

        </div>
        <a class="popup-close" id="popup-close" href="#close" ></a>
    </div>

    <div class="content">
        <div class="rowbot">
			<h3>Pollinator Site Location</h3>
			<p><i style="font-size: small" class="fa fa-exclamation-circle"></i> indicates required field</p>
		</div>
        <div class="rownor">
            <asp:DropDownList ID="ddlCountry" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Country" ToolTip="Required">
                <asp:ListItem Value="NONE">Select Country</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlCountry" ErrorMessage="Select a country" ToolTip="Select a country" ValidationGroup="RegisterUserStep2"></asp:RequiredFieldValidator>
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="30" ID="txtLandscapeCity" runat="server" class="text" ToolTip="Required" placeholder="City" required></asp:TextBox>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="tfvLandscapeCity" runat="server" ControlToValidate="txtLandscapeCity" ErrorMessage="City is required" ToolTip="City is required" ValidationGroup="RegisterUserStep2">City is required</asp:RequiredFieldValidator>
        </div>

        <div class="rownor">
            <div class="floatLeft" style="width: 50%; padding-right: 5px">
                <asp:TextBox MaxLength="30" ID="txtLandscapeState" runat="server" class="text" placeholder="State/Province"></asp:TextBox>
            </div>
            <div class="floatRight" style="width: 50%; padding-left: 5px">
                <asp:TextBox MaxLength="10" ID="txtLandscapeZipcode" runat="server" class="text" placeholder="Zip Code/Postal Code"></asp:TextBox>
                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtLandscapeZipcode" ID="revLandscapeZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Postal Code !" ValidationGroup="RegisterUserStep2"></asp:RegularExpressionValidator>
            </div>
            <div style="clear: both"></div>
        </div>

        <div class="rownor">

            <div id="previewMapInline" class="floatLeft" style="width: 60%; height: 250px"></div>
            <div class="floatRight">
                <a style="font-size: 14px;" class="button btn36" id="showmap_popupNormal" href="#map_popup" onclick="codeAddress(this.id)">
                    <img style="width: 20px; height: 20px" src="<%=ResolveUrl("~/Images/icon/icon-target.png") %>" />
                    <span class="buttonText">Confirm or Adjust Location</span> </a>
            </div>
            <div style="clear: both"></div>
        </div>

        <div class="rowbot">
            <h3>About Your Pollinator Site</h3>
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtOrganizationName" maxlenght="100" runat="server" class="text" ToolTip="Please leave blank if you are registering a residential or other non organizational pollinator site" placeholder="Organization Name"></asp:TextBox>
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtOrganizationDescription"  runat="server" class="text" TextMode="MultiLine" Rows="5"  placeholder="Organization Description"></asp:TextBox>
        </div>
        <div class="rownor">
            <asp:DropDownList ID="ddlPollinatorType" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Type of Pollinator Site" ToolTip="Required">
                <asp:ListItem Value="NONE">Type of Pollinator Site</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPollinatorType" runat="server" ControlToValidate="ddlPollinatorType" ErrorMessage="Select one Type of Pollinator Site" ToolTip="Select one Type of Pollinator Site" ValidationGroup="RegisterUserStep2"></asp:RequiredFieldValidator>
        </div>
        <div class="rownor">

            <asp:DropDownList ID="ddlPollinatorSize" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Size of Pollinator Site" ToolTip="Required">
                <asp:ListItem Value="NONE">Size of Pollinator Site</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPollinatorSize" runat="server" ControlToValidate="ddlPollinatorSize" ErrorMessage="Select one Size of Pollinator Site" ToolTip="Select one Size of Pollinator Site" ValidationGroup="RegisterUserStep2"></asp:RequiredFieldValidator>
        </div>
        <div class="rownor">
            <asp:DropDownList ID="ddlFindOut" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="How did You Find Out About Us?">
                <asp:ListItem Value="NONE">How did you find out about us?</asp:ListItem>             
             

            </asp:DropDownList>
        </div>


        <div class="rownor">
            <h3>Share your Video/Photos!</h3>
        </div>

        <div class="rownor">
            <div class="floatLeft" style="width: 50%; text-align: center">
                <img id="imgThumbnailNor" src="" class="thumbnail2" style="display: none">
            </div>
            <div class="floatRight" style="padding-bottom: 5px; width: 50%; text-align: center">
                <div id="divVideoPlayer" style="display: none; margin-top: -20px;"></div>
            </div>
            <div style="clear: both"></div>
        </div>

        <div class="rowtop">
            <div class="floatLeft" style="width: 50%; text-align: center">
                <asp:Label id="numPhoto" runat="server"></asp:Label>
                <label class="file-upload">
                    <a class="btnUploadPhoto button btn36" id="linkAddPhoto" href="#Upload_formimage" onclick="openPopup()" style="min-width: 190px; font-size: 14px;">Add Images</a>
                </label>
                <img id="loadingNormal" src="<%=ResolveUrl("~/Images/loading.gif")%>" style="display: none;">
            </div>

            <div class="floatRight" style="width: 50%; text-align: center">
                <asp:Label id="numVideo" runat="server"></asp:Label>
                <label class="file-upload">
                    <a class="button btn36" onclick="openPopup()" id="linkAddVideo" href="#Upload_formvideo" style="min-width: 190px; font-size: 14px;">Add Videos</a>
                </label>
                <img id="loadingNormalVideo" src="<%=ResolveUrl("~/Images/loading.gif")%>" style="display: none;">
            </div>
            <div style="clear: both"></div>
        </div>
        <div>
            <div class="floatLeft" style="width: 50%; text-align: center">
                <asp:TextBox MaxLength="255" ID="txtPhotoUrl" Style="display: none;" onblur="ShowImgThumnail(this.id, 'imgThumbnailNor');" runat="server" class="text" placeholder="Photo URL"></asp:TextBox>
                <img id="loading" src="<%=ResolveUrl("~/Images/loading.gif")%>" style="display: none;">
                <span id="validatorPhotoUrl" title="You can upload only files with the following extensions: jpg, jpeg, gif, png" class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
            </div>
            <div class="floatRight" style="width: 50%; text-align: center">
                <asp:TextBox MaxLength="255" ID="txtYoutubeUrl" Style="display: none" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                <img id="loadingVideo" src="<%=ResolveUrl("~/Images/loading.gif")%>" style="display: none;">
                <div class="during-upload" id="during-upload" style="display: none">
                    <p><span id="percent-transferred">Uploading</span></p>
                    <p>
                        <progress id="upload-progress" max="100" value="1" style="width: 190px"></progress>
                    </p>
                </div>
                <span id="validatorVideoUrl" title="You can upload only flv,mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files." class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
            </div>
            <div style="clear: both"></div>
        </div>

        <div id="lblCreateAccountTitle" class="rowbot lblCreateAccountTitle">
            <h1>Create Your Account!
                <i style="font-size: medium" class="fa fa-question-circle fa-fw help" data-container="body" data-toggle="popover" data-placement="right"
                    data-content="Creating an account will allow you to login at a later date to 
                    update your SHARE site details or add new photos and videos. 
                    Creating an account is not required to post your site to the map."
                    data-original-title="" title=""></i>
            </h1>

        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="50" class="text" ToolTip="" placeholder="Username" ID="txtUserName" runat="server" onchange="CheckExistUserName(this.id, 'lblUserAvailability');"></asp:TextBox>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtUserName" ID="revUsername" ValidationExpression="^[a-zA-Z0-9_-]{3,}$" runat="server" ErrorMessage="Invalid Username! It must be at least 3 characters and does not include special characters." ValidationGroup="CreateAccount"></asp:RegularExpressionValidator>
            <div id="lblUserAvailability" class="available"></div>

        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="128" ID="txtPassword" runat="server" TextMode="Password" class="text password-strength-meter" ToolTip="" placeholder="Password"></asp:TextBox>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtUserName" ID="revPassword" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required" ValidationGroup="CreateAccount"></asp:RegularExpressionValidator>

        </div>
        <div class="rownor">
            <div style="text-align: center">
                <a id="btnFinishShare" class="submit button btn1 buttonlarge" onclick="registerUserStep2()">
                    <span style="padding-left: 2.2em; padding-right: 2.2em">&nbsp;&nbsp;&nbsp;&nbsp;Finish!</span>
                    <span class="fa fa-arrow-right"></span>
                </a>
            </div>

            <div style="width: 300px; margin: -44px auto 0px; height: 44px;">
                <img class="checking" style="display: none;" src="<%=ResolveUrl("~/Images/loading.gif") %>" />
            </div>
        </div>

        <div class="rownor">
            <input type="checkbox" id="cbxNotCreateAccount">
            <label id="lblNotCreateAccount" for="cbxNotCreateAccount" style="display: inline">I don't need to access my account again, just post!</label>
        </div>

    </div>
</div>
<%--Single upload user controls--%>

<input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
<yb:SingleYoutube runat="server" ID="SingleYoutube" />
<uc:SinglePhoto runat="server" ID="SinglePhoto" />
<uc:Upload runat="server" ID="mulUploadFiles" />
<uc:Upload runat="server" ID="mulUploadVideo" FileType="video" /> 
<script type="text/javascript">
    // Upload single photo
    var txtPhotoUrl = '#<%=txtPhotoUrl.ClientID%>';

    var imgPhoto = 'imgThumbnailNor';
    var numPhoto = '#<%=numPhoto.ClientID%>';
    var numVideo = '#<%=numVideo.ClientID%>';
    var fileToUploadID = 'fileToUploadNormal';
    var dontDeletePreImage = '<%=dontDeletePreImage.ClientID%>';
    var validatorInputPhotoUrl = '#validatorPhotoUrl';
    var loadingImage = '#loading';
    var linAddPhoto;

    //onchange
    //$(txtPhotoUrl).change(function () {
      //  displayImageOnChange(this, false);
    //});
    // End Upload single photo

    //Upload single video
    var txtYoutubeUrl = '#<%=txtYoutubeUrl.ClientID%>';
    var validatorInputVideoUrl = '#validatorVideoUrl';
    var loadingVideo = '#loadingVideo';
    var divVideoPlayer = '#divVideoPlayer';
    var duringupload = "#during-upload";
    var uploadprogress = "#upload-progress";
    var percenttransferred = "#percent-transferred";
    var linkAddVideo = '';

    //show first item
    $(txtYoutubeUrl).blur(function () {
        displayVideoOnChange(this);
    });

    <%--End single Upload usercontrol--%>

   
</script>
<script type="text/javascript">
    
    $(document).ready(function () {
        //google.maps.event.trigger(null, 'resize');
        $("[data-toggle='popover']").popover({ trigger: "hover" });
        $('#<%=ddlCountry.ClientID%>').change(function () {
            codeAddress();
        });
        $('#<%=txtLandscapeCity.ClientID%>').change(function () {
            codeAddress();
        });
        $('#<%=txtLandscapeState.ClientID%>').change(function () {
            codeAddress();
        });
        $('#<%=txtLandscapeZipcode.ClientID%>').change(function () {
            codeAddress();
        });
    });

    function gotoStep3() {
        $("#step2").hide();
        $("#step3").show();
    }

    function checkAgreement(source, args) {
        var checked = $("#cbxAccept").is(":checked");
        if (checked) {
            args.IsValid = true;
        }
        else {
            args.IsValid = false;
        }
    }

    function registerUserStep2() {
        if ($("#btnFinishShare").attr("disabled") == true)
            return;

        if (!Page_ClientValidate('RegisterUserStep2')) {
            return false;
        }
        $("#step2 .checking").show();
        $("#step2").find("*").attr("disabled", "disabled");

        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: '2',
                fullName: $('#<%=txtFullName.ClientID%>').val(),
                email: $('#<%=txtEmail.ClientID%>').val(),
                phoneNumber: '',
                country: $('#<%=ddlCountry.ClientID%>').val(),
                landscapeCity: $('#<%=txtLandscapeCity.ClientID%>').val(),
                landscapeState: $('#<%=txtLandscapeState.ClientID%>').val(),
                landscapeZipcode: $('#<%=txtLandscapeZipcode.ClientID%>').val(),
                lat: $("#<%=hdnLat.ClientID%>").val(),
                lng: $("#<%=hdnLng.ClientID %>").val(),
                organizationName: $('#<%=txtOrganizationName.ClientID%>').val(),
                organizationDescription: $('#<%=txtOrganizationDescription.ClientID%>').val(),
                pollinatorType: $('#<%=ddlPollinatorType.ClientID%>').val(),
                pollinatorSize: $('#<%=ddlPollinatorSize.ClientID%>').val(),
                findOut: $('#<%=ddlFindOut.ClientID%>').val(),
                photoUrl: $('#<%=txtPhotoUrl.ClientID%>').val(),
                youtubeUrl: $('#<%=txtYoutubeUrl.ClientID%>').val(),
                userName: $('#<%=txtUserName.ClientID%>').val(),
                password: $('#<%=txtPassword.ClientID%>').val(),
                notCreateAccount: $('#cbxNotCreateAccount').is(":checked"),

            },
            dataType: "json",
            success: function (result) {
                gotoStep3();
            },
            error: function (xhr, status) {
                alert("An error occurred: " + status);
            }
        });
    }
</script>

<!-- Map  -->
<a href="#x" class="overlay" id="map_popup"></a>
<div id="mappopup" class="popup" style="width: 810px; height: 450px">
    <strong>
        <label id="lblPickLocation" style="color: #555; font-size: 14px">Find a location and check in</label>
    </strong>
    <div id="locationMapPopup" style="width: 780px; height: 335px"></div>
    <p style="text-align: center; padding: 10px 0">
        <a class="submit button btn24" style="min-width: 200px; color: #fff; font-size: 14px; font-family: Arial;" href="#x">OK</a>
    </p>
    <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static" />

</div>

<script type="text/javascript">

    var locationMapPopup = null;
    var locationMarkerPopup = null;

    var locationMapInline = null;
    var locationMarkerInline = null;
    var flag_open_map = 0;

    var infowindow = new google.maps.InfoWindow(
    {
        size: new google.maps.Size(150, 50)
    });

    // A function to create the marker and set up the event window function 
    function createMarker(latlng, locationMap, contentString) {
        var locationMarker = new google.maps.Marker({
            position: latlng,
            map: locationMap,
            zIndex: Math.round(latlng.lat() * -100000) << 5
        });

        //set position: lat, long
        var ctlLat = '<%=hdnLat.ClientID%>';
        var ctlLng = '<%=hdnLng.ClientID%>';
        document.getElementById(ctlLat).value = latlng.lat();
        document.getElementById(ctlLng).value = latlng.lng();

        google.maps.event.addListener(locationMarker, 'click', function () {
            infowindow.setContent(contentString);
            infowindow.open(locationMap, locationMarker);
        });

        return locationMarker;
    }

    function iisempty(x) {
        if (x !== "" && x !== " ")
            return true;
    }

    function getAddress() {
        //country
        var LandscapeCountry = $('#<%=ddlCountry.ClientID%>').find('option:selected').html();
        var LandscapeCountryValue = $('#<%=ddlCountry.ClientID%>').find('option:selected').val();
        var LandscapeCountryZipcode = $('#<%=txtLandscapeZipcode.ClientID%>').val();
        var LandscapeCity = $('#<%=txtLandscapeCity.ClientID%>').val();
        var LandscapeState = $('#<%=txtLandscapeState.ClientID%>').val();

        //build address string
        if (LandscapeCountryValue == 'NONE') {
            var addr = [LandscapeCity, " " + LandscapeState, " " + LandscapeCountryZipcode];
        }
        else {
            var addr = [LandscapeCity, " " + LandscapeState, " " + LandscapeCountryZipcode, " " + LandscapeCountry];
        }

        addr = addr.filter(iisempty);
        address = addr.join();
        return address;
    }

    function getInfoWinContent(gohere) {
        address = getAddress();

        var html = "";
        if (address == "") {
            html += "<h2 class=\"info-window-header\">This is your location!</h2><hr />";
        }
        html += "<div class='infowindows'>";
        if (address != "") {
            html += "<p>" + address + "</p>";
        }
        html += "</div>";

        if (gohere)
            html = html + '<ul class="callout-link-bottom"><li><a href="javascript:gohere(' + locationMapPopup + ',10)" style="color: #3764A0">Go here</a></li></ul>';

        return html;
    }

    function codeAddress(controlFocusID) {
        address = getAddress();
        if (flag_open_map != 0) {
            //set position: lat, long
            var ctlLat = '<%=hdnLat.ClientID%>';
            var ctlLng = '<%=hdnLng.ClientID%>';
            var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);

            locationMapPopup.setOptions({ center: coordinate });
            if (locationMarkerPopup) {
                locationMarkerPopup.setMap(null);
                locationMarkerPopup = null;
            }
            locationMarkerPopup = createMarker(coordinate, locationMapPopup, getInfoWinContent(true));

            if (locationMarkerInline) {
                locationMarkerInline.setMap(null);
                locationMarkerInline = null;
            }
            locationMarkerInline = createMarker(coordinate, locationMapInline, getInfoWinContent(false));
            locationMarkerInline.setIcon(rootServerPath + "Images/marker/icon-7.gif");
            locationMapInline.setOptions({ center: coordinate });

        } else if (address != "") {
            geocoder.geocode({ 'address': address }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    // console.log("pin by address");
                    locationMapPopup.setOptions({ center: results[0].geometry.location, zoom: 7 });
                    if (locationMarkerPopup) {
                        locationMarkerPopup.setMap(null);
                        locationMarkerPopup = null;
                    }
                    locationMarkerPopup = createMarker(results[0].geometry.location, locationMapPopup, getInfoWinContent(true));

                    if (locationMarkerInline) {
                        locationMarkerInline.setMap(null);
                        locationMarkerInline = null;
                    }
                    locationMarkerInline = createMarker(results[0].geometry.location, locationMapInline, getInfoWinContent(false));
                    locationMarkerInline.setIcon(rootServerPath + "Images/marker/icon-7.gif");
                    locationMapInline.setOptions({ center: results[0].geometry.location });
                } else {
                    alert('Location not found for "' + address + '". Please find your own pin on map.');
                }
            });
        }

        //set control forcus
        //   $('#HiddenControlFocus').val(controlFocusID);
    }

    function initializeMap() {
        // create the map popup              
        locationMapPopup = new google.maps.Map(document.getElementById("locationMapPopup"),
        {
            zoom: 3,
            center: new google.maps.LatLng(43.907787, -79.359741),
            mapTypeControl: true,
            mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
            navigationControl: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        locationMapInline = new google.maps.Map(document.getElementById("previewMapInline"),
        {
            zoom: 6,
            center: new google.maps.LatLng(43.907787, -79.359741),
            zoomControl: false,
            rotateControl: false,
            streetViewControl: false,
            navigationControl: false,
            scrollwheel: false,
            mapTypeControl: false
        });

        google.maps.event.addListener(locationMapPopup, 'click', function (event) {
            infowindow.close();

            flag_open_map = 1;

            var geocoder = new google.maps.Geocoder();
            geocoder.geocode({ 'latLng': new google.maps.LatLng(event.latLng.lat(), event.latLng.lng()) },
                function (results, status) {
                    if (status == google.maps.GeocoderStatus.ZERO_RESULTS || !results[0]) {
                        alert('Location is invalid!');
                    } else {
                        //call function to create marker
                        if (locationMarkerPopup) {
                            locationMarkerPopup.setMap(null);
                            locationMarkerPopup = null;
                        }
                        locationMarkerPopup = createMarker(event.latLng, locationMapPopup, getInfoWinContent(true));

                        if (locationMarkerInline) {
                            locationMarkerInline.setMap(null);
                            locationMarkerInline = null;
                        }
                        locationMarkerInline = createMarker(event.latLng, locationMapInline, getInfoWinContent(false));
                        locationMarkerInline.setIcon(rootServerPath + "Images/marker/icon-7.gif");
                        locationMapInline.setOptions({ center: event.latLng });
                    }
                });
        });
    }

    new google.maps.event.addDomListener(window, 'load', initializeMap);

    function gohere(locationMap, zoom) {
        //set position: lat, long
        var ctlLat = '<%= hdnLat.ClientID %>';
        var ctlLng = '<%=hdnLng.ClientID %>';
        var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);
        locationMap.setOptions({ center: coordinate, zoom: zoom });
    }

</script>
