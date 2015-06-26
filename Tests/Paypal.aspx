<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Paypal.aspx.cs" Inherits="Paypal" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <%--Show process bar such as while redirect to paypal page--%>
        <a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
        <a href="#x" class="overlay" id="Processbar_form"></a>
        <div class="popup" style="height:auto;  background:none; border:none">
          <div style="width:auto; text-align:center">
            <p style="margin-bottom: 0px;z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
          </div>
        </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#loginpopup').hide();
            $('footer').hide();
            $('header').hide();

            //Disable auto close popup when clickshowProcessbar
            $('#Processbar_form').on('click', function (e) {
                e.preventDefault();
            });
            $('showProcessbar').click();
        });
    </script>
</asp:Content>

