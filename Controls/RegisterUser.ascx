<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterUser.ascx.cs" Inherits="Controls_RegisterUser" %>
<%@ Register Src="RegisterUserStep2.ascx" TagName="RegisterStep2" TagPrefix="uc" %>
<%@ Register Src="RegisterUserStep3.ascx" TagName="RegisterStep3" TagPrefix="uc" %>
<%@ Register Src="RegisterUserStep4.ascx" TagName="RegisterStep4" TagPrefix="uc" %>
<%@ Register Src="RegisterUserStepFinal.ascx" TagName="RegisterUserStepFinal" TagPrefix="uc" %>

<div class="containerbt">
    <uc:RegisterStep2 ID="RegisterStep2" runat="server" />
    <uc:RegisterStep3 ID="RegisterStep3" runat="server" />
    <uc:RegisterStep4 ID="RegisterStep4" runat="server" />
    <%--Show process bar such as while redirect to paypal page--%>
    <a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
    <a href="#x" class="overlay" id="Processbar_form"></a>
    <div class="popup" style="height: auto; background: none; border: none">
        <div style="width: auto; text-align: center">
            <p style="color: white; margin-bottom: 0px; z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
        </div>
    </div>
    <uc:RegisterUserStepFinal ID="RegisterUserStepFinal" runat="server" />
</div>

<script type="text/javascript">
    $(document).ready(function () {
        //  $(".registercontainer > .content .ms-parent").css("z-index", 0);
    })
    /* function showAddAccount() {
         $("#step1").hide();
         $("#stepCreateAccount").show();
         $("#lblCreateAccountTitle").html("Add password");
         $("#lblNotCreateAccount").html("I don't want to access my account again");
     }*/

    function showBFFConfirm() {
        $("#step1").hide();
        $("#stepFinal").show();
        $("#imgConfirmBFF").show();
        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: 'final',
                type: 'BFF'
            }
        });

    }
</script>
