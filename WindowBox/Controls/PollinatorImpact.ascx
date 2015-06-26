<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PollinatorImpact.ascx.cs" Inherits="WindowBox_Controls_PollinatorImpact" %>

<style type="text/css">
    .confirmSavePopupHeader {
        background-image: linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%);
        padding: 5px;
        margin: -15px;
        border-top-left-radius: 5px;
        border-top-right-radius: 5px;
        font-weight: bold;
    }
        
    .garden div {
        /*border: solid 1px red;*/
        display: block;
        position: absolute;
    }

    .garden div:hover {
        background: rgba(100, 100, 100, 0.5);
        -moz-border-radius: 50%; 
        -webkit-border-radius: 50%; 
        border-radius: 50%;
    }

    .garden ul li.pot img
    {
        z-index: -1;
    }
</style>


<script type="text/javascript">
    $(document).ready(function () {
        $('#<%= btnSave.ClientID%>').click(function () {
            $('#create_account')[0].click(); 
            return false;
        });
        
        $('#btnConfirmSaveOK').click(function () {
            $('#save_success')[0].click();
            setTimeout(redirectToWindowBoxProfile, 5000);
            
            return false;
        });
    });
    
    function redirectToWindowBoxProfile() {
        document.location = '<%= ResolveUrl("../WindowBoxDisplay.aspx")%>';
    }
</script>


<a href="#save_success_popup" id="save_success" style="display: none"></a>
<a href="#x" class="overlay" id="save_success_popup"></a>
<div class="popup" style="width: 600px; height: 160px">
    <div class="confirmSavePopupHeader">Information</div>

    <p style="margin-top: 30px;color:black;font-size: 13px;font-family: Arial">
        Save successfully. It will redirect to your publically visiable Window Box in 5 seconds. 
        <br/>
        Click <a href=<%= ResolveUrl("../WindowBoxDisplay.aspx") %> style="color: blue">here</a> if you don't want to wait.
    </p>
    <a href="#close" class="popup-close" onclick="setFocusByControl('');"></a>
</div>


<%--<a href="#create_account_popup" class="overlay" id="create_account">aaaa</a>--%>

<a href="#create_account_popup" id="create_account" style="display: none"></a>
<a href="#x" class="overlay" id="create_account_popup"></a>

<div class="popup" style="width: 600px; height: 350px">
    <div class="confirmSavePopupHeader">Create Account</div>
    <div style="width: 100%;text-align: center;font-weight: bold;font-size:18px;margin-top:15px">
        Create An Account
    </div>

    <p>
        If you would like to be able to make changes to your Window Box, please enter a password and display name.
    </p>
            
    <p>
        <asp:TextBox MaxLength="100" Width="100%" Height="54" ID="txtDisplayName" runat="server" class="text" ToolTip="Enter your display name" placeholder="Display Name" required></asp:TextBox>
        <asp:TextBox MaxLength="100" Width="100%" Height="54" ID="txtPassword" runat="server" class="text" ToolTip="Enter your password" placeholder="Password" required></asp:TextBox>
        
        <div style="width: 100%;text-align: center;">
            <a type="button" class="btn btn-danger" aria-hidden="true" style="margin:auto; color: white; font-size: 16px;" href="">
                No Thanks <br/>
                I don't need to make changes
            </a>
        
            <a type="button" class="btn btn-success" id="btnConfirmSaveOK" aria-hidden="true" style="margin:auto; color: white; font-size: 16px;" href="">
                Let's do it<br/>
                Who knows how my garden will grow!
            </a>
        </div>
    </p>
    <a href="#close" class="popup-close" onclick="setFocusByControl('');"></a>
</div>


<h1 style="margin-left:10px">Pick Your Plants</h1>

<div style="width: 200px;text-align: center;float: right">
    <h3>Pollinator Impact</h3>
    
    <img src='<%= ResolveUrl("../Images/pollinator_impact.png") %>'/>
    <br/><br/><br/><br/><br/>
    <button id="btnReset" runat="server" class="btn btn-danger" aria-hidden="true" style="width: 150px" type="button">Reset</button>
    <br/><br/>
    <button id="btnSave" runat="server" class="btn btn-success" aria-hidden="true" style="width: 150px" type="button">SAVE</button>
</div>

<!--Drop Zone-->
<div class="garden" style="height: 450px;width:666px;margin:0 200px 0;background: url(<%= ResolveUrl("../Images/WindowBox_Flowers2.png")%>) no-repeat 50%;background-size: 100% 100%;">
  
            <div id="Li1" class="pot" style="width: 130px;height:130px;margin-top:195px;margin-left:45px;" frame-radius='85' frame-left='25' frame-top='25'></div>
    
            <div id="Li2" class="pot" style="width: 90px;height:90px;top:220px;left:220px;" frame-radius='50' frame-left='20' frame-top='25'></div>
 
            <div id="Li3" class="pot" style="width: 100px;height:90px;top:210px;left:350px;" frame-radius='50' frame-left='25' frame-top='20'></div>

            <div id="Li4" class="pot" style="width: 100px;height: 90px;top:215px;left:500px;" frame-radius='60' frame-left='15' frame-top='13'></div>
     
<%--        <li id="pot1" class="pot" style="width: 130px;height:130px;top:-140px;margin-left:15px;" frame-radius='85' frame-left='25' frame-top='225'></li>
        <li id="pot2" class="pot" style="width: 80px;height: 80px;top:-155px;left:15px;" frame-radius='60' frame-left='10' frame-top='245'></li>
        <li id="pot3" class="pot" style="width: 90px;height: 90px;top:-155px;left:25px;" frame-radius='60' frame-left='20' frame-top='230'></li>
        <li id="pot4" class="pot" style="width: 90px;height: 90px;top:-155px;left:45px;" frame-radius='60' frame-left='20' frame-top='230'></li>--%>

</div>