<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>

<div class="registercontainer" id="step1">
    <div class="header">       
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="1" Percent="5" />
        <h1>Register Your Pollinator Site
        </h1>
    </div>

    <div class="content">
        <div class="rowbot">
           <h3>Basic Info</h3> 
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="60" class="text" ToolTip="Full Name" placeholder="Full Name" ID="txtFullName" runat="server" required></asp:TextBox>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvPreFirstName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full Name is required" ToolTip="Full Name is required" ValidationGroup="RegisterUserStep1"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revPreFirstName" ControlToValidate="txtFullName" runat="server" ValidationExpression="[^{}]*" ErrorMessage="Invalid Full Name" ValidationGroup="RegisterUserStep1"></asp:RegularExpressionValidator>
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="256" class="text" ID="txtEmail" runat="server" ToolTip="Email Address" placeholder="Email Address" TextMode="Email" ></asp:TextBox>          
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="validEmail" ControlToValidate="txtEmail" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email. For example: john@pollinator.org" ValidationGroup="RegisterUserStep1"></asp:RegularExpressionValidator>

        </div>
      
        <div class="rownor">
            <input type="checkbox" id="cbxPat">
            <label for="cbxPat" style="display: inline">Sign me up for the Pollinator Action Team newsletter</label>
        </div>

         <div class="rownor">
            <input type="checkbox" id="cbxAccept">
            <label for="cbxAccept" style="display: inline">I accept the Pollinator Partnership Privacy Policy <a style="color:blue" href="#PolicyPopup"> HERE</a></label>
             <br />
           <asp:CustomValidator ID="chkAgreeValidator" runat="server" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ValidationGroup="RegisterUserStep1"
    ClientValidationFunction="checkAgreement">
 Unable to register if not accept the privacy policy
    </asp:CustomValidator>
        </div>
        
    </div>

    <div class="footer">
        
          <div class="rownor" >          
            <div style="text-align: center">	
				<a id="btnRegisterStep1" class="submit button btn1 buttonlarge" onclick="registerUserStep1()">
					<img style="padding-top:6px" src="<%= ResolveUrl("~/Images/marker/icon-large-4.png")%>" />
					<span style="padding-left:2.4em;padding-right:2.2em">&nbsp;&nbsp;&nbsp;&nbsp;Register</span> <span class="fa fa-arrow-right"></span> 
				</a>
			  </div>
			 <div  style="width:320px;margin: -44px auto 0px; height: 44px;">
                <img class="checking"  style="display:none"  src="<%=ResolveUrl("~/Images/loading.gif") %>" />        
            </div>   
                
        </div>
            

         <div style="width:450px;margin:20px auto;">	
		 <div class="floatLeft">
            <img class="imgLogoStep1" src="<%= ResolveUrl("~/Images/SHARElogoNoTextFINAL.png")%>" />
        </div>
        <div class="floatRight" style="margin-left: 30px">
            <img class="imgLogoStep1" src="<%= ResolveUrl("~/Images/logo/Bee-Friendly-Farmer-Logo.png")%>" />
        </div>
        <div style="clear: both"></div>
              </div>
    </div>

      <%--Show Policy modal poupu such as while redirect to paypal page--%>
   
    <a href="#x" class="overlay" id="PolicyPopup"></a>
    <div class="popup" >
        <div style="width: auto; text-align: center;padding:15px">
           <h3>SHARE/BFF Privacy Policy </h3>
        </div>
         <div style="width: auto; text-align: justify">       
We only have access to/collect information that you voluntarily give us via email or other direct contact from you. You will not be contacted without your permission; your information is confidential, and we will not sell or rent this information to anyone.

        </div>
        <div class="float-right">
            <a style="color:blue" href="http://www.pollinator.org/privacypolicy.html" target="_blank">More Information</a>
        </div>

        <a class="popup-close" id="popup-close" href="#close" ></a>
    </div>

</div>

<style>
   
</style>
<script type="text/javascript">
    function checkAgreement(source, args) {
        var checked = $("#cbxAccept").is(":checked");  
         if (checked) {
             args.IsValid = true;
         }
         else {
             args.IsValid = false;
         }
     }
    function registerUserStep1() {
	  if ($("#btnRegisterStep1").attr("disabled") == true)
            return;
			
        if (!Page_ClientValidate('RegisterUserStep1')) {
            return false;
        }      
		$("#step1 .checking").show();
        $("#step1").find("*").attr("disabled", "disabled");
        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: '1',
                fullName: $('#<%=txtFullName.ClientID%>').val(),
                email: $('#<%=txtEmail.ClientID%>').val(),
                phoneNumber: '',
             },
             dataType: "json",
             success: function (result) {						 
                 $("#step1").hide();            
                 $("#step2").show();
                 google.maps.event.trigger(locationMapInline, 'resize');
             },
             error: function (xhr, status) {
			// $(".checking").hide();
                 alert("An error occurred: " + status);
             }
         });
     }
</script>
