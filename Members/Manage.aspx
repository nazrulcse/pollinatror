<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Manage.aspx.cs" Inherits="Members_Manage" %>
<%@ Register Src="~/Controls/UploadMultiFiles.ascx" TagName="Upload" TagPrefix="uc" %>
<%@ Register Src="~/Controls/UploadSinglePhoto.ascx" TagName="SinglePhoto" TagPrefix="uc" %>
<%@ Register Src="~/Controls/YoutubeSingleVideo.ascx" TagName="SingleYoutube" TagPrefix="yb" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>

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

    <script src="../Scripts/common.js" type="text/javascript"></script>
    <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/Content/Site.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />
    </noscript>
    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />


    <style type="text/css" media="screen">            
            form select
             {     
				-webkit-appearance: none;			
            }

        </style>
    <style type="text/css">
        #map_canvas {
            margin-top: 5px; margin-left: 0;margin-right: 20px; height: 420px;
            width: 1000px;
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
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">

        <%=Scripts.Render("~/js/skel.min.js")%>
        <%=Scripts.Render("~/Scripts/AjaxFileupload.js")%>   
    </asp:PlaceHolder>


    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            var Chrome = false;
            if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
                Chrome = true;
                $('.registerSelect').addClass('dropdownlist');
            }
            else if (navigator.userAgent.toLowerCase().indexOf('mozilla') > -1) {
                $('.registerSelect').addClass('dropdownlistFirefox');
            }

            //prevent user type into textbox
            $('#<%=txtPrePhotoUrl.ClientID %>, #<%=txtPreYoutubeUrl.ClientID %>').keypress(function (e) {
                e.preventDefault();
            });
            $('#<%=txtPrePhotoUrl.ClientID %>, #<%=txtPreYoutubeUrl.ClientID %>').keydown(function (e) {
                e.preventDefault();
            });

            $('#<%=txtPrePhotoUrl.ClientID %>').focusin(function (e) {
                $('#btnPhotos').focus();
            });
            $('#<%=txtPreYoutubeUrl.ClientID %>').focusin(function (e) {
                $('#btnVideos').focus();
            });

        });


        //User Yes to switch to premium form
        //select 
        function selectYes() {
            isClickClosePopup = true;
            var isOK = true;
            //copy Normal to Premium
            if ($('#<%=txtNorUserName.ClientID %>').val()!='') 
                $('#<%=txtPreUserName.ClientID %>').val($('#<%=txtNorUserName.ClientID %>').val());

            if ($('#<%=txtNorFirstName.ClientID %>').val() != '') 
                $('#<%=txtPreFirstName.ClientID %>').val($('#<%=txtNorFirstName.ClientID %>').val());

            if ($('#<%=txtNorLastName.ClientID %>').val() != '') 
                $('#<%=txtPreLastName.ClientID %>').val($('#<%=txtNorLastName.ClientID %>').val());

            if ($('#<%=txtNorPhoneNumber.ClientID %>').val() != '') 
                $('#<%=txtPrePhoneNumber.ClientID %>').val($('#<%=txtNorPhoneNumber.ClientID %>').val());

            if ($('#<%=txtNorEmail.ClientID %>').val() != '') 
                $('#<%=txtPreEmail.ClientID %>').val($('#<%=txtNorEmail.ClientID %>').val());

            if ($('#<%=txtNorOrganizationName.ClientID %>').val() != '') 
                $('#<%=txtPreOrganizationName.ClientID %>').val($('#<%=txtNorOrganizationName.ClientID %>').val());

            //size
            var pollinatorSize = $('#<%=ddlNorPollinatorSize.ClientID %>').find('option:selected').val();
            $('#<%=ddlPrePollinatorSize.ClientID %>').val(pollinatorSize);

            //type
            var pollinatorType = $('#<%=ddlNorPollinatorType.ClientID %>').find('option:selected').val();
            $('#<%=ddlPrePollinatorType.ClientID %>').val(pollinatorType);

            //country
            var country = $('#<%=ddlNorCountry.ClientID %>').find('option:selected').val();
            $('#<%=ddlNorCountry.ClientID %>').val(country);
           
            if ($('#<%=txtNorLandscapeStreet.ClientID %>').val() != '') 
                $('#<%=txtPreLandscapeStreet.ClientID %>').val($('#<%=txtNorLandscapeStreet.ClientID %>').val());

            if ($('#<%=txtNorLandscapeCity.ClientID %>').val() != '') 
                $('#<%=txtPreLandscapeCity.ClientID %>').val($('#<%=txtNorLandscapeCity.ClientID %>').val());

            if ($('#<%=txtNorLandscapeState.ClientID %>').val() != '') 
                $('#<%=txtPreLandscapeState.ClientID %>').val($('#<%=txtNorLandscapeState.ClientID %>').val());

            if ($('#<%=txtNorLandscapeZipcode.ClientID %>').val() != '') 
                $('#<%=txtPreLandscapeZipcode.ClientID %>').val($('#<%=txtNorLandscapeZipcode.ClientID %>').val());

            if ($('#<%=txtNorPhotoUrl.ClientID %>').val() != '') 
                $('#<%=txtPrePhotoUrl.ClientID %>').val($('#<%=txtNorPhotoUrl.ClientID %>').val());

            if ($('#<%=txtNorYoutubeUrl.ClientID %>').val() != '') 
                $('#<%=txtPreYoutubeUrl.ClientID %>').val($('#<%=txtNorYoutubeUrl.ClientID %>').val());

            //txtPrePosition to valid map
            $('#<%=txtPrePosition.ClientID %>').val($('#<%=txtPosition.ClientID %>').val());

            //ShowRegisterForm('premium');
            $('#<%=btnPreUpdate.ClientID %>').html('Upgrade');
            $('#<%=divRowRegPremium.ClientID %>').show();
            $('#<%=divRowRegNormal.ClientID %>').hide();
            $('#<%=txtPreFirstName.ClientID %>').focus();//set focus
            $('#<%=HiddenMemberLevel.ClientID %>').val(1);

            //VIDEO 
            SetVariablesOfUploadControl('1');

            //show first item
            displayImageOnChange('#<%=txtPrePhotoUrl.ClientID %>', true);

            displayVideoWithOutValidate('#<%=txtPreYoutubeUrl.ClientID %>', true);
            $(txtYoutubeUrl).change(function () {
                displayVideoOnChange(this);
            });
        }

        
    //Show thumbnail photo(only normal user form)
        function ShowImgThumnail(txtPhotoUrl, imgThumbnail) {
            alert('ShowImgThumnail');
            if (imgThumbnail=='') {
                imgThumbnail = '<%= imgPhoto.ClientID%>';
            }
            //alert('ShowImgThumnail:txtPhotoUrl=' + txtPhotoUrl + ';imgThumbnail=' + imgThumbnail);
            
         var rootServerPath = '<%=ResolveUrl("~")%>';
         var imgUrl = rootServerPath + $('#' + txtPhotoUrl).val();
         if ($('#' + txtPhotoUrl).val().toLowerCase().match("^http:") || $('#' + txtPhotoUrl).val().toLowerCase().match("^https:")) {
             imgUrl = $('#' + txtPhotoUrl).val();
         }
         if ($('#' + txtPhotoUrl).val() == '') {
             $('#' + imgThumbnail).css('display', 'none');
         }
         else if ($('#' + txtPhotoUrl).val().indexOf(';') >= 0) {
             imgUrl = imgUrl.split(';')[0];
             $('#' + imgThumbnail).css('display', 'block');
             $('#' + imgThumbnail).attr('src', imgUrl);
         }
         else {
             $('#' + imgThumbnail).css('display', 'block');
             $('#' + imgThumbnail).attr('src', imgUrl);
         }
    }

        //ChangePhotoMulti
        //function ChangePhotoMulti(txtPhotoMultiID, lblTotalPhotoMultiID) {
            
        //    alert('txtPhotoMultiID=' + txtPhotoMultiID);
        //    console.log('lblTotalPhotoMultiID=' + lblTotalPhotoMultiID);
        //    //set total photos to label lblTotalPhotoMulti
        //    var valUrl = $('#' + txtPhotoMultiID).val();
        //    if (valUrl.length == 0) {
        //        $('#' + lblTotalPhotoMultiID).val('(0 photo)');
        //    }
        //    else {
        //        var arrayUrl = valUrl.split(';');
        //        if (arrayUrl == 1) {
        //            $('#' + lblTotalPhotoMultiID).val('(1 photo)');
        //        }
        //        else {
        //            $('#' + lblTotalPhotoMultiID).val('(' + arrayUrl.length + ' photos)');
        //        }
        //    }
        //}
    
    </script>

    <script src= "<%= ResolveUrl("~/Scripts/placeholders.jquery.js") %>" type="text/javascript"></script>

    <div id="main-wrapper" style="margin-top: -42px;">
        <input id="HiddenControlFocus" value="0" type="hidden" />        
        <input runat="server" id="HiddenUploadUserFolder_Photo" value="" type="hidden" />        
        <input runat="server" id="HiddenUploadUserFolder_Video" value="" type="hidden" />
                
        <input runat="server" id="HiddenMemberLevel" value="0" type="hidden" />        
        <div class="container" style="width: 1050px;">
            <%--   <h2>User & Pollinator Information</h2>
            <p>
                <asp:HyperLink ID="BackLink" runat="server"
                    NavigateUrl="~/ShareMap">&lt;&lt; Back to share map</asp:HyperLink>
            </p>--%>
            <div style="width: 80%">

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
                <script type="text/javascript">
                    $(document).ready(function () {
                        $(".close").click(function () {
                            $(".alert").alert();
                        });
                    });
                </script>

            </div>
            <%--<div style="float:right; margin-right: 51px; z-index: 10"><a id="linkChangePassword" href="ChangePassword" style="cursor: pointer;color: #436A1B;" title="Click here to change your password" >Change Your Password</a></div>--%>
            <div class="row" runat="server" id="divRowRegNormal" style ="margin-top: 50px;">
                <div class="12u" style ="margin-left: -50px;">
                    <div style="width: 100%; text-align: center">
                        <span class="message-error" style="color: red; margin-left: 13px; margin-top: 10px;">
                            <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal></span>
                    </div>
                    <fieldset style="border: 1px #ccc solid;">
                        <legend>Personal Information</legend>

                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="60" class="text" ToolTip="First Name" placeholder="First Name" ID="txtNorFirstName" runat="server" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNorFirstName" runat="server" ControlToValidate="txtNorFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="CreateUserWizard1">First Name is required.</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revNorFirstName" ControlToValidate="txtNorFirstName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid First Name" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="60" class="text" ToolTip="Last Name" placeholder="Last Name" ID="txtNorLastName" runat="server"></asp:TextBox>
                                <%--<asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revNorLastName" ControlToValidate="txtNorLastName" runat="server" ValidationExpression="[^<>?|@#$%^]*" ErrorMessage="Invalid Last Name" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>--%>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="24" class="text" ToolTip="Phone Number" placeholder="Phone Number" ID="txtNorPhoneNumber" runat="server"></asp:TextBox>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtNorPhoneNumber" ID="revNorPhoneNumber" ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone Number." ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="256" TextMode="Email" class="text" ID="txtNorEmail" runat="server" ToolTip="Email Address" placeholder="Email Address" required></asp:TextBox><%--TextMode="Email"--%>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="txtNorEmailRequired" runat="server" ControlToValidate="txtNorEmail" ErrorMessage="Email Address is required." ToolTip="Email Address is required." ValidationGroup="CreateUserWizard1">Email Address is required.</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="regexNorEmailValid" ControlToValidate="txtNorEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="50" class="text" ToolTip="Username" placeholder="Username" ID="txtNorUserName" runat="server" style="background: #ccc;" disabled></asp:TextBox>
                            </div>
                            <div class="6u">
                                <asp:DropDownList ID="ddlNorPollinatorType" Width="100%" runat="server" CssClass="registerSelect" placeholder="Type of Pollinator Location">
                                    <asp:ListItem Value="NONE">Type of Pollinator Location</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNor5" runat="server" ControlToValidate="ddlNorPollinatorType" ErrorMessage="Select one type of Pollinator Location" ToolTip="Select one type of Pollinator Location" ValidationGroup="CreateUserWizard1">Select one type of Pollinator Location.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset style="border: 1px #ccc solid;">
                        <legend>Pollinator Information</legend>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox ID="txtNorOrganizationName" MaxLength="100"  runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                            </div>
                            <div class="6u">
                                <asp:DropDownList ID="ddlNorPollinatorSize"  Width="100%" runat="server" CssClass="registerSelect" placeholder="Size of Pollinator Location">
                                    <asp:ListItem Value="NONE">Size of Pollinator Location</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNor6" runat="server" ControlToValidate="ddlNorPollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="CreateUserWizard1"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="col-lg-12">
                                <asp:TextBox ID="txtOrganizationDescription"  runat="server" class="text" TextMode="MultiLine" Rows="5"  placeholder="Organization Description"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="100" ID="txtNorLandscapeStreet" runat="server" class="text" ToolTip="Landscape Street" placeholder="Landscape Street" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNorLandscapeStreet" runat="server" ControlToValidate="txtNorLandscapeStreet" ErrorMessage="Landscape Street is required." ToolTip="Landscape Street is required." ValidationGroup="CreateUserWizard1">Landscape Street is required.</asp:RequiredFieldValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtNorLandscapeCity" runat="server" class="text" ToolTip="Landscape City" placeholder="Landscape City" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNorLandscapeCity" runat="server" ControlToValidate="txtNorLandscapeCity" ErrorMessage="Landscape City is required." ToolTip="Landscape City is required." ValidationGroup="CreateUserWizard1">Landscape City is required.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtNorLandscapeState" runat="server" class="text" ToolTip="Landscape State" placeholder="Landscape State"></asp:TextBox>
                            </div>
                            <div class="6u" style="display: inline-flexbox;">
                                <div style="float: left; width: 49%">
                                    <asp:TextBox MaxLength="10" ID="txtNorLandscapeZipcode" runat="server" class="text" ToolTip="Landscape Zipcode" placeholder="Landscape Zipcode"></asp:TextBox>
                                    
                                </div>
                                <div style="float: right; width: 49%" title="Country">
                                    <asp:DropDownList ID="ddlNorCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                    </asp:DropDownList>
                                </div>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtNorLandscapeZipcode" ID="revNorLandscapeZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code." ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u" style="width: 100%">
                                <a style="font-size: 14px;" class="button btn36" id="showmap_popupNormal" href="#map_popup" onclick="codeAddress('normal', this.id)">Find location on map</a>
                                <asp:TextBox MaxLength="10" ID="txtPosition" TabIndex="100" runat="server" Style="height: 0px;width: 0px; margin-left: -16px; background-color: #ccc"></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RfvtxtPosition" runat="server" ControlToValidate="txtPosition" ErrorMessage="Please, click to preview and determine your location on map." ToolTip="Please, click to preview and determine your location on map." ValidationGroup="CreateUserWizard1"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <%--Normal: Upload Photo and Video onblur="ShowImgThumnail(this.id, 'MainContent_imgPhoto');"--%>
                        <div class="row half">
                            <div class="6u">
                                   <asp:TextBox MaxLength="255" ID="txtNorPhotoUrl"  runat="server" class="text" placeholder="Photo URL"></asp:TextBox>
                                   <img id="loading" src="../images/loading.gif" style="display: none;">
                                    <span id="validatorPhotoUrl" title="You can upload only files with the following extensions: jpg, jpeg, gif, png" class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                            </div>
                            <div class="6u">
                                 <asp:TextBox MaxLength="255" ID="txtNorYoutubeUrl" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                                    <img id="loadingVideo" src="../images/loading.gif" style="display: none;">
                                      <div class="during-upload" id="during-upload" style="display:none">
                                        <p><span id="percent-transferred" >Uploading</span></p>
                                        <p>
                                            <progress id="upload-progress" max="100" value="1" style="width:190px""></progress>
                                        </p>
                                      </div>
                                    <span id="validatorVideoUrl" title="You can upload only flv,mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files." class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:Label runat="server" id="numPhotoN" style="display: block; margin-top: -30px;margin-left: 2px;margin-bottom: 2px;">(0 photo)</asp:Label>
                                <a href="#Upload_formimage" id="btnPhotosN" onclick="openPopup();" class="btnUploadPhoto button btn36" style="font-size: 14px;">Photos</a>
                            </div>
                            <div class="6u">
                                <asp:Label runat="server" id="numVideoN" style="display: block; margin-top: -30px;margin-left: 2px;margin-bottom: 2px;">(0 video)</asp:Label>
                                <a href="#Upload_formvideo" id="btnVideosN" onclick="openPopup(); " class="button btn36" style="font-size: 14px;">Videos</a> 
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:Image ID="imgPhoto" BorderStyle="None" ImageUrl="" runat="server" CssClass="thumbnail2" />
                            </div>
                            <div class="6u" style="padding-bottom:5px">                                    
                                <div id="divVideoPlayer" style="display:none; margin-top:-20px;"></div>
                            </div>       
                        </div>
                        <%-- End normal upload  --%>
                    </fieldset>

                    <div style="width: 100%; align-items: center; text-align: center; margin-bottom: 19px;">
                        <a href="#showTermOfPremium_form" id="showTermOfPremium_popup" class="button btn36" style="margin-bottom: 27px; min-width: 300px; font-size: 17px ; font-weight: 700;margin-right: -17px;">Interested in Becoming a Bee Friendly Farmer?</a>
                    </div>

                </div>

                <div class="row" style="width: 100%; text-align: center">
                    <div class="12u" style="width: 100%; text-align: center">
                        <div class="6u" style="width: 100%; text-align: center">
                            <button id="btnUpdate" type="button" causesvalidation="True" validationgroup="CreateUserWizard1" class="submit button btn12" style="min-width: 300px; color: white; font-size: 23px;"
                                runat="server" onserverclick="btnUpdate_Click">
                                <span>Save</span>
                            </button>

                            <button id="Button2" type="button" class="button btn36" style="min-width: 300px; font-size: 23px; font-weight: 700;"
                                runat="server" onserverclick="btnCancel_Click">
                                <span>Cancel</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row" runat="server" id="divRowRegPremium" >
                <div class="12u" style="margin-left: -50px;margin-top: 0px;padding: 0px 0 0 50px;">

                    <div style="width: 100%; text-align: center">
                        <span class="message-error" style="color: red; margin-left: 13px; margin-top: 10px;">
                            <asp:Literal ID="PreErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                        </span>
                    </div>

                    <fieldset style="border: 1px #ccc solid;">
                        <legend>General Information</legend>

                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="60" class="text" ToolTip="First Name" placeholder="First Name" ID="txtPreFirstName" runat="server" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreFirstName" runat="server" ControlToValidate="txtPreFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="CreateUserWizard2">First Name is required.</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RegularExpressionValidator6" ControlToValidate="txtPreFirstName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid First Name" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="60" class="text" ToolTip="Last Name" placeholder="Last Name" ID="txtPreLastName" runat="server"></asp:TextBox>
                                <%--<asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RegularExpressionValidator8" ControlToValidate="txtPreLastName" runat="server" ValidationExpression="[^<>?|@#$%^]*" ErrorMessage="Invalid Last Name" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>--%>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="100" ID="txtPreOrganizationName" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="255" ID="txtPreWebsite" runat="server" class="text" ToolTip="Website" placeholder="Website"></asp:TextBox>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revWebsite" ControlToValidate="txtPreWebsite" runat="server" ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Invalid URL" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="24" class="text" ToolTip="Phone Number" placeholder="Phone Number" ID="txtPrePhoneNumber" runat="server"></asp:TextBox>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPrePhoneNumber" ID="RegularExpressionValidator3" ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone Number." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="256" class="text" ID="txtPreEmail" runat="server" ToolTip="Email Address" placeholder="Email Address" TextMode="Email" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="EmailRequired" runat="server" ControlToValidate="txtPreEmail" ErrorMessage="Email Address is required." ToolTip="Email Address is required." ValidationGroup="CreateUserWizard2">Email Address is required.</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="regexEmailValid" ControlToValidate="txtPreEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>

                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="50" class="text" ToolTip="Username" placeholder="Username" ID="txtPreUserName" runat="server" style="background: #ccc;"  disabled></asp:TextBox>
                            </div>
                            <div class="6u">
                                <asp:DropDownList ID="ddlPrePollinatorType" Width="100%" runat="server" CssClass="registerSelect" placeholder="Type of Pollinator Location">
                                    <asp:ListItem Value="NONE">Type of Pollinator Location</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPre5" runat="server" ControlToValidate="ddlPrePollinatorType" ErrorMessage="Select one type of Pollinator Location" ToolTip="Select one type of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one type of Pollinator Location.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u" style="width: 100%;">
                                <h3>Organization Description</h3>
                                <asp:TextBox ID="txtPreDescription" runat="server" class="text" TextMode="MultiLine" Rows="5"></asp:TextBox>
                            </div>
                        </div>
                        <%--Premium: Upload Photo and Video--%>
                        <div class="row half" >
                            <div class="6u">
                                <asp:TextBox MaxLength="255" ID="txtPrePhotoUrl" TabIndex="-1" style="background: #ccc; " runat="server" class="text" ToolTip="Photo URL" placeholder="Photo URL" ></asp:TextBox>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="255" ID="txtPreYoutubeUrl"   TabIndex="-1" style="background: #ccc; " runat="server" class="text" ToolTip="Youtube URL" placeholder="Youtube URL"></asp:TextBox>
                                 <img id="loadingVideoP" src="../images/loading.gif" style="display: none;">
                                  <span id="validatorVideoUrlP"  class="message-error" style="display: none;"></span>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:Label runat="server" id="numPhoto" style="display: block; margin-top: -30px;margin-left: 2px;margin-bottom: 2px;">(0 photo)</asp:Label>
                                <a href="#Upload_formimage" id="btnPhotos" onclick="openPopup();" class="btnUploadPhoto button btn36" style="font-size: 14px;">Photos</a>
                            </div>
                            <div class="6u">
                                <asp:Label runat="server" id="numVideo" style="display: block; margin-top: -30px;margin-left: 2px;margin-bottom: 2px;">(0 video)</asp:Label>
                                <a href="#Upload_formvideo" id="btnVideos" onclick="openPopup(); " class="button btn36" style="font-size: 14px;">Videos</a> 
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u" style="padding-bottom:5px">                                    
                                    <asp:Image ID="imgPhotoP" ImageUrl="#" runat="server" CssClass="thumbnail2" />
                             </div>
                            <div class="6u" style="padding-bottom:5px">                                    
                                <div id="divPreVideoPlayer" style="display: block; margin-top: -20px;"></div>
                            </div>     
                        </div>

                    </fieldset>

                    <fieldset style="border: 1px #ccc solid; margin-bottom: 2px;">
                        <legend>Pollinator Information</legend>
                        <div class="row half">
                          <%--  <div class="6u">
                                <asp:TextBox ID="txtPreOrganizationName_PollinatorLocation" MaxLength="100" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                            </div>--%>
                            <div class="6u" style="width:100%">
                                <asp:DropDownList ID="ddlPrePollinatorSize" Width="100%" runat="server" CssClass="registerSelect" placeholder="Size of Pollinator Location">
                                    <asp:ListItem Value="NONE">Size of Pollinator Location</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPre6" runat="server" ControlToValidate="ddlPrePollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one Size of Pollinator Location.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="100" ID="txtPreLandscapeStreet" runat="server" class="text" ToolTip="Address" placeholder="Address" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreLandscapeStreet" runat="server" ControlToValidate="txtPreLandscapeStreet" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="CreateUserWizard2">Address is required.</asp:RequiredFieldValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtPreLandscapeCity" runat="server" class="text" ToolTip="City" placeholder="City" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreLandscapeCity" runat="server" ControlToValidate="txtPreLandscapeCity" ErrorMessage="City is required." ToolTip="City is required." ValidationGroup="CreateUserWizard2">City is required.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtPreLandscapeState" runat="server" class="text" ToolTip="State" placeholder="State"></asp:TextBox>
                            </div>
                            <div class="6u" style="display: inline-flexbox;">
                                <div style="float: left; width: 49%">
                                    <asp:TextBox MaxLength="10" ID="txtPreLandscapeZipcode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code/Country Code"></asp:TextBox>
                                    
                                </div>
                                <div style="float: right; width: 49%" title="Country">
                                    <asp:DropDownList ID="ddlPreCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                    </asp:DropDownList>
                                </div>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPreLandscapeZipcode" ID="revLandscapeZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zip Code/Country Code." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u" style="width: 100%; font-size: 14px">
                                <input type="checkbox" id="cbxUseAsBillingAddress" onclick="Check_cbxUseAsBillingAddress('MainContent_');" title="Check on to copy Information at bellow section to Billing Address setion">
                                <label for="cbxUseAsBillingAddress" style="display: inline">Use as Billing Address</label>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u" style="width: 100%">
                                <a style="font-size: 14px;" class="button btn36" id="showmap_popup" href="#map_popup" onclick="codeAddress('premium', this.id)">Find location on map</a>
                                <asp:TextBox MaxLength="10" ID="txtPrePosition" TabIndex="100" runat="server" Style="height: 0px;width: 0px; margin-left: -16px; background-color: #ccc"></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvtxtPrePosition" runat="server" ControlToValidate="txtPrePosition" ErrorMessage="Please, click to preview and determine your location on map." ToolTip="Please, click to preview and determine your location on map." ValidationGroup="CreateUserWizard2"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div style="width: 100%; margin-bottom: -25px;">
                                <h3>Billing Address</h3>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="100" ID="txtPreBillingAddress" runat="server" class="text" ToolTip="Address" placeholder="Address" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreBillingAddress" runat="server" ControlToValidate="txtPreBillingAddress" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="CreateUserWizard2">Address is required.</asp:RequiredFieldValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtPreBillingCity" runat="server" class="text" ToolTip="City" placeholder="City" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreBillingCity" runat="server" ControlToValidate="txtPreBillingCity" ErrorMessage="City is required." ToolTip="City is required." ValidationGroup="CreateUserWizard2">City is required.</asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row half">
                            <div class="6u">
                                <asp:TextBox MaxLength="30" ID="txtPreBillingState" runat="server" class="text" ToolTip="State" placeholder="State" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreBillingState" runat="server" ControlToValidate="txtPreBillingState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="CreateUserWizard2">State is required.</asp:RequiredFieldValidator>
                            </div>
                            <div class="6u">
                                <asp:TextBox MaxLength="10" ID="txtPreBillingZipcode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code" required></asp:TextBox>
                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreBillingZipcode" runat="server" ControlToValidate="txtPreBillingZipcode" ErrorMessage="Zip Code is required." ToolTip="Zip Code is required." ValidationGroup="CreateUserWizard2">Zip Code is required.</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPreBillingZipcode" ID="RegularExpressionValidator5" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zipcode" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                 
                    </fieldset>
                </div>
                <div class="row" style="width: 100%; text-align: center">
                <div class="12u" style="width: 100%; text-align: center">
                    <div class="6u" style="width: 100%; text-align: center">

                        <button id="btnPreUpdate" type="button" causesvalidation="True" ValidationGroup="CreateUserWizard2"  class="submit button btn12" style="min-width: 300px; color: white; font-size: 23px;"
                            runat="server" onserverclick="btnUpdate_Click">Save</button>

                        <button id="btnCancel" type="button" causesvalidation="true"  class="submit button btn36" style="min-width: 300px; font-size: 23px; font-weight:700"
                            runat="server" onserverclick="btnCancel_Click">
                            <span>Cancel</span>
                        </button>
                    </div>
                </div>
            </div>
            </div>

            
        </div>

        <%--<a id="MainContent_HyperLink123" href="http://demo.evizi.com:8088/Paypal?userID=6db7e60f-d43d-4827-a735-7bfe1fc4d8f5" target="_parent">HyperLink</a>--%>

        <%--popup Update successfull--%>
        <a class="submit button btn12" href="#confirm_form" id="confirm_pop" style="display: none">Confirm Information</a>
        <a href="#x" class="overlay" id="confirm_form"></a>
        <div class="popup">
            <div class="row">
                <div class="12u" align="center">
                    <img border="0" alt="" src="http://www.pollinator.org/Images/SHARE/SHARElogoTextFINAL.jpg">
                </div>
            </div>
            <div class="row">
                <div class="12u" align="center">
                    <h3>Update successful</h3>
                </div>
            </div>
            <div class="row">
                <div class="12u" align="center">
                    <asp:HyperLink runat="server" NavigateUrl="~/Members/Manage" ID="linkReturnToMap" CssClass="submit button btn12" Text="Return To Map">OK</asp:HyperLink>
                </div>
            </div>
            <a class="popup-close" href="#close"></a>
        </div>

        <%--Show process bar such as while redirect to paypal page--%>
        <a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
        <a href="#x" class="overlay" id="Processbar_form"></a>
        <div class="popup" style="height:auto;  background:none; border:none">
          <div style="width:auto; text-align:center">
            <p style="color: white; margin-bottom: 0px;z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
          </div>
         <%-- <a class="popup-close" href="#close"></a>--%>
        </div>



        <!--Vinh-->
        <a href="#x" class="overlay" id="showTermOfPremium_form"></a>
        <div class="popup" style="height: auto">
            <div class="row">
                <div class="12u" align="center">
                    <img border="0" style="max-height: 175px" alt="" src="../Images/logo/Bee-Friendly-Farmer-Logo.png">
                </div>
            </div>
            <div class="row">
                <div class="12u" style="text-align: justify">
                    <h3 style="text-align: center; margin-bottom: 25px; margin-top: -37px;">Would you like to make your SHARE site Bee Friendly Farmer Certified?</h3>
                    <p>
                        With a donation of $35 USD annual certification fee is tax-deductible for U.S. participants. If you are Canadian, be 
sure to read the Tax-Related Information for Canadians document. Your generous contribution 
will be used to help cost-share efforts by growers to plant additional bee forage. 
Visit <a style="color: blue; cursor: pointer" href="http://pfspbees.org/" target="_blank">http://pfspbees.org/</a> to learn more.
                    </p>
                </div>
            </div>
            <div>
                <div class="12u" style="text-align: center; margin-top: -56px; margin-bottom: -30px; margin-left: 3%;">
                    <div class="6u" style="width: 100%; font-size: 14px;">
                        <a id="btnOK" href="#close" class="submit button btn12" style="font-family: Verdana; color: white; font-size: 14px" onclick="selectYes();">Yes, I agree</a>
                        <a id="btnNotOK" href="#close" class="submit button btn12" style="font-family: Verdana; color: white; font-size: 14px; margin: 28px;">No, thanks!</a>
                    </div>
                </div>
            </div>
            <a class="popup-close" href="#close"></a>
        </div>

        <%--Script support for Upload control--%>
         <script type="text/javascript">
             var txtPhotoUrl = '';
             var imgPhoto = '';
             var linAddPhoto = '';;
             var fileToUploadID = '';
             var dontDeletePreImage = '';
             var validatorInputPhotoUrl = '';
             //Upload single video
             var txtYoutubeUrl = '';
             var validatorInputVideoUrl = '';

             //photo
             var loadingImage;

             //video
             var loadingVideo = '';
             var divVideoPlayer = '';
             var duringupload = '';
             var uploadprogress = '';
             var percenttransferred = '';
             var numPhoto;
             var numVideo;
             var linAddVideo = '';

             function SetVariablesOfUploadControl(isPremiumType) {
                 if (isPremiumType == '0') {//Normal
                     //photo
                     loadingImage = '#loading';
                     txtPhotoUrl = '#<%=txtNorPhotoUrl.ClientID %>';
                     imgPhoto = '<%=imgPhoto.ClientID %>';
                     linAddPhoto = '';
                     fileToUploadID = '';
                     dontDeletePreImage = '<%=dontDeletePreImage.ClientID %>';
                     validatorInputPhotoUrl = '#validatorPhotoUrl';
                     loadingImage = '#loading';

                     //onchange
                     $(txtPhotoUrl).change(function () {
                         displayImageOnChange(this, false);
                     });

                     //video
                     txtYoutubeUrl = '#<%=txtNorYoutubeUrl.ClientID%>';
                     validatorInputVideoUrl = '#validatorVideoUrl';
                     divVideoPlayer = '#divVideoPlayer';
                     loadingVideo = '#loadingVideo';

                     loadingVideo = '#loadingVideo';
                     divVideoPlayer = '#divVideoPlayer';
                     duringupload = "#during-upload";
                     uploadprogress = "#upload-progress";
                     percenttransferred = "#percent-transferred";

                     linAddVideo = '';

                     //change textbox
                     $(txtYoutubeUrl).blur(function () {
                         displayVideoOnChange(this, false);
                     });
                 }
                 else {//Premium
                     // photo
                     txtPhotoUrl = '#<%=txtPrePhotoUrl.ClientID %>';
                     imgPhoto = '<%=imgPhotoP.ClientID %>';
                     validatorInputPhotoUrl = '#validatorPhotoUrlP';
                     numPhoto = '#<%=numPhoto.ClientID%>';

                     //onchange photo
                     $(txtPhotoUrl).change(function () {
                         displayImageOnChange(this, true);
                     });

                     //video
                     txtYoutubeUrl = '#<%=txtPreYoutubeUrl.ClientID%>';
                     validatorInputVideoUrl = '#validatorVideoUrlP';
                     divVideoPlayer = '#divPreVideoPlayer';
                     loadingVideo = '#loadingVideoP';
                     numVideo = '#<%=numVideo.ClientID%>';
                     linAddVideo = '';

                     //on blur video
                     $(txtYoutubeUrl).blur(function () {
                         displayVideoOnChange(this, true);
                     });

                 }
             }

        </script>


        <input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
        <yb:SingleYoutube runat="server" ID="SingleYoutube"  />
        <uc:SinglePhoto runat="server" ID="SinglePhoto"  />
        <uc:Upload runat="server" ID="mulUploadImage"  />
        <uc:Upload runat="server" ID="mulUploadVideo" FileType="video" />

         <!-- DUY:popup locat map -->
    <a href="#x" class="overlay" id="map_popup"></a>
    <div id="mappopup" class="popup" style="width: 810px; height: 450px;">

        <strong><label  ID="lblPickLocation" style="color: #555; font-size: 14px">Find a location and check in</label> </strong>
        <div id="locationmap-canvas" style="width: 780px; height: 335px"></div> 
        <input type="hidden" id="lat" name="lat" value="" />
        <input type="hidden" id="lng" name="lng" value="" />
        <p style="text-align: center; padding: 10px 0"><a class="submit button btn24" onclick="setFocusByControl('');" style="min-width: 200px; color: #fff; font-size: 14px; font-family: Arial;" href="#x">OK</a></p>
        <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static"   />
        <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static" />
        <a href="#close" class="popup-close" onclick="setFocusByControl('');"></a>
    </div>
        
     <script type="text/javascript">
             //Disable auto close popup when clickshowProcessbar
             $('#Processbar_form').on('click', function (e) {
                 e.preventDefault();
             });
             $('#confirm_form').on('click', function (e) {
                 e.preventDefault();
             });

            //Vinh add action set focus after close popup 
             function setFocusByControl(idControl) {
                 if (idControl == '' || idControl == 'undefined') {
                     idControl = $('#HiddenControlFocus').val();
                 }
                 $('#' + idControl).focus();
             }
    </script>

         <script type="text/javascript">
             var premium = "normal";
             // global "map" variable
             var locationmap = null;
             var locationmarker = null;
             var geocoder;

             var subPrefixNormal = 'MainContent_';
             var subPrefixPremium = 'MainContent_';


             var infowindow = new google.maps.InfoWindow(
               {
                   size: new google.maps.Size(150, 50)
               });

             // A function to create the marker and set up the event window function 
             function createMarker(latlng, name, html, userType) {
                 if (latlng=='') {
                     alert('Please type a valid address before click "Find location on map"');
                 }
                 var contentString = html;
                 var locationmarker = new google.maps.Marker({
                     position: latlng,
                     map: locationmap,
                     zIndex: Math.round(latlng.lat() * -100000) << 5
                 });

                 //set position: lat, long
                var ctlLat = '<%= hdnLat.ClientID %>';
                var ctlLng = '<%=hdnLng.ClientID %>';
                document.getElementById(ctlLat).value = latlng.lat();
                document.getElementById(ctlLng).value = latlng.lng();

            if (userType == 'premium') {
                $('#' + subPrefixPremium + 'txtPrePosition').val(latlng.lat());
                $("#" + subPrefixPremium + 'RfvtxtPrePosition').css("display", "none");
            }
            else {
                $('#' + subPrefixNormal + 'txtPosition').val(latlng.lat());
                $('#' + subPrefixNormal + 'RfvtxtPosition').css("display", "none");
            }

            google.maps.event.addListener(locationmarker, 'click', function () {
                infowindow.setContent(contentString);
                infowindow.open(locationmap, locationmarker);
            });


            google.maps.event.trigger(locationmarker, 'click');
            return locationmarker;
        }

        function iisempty(x) {
            if (x !== "" && x !== " ")
                return true;
        }

        function codeAddress(userType, controlFocusID) {
            premium = userType;
            var subPrefix = subPrefixNormal + 'txtNor';
            if (userType == 'premium') {
                subPrefix = subPrefixPremium + 'txtPre';
            }

            var OrganizationName = $("#" + subPrefix + "OrganizationName").val();
            var LandscapeStreet = $("#" + subPrefix + "LandscapeStreet").val();
            var LandscapeCity = $("#" + subPrefix + "LandscapeCity").val();
            var LandscapeState = $("#" + subPrefix + "LandscapeState").val();

            var addr = [" " + LandscapeStreet, " " + LandscapeCity, " " + LandscapeState];
            addr = addr.filter(iisempty);
            var address = addr.join();

            var html = "<div class='infowindows'>";
            if (OrganizationName != "") {
                html += "<h2>" + OrganizationName.replace(/(<([^>]+)>)/ig, "") + "</h2><hr />";
            }
            if (address != "") {
                html += "<p>" + address.replace(/(<([^>]+)>)/ig, "") + "</p>";
            }
            if (OrganizationName == "" && address == "") {
                html += "<h2>This is your location!</h2><hr />";
            }
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';
            html += "</div>";

            var ctlLat = '#<%=hdnLat.ClientID %>';
            var ctlLng = '#<%=hdnLng.ClientID %>';
            var lat = $(ctlLat).val();
            var lng = $(ctlLng).val();

            if (lat != "" && lng != "") {
                var location = new google.maps.LatLng(lat, lng);
                locationmap.setCenter(location);

                if (locationmarker) {
                    locationmarker.setMap(null);
                    locationmarker = null;
                }
                locationmarker = createMarker(location, "pollinator", html);
                console.log("ADDR1:" + addr);
            } else {
                if (addr == '') {
                    addr = address;
                }
                console.log("ADDR2:" + addr);
                geocoder.geocode({ 'address': addr }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        locationmap.setCenter(results[0].geometry.location);

                        if (locationmarker) {
                            locationmarker.setMap(null);
                            locationmarker = null;
                        }
                        locationmarker = createMarker(results[0].geometry.location, "pollinator", html);
                    } else {
                        console.log('Geocode was not successful for the following reason: ' + status);
                    }
                });

            }

            //set control forcus
            $('#HiddenControlFocus').val(controlFocusID);
        }

        function initialize2() {
            // create the map
            var myOptions = {
                zoom: 3,
                center: new google.maps.LatLng(43.907787, -79.359741),
                mapTypeControl: true,
                mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
                navigationControl: true,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            geocoder = new google.maps.Geocoder();

            locationmap = new google.maps.Map(document.getElementById("locationmap-canvas"),
                                          myOptions);

            google.maps.event.addListener(locationmap, 'click', function () {
                infowindow.close();
            });


            google.maps.event.addListener(locationmap, 'click', function (event) {

                var subPrefix = subPrefixNormal + 'txtNor';
                if (premium == 'premium') {
                    subPrefix = subPrefixPremium + 'txtPre';
                }
                var OrganizationName = $("#" + subPrefix + "OrganizationName").val();
                var LandscapeStreet = $("#" + subPrefix + "LandscapeStreet").val();
                var LandscapeCity = $("#" + subPrefix + "LandscapeCity").val();
                var LandscapeState = $("#" + subPrefix + "LandscapeState").val();

                var addr = [" " + LandscapeStreet, " " + LandscapeCity, " " + LandscapeState];
                addr = addr.filter(iisempty);
                address = addr.join();

                var html = "<div class='infowindows'>";
                if (OrganizationName != "") {
                    html += "<h2>" + OrganizationName.replace(/(<([^>]+)>)/ig, "") + "</h2><hr />";
                }
                if (address != "") {
                    html += "<p>" + address.replace(/(<([^>]+)>)/ig, "") + "</p>";
                }
                if (OrganizationName == "" && address == "") {
                    html += "<h2>This is your location!</h2><hr />";
                }
                html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';
                html += "</div>";


                var geolocation = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());

                var geocoder = new google.maps.Geocoder();

                geocoder.geocode({ 'latLng': geolocation }, function (results, status) {

                    if (status == google.maps.GeocoderStatus.ZERO_RESULTS || !results[0]) {
                        alert('It is a sea');
                    } else {
                        //call function to create marker
                        if (locationmarker) {
                            locationmarker.setMap(null);
                            locationmarker = null;
                        }
                        locationmarker = createMarker(event.latLng, "pollinator", html);
                    }
                });
            });

        }

        function gohere() {

            //set position: lat, long
            var ctlLat = '<%=hdnLat.ClientID %>';
            var ctlLng = '<%=hdnLng.ClientID %>';
            var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);
            locationmap.setOptions({ center: coordinate, zoom: 10 });
        }

        new google.maps.event.addDomListener(window, 'load', initialize2);
    </script>

       
</asp:Content>


   