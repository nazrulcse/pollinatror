<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>
<div class="registercontainer" id="step3"  style="display: none;">
    <div class="header">
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="3" Percent="55" />
    </div>
    <div class="header" style="text-align: center">
        <img border="0" class="imgHeader" alt="" src="<%= ResolveUrl("~/Images/SHARElogoNoTextFINAL.png")%>">
        <h3>Congratulations, you have completed your SHARE registration process!</h3>
    </div>


    <div class="content" style="text-align: center; width: 90%">

        <div class="rownor" style="text-align: justify;">
            After our team has verified your pollinator site, you will automatically be added to the SHARE map and join thousands of people around the globe who share your passion for creating a healthier planet.  

        </div>
        <div class="rownor">

            <h3>Interested in further certification?</h3>
        </div>
    </div>
    <div class="footer">
        <div style="text-align: center">
            <a id="btnCreateAccount" class="submit button btn1 buttonlarge" onclick="gotoConfirmShare()">
                <span class="buttonText">No thanks, take me to the SHARE map</span>
                <span class="fa fa-arrow-right"></span>
            </a>
        </div>
        <div style="text-align: center; width: 478px; margin: 20px auto;">
            <div class="floatLeft" style="margin-top: 5px">
			
                <a style="color: blue; cursor: pointer; font-size: 21px; padding-left: 10px" href="http://www.pollinator.org/SHARE_certifications">Yes, I would like to learn about additional certification opportunities!
                </a>
            </div>
            <div style="clear: both"></div>
        </div>
    </div>
</div>


<script type="text/javascript">
    function gotoConfirmShare() {
        $("#step3").hide();
        $("#stepFinal").show();
        $("#imgConfirmShare").show();
        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: 'final',
                type: 'SHARE'
            }
        });


    }
    function gotoStep4() {
        $("#step3").hide();
        $("#step4").show();

    }
</script>
