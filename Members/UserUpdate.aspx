<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="UserUpdate.aspx.cs" Inherits="Members_UserUpdate" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">



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
      <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />

    </noscript>

    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

    <asp:PlaceHolder ID="PlaceHolder3" runat="server">

        <%=Scripts.Render("~/js/skel.min.js") %>
        <%=Scripts.Render("~/Scripts/AjaxFileupload.js") %>   
    </asp:PlaceHolder>



    <script src="Scripts/common.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            var Chrome = false;
            if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
                Chrome = true;
                $('select').addClass('dropdownlist');
            }
        });

    </script>

  

    <script type="text/javascript">

        function fileUpload(txtphotoUrlID, imgPhoto, imgLoading, fileToUploadID) {
            var rootServerPath = '<%=ResolveUrl("~")%>';
            ajaxFileUpload(rootServerPath, txtphotoUrlID, imgLoading, fileToUploadID);

            setTimeout(function () {
                var imgUrl = rootServerPath + $('#' + txtphotoUrlID).val();
                $('#' + imgPhoto).attr('src', imgUrl);
            }, 1000); // how l

        }

        function Check_cbxUseAsBillingAddress() {

            var txtLandscapeStreet = '#<%=txtLandscapeStreet.ClientID %>';
            var txtLandscapeCity = '#<%= txtLandscapeCity.ClientID %>';
            var txtLandscapeState = '#<%= txtLandscapeState.ClientID %>';
            var txtLandscapeZipcode = '#<%= txtLandscapeZipcode.ClientID %>';

            var txtBillingAddress = '#<%= txtBillingAddress.ClientID %>';
            var txtBillingCity = '#<%= txtBillingCity.ClientID %>';
            var txtBillingState = '#<%= txtBillingState.ClientID %>';
            var txtBillingZipcode = '#<%= txtBillingZipcode.ClientID %>';

            if ($('#cbxUseAsBillingAddress').prop('checked')) {

                $(txtBillingAddress).val($(txtLandscapeStreet).val());
                $(txtBillingCity).val($(txtLandscapeCity).val());
                $(txtBillingState).val($(txtLandscapeState).val());
                $(txtBillingZipcode).val($(txtLandscapeZipcode).val());


            } else {


            }
        }

    </script>

    <div id="main-wrapper">
        <div class="container" style="width: 1050px;">
            <h2>User & Pollinator Information</h2>
            <p>
                <asp:HyperLink ID="BackLink" runat="server"
                    NavigateUrl="~/ShareMap.aspx">&lt;&lt; Back to share map</asp:HyperLink>
            </p>
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
            <%--<div class="row" id="divRowRegPremium" style="margin-top:20px; margin-bottom: 20px; margin-right: 20px;" runat="server">--%>
            <fieldset>
                <legend>General Information</legend>

                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="60" class="text" ToolTip="First Name" placeholder="First Name" ID="txtFirstName" runat="server" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="CreateUserWizard2">First Name is required.</asp:RequiredFieldValidator>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="60" class="text" ToolTip="Last Name" placeholder="Last Name" ID="txtLastName" runat="server" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last Name is required." ToolTip="Last Name is required." ValidationGroup="CreateUserWizard2">Last Name is required.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="100" ID="txtOrganizationName" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="255" ID="txtWebsite" runat="server" class="text" ToolTip="Website" placeholder="Website"></asp:TextBox>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="24" class="text" ToolTip="Phone Number" placeholder="Phone Number" ID="txtPhoneNumber" runat="server"></asp:TextBox>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="256" class="text" ID="txtEmail" runat="server" ToolTip="Email Address, example: me@example.com" placeholder="Email Address, example: me@example.com" TextMode="Email" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="EmailRequired" runat="server" ControlToValidate="txtEmail" ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="CreateUserWizard2">E-mail is required.</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format, Example: me@example.com" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                    </div>
                </div>
                <%--   <div class="row half">
                    <div class="6u" style="width: 100%">
                        <asp:TextBox MaxLength="50" class="text" ToolTip="Username" placeholder="Username" ID="txtUserName" runat="server" onchange="CheckExistUserName(this.id, 'lblUserAvailabilityPremium');" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="UserNameRequired" runat="server" ControlToValidate="txtUserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="CreateUserWizard2">User Name is required.</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtUserName" ID="RegularExpressionValidator1" ValidationExpression="^[a-zA-Z0-9]{2,}$" runat="server" ErrorMessage="Minimum 2 characters required." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                    </div>
                    <div id="lblUserAvailabilityPremium"></div>
                </div>--%>

                <div class="row half">
                    <div class="6u" style="width: 100%">
                        <asp:DropDownList ID="ddlPollinatorType" Width="100%" runat="server" placeholder="Type of Pollinator Location">
                            <asp:ListItem Value="NONE">Type of Pollinator Location</asp:ListItem>
                            <asp:ListItem Value="1">Home Garden</asp:ListItem>
                            <asp:ListItem Value="2">School</asp:ListItem>
                            <asp:ListItem Value="3">Farm</asp:ListItem>
                            <asp:ListItem Value="4">Government</asp:ListItem>
                            <asp:ListItem Value="5">Rights of Way (ROW)</asp:ListItem>
                            <asp:ListItem Value="6">Church</asp:ListItem>
                            <asp:ListItem Value="7">Corporation</asp:ListItem>
                            <asp:ListItem Value="8">Nonprofit</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlPollinatorType" ErrorMessage="Select one type of Pollinator Location" ToolTip="Select one type of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one type of Pollinator Location.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u" style="width: 100%;">
                        <h4>Organization Description <a href="#" class="fa fa-question-circle solo"><span>Question</span></a></h4>
                        <asp:TextBox ID="txtDescription" runat="server" class="text" TextMode="MultiLine" Rows="5"></asp:TextBox>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="255" ID="txtPhotoUrl" runat="server" class="text" ToolTip="Photo URL" placeholder="Photo URL"></asp:TextBox>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="255" ID="txtYoutubeUrl" runat="server" class="text" ToolTip="Youtube URL" placeholder="Youtube URL"></asp:TextBox>

                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <label class="file-upload">
                            <a class="button btn36" style="width: 130px; font-size: 12px;">Add Photo</a>
                            <img id="loadingPremium" src="../images/loading.gif" style="display: none;">
                            <asp:FileUpload ID="fileToUploadPremium" runat="server" ClientIDMode="Static" onchange="javascript:return fileUpload('MainContent_txtPhotoUrl', 'MainContent_imgPhotoP','loadingPremium', 'fileToUploadPremium');" />
                        </label>

                    </div>
                    <div class="6u"><a href="#" class="button btn36" style="width: 130px; font-size: 12px;">Add Video</a> </div>
                </div>

                <div class="row half">

                    <div class="6u">
                        <asp:Image ID="imgPhotoP" ImageUrl="#" runat="server" CssClass="thumbnail2" />
                    </div>
                </div>

            </fieldset>
            <fieldset style="margin-bottom: 4px;">
                <legend>Pollinator Location</legend>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox ID="txtOrganizationNamePollinatorLocation" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                        <%--<asp:RequiredFieldValidator Display = "Dynamic" CssClass="message-error" SetFocusOnError="true"  ID="RequiredFieldValidatorOrganizationName" runat="server" ControlToValidate="txtOrganizationName" ErrorMessage="Organization Name is required." ToolTip="Organization Name is required." ValidationGroup="CreateUserWizard2">*</asp:RequiredFieldValidator>--%>
                    </div>
                    <div class="6u">
                        <asp:DropDownList ID="ddlPollinatorSize" Width="100%" runat="server" placeholder="Size of Pollinator Location">
                            <asp:ListItem Value="NONE">Size of Pollinator Location</asp:ListItem>
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
                        <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlPollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one Size of Pollinator Location.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="100" ID="txtLandscapeStreet" runat="server" class="text" ToolTip="Address" placeholder="Address" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorLandscapeStreet" runat="server" ControlToValidate="txtLandscapeStreet" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="CreateUserWizard2">Address is required.</asp:RequiredFieldValidator>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="30" ID="txtLandscapeCity" runat="server" class="text" ToolTip="City" placeholder="City" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorLandscapeCity" runat="server" ControlToValidate="txtLandscapeCity" ErrorMessage="City is required." ToolTip="City is required." ValidationGroup="CreateUserWizard2">City is required.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="30" ID="txtLandscapeState" runat="server" class="text" ToolTip="State" placeholder="State" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorLandscapeState" runat="server" ControlToValidate="txtLandscapeState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="CreateUserWizard2">State is required.</asp:RequiredFieldValidator>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="10" ID="txtLandscapeZipcode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorLandscapeZipcode" runat="server" ControlToValidate="txtLandscapeZipcode" ErrorMessage="Zipcode is required." ToolTip="Zipcode is required." ValidationGroup="CreateUserWizard2">Zipcode is required.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div>
                    <div class="6u" style="width: 100%; font-weight: bold;">
                        <input type="checkbox" id="cbxUseAsBillingAddress" onclick="Check_cbxUseAsBillingAddress();" title="Check on to copy Information at bellow section to Billing Address setion">
                        <label for="cbxUseAsBillingAddress" style="display: inline">Use as Billing Address</label>
                        <h4>Billing Address</h4>

                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="100" ID="txtBillingAddress" runat="server" class="text" ToolTip="Address" placeholder="Address" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtBillingAddress" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="CreateUserWizard2">Address is required.</asp:RequiredFieldValidator>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="30" ID="txtBillingCity" runat="server" class="text" ToolTip="City" placeholder="City" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtBillingCity" ErrorMessage="City is required." ToolTip="City is required." ValidationGroup="CreateUserWizard2">City is required.</asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row half">
                    <div class="6u">
                        <asp:TextBox MaxLength="30" ID="txtBillingState" runat="server" class="text" ToolTip="State" placeholder="State" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtBillingState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="CreateUserWizard2">State is required.</asp:RequiredFieldValidator>
                    </div>
                    <div class="6u">
                        <asp:TextBox MaxLength="10" ID="txtBillingZipcode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code" required></asp:TextBox>
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtBillingZipcode" ErrorMessage="Zip code is required." ToolTip="Zip code is required." ValidationGroup="CreateUserWizard2">Zip code is required.</asp:RequiredFieldValidator>
                    </div>
                </div>

             <%--   <div class="row">
                    <div class="-1u 10u">
                        <section id="mbs">
                                                                <div class="row">
                                                                    <div class="12u">
                                                                        <header>
                                                                            <h2>Your Membership</h2>
                                                                            <input runat="server" id="HiddenPremiumLevel" value="3" type="hidden" />
                                                                        </header>
                                                                    </div>
                                                                </div>
                                                                <div class="row flush">
                                                                    <div class="4u" id="divLevel1">
                                                                        <h3>Level 1<span>5 lbs</span></h3>
                                                                        <h4><a href="#">For The Firsttimers</a></h4>
                                                                        <p>Up to <span>10 Pictures</span></p>
                                                                        <p>Up to <span>2 Video</span></p>
                                                                        <p class="submit"><a id="btnLevel1" class="button btn9" onclick="SelectPremiumLevel(1);">Select</a></p>
                                                                    </div>
                                                                    <div class="4u" id="divLevel2">
                                                                        <h3>Level 2<span>20 lbs</span></h3>
                                                                        <h4><a href="#">For the Regular</a></h4>
                                                                        <p>Up to <span>28 Pictures</span></p>
                                                                        <p>Up to <span>4 Video</span></p>
                                                                        <p class="submit"><a id="btnLevel2" class="button btn9" onclick="SelectPremiumLevel(2);">Select</a></p>
                                                                    </div>
                                                                    <div class="4u selected" id="divLevel3">
                                                                        <h3>Level 3<span>50 lbs</span></h3>
                                                                        <h4><a href="#">For the Ballers</a></h4>
                                                                        <p>Up to <span>62 Pictures</span></p>
                                                                        <p>Up to <span>13 Video</span></p>
                                                                        <p class="submit"><a id="btnLevel3" class="button btn15" onclick="SelectPremiumLevel(3);">Your</a></p>
                                                                    </div>
                                                                </div>
                                                            </section>
                    </div>
                </div>--%>

                <div class="row half">
                    <div class="-3u 6u">
                        <fieldset>
                            <legend>Payment Information</legend>
                            <div class="row half">
                                <div class="6u">
                                    <asp:TextBox MaxLength="255" ID="txtPaymentFullName" runat="server" class="text" ToolTip="Full Name" placeholder="Full Name" required></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorPaymentFullName" runat="server" ControlToValidate="txtPaymentFullName" ErrorMessage="Full Name is required." ToolTip="Full Name is required." ValidationGroup="CreateUserWizard2">Full name is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u">
                                    <asp:TextBox MaxLength="130" ID="txtPaymentAddress" runat="server" class="text" ToolTip="Address" placeholder="Address" required></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorPaymentAddress" runat="server" ControlToValidate="txtPaymentAddress" ErrorMessage="Address is required." ToolTip="Address is required." ValidationGroup="CreateUserWizard2">Address is required.</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row half">
                                <div class="6u">
                                    <asp:TextBox MaxLength="30" ID="txtPaymentState" runat="server" class="text" ToolTip="City/State" placeholder="City/State" required></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorPaymentState" runat="server" ControlToValidate="txtPaymentState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="CreateUserWizard2">State is required.</asp:RequiredFieldValidator>
                                </div>
                                <div class="6u">
                                    <asp:TextBox MaxLength="10" ID="txtPaymentCardNumber" runat="server" class="text" ToolTip="CC Numbe" placeholder="CC Number" required></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidatorPaymentCardNumber" runat="server" ControlToValidate="txtPaymentCardNumber" ErrorMessage="CC Number is required." ToolTip="CC Number is required." ValidationGroup="CreateUserWizard2">CC Number is required.</asp:RequiredFieldValidator>
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
                </div>
            </fieldset>

            <div class="row" style="width: 100%; text-align: center">
                <div class="12u" style="width: 100%; text-align: center">
                    <div class="6u" style="width: 100%; text-align: center">
                        <button id="Button1" type="button" causesvalidation="True" validationgroup="CreateUserWizard2" class="submit button btn12" style="min-width: 300px;color: white; font-size: 23px;"
                            runat="server" onserverclick="btnUpdate_Click">
                            <span>Update</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    
    </div>

        
<a class="submit button btn12" href="#confirm_form" id="confirm_pop" style="display: none">Confirm Information</a>

<a href="#x" class="overlay" id="confirm_form"></a>
<div class="popup">
  <div class="row">
    <div class="12u" align="center"> <img border="0" alt="" src="http://www.pollinator.org/Images/SHARE/SHARElogoTextFINAL.jpg"> </div>
  </div>
  <div class="row">
    <div class="12u" align="center">
      <h3>Update successful</h3>
    </div>
  </div>
  <div class="row">
    <div class="12u" align="center">
        <asp:HyperLink runat="server" NavigateUrl="~/Members/UserUpdate.aspx" ID="linkReturnToMap" CssClass="submit button btn12" Text="Return To Map">OK</asp:HyperLink>
    </div>
  </div>
  <a class="popup-close" href="#close"></a> </div>

</asp:Content>
