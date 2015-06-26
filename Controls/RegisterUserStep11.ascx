<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>
<div class="container registercontainer" id="step11" style="display: none">
    <div class="header">
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="11" Percent="70" />
        <h1>Abour your BFF
        </h1>
        <div class="subHeader">Questionaire</div>
    </div>

    <div class="content">
        <div class="rowbot">
            List the names of plants on your property that seasonally provide pollen and nectar
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer7" runat="server" class="text" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="rowbot">
            What, if any, are the bee pollinated crops grown?
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer8" runat="server" class="text" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="rowbot">
            Any other certification
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer9" runat="server" class="text" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

    </div>

    <div class="footer">
        <div class="floatRight">
            <a id="btnRegister" class="submit button btn1" onclick="registerUserStep11()">
                <img src="<%= ResolveUrl("~/Images/marker/icon-large-0.png")%>" /><span class="buttonText">Paypal</span>  &#10151;
            </a>
        </div>
        <div style="clear: both"></div>
    </div>

</div>


<%--Show process bar such as while redirect to paypal page--%>
<a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
<a href="#x" class="overlay" id="Processbar_form"></a>
<div class="popup" style="height: auto; background: none; border: none">
    <div style="width: auto; text-align: center">
        <p style="color: white; margin-bottom: 0px; z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
        <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
    </div>
</div>


<script type="text/javascript">
    //Disable auto close popup when clickshowProcessbar
    $('#Processbar_form').on('click', function (e) {
        e.preventDefault();
    });

    function registerUserStep11() {
        if (!Page_ClientValidate('RegisterUserStep11')) {
            return false;
        }
        document.getElementById('showProcessbar').click();

        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: '11',
          
            },      
            success: function (data) {
                $("#step11").hide();

                var result = data.toString();
                document.getElementById('paypal_container').innerHTML = result;
                document.getElementById('paypal_btn').click();
            },
            error: function (xhr, status) {
                alert("An error occurred: " + status);
            }
        });
    }
</script>