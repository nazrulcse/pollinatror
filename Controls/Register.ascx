<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Register.ascx.cs" Inherits="Account_Register" %>
<%@ Register Src="PasswordStrength.ascx" TagName="PasswordStrength" TagPrefix="uc" %>
<%@ Register Src="~/Controls/UploadSinglePhoto.ascx" TagName="SinglePhoto" TagPrefix="uc" %>
<%@ Register Src="~/Controls/YoutubeSingleVideo.ascx" TagName="SingleYoutube" TagPrefix="yb" %>

<!--BEGIN: Javascript plug-in for validating password strength-->
<uc:PasswordStrength runat="server" />
<!--BEGIN: Jquery plug-in for validating password strength-->


<script type="text/javascript">


    function ShowImgThumnail(txtPhotoUrl, imgThumbnail) {
        var rootServerPath = '<%=ResolveUrl("~")%>';

         var imgUrl = rootServerPath + $('#' + txtPhotoUrl).val();
         if ($('#' + txtPhotoUrl).val().toLowerCase().match("^http:") || $('#' + txtPhotoUrl).val().toLowerCase().match("^https:")) {
             imgUrl = $('#' + txtPhotoUrl).val();
         }

         if ($('#' + txtPhotoUrl).val() == '') {
             $('#' + imgThumbnail).css('display', 'none');
         }
         else {
             $('#' + imgThumbnail).css('display', 'block');
             $('#' + imgThumbnail).attr('src', imgUrl);
         }
     }


     function selectYes() {

         var isOK = true;
         //var subPrefixFrom = 'MainContent_Register1_LoginView1_';
         //var subPrefixTo = 'MainContent_Register1_LoginView1_';

         var subPrefix = 'MainContent_Register1_LoginView1_';
         var subPrefixFrom = 'MainContent_Register1_LoginView1_txt';
         var subPrefixTo = 'MainContent_Register1_LoginView1_txtPre';

         //copy Normal to Premium
         if ($('#' + subPrefixFrom + 'FirstName').val()!='')
             $('#' + subPrefixTo + 'FirstName').val($('#' + subPrefixFrom + 'FirstName').val());

         if ($('#' + subPrefixFrom + 'LastName').val() != '')
             $('#' + subPrefixTo + 'LastName').val($('#' + subPrefixFrom + 'LastName').val());

         if ($('#' + subPrefixFrom + 'PhoneNumber').val() != '')
             $('#' + subPrefixTo + 'PhoneNumber').val($('#' + subPrefixFrom + 'PhoneNumber').val());

         if ($('#' + subPrefixFrom + 'Email').val() != '')
             $('#' + subPrefixTo + 'Email').val($('#' + subPrefixFrom + 'Email').val());

         //if ($('#' + subPrefixFrom + 'UserName').val() != '')
         //    $('#' + subPrefixTo + 'UserName').val($('#' + subPrefixFrom + 'UserName').val());

         //if ($('#' + subPrefixFrom + 'Password').val() != '')
         //    $('#' + subPrefixTo + 'Password').val($('#' + subPrefixFrom + 'Password').val());
         //if ($('#' + subPrefixFrom + 'ConfirmPassword').val() != '')
         //    $('#' + subPrefixTo + 'ConfirmPassword').val($('#' + subPrefixFrom + 'ConfirmPassword').val());

         if ($('#' + subPrefixFrom + 'OrganizationName').val() != '')
             $('#' + subPrefixTo + 'OrganizationName').val($('#' + subPrefixFrom + 'OrganizationName').val());


         var pollinatorSize = $('#' + subPrefix + 'ddlPollinatorSize').find('option:selected').val();
         $('#' + subPrefix + 'ddlPrePollinatorSize').val(pollinatorSize);

         var pollinatorType = $('#' + subPrefix + 'ddlPollinatorType').find('option:selected').val();
         $('#' + subPrefix + 'ddlPrePollinatorType').val(pollinatorType);

         var country = $('#' + subPrefix + 'ddlCountry').find('option:selected').val();
         $('#' + subPrefix + 'ddlPreCountry').val(country);

         if ($('#' + subPrefixFrom + 'LandscapeStreet').val() != '')
             $('#' + subPrefixTo + 'LandscapeStreet').val($('#' + subPrefixFrom + 'LandscapeStreet').val());

         if ($('#' + subPrefixFrom + 'LandscapeCity').val() != '')
             $('#' + subPrefixTo + 'LandscapeCity').val($('#' + subPrefixFrom + 'LandscapeCity').val());

         if ($('#' + subPrefixFrom + 'LandscapeState').val() != '')
             $('#' + subPrefixTo + 'LandscapeState').val($('#' + subPrefixFrom + 'LandscapeState').val());

         if ($('#' + subPrefixFrom + 'LandscapeZipcode').val() != '')
            $('#' + subPrefixTo + 'LandscapeZipcode').val($('#' + subPrefixFrom + 'LandscapeZipcode').val());

         if ($('#' + subPrefixFrom + 'PhotoUrl').val() != '')
            $('#' + subPrefixTo + 'PhotoUrl').val($('#' + subPrefixFrom + 'PhotoUrl').val());

         if ($('#' + subPrefixFrom + 'YoutubeUrl').val() != '')
            $('#' + subPrefixTo + 'YoutubeUrl').val($('#' + subPrefixFrom + 'YoutubeUrl').val());

         $('#' + subPrefixTo + 'Position').val($('#' + subPrefixFrom + 'Position').val());

         ShowRegisterForm('premium');

         //show thumnail
         ShowImgThumnail(subPrefixTo + 'PhotoUrl', 'imgThumbnailPre');

         //VIDEO
         SetVariablesOfUploadControl('1');

         //show first item
         displayVideoWithOutValidate('#MainContent_Register1_LoginView1_txtPreYoutubeUrl', false);
         $(txtYoutubeUrl).change(function () {
             displayVideoOnChange(this);
         });
     }


     //hide/show tab
     function ShowMoreShareSteps() {
         $('#btnShowMore').text('');
         $('#shareStepsContainer').css('display', 'block')
     }

</script>
<style type="text/css">
    .buttonCreateUser {
        margin-right: 281px;
        width: 436px;
        color: white;
        font-size: 14px;
        margin-top: 10px;
    }
</style>

<div id="main-wrapper">
    <div class="container" style="width: 1050px;">
        <div class="row" style="width: 100%">
            <input id="HiddenControlFocus" value="0" type="hidden" />
            <asp:LoginView ID="LoginView1" runat="server">
                <AnonymousTemplate>
                    <div id="divRegisterContainer" style="width: 100%">
                        <div class="row" id="divRowRegNormal" style="margin-top: 50px;">
                            <div class="12u">
                                <div style="width: 100%; text-align: center">
                                    <span class="message-error" style="color: red; margin-left: 13px; margin-top: 10px;">
                                        <asp:Label ID="lblErrorMessage" runat="server"></asp:Label></span>
                                </div>
                                <fieldset style="border: 1px #ccc solid;">
                                    <legend>Personal Information</legend>

                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="60" class="text" ToolTip="First Name" placeholder="First Name" ID="txtFirstName" runat="server" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="CreateUserWizard1">First Name is required.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revFirstName" ControlToValidate="txtFirstName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid First Name" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="60" class="text" ToolTip="Last Name" placeholder="Last Name" ID="txtLastName" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="24" class="text" ToolTip="Phone Number" placeholder="Phone Number" ID="txtPhoneNumber" runat="server"></asp:TextBox>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPhoneNumber" ID="revPhoneNumber" ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone Number." ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="256" TextMode="Email" class="text" ID="txtEmail" runat="server" ToolTip="Email Address" placeholder="Email Address" required></asp:TextBox><%--TextMode="Email"--%>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email Address is required." ToolTip="Email Address is required." ValidationGroup="CreateUserWizard1">Email Address is required.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revEmail" ControlToValidate="txtEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                   <%-- <div class="row half">
                                        <div style="width: 100%; height: 20px;margin-top: -20px; color: rgb(158, 149, 149); font-style:italic; font-size:14px">Username/password is optional</div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="50" class="text" ToolTip="Username" placeholder="Username" ID="txtUserName" runat="server" onchange="CheckExistUserName(this.id, 'lblUserAvailabilityNormal','MainContent_Register1_LoginView1_revUsername');"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvUserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="Username is required." ToolTip="Username is required." ValidationGroup="CreateUserWizard1">Username is required.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revUsername" ControlToValidate="txtUserName" ValidationExpression="^[a-zA-Z0-9_-]{3,}$" runat="server" ErrorMessage="Invalid Username! It must be at least 3 characters and does not include special characters." ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                            <div id="lblUserAvailabilityNormal" class="available"></div>
                                        </div>
                                        <div class="6u" style="display: inline-flexbox;">
                                            <div style="float: left; width: 49%">
                                                <asp:TextBox MaxLength="128" ID="txtPassword" runat="server" TextMode="Password" class="text password-strength-meter" ToolTip="Password" placeholder="Password"></asp:TextBox>
                                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="CreateUserWizard1">Password is required.</asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPassword" ID="revPassword" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required." ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                            </div>
                                            <div style="float: right; width: 49%">
                                                <asp:TextBox MaxLength="128" ID="txtConfirmPassword" runat="server" TextMode="Password" class="text" ToolTip="Confirm Password" placeholder="Confirm Password"></asp:TextBox>
                                                <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required." ValidationGroup="CreateUserWizard1"></asp:RequiredFieldValidator>
                                            </div>
                                            <asp:CompareValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="cvPasswordCompare" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="The Password and Confirmation Password must match." ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
                                        </div>
                                    </div>--%>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%">
                                            <asp:DropDownList ID="ddlPollinatorType" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Type of Pollinator Location">
                                                <asp:ListItem Value="NONE">Type of Pollinator Location</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPollinatorType" runat="server" ControlToValidate="ddlPollinatorType" ErrorMessage="Select one Type of Pollinator Location" ToolTip="Select one Type of Pollinator Location" ValidationGroup="CreateUserWizard1">Select one Type of Pollinator Location.</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </fieldset>
                                <fieldset style="border: 1px #ccc solid;">
                                    <legend>Pollinator Information</legend>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox ID="txtOrganizationName" maxlenght="100" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                                        </div>
                                        <div class="6u">
                                            <asp:DropDownList ID="ddlPollinatorSize" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Size of Pollinator Location">
                                                <asp:ListItem Value="NONE">Size of Pollinator Location</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPollinatorSize" runat="server" ControlToValidate="ddlPollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="CreateUserWizard1"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="100" ID="txtLandscapeStreet" runat="server" class="text" ToolTip="Landscape Street" placeholder="Landscape Street" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvLandscapeStreet" runat="server" ControlToValidate="txtLandscapeStreet" ErrorMessage="Landscape Street is required." ToolTip="Landscape Street is required." ValidationGroup="CreateUserWizard1">Landscape Street is required.</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="30" ID="txtLandscapeCity" runat="server" class="text" ToolTip="Landscape City" placeholder="Landscape City" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="tfvLandscapeCity" runat="server" ControlToValidate="txtLandscapeCity" ErrorMessage="Landscape City is required." ToolTip="Landscape City is required." ValidationGroup="CreateUserWizard1">Landscape City is required.</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="30" ID="txtLandscapeState" runat="server" class="text" ToolTip="Landscape State" placeholder="Landscape State" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvLandscapeState" runat="server" ControlToValidate="txtLandscapeState" ErrorMessage="Landscape State is required." ToolTip="Landscape State is required." ValidationGroup="CreateUserWizard1">Landscape State is required.</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="6u" style="display: inline-flexbox;">
                                            <div style="float: left; width: 49%">
                                                <asp:TextBox MaxLength="10" ID="txtLandscapeZipcode" runat="server" class="text" ToolTip="Landscape Zipcode" placeholder="Zip Code/Country Code" required></asp:TextBox>
                                            </div>
                                            <div style="float: right; width: 49%" title="Country">
                                                <asp:DropDownList ID="ddlCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                                </asp:DropDownList>
                                            </div>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvLandscapeZipcode" runat="server" ControlToValidate="txtLandscapeZipcode" ErrorMessage="Zip Code/Country Code  is required." ToolTip="Zip Code/Country Code  is required." ValidationGroup="CreateUserWizard1">Zip Code/Country Code  is required.</asp:RequiredFieldValidator>
                                             <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtLandscapeZipcode" ID="revLandscapeZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zipcode!" ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>

                                    <div class="row half">

                                        <div class="6u" style="width: 100%">
                                            <a style="font-size: 14px;" class="button btn36" id="showmap_popupNormal" href="#map_popup" onclick="codeAddress('normal', this.id)">Find location on map</a>
                                            <asp:TextBox MaxLength="10" ID="txtPosition" TabIndex="100" runat="server" Style="height: 0px; width: 0px; margin-left: -16px; background-color: #ccc"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPosition" runat="server" ControlToValidate="txtPosition" ErrorMessage="Please, click to preview and determine your location on map." ToolTip="Please, click to preview and determine your location on map." ValidationGroup="CreateUserWizard1"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <%--Normal: Upload Photo and Video--%>

                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="255" ID="txtPhotoUrl" onblur="ShowImgThumnail(this.id, 'imgThumbnailNor');" runat="server" class="text" placeholder="Photo URL"></asp:TextBox>
                                            <img id="loading" src="../images/loading.gif" style="display: none;">
                                            <span id="validatorPhotoUrl" title="You can upload only files with the following extensions: jpg, jpeg, gif, png" class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="255" ID="txtYoutubeUrl" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                                            <img id="loadingVideo" src="../images/loading.gif" style="display: none;">
                                            <div class="during-upload" id="during-upload" style="display: none">
                                                <p><span id="percent-transferred">Uploading</span></p>
                                                <p>
                                                    <progress id="upload-progress" max="100" value="1" style="width: 190px"></progress>
                                                </p>
                                            </div>
                                            <span id="validatorVideoUrl" title="You can upload only flv,mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files." class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <label class="file-upload">
                                                <a class="button btn36" id="linkAddPhoto" runat="server" style="min-width: 190px; font-size: 14px;">Add Photo</a>
                                                <asp:FileUpload ID="fileToUploadNormal" Style="height: 1px; width: 1px" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadPhoto('MainContent_Register1_LoginView1_txtPhotoUrl', 'imgThumbnailNor','loadingNormal', 'fileToUploadNormal', '#validatorPhotoUrl', 'MainContent_Register1_LoginView1_linkAddPhoto');" />
                                            </label>
                                            <img id="loadingNormal" src="../images/loading.gif" style="display: none;">
                                        </div>

                                        <div class="6u">
                                            <label class="file-upload">
                                                <a class="button btn36" id="linkAddVideo" runat="server" style="min-width: 190px; font-size: 14px;">Add Video</a>
                                                <asp:FileUpload Style="height: 1px; width: 1px" ID="fileToUploadNormalVideo" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadVideo('MainContent_Register1_LoginView1_txtYoutubeUrl', 'loadingNormalVideo', 'fileToUploadNormalVideo', '#validatorVideoUrl', 'MainContent_Register1_LoginView1_linkAddVideo');" />
                                            </label>
                                            <img id="loadingNormalVideo" src="../images/loading.gif" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <img id="imgThumbnailNor" src="" class="thumbnail2" style="display: none">
                                        </div>
                                        <div class="6u" style="padding-bottom: 5px">
                                            <div id="divVideoPlayer" style="display: none; margin-top: -20px;"></div>
                                        </div>
                                    </div>
                                    <%-- End normal upload  --%>
                                </fieldset>

                                <div style="width: 100%; align-items: center; text-align: center; margin-bottom: 19px;">
                                    <a href="#showTermOfPremium_form" id="showTermOfPremium_popup" class="button btn36" style="margin-bottom: 27px; min-width: 300px; font-size: 21px ; font-weight: 700;margin-right: -17px;">Interested in Becoming a Bee Friendly Farmer?</a>
                                </div>
                                <div class="row">
                                    <div class="12u">
                                        <section id="share">
                                            <header>
                                                <h2>Share Steps </h2>
                                                <%--<a href="#" class="fa fa-question-circle solo"><span>Question</span></a>--%>
                                                <div style="text-align: center; width: 100%; font-size: 21px; margin-top: -42px;">
                                                    <a id="btnShowMore" onclick="ShowMoreShareSteps();" style="cursor: pointer;">Show More</a>
                                                </div>

                                            </header>
                                            <div id="shareStepsContainer" style="display: none">
                                                <div class="row">
                                                    <div class="12u">
                                                        <section class="box" style="font-size: 13px; margin-top: 48px; margin-bottom: 30px;">
                                                            <ul id="tabs">
                                                                <li><a href="#" name="tab1" class="tab1">One - Plan and Plant</a></li>
                                                                <li><a href="#" name="tab2" class="tab2">Two - Monitor</a></li>
                                                                <li><a href="#" name="tab3" class="tab3">Three - Report</a></li>
                                                                <%--<li><a href="#" name="tabShowMore" class="tabShowMore">Show More</a></li>--%>
                                                            </ul>
                                                            <div id="tabContent" style="text-align: justify">
                                                                <div id="tab1">
                                                                    <h2>Step 1<span>Plan and Plant</span></h2>
                                                                    <p>Whether you are a farmer of many acres, a land manager of a large tract of land, or a gardener with a small lot, you can increase the number of pollinators in your area by making conscious choices to include plants that provide essential habitat for bees, butterflies, moths, beetle, hummingbirds, and other pollinators. &nbsp;As you begin to plan and plant, be sure to include elements that provide food, shelter, and water for pollinators.</p>
                                                                    <h3>Food</h3>
                                                                    <p>Flowers provide nectar and pollen to pollinators. &nbsp;Fermenting fallen fruits also provide food for bees, beetles, and butterflies. &nbsp;Specific host plants are eaten by the larvae of pollinators such as butterflies.</p>
                                                                    <ul>
                                                                        <li>Plant in groups to increase pollination efficiency. &nbsp;If a pollinator can visit the same type of flower over and over, it doesn&rsquo;t have to relearn how to enter the flower and transfer pollen of the same species, instead of squandering the pollen on unreceptive flowers.</li>
                                                                        <li>Plant with bloom season in mind, providing food from early spring to late fall</li>
                                                                        <li>Plant a diversity of plants to support a variety of pollinators</li>
                                                                        <li>Flowers of different color, fragrance, and season of bloom on plants of different heights will attract different pollinator species and provide pollen and nectar throughout the seasons</li>
                                                                        <li>Many herbs and annuals, although not native, are very good for pollinators (.e.g. mint, oregano, garlic, chives, and lavender)</li>
                                                                        <li>Recognize weeds that might be a good source of food (e.g. dandelions)</li>
                                                                        <li>Learn and utilize Integrated Pest Management practices to address pest concerns. &nbsp;Minimize or eliminate the use of pesticides </li>
                                                                    </ul>
                                                                    <h3>Shelter</h3>
                                                                    <p>Pollinators need protection from severe weather and from predators as well as sites for nesting and roosting.</p>
                                                                    <ul>
                                                                        <li>Incorporate different canopy layers in the landscape by planting trees, shrubs, and different-sized perennial plants</li>
                                                                        <li>Leave dead snags for nesting sites of bees, and other dead plants and leaf litter for shelter</li>
                                                                        <li>Build bee boxes to encourage solitary, non-aggressive bees to nest on your property</li>
                                                                        <li>Leave some areas of soil uncovered to provide ground nesting insects easy access to underground tunnels</li>
                                                                        <li>Group plantings so that pollinators can move safely through the landscape protected from predators</li>
                                                                        <li>Include plants that are needed by butterflies during their larval development </li>
                                                                    </ul>
                                                                    <h3>Water</h3>
                                                                    <p>A clean, reliable source of water is essential to pollinators.</p>
                                                                    <ul>
                                                                        <li>Natural and human-made water features such as running water, pools, ponds, and small containers of water provide drinking and bathing opportunities for pollinators.</li>
                                                                        <li>Ensure the water sources have a shallow or sloping side so the pollinators can easily approach the water without drowning. </li>
                                                                    </ul>
                                                                    <p class="tabnav"><a id="showtab2" class="btn12" style="padding: 5px; color: white; cursor:pointer;">Next Step &#10151;</a></p>
                                                                    <div class="separatorLine"></div>
                                                                </div>
                                                                <div id="tab2">
                                                                    <h2>Step 2<span>Monitor</span></h2>
                                                                    <p>Observe wildlife activity in your farm fields, woodlands, and gardens to determine what actions you can take to encourage other pollinators to feed and nest. Evaluate the placement of individual plants and water sources and use your knowledge of specific pollinator needs to guide your choice and placement of additional plants and other habitat elements. Minor changes by many individuals can positively impact the pollinator populations in your area. &nbsp;Be sure to keep a record of your observations. We have provided you with an optional free to download monitoring data sheet.<a href="http://www.pollinator.org/PDFs/SHARE/SHAREmonitoringdatasheet.pdf"> Click here to download yours.</a></p>
                                                                    <p>Watch for - and enjoy - the changes in your landscape! </p>
                                                                    <p class="tabnav"><a id="showtab3" href="#" class="btn12" style="padding: 5px; color: white; cursor:pointer;">Next Step &#10151;</a></p>
                                                                    <div class="separatorLine"></div>
                                                                </div>
                                                                <div id="tab3">
                                                                    <h2>Step 3<span>Report</span></h2>
                                                                    <p>We want to hear from you!  Applicants that have registered and met the S.H.A.R.E. registration requirements are encouraged to report on the status of their pollinator landscape monitoring by emailing <a href="mailto:SHARE@pollinator.org">SHARE@pollinator.org</a>.  Registered S.H.A.R.E. applicants that report on their pollinator landscape will receive an e-certificate, access to free online materials and have the option to receive a printed S.H.A.R.E. site sign by donating $20.00. </p>
                                                                    <p class="tabnav">
                                                                        <a id="showtab1" href="#" class="btn12" style="padding: 5px; color: white; cursor:pointer;">Back To Step 1</a>
                                                                    </p>
                                                                </div>
                                                            </div>
                                                        </section>
                                                    </div>
                                                </div>
                                            </div>
                                        </section>
                                    </div>
                                </div>

                                <div style="width: 100%; align-items: center; text-align: center; margin-bottom: 19px;">
                                    <a id="btnUpdate" type="button" causesvalidation="True" validationgroup="CreateUserWizard1" class="submit button btn12" style="margin-left: 28px; width: 530px; min-width: 300px; color: white; font-size: 21px;"
                                        runat="server" onserverclick="btnUpdate_Click">
                                        Confirm Information</a>
                                </div>
                            </div>
                        </div>

                        <div class="row" id="divRowRegPremium" style="display: block">
                            <div class="12u">
                                <div style="width: 100%; text-align: center">
                                    <span class="message-error" style="color: red; margin-left: 13px; margin-top: 10px;">
                                        <asp:Label ID="lblPreErrorMessage" runat="server"></asp:Label>
                                    </span>
                                </div>

                                <fieldset style="border: 1px #ccc solid;">
                                    <legend>General Information</legend>

                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="60" class="text" ToolTip="First Name" placeholder="First Name" ID="txtPreFirstName" runat="server" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreFirstName" runat="server" ControlToValidate="txtPreFirstName" ErrorMessage="First Name is required." ToolTip="First Name is required." ValidationGroup="CreateUserWizard2">First Name is required.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revPreFirstName" ControlToValidate="txtPreFirstName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid First Name" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="60" class="text" ToolTip="Last Name" placeholder="Last Name" ID="txtPreLastName" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="100" ID="txtPreOrganizationName" runat="server" class="text" ToolTip="Organization Name" placeholder="Organization Name"></asp:TextBox>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="255" ID="txtPreWebsite" runat="server" class="text" ToolTip="Website" placeholder="Website"></asp:TextBox>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revPreWebsite" ControlToValidate="txtPreWebsite" runat="server" ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Invalid URL" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="24" class="text" ToolTip="Phone Number" placeholder="Phone Number" ID="txtPrePhoneNumber" runat="server"></asp:TextBox>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPrePhoneNumber" ID="rfvPrePhoneNumber" ValidationExpression="([()\d+-.\s])*" runat="server" ErrorMessage="Invalid Phone Number." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="256" class="text" ID="txtPreEmail" runat="server" ToolTip="Email Address" placeholder="Email Address" TextMode="Email" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreEmail" runat="server" ControlToValidate="txtPreEmail" ErrorMessage="Email Address is required." ToolTip="Email Address is required." ValidationGroup="CreateUserWizard2">Email Address is required.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revPreEmail" ControlToValidate="txtPreEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>

                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div style="width: 100%; height: 20px;margin-top: -20px; color: rgb(158, 149, 149); font-style:italic; font-size:14px">Username/password is optional</div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="50" class="text" ToolTip="Username" placeholder="Username" ID="txtPreUserName" runat="server" onchange="CheckExistUserName(this.id, 'lblUserAvailabilityPremium','MainContent_Register1_LoginView1_revPreUsername');"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreUserName" runat="server" ControlToValidate="txtPreUserName" ErrorMessage="Username is required." ToolTip="Username is required." ValidationGroup="CreateUserWizard2">Username is required.</asp:RequiredFieldValidator>--%>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPreUserName" ID="revPreUsername" ValidationExpression="^[a-zA-Z0-9_-]{3,}$" runat="server" ErrorMessage="Invalid Username! It must be at least 3 characters and does not include special characters." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                            <div id="lblUserAvailabilityPremium" class="available"></div>

                                            <%--<asp:TextBox Visible="false" ID="txtPreQuestion" runat="server" class="text" ToolTip="xxx" placeholder="Question" Text="Question" required></asp:TextBox>
                                            <asp:TextBox Visible="false" ID="txtPreAnswer" runat="server" class="text" ToolTip="xxx" placeholder="Answer" Text="Answer" required></asp:TextBox>--%>
                                        </div>
                                        <div class="6u" style="display: inline-flexbox;">
                                            <div style="float: left; width: 49%">
                                                <asp:TextBox MaxLength="128" ID="txtPrePassword" runat="server" TextMode="Password" class="text password-strength-meter" ToolTip="Password" placeholder="Password" ></asp:TextBox>
                                                <%--<asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPrePassword" runat="server" ControlToValidate="txtPrePassword" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="CreateUserWizard2">Password is required.</asp:RequiredFieldValidator>--%>
                                                <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPrePassword" ID="revPrePassword" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required." ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                            </div>
                                            <div style="float: right; width: 49%">
                                                <asp:TextBox MaxLength="128" ID="txtPreConfirmPassword" runat="server" TextMode="Password" class="text" ToolTip="Confirm Password" placeholder="Confirm Password" ></asp:TextBox>
                                                <%--<asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreConfirmPassword" runat="server" ControlToValidate="txtPreConfirmPassword" ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required." ValidationGroup="CreateUserWizard2">Confirm Password is required.</asp:RequiredFieldValidator>--%>
                                                <asp:CompareValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="cvPrePasswordCompare" runat="server" ControlToCompare="txtPrePassword" ControlToValidate="txtPreConfirmPassword" ErrorMessage="The Password and Confirmation Password must match." ValidationGroup="CreateUserWizard2"></asp:CompareValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%">
                                            <asp:DropDownList ID="ddlPrePollinatorType" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Type of Pollinator Location">
                                                <asp:ListItem Value="NONE">Type of Pollinator Location</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPrePollinatorType" runat="server" ControlToValidate="ddlPrePollinatorType" ErrorMessage="Select one Type of Pollinator Location" ToolTip="Select one Type of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one Type of Pollinator Location.</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%;">
                                            <h3>Organization Description </h3>
                                            <asp:TextBox ID="txtPreDescription" runat="server" class="text" TextMode="MultiLine" Rows="5"></asp:TextBox>
                                        </div>
                                    </div>
                                    <%--Premium: Upload Photo and Video--%>

                                    <div class="row half">
                                        <div class="6u">
                                            <asp:TextBox MaxLength="255" ID="txtPrePhotoUrl" onblur="ShowImgThumnail(this.id, 'imgThumbnailPre');" runat="server" class="text" placeholder="Photo URL"></asp:TextBox>
                                            <img id="imgPreLoading" src="../images/loading.gif" style="display: none;">
                                            <span id="validatorPrePhotoUrl" title="You can upload only files with the following extensions: jpg, jpeg, gif, png" class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                                        </div>
                                        <div class="6u">
                                            <asp:TextBox MaxLength="255" ID="txtPreYoutubeUrl" runat="server" class="text" placeholder="Youtube URL"></asp:TextBox>
                                            <img id="imgPreLoadingVideo" src="../images/loading.gif" style="display: none;">
                                            <div class="during-upload" id="during-uploadPre" style="display: none">
                                                <p><span id="percent-transferredPre">Uploading</span></p>
                                                <p>
                                                    <progress id="upload-progressPre" max="100" value="1" style="width: 190px"></progress>
                                                </p>
                                            </div>
                                            <span id="validatorPreVideoUrl" title="You can upload only flv,mp4, avi, mpg, m4v, mov, wmv, swf, rm, ram, ogg, webm, mpeg extensions files." class="message-error" style="display: none;">You can upload only files with the following extensions: jpg, jpeg, gif, png</span>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <label class="file-upload">
                                                <a class="button btn36" id="linkPreAddPhoto" runat="server" style="min-width: 190px; font-size: 14px;">Add Photo</a>
                                                <asp:FileUpload ID="fileToUploadSinglePremium" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadPhoto('MainContent_Register1_LoginView1_txtPrePhotoUrl', 'imgThumbnailPre','imgPhotoUploadingPre', 'fileToUploadSinglePremium', '#validatorPrePhotoUrl', 'MainContent_Register1_LoginView1_linkPreAddPhoto');" />
                                            </label>
                                            <img id="imgPhotoUploadingPre" src="../images/loading.gif" style="display: none;">
                                        </div>

                                        <div class="6u">
                                            <label class="file-upload">
                                                <a class="button btn36" id="linkPreAddVideo" runat="server" style="min-width: 190px; font-size: 14px;">Add Video</a>
                                                <asp:FileUpload ID="fileToUploadVideoSinglePremium" runat="server" ClientIDMode="Static" onchange="javascript:return fileUploadVideo('MainContent_Register1_LoginView1_txtPreYoutubeUrl', 'imgVideoUploadingPre', 'fileToUploadVideoSinglePremium', '#validatorPreVideoUrl', 'MainContent_Register1_LoginView1_linkPreAddVideo');" />
                                            </label>
                                            <img id="imgVideoUploadingPre" src="../images/loading.gif" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u">
                                            <img id="imgThumbnailPre" src="" class="thumbnail2" style="display: none">
                                        </div>
                                        <div class="6u" style="padding-bottom: 5px">
                                            <div id="divVideoPlayerPre" style="display: none; margin-top: -20px;"></div>
                                        </div>
                                    </div>
                                    <%-- End normal upload  --%>
                                </fieldset>

                                <fieldset style="border: 1px #ccc solid; margin-bottom: 36px;">
                                    <legend>Pollinator Information</legend>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%">
                                            <asp:DropDownList ID="ddlPrePollinatorSize" Width="100%" runat="server" CssClass="registerSelect" AppendDataBoundItems="true" placeholder="Size of Pollinator Location">
                                                <asp:ListItem Value="NONE">Size of Pollinator Location</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPrePollinatorSize" runat="server" ControlToValidate="ddlPrePollinatorSize" ErrorMessage="Select one Size of Pollinator Location" ToolTip="Select one Size of Pollinator Location" ValidationGroup="CreateUserWizard2">Select one Size of Pollinator Location.</asp:RequiredFieldValidator>
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
                                            <asp:TextBox MaxLength="30" ID="txtPreLandscapeState" runat="server" class="text" ToolTip="State" placeholder="State" required></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreLandscapeState" runat="server" ControlToValidate="txtPreLandscapeState" ErrorMessage="State is required." ToolTip="State is required." ValidationGroup="CreateUserWizard2">State is required.</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="6u" style="display: inline-flexbox;">
                                            <div style="float: left; width: 49%">
                                                <asp:TextBox MaxLength="10" ID="txtPreLandscapeZipcode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code/Country Code" required></asp:TextBox>
                                            </div>
                                            <div style="float: right; width: 49%" title="Country">
                                                <asp:DropDownList ID="ddlPreCountry" Width="100%" runat="server" CssClass="registerSelect" placeholder="Country">
                                                </asp:DropDownList>
                                            </div>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreLandscapeZipcode" runat="server" ControlToValidate="txtPreLandscapeZipcode" ErrorMessage="Zip Code/Country Code  is required" ToolTip="Zip Code/Country Code  is required" ValidationGroup="CreateUserWizard2">Zip Code/Country Code  is required</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPreLandscapeZipcode" ID="revPreLandscapeZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zipcode!" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%; font-size: 14px">
                                            <input type="checkbox" id="cbxUseAsBillingAddress" onclick="Check_cbxUseAsBillingAddress('MainContent_Register1_LoginView1_');" title="Check on to copy Information at bellow section to Billing Address setion">
                                            <label for="cbxUseAsBillingAddress" style="display: inline">Use as Billing Address</label>
                                        </div>
                                    </div>
                                    <div class="row half">
                                        <div class="6u" style="width: 100%">
                                            <a style="font-size: 14px;" class="button btn36" id="showmap_popup" href="#map_popup" onclick="codeAddress('premium', this.id)">Find location on map</a>
                                            <asp:TextBox MaxLength="10" ID="txtPrePosition" TabIndex="100" runat="server" Style="height: 0px; width: 0px; margin-left: -16px; background-color: #ccc"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPrePosition" runat="server" ControlToValidate="txtPrePosition" ErrorMessage="Please, click to preview and determine your location on map." ToolTip="Please, click to preview and determine your location on map." ValidationGroup="CreateUserWizard2"></asp:RequiredFieldValidator>
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
                                            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="txtPreBillingZipcode" ID="revPreBillingZipcode" ValidationExpression="[A-Za-z0-9\s-]*" runat="server" ErrorMessage="Invalid Zipcode!" ValidationGroup="CreateUserWizard2"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                </fieldset>

                                <div style="width: 100%; align-items: center; text-align: center; margin-bottom: 19px;">
                                    <button id="btnPreUpdate" type="button" causesvalidation="True" validationgroup="CreateUserWizard2" class="submit button btn12" style="margin-left: 11px; width: 365px; min-width: 300px; color: white; font-size: 19px;"
                                        runat="server" onserverclick="btnPreUpdate_Click">
                                        Confirm Information</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </AnonymousTemplate>
                <LoggedInTemplate>
                    <div style="width: 100%; text-align: center;">
                        <a id="btnGoPremium" href="~/Members/Manage?goPre=1" runat="server" visible="false" class="submit button btn12" style="min-width: 300px; color: white; font-size: 23px;">Upgrade To Bee Friendly Farmers</a>
                    </div>
                </LoggedInTemplate>
            </asp:LoginView>
        </div>
    </div>
</div>

<asp:PlaceHolder runat="server" ID="phEmailTasks"></asp:PlaceHolder>


<%--Single upload user controls--%>
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
            if (isPremiumType == '1') {//Premium
                // Upload single photo
                txtPhotoUrl = '#MainContent_Register1_LoginView1_txtPrePhotoUrl';
                imgPhoto = 'imgThumbnailPre';
                linAddPhoto = 'MainContent_Register1_LoginView1_linkPreAddPhoto';;
                fileToUploadID = 'fileToUploadNormal';
                dontDeletePreImage = '<%=dontDeletePreImage.ClientID %>';
                validatorInputPhotoUrl = '#validatorPrePhotoUrl';
                loadingImage = '#imgPreLoading';

                //onchange photo
                $(txtPhotoUrl).change(function () {
                    displayImageOnChange(this, false);
                });
                displayImageOnChange(txtPhotoUrl, false);
                // End Upload single photo

                //Upload single video
                txtYoutubeUrl = '#MainContent_Register1_LoginView1_txtPreYoutubeUrl';
                validatorInputVideoUrl = '#validatorPreVideoUrl'; 

                //video
                loadingVideo = '#imgPreLoadingVideo';
                divVideoPlayer = '#divVideoPlayerPre';
                duringupload = "#during-uploadPre";
                uploadprogress = "#upload-progressPre";
                percenttransferred = "#percent-transferredPre";

                //on blur video
                $(txtYoutubeUrl).blur(function () {
                    displayVideoOnChange(this, false);
                });
            }
            else {//Normal
                // Upload single photo
                txtPhotoUrl = '#MainContent_Register1_LoginView1_txtPhotoUrl';

                imgPhoto = 'imgThumbnailNor';
                linAddPhoto = 'MainContent_Register1_LoginView1_linkAddPhoto';;
                fileToUploadID = 'fileToUploadNormal';
                dontDeletePreImage = '<%=dontDeletePreImage.ClientID %>';
                validatorInputPhotoUrl = '#validatorPhotoUrl';
                loadingImage = '#loading';

                //onchange
                $(txtPhotoUrl).change(function () {
                    displayImageOnChange(this, false);
                });
                // End Upload single photo

                

                //video
                //Upload single video
                txtYoutubeUrl = '#MainContent_Register1_LoginView1_txtYoutubeUrl';
                validatorInputVideoUrl = '#validatorVideoUrl';
                loadingVideo = '#loadingVideo';
                divVideoPlayer = '#divVideoPlayer';
                duringupload = "#during-upload";
                uploadprogress = "#upload-progress";
                percenttransferred = "#percent-transferred";

                //show first item
                $(txtYoutubeUrl).blur(function () {
                    displayVideoOnChange(this);
                });
            }
        }

        //Normal is default
        SetVariablesOfUploadControl('0');

</script>
<input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
<yb:SingleYoutube runat="server" ID="SingleYoutube" />
<uc:SinglePhoto runat="server" ID="SinglePhoto" />
<%--End single Upload usercontrol--%>

<%--Show process bar such as while redirect to paypal page--%>
<a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
<a href="#x" class="overlay" id="Processbar_form"></a>
<div class="popup" style="height: auto; background: none; border: none">
    <div style="width: auto; text-align: center">
        <p style="color: white; margin-bottom: 0px; z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
        <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
    </div>
</div>

<!--show popup confirm -->
<a class="submit button btn12" href="#confirm_form" id="confirm_pop" style="display: none">Confirm Information</a>
<a href="#x" class="overlay" id="confirm_form"></a>
<div class="popup">
    <div class="row">
        <div class="12u" align="center"><a id="pollinator_home" runat="server" href="http://pollinator.org">
            <img border="0" alt="" src="http://www.pollinator.org/Images/SHARE/SHARElogoTextFINAL.jpg">
        </a></div>
    </div>
    <div class="row">
        <div class="12u" align="center">
            <h3>Registration Confirmed</h3>
        </div>
    </div>
    <div class="row">
        <div class="12u" align="center">
            <asp:HyperLink runat="server" ID="linkReturnToMap" NavigateUrl="~/Default" CssClass="submit button btn12" Text="Return To Map"></asp:HyperLink>
        </div>

    </div>
    <a class="popup-close" href="#close"></a>
</div>


<!--Vinh: popup show term of premium-->
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

<!-- DUY -->
<a href="#x" class="overlay" id="map_popup"></a>
<div id="mappopup" class="popup" style="width: 810px; height: 450px">

    <strong>
        <label id="lblPickLocation" style="color: #555; font-size: 14px">Find a location and check in</label>
    </strong>
    <div id="locationmap-canvas" style="width: 780px; height: 335px"></div>
    <input type="hidden" id="lat" name="lat" value="" />
    <input type="hidden" id="lng" name="lng" value="" />
    <p style="text-align: center; padding: 10px 0"><a class="submit button btn24" onclick="setFocusByControl('');" style="min-width: 200px; color: #fff; font-size: 14px; font-family: Arial;" href="#x">OK</a></p>
    <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static" />
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
    var flag_open_map = 0;
    var subPrefix = 'MainContent_Register1_LoginView1_';

    var infowindow = new google.maps.InfoWindow(
        {
            size: new google.maps.Size(150, 50)
        });

    // A function to create the marker and set up the event window function 
    function createMarker(latlng, name, html, userType) {
        var contentString = html;
        var locationmarker = new google.maps.Marker({
            position: latlng,
            map: locationmap,
            zIndex: Math.round(latlng.lat() * -100000) << 5
        });

        //document.getElementById("lat").value = latlng.lat();
        //document.getElementById("lng").value = latlng.lng();

        //set position: lat, long
        var ctlLat = '<%= hdnLat.ClientID %>';
            var ctlLng = '<%=hdnLng.ClientID %>';
            document.getElementById(ctlLat).value = latlng.lat();
            document.getElementById(ctlLng).value = latlng.lng();

            //alert('subPrefix=' + subPrefix);
            if (userType == 'premium') {
                $('#' + subPrefix + 'txtPrePosition').val(latlng.lat());
                $("#" + subPrefix + 'rfvPrePosition').css("display", "none");
            }
            else {
                $('#' + subPrefix + 'txtPosition').val(latlng.lat());
                $('#' + subPrefix + 'rfvPosition').css("display", "none");
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

            premium = userType;//Premium or normal

            var OrganizationName = '';
            var LandscapeStreet = '';
            var LandscapeCity = '';
            var LandscapeState = '';
            //country
            var LandscapeCountry = '';
            var LandscapeCountryValue = '';
            if (userType == 'premium') {
                OrganizationName = $("#" + subPrefix + "txtPreOrganizationName").val();
                LandscapeStreet = $("#" + subPrefix + "txtPreLandscapeStreet").val();
                LandscapeCity = $("#" + subPrefix + "txtPreLandscapeCity").val();
                LandscapeState = $("#" + subPrefix + "txtPreLandscapeState").val();
                //country
                LandscapeCountry = $('#' + subPrefix + 'ddlPreCountry').find('option:selected').html();
                LandscapeCountryValue = $('#' + subPrefix + 'ddlPreCountry').find('option:selected').val();
            }
            else {//Normal
                OrganizationName = $("#" + subPrefix + "txtOrganizationName").val();
                LandscapeStreet = $("#" + subPrefix + "txtLandscapeStreet").val();
                LandscapeCity = $("#" + subPrefix + "txtLandscapeCity").val();
                LandscapeState = $("#" + subPrefix + "txtLandscapeState").val();
                //country
                LandscapeCountry = $('#' + subPrefix + 'ddlCountry').find('option:selected').html();
                LandscapeCountryValue = $('#' + subPrefix + 'ddlCountry').find('option:selected').val();
            }


            //build address string
            if (LandscapeCountryValue == 'NONE') {
                var addr = [LandscapeStreet, " " + LandscapeCity, " " + LandscapeState];
            }
            else {
                var addr = [LandscapeStreet, " " + LandscapeCity, " " + LandscapeState, " " + LandscapeCountry];
            }

            console.log("#LandscapeStreet: " + LandscapeStreet);

            addr = addr.filter(iisempty);
            address = addr.join();

            var html = "";
            if (OrganizationName != "") {
                html += "<h2 class=\"info-window-header\">" + OrganizationName + "</h2><hr />";
            }
            if (OrganizationName == "" && address == "") {
                html += "<h2 class=\"info-window-header\">This is your location!</h2><hr />";
            }
            html += "<div class='infowindows'>";
            if (address != "") {
                html += "<p>" + address + "</p>";
            }
            html += "</div>";
            html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';

            if (flag_open_map != 0) {
                //set position: lat, long
                var ctlLat = '<%= hdnLat.ClientID %>';
                var ctlLng = '<%=hdnLng.ClientID %>';
                var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);
                locationmap.setOptions({ center: coordinate });
                if (locationmarker) {
                    locationmarker.setMap(null);
                    locationmarker = null;
                }
                locationmarker = createMarker(coordinate, "pollinator", html, userType);
            } else if (address != "") {
                console.log("[#2]address: " + address);
                geocoder.geocode({ 'address': address }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        locationmap.setOptions({ center: results[0].geometry.location, zoom: 7 });
                        if (locationmarker) {
                            locationmarker.setMap(null);
                            locationmarker = null;
                        }
                        locationmarker = createMarker(results[0].geometry.location, "pollinator", html, userType);
                    } else {
                        alert('Location not found for "' + address + '". Please find your own pin on map.');
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
                flag_open_map = 1;

                var OrganizationName = '';
                var LandscapeStreet = '';
                var LandscapeCity = '';
                var LandscapeState = '';
                //country
                var LandscapeCountry = '';
                var LandscapeCountryValue = '';

                if (premium == 'premium') {
                    OrganizationName = $("#" + subPrefix + "txtPreOrganizationName").val();
                    LandscapeStreet = $("#" + subPrefix + "txtPreLandscapeStreet").val();
                    LandscapeCity = $("#" + subPrefix + "txtPreLandscapeCity").val();
                    LandscapeState = $("#" + subPrefix + "txtPreLandscapeState").val();

                    //country
                    LandscapeCountry = $('#' + subPrefix + 'ddlPreCountry').find('option:selected').html();
                    LandscapeCountryValue = $('#' + subPrefix + 'ddlPreCountry').find('option:selected').val();
                }
                else {
                    OrganizationName = $("#" + subPrefix + "txtOrganizationName").val();
                    LandscapeStreet = $("#" + subPrefix + "txtLandscapeStreet").val();
                    LandscapeCity = $("#" + subPrefix + "txtLandscapeCity").val();
                    LandscapeState = $("#" + subPrefix + "txtLandscapeState").val();

                    //country
                    LandscapeCountry = $('#' + subPrefix + 'ddlCountry').find('option:selected').html();
                    LandscapeCountryValue = $('#' + subPrefix + 'ddlCountry').find('option:selected').val();
                }


                //build address string
                if (LandscapeCountryValue == 'NONE') {
                    var addr = [" " + LandscapeStreet, " " + LandscapeCity, " " + LandscapeState];
                }
                else {
                    var addr = [" " + LandscapeStreet, " " + LandscapeCity, " " + LandscapeState, " " + LandscapeCountry];
                }

                addr = addr.filter(iisempty);
                address = addr.join();

                var html = "";
                if (OrganizationName != "") {
                    html += "<h2 class=\"info-window-header\">" + OrganizationName + "</h2><hr />";
                }
                if (OrganizationName == "" && address == "") {
                    html += "<h2 class=\"info-window-header\">This is your location!</h2><hr />";
                }
                html += "<div class='infowindows'>";
                if (address != "") {
                    html += "<p>" + address + "</p>";
                }
                html += "</div>";
                html += '<ul class="callout-link-bottom"><li><a href="javascript:gohere()" style="color: #3764A0">Go here</a></li></ul>';


                var geolocation = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());

                var geocoder = new google.maps.Geocoder();

                geocoder.geocode({ 'latLng': geolocation }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.ZERO_RESULTS || !results[0]) {
                        alert('Location is invalid!');
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
        new google.maps.event.addDomListener(window, 'load', initialize2);

        function gohere() {

            //set position: lat, long
            var ctlLat = '<%= hdnLat.ClientID %>';
            var ctlLng = '<%=hdnLng.ClientID %>';
            var coordinate = new google.maps.LatLng(document.getElementById(ctlLat).value, document.getElementById(ctlLng).value);
            locationmap.setOptions({ center: coordinate, zoom: 10 });
        }

</script>
