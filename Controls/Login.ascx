<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Login.ascx.cs" Inherits="Controls_Login" %>

<a href="#" class="overlay" id="login_form"></a>
<div class="popup" id="loginpopup">

    <div class="row">
        <div class="12u">
            <h2>Welcome Guest!</h2>
            <p>Please enter your username and password here</p>
        </div>
    </div>
    <div class="message-error" id="error" style="display: none">
        Invalid username or password
    </div>
    <div class="row half">
        <div class="12u">
            <asp:TextBox ID="txtUserName" runat="server" CssClass="text" placeholder="Username" ToolTip="Username"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="Login" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="UserNameRequired" runat="server" ControlToValidate="txtUserName" ErrorMessage="Username is required." ToolTip="Username is required."></asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="row half">
        <div class="12u">
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="text" placeholder="Password" ToolTip="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="Login" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="PasswordRequired" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." ToolTip="Password is required."></asp:RequiredFieldValidator>

        </div>
    </div>

    <div class="row half">
        <div class="6u">

            <asp:CheckBox ID="chkIsRemember" runat="server" Text=" Remember me" Width="100%" Font-Bold="true" />
        </div>
    </div>

    <div class="row half">
        <div class="6u">
            <div style="float: left">
                <a onclick="clickLogin()" class="submit button btn12" style="font-family: Verdana; color: white; font-size: 14px" id="btnLogin">Log In</a>
            </div>
            <div style="float: left; padding-top: 9px">
                <img id="checking" src="<%=ResolveUrl("~/images/loading.gif") %>" style="display: none">
            </div>
        </div>
        <div align="right" class="6u">
            <a href="#" onclick="forgotPassword()" id="forgotPassword">Forgot your password?</a><br>
            New member? <a href="#close" onclick="signUp()" id="SignUp">Register now</a>
        </div>
    </div>
    <a class="popup-close" id="popup-close" href="#close" onclick="closeLogin()"></a>
</div>

<style>
    #loginpopup a:not(#popup-close):focus
    {
        box-shadow: 0 0 2px 1px #8ededc;
    }

    .loginfocus
    {
        box-shadow: 0 0 2px 1px #8ededc;
        border: 1px solid #8ededc;
    }

    .popup label
    {
        display: inline;
    }

    input:invalid
    {
        -moz-box-shadow: none;
        box-shadow: none;
    }
</style>
<script type="text/javascript">

    var txtUserName = '#<%=txtUserName.ClientID %>';
    var txtPassword = '#<%=txtPassword.ClientID %>';
    var chkIsRemember = '#<%=chkIsRemember.ClientID %>';

    var UserNameRequired = '#<%=UserNameRequired.ClientID %>';
    var PasswordRequired = '#<%=PasswordRequired.ClientID %>';

    var checking = false;

    function signUp() {
        if (checking)
            return false;

        var signUpLink1 = '<%=ResolveUrl("~/ShareMap.aspx")%>';
        var signUpLink2 = '<%=ResolveUrl("~/ShareMap")%>';
        var pathname = window.location.pathname;
        if (pathname != signUpLink1 && pathname != signUpLink2) {
            window.location = signUpLink;
        }
        else {
            closeLogin();
        }
    }

    function forgotPassword() {
        if (checking)
            return false;

        var link = '<%=ResolveUrl("~/Account/PasswordRecovery")%>';
        window.location = link;
    }

    function clickLogin() {
        if (checking)
            return false;

        userName = $(txtUserName).val();
        password = $(txtPassword).val();

        if (userName == "")
            $(UserNameRequired).css("display", "inline");

        if (password == "")
            $(PasswordRequired).css("display", "inline");

        if (userName == "" || password == "")
            return false;

        doLogin(userName, password);
    }

    function doLogin(userName, password) {
        if (checking)
            return false;

        checking = true;
        $("#error").html("");
        $('#checking').css("display", "inline");

        $("#loginpopup").find("*").attr("disabled", "disabled");
        var locationClose = $('#popup-close').attr("href");
        $("#popup-close").removeAttr('href');

        var locationSignUp = $('#SignUp').attr("href");
        $("#SignUp").removeAttr('href');
        var locationForgotPassword = $('#forgotPassword').attr("href");
        $("#forgotPassword").removeAttr('href');

        var isRemember;
        if ($(chkIsRemember).is(':checked') == true)
            isRemember = true
        else
            isRemember = false;

        var password = encodeURIComponent(password);

        var dataTransfer = JSON.stringify({
            UserName: userName,
            Password: password,
            IsRemember: isRemember
        });

        $.ajax({
            type: "POST",
            url: "<%=ResolveUrl("~/Handlers/SignIn.ashx")%>?UserName=" + userName + "&Password=" + password + "&IsRemember=" + isRemember,
            data: dataTransfer,
            success: function (data, status) {
                var result = data.toString();
                if (result == "" || result == "false" || result == "error") {
                    checking = false;

                    if (result == "error")
                        $("#error").html("Login error. Can't access database. Please contact to webmaster");
                    else
                        $("#error").html("Invalid username or password");

                    $("#error").css("display", "inline");
                    $('#checking').css("display", "none");

                    $("#loginpopup").find("*").removeAttr("disabled");
                    $("#popup-close").attr("href", locationClose);
                    $("#SignUp").attr("href", locationSignUp);
                    $("#forgotPassword").attr("href", locationForgotPassword);
                    return false;
                }
                else {
                    checking = false;
                    var rootServerPath = '<%=ResolveUrl("~")%>';
                    window.location = rootServerPath + result;

                }
            },
            error: function (data, status, e) {
                checking = false;
                console.log("error!!!" + data);

                $("#error").html("Login error. Call ajax fail. Please contact to webmaster");
                $("#error").css("display", "inline");
                $('#checking').css("display", "none");

                $("#loginpopup").find("*").removeAttr("disabled");
                $("#popup-close").attr("href", locationClose);
                $("#SignUp").attr("href", locationSignUp);
                $("#forgotPassword").attr("href", locationForgotPassword);
                return false;
            }
        });
    }

    function closeLogin() {
        if (checking)
            return false;

        $(txtUserName).val("");
        $(txtPassword).val("");
        $(txtUserName).removeAttr("required");
        $(txtPassword).removeAttr("required");

        $("#error").css("display", "none");
        $("#error").html("");

        $(UserNameRequired).css("display", "none");
        $(PasswordRequired).css("display", "none");
        $("#btnLogin").removeClass("loginfocus");

        $(txtUserName).attr("tabindex", -1);
        $(txtPassword).attr("tabindex", -1);
        $(chkIsRemember).attr("tabindex", -1);
        $("#btnLogin").attr("tabindex", -1);
        $("#forgotPassword").attr("tabindex", -1);
        $("#SignUp").attr("tabindex", -1);

        $(chkIsRemember).removeAttr("checked");
    }


    function setFirstFocus() {
        setTimeout(function () {
            initPopup();
        }, 1000);
    }

    var focusElement;

    function initPopup() {
        $(txtUserName).focus();
        focusElement = 'txtUserName';
        $(txtUserName).attr("required", "required");
        $(txtPassword).attr("required", "required");
        $("#popup-close").attr("tabindex", -1);
        $(txtUserName).attr("tabindex", 1);
        $(txtPassword).attr("tabindex", 2);
        $(chkIsRemember).attr("tabindex", 3);
        $("#btnLogin").attr("tabindex", 4);
        $("#forgotPassword").attr("tabindex", 5);
        $("#SignUp").attr("tabindex", 6);
    }

    window.onload = function () {
        setTimeout(function () {
            if (window.location.hash == "#login_form") {
                setFirstFocus();

            }
        }, 2000);

    };

    //Disable auto close popup when click
    $('#login_form').on('click', function (e) {
        e.preventDefault();
    });

    $(txtUserName).change(function () {
        $("#error").css("display", "none");
    });

    $(txtPassword).change(function () {
        $("#error").css("display", "none");
    });

    $(document).keypress(function (event) {

        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            event.preventDefault();
            if (focusElement == 'txtUserName' || focusElement == 'txtPassword') {
                userName = $(txtUserName).val();
                password = $(txtPassword).val();
                if (userName != "" && password != "") {
                    $("#btnLogin").focus();
                    doLogin(userName, password);
                    return;
                }
                if (focusElement == 'txtUserName' && userName != "") {
                    $(txtPassword).focus();

                }
            }
            else if (focusElement == 'btnLogin') {
                clickLogin();
            }

        }

    })



    $(txtUserName).focus(function () {
        focusElement = 'txtUserName';
    });

    $(txtPassword).focus(function () {
        focusElement = 'txtPassword';
    });

    $("#chkIsRemember").focus(function () {
        focusElement = 'chkIsRemember';
    });

    $("#btnLogin").focus(function () {
        focusElement = 'btnLogin';
        $(this).addClass("loginfocus");
    });

    $("#btnLogin").focusout(function () {
        $(this).removeClass("loginfocus");
    });

    $("#SignUp").on('focusout', function (e) {
        if ($("#loginpopup").css("visibility") == "visible") {
            e.preventDefault();
            $(txtUserName).focus();
        }
    });

</script>