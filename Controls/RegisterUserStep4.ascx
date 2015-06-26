<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>
<div class="registercontainer" id="step4"  style="display: none;"  >
    <div class="header">
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="4" Percent="75" />
        <h1>Bee Friendly Farmer Registration
        </h1>
    </div>

    <div class="content">
        <div class="rownor">
            <h3>About Your Pollinator Site</h3>
        </div>

        <div class="rownor">
           What type of certification
        </div>
        <div class="rownor">
            <div class="floatLeft" style="width: 33%; text-align: center; padding-right: 20px">
                <div>
                    <img class="certificationImage" src="<%= ResolveUrl("~/Images/Gardener.jpg")%>">
                </div>
                <div class="certificationTypeName">
                    <input type="radio" name="rdoCertificationType" id="rdoGardener"><label for="rdoGardener">Gardener</label>
                </div>
               

            </div>
            <div class="floatLeft" style="width: 34%; text-align: center; padding-right: 20px">
                <div>
                    <img class="certificationImage" src="<%= ResolveUrl("~/Images/Farmer.jpg")%>">
                </div>
                <div class="certificationTypeName">
                    <input type="radio" name="rdoCertificationType" id="rdoFamer"><label for="rdoFamer">Farmer</label>

                </div>
              
            </div>
            <div class="floatRight" style="width: 33%; text-align: center;">
                <div>
                    <img class="certificationImage" src="<%= ResolveUrl("~/Images/Beekeeper.jpg")%>">
                </div>
                <div class="certificationTypeName">
                    <input type="radio" name="rdoCertificationType" id="rdoBeekeeper"><label for="rdoBeekeeper">Beekeeping Operation</label>
                </div>
               
            </div>
            <div style="clear: both"></div>
        </div>

        <div class="rowbot">
            Organization Website
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="255" ID="txtOrgWebsite" runat="server" class="text" ToolTip="Organization Website" placeholder="Organization Website"></asp:TextBox>
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="revOrgWebsite" ControlToValidate="txtOrgWebsite" runat="server" ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Invalid URL" ValidationGroup="RegisterUserStep4"></asp:RegularExpressionValidator>
        </div>
        <div class="rownor" style="margin-top:20px">
            <h3>Bee Friendly Farmer Questions</h3>
        </div>
        <div class="rowbot">
            How do you currently provide forage for bees? (check all that apply)
        </div>
        <div class="rownor">
            <select name="Answer1" id="Answer1" multiple="multiple" class="registerMultiSelect">
                <option value="1">Bee-attractive flowering perennials </option>
                <option value="2">Berries</option>
                <option value="3">Ground covers/cover crops (e.g., clovers, mustard, vetch) </option>
                <option value="4">Restored native meadows, pollinator friendly wildlife plantings  </option>
                <option value="5">Bee-attractive flowering fallow crops </option>
                <option value="6">Flowering hedgerows </option>
                <option value="7">Flowering trees that provide nectar/pollen </option>
                <option value="8">Insectary garden (flowering plants grown to attract beneficial insects)</option>
                <option value="9">"Weedy" areas not managed (allowed to flower)</option>
                <option value="10">Other </option>
            </select>
        </div>

        <div class="rowbot">
            My site is a (select all that apply)
        </div>
        <div class="rownor">
            <select name="Answer2" id="Answer2" multiple="multiple" class="registerMultiSelect">
                <optgroup label="Farm">
                    <option value="Vegetable">Vegetable</option>
                    <option value="Fruit">Fruit</option>
                    <option value="SeedCrop">Seed Crop</option>
                    <option value="Grain">Grain</option>
                </optgroup>

                <option value="Ranch">Ranch</option>
                <option value="Orchard">Orchard</option>
                <option value="Vineyard">Vineyard</option>
                <option value="Timber/Forest">Timber/Forest</option>

                <optgroup label="Beekeeping Operation">
                    <option value="Hobby">Hobby</option>
                    <option value="Small professional hives">Small professional hives</option>
                    <option value="Large professional hives">Large professional hives</option>
                </optgroup>

                <option value="Ranch">Home</option>
                <option value="Utility">Utility</option>
                <option value="Corporation">Corporation</option>
                <option value="Other">Other</option>
            </select>
        </div>
        <div class="rowbot">
            Roughly what % of the landscape that you manage contains bee forage?
        </div>
        <div class="rownor">
            <asp:TextBox MaxLength="255" ID="txtAnswer3" runat="server" class="text"></asp:TextBox>
        </div>


        <div class="rowbot">
            Describe how you provide nesting for bees (check all that apply, minimum 2)
        </div>
        <div class="rownor">
            <select name="Answer4" id="Answer4" multiple="multiple" class="registerMultiSelect">
                <option value="1">Undisturbed (untilled) ground [including bare soil, small cut banks and sand piles]</option>
                <option value="2">Dead trees/snags</option>
                <option value="3">Native bee nesting boxes (for example for mason or leafcutter bees) </option>
                <option value="4">Apiaries (managed honey bees) </option>
            </select>
        </div>

        <div class="rowbot">
            How do you provide reliable water sources for bees?
        </div>
        <div class="rownor">
            <select name="Answer5" id="Answer5" multiple="multiple" class="registerMultiSelect">
                <option value="1">River </option>
                <option value="2">Pond</option>
                <option value="3">Irrigation, rain water collection</option>
                <option value="4">Garden water features </option>
                <option value="5">Other </option>
            </select>
        </div>

        <div class="rowbot">
           Which are the best management practices being used to minimize bee poisonings?
        </div>
        <div class="rownor">
            <select name="Answer6" id="Answer6" multiple="multiple" class="registerMultiSelect">
                <option value="1">Bee-attractive flowering perennials </option>
                <option value="2">Berries</option>
                <option value="3">Ground covers/cover crops (e.g., clovers, mustard, vetch) </option>
                <option value="4">Restored native meadows, pollinator friendly wildlife plantings  </option>
                <option value="5">Bee-attractive flowering fallow crops </option>
                <option value="6">Flowering hedgerows </option>
                <option value="7">Flowering trees that provide nectar/pollen </option>
                <option value="8">Insectary garden (flowering plants grown to attract beneficial insects)  </option>
                <option value="9">"Weedy" areas not managed (allowed to flower)   </option>
                <option value="10">Other </option>
            </select>
        </div>

        <div class="rowbot">
            List the names of plants on your property that seasonally provide pollen and nectar
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer7" runat="server" class="text" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="rowbot">
            What, if any, are the bee pollinated crops grown on your property?
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer8" runat="server" class="text" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="rowbot">
           Do you have any other land certifications?
        </div>
        <div class="rownor">
            <asp:TextBox ID="txtAnswer9" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>
    </div>

    <div class="footer">      
          <div class="rownor" >          
            <div style="text-align: center">
                    <a id="btnFinishBFF" class="submit button btn1 buttonlarge" onclick="registerUserStep4()">
                        <img style="padding-top: 4px;width:40px;" src="<%= ResolveUrl("~/Images/Bee_Friendly_Farmer_Logo.png")%>" />
                        <span style="padding-left: 2.4em; padding-right: 2.2em">&nbsp;&nbsp;&nbsp;&nbsp;Finish and Pay</span>
                        <span class="fa fa-arrow-right"></span>
                    </a>
                </div>
               
		     </div>
               
         <div  style="width:375px;margin: -44px auto 0px; height: 44px;">
                <img class="checking"  style="display:none;"  src="<%=ResolveUrl("~/Images/loading.gif") %>" />        
            </div>      
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function () {
        $('.registerMultiSelect').css("width", "780px");
        $('.registerMultiSelect').multipleSelect();
        $('input[data-group="group_0"]').parent().parent().css("padding-left", "30px");
        $('input[data-group="group_5"]').parent().parent().css("padding-left", "30px");

        //Disable auto close popup when clickshowProcessbar
        $('#Processbar_form').on('click', function (e) {
            e.preventDefault();
        });

    });

    function registerUserStep4() {
        if ($("#btnFinishBFF").attr("disabled") == true)
            return;

        if (!Page_ClientValidate('RegisterUserStep4')) {
            return false;
        }
        $("#step4 .checking").show();
        $("#step4").find("*").attr("disabled", "disabled");

        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: '4',
                orgWebsite: $('#<%=txtOrgWebsite.ClientID%>').val(),
            },
            success: function (data) {
                $("#step4 .checking").hide();
                document.getElementById('showProcessbar').click();
                document.getElementById('paypal_container').innerHTML = data;
                document.getElementById('paypal_btn').click();
            },
            error: function (xhr, status) {
                $("#step4 .checking").hide();
                alert("An error occurred: " + status);
            }
        });

    }
</script>
