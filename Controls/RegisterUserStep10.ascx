<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterUserStep10.ascx.cs" Inherits="Controls_RegisterUserStep9" %>

<%@ Register Src="RegisterUserProgress.ascx" TagName="RegisterUserProgress" TagPrefix="uc" %>
<div class="container registercontainer" id="step10" style="display: none">
    <div class="header">
        <uc:RegisterUserProgress ID="RegisterUserProgess" runat="server" Step="10" Percent="60" />
        <h1>Abour your BFF
        </h1>
        <div class="subHeader">Questionaire</div>
    </div>
    <div class="content">
        <div class="rowbot">
            Describe how you provide nesting for bees (check all that apply, minimum 2)
        </div>
        <div class="rownor">
            <select name="Answer4" id="Answer4" multiple="multiple" style="width: 780px" class="registerSelect">
                <option value="1">Undisturbed (untilled) ground [including bare soil, small cut banks and sand piles]</option>
                <option value="2">Dead trees/snags</option>
                <option value="3">Native bee nesting boxes (for example for mason or leafcutter bees) </option>
                <option value="4">Apiaries (managed honey bees) </option>
            </select>
        </div>

        <div class="rowbot">
            Describe how you provide reliable water sources for bees?
        </div>
        <div class="rownor">
            <select name="Answer5" id="Answer5" multiple="multiple" style="width: 780px" class="registerSelect">
                <option value="1">River </option>
                <option value="2">Pond</option>
                <option value="3">Irrigation, rain water collection</option>
                <option value="4">Garden water features </option>
                <option value="5">Other </option>
            </select>
        </div>

        <div class="rowbot">
            Best Management Practices being used to minimize bee poisonings
        </div>
        <div class="rownor">
            <select name="Answer6" id="Answer6" multiple="multiple" style="width: 780px" class="registerSelect">
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
    </div>

    <div class="footer">
        <div class="floatRight">
            <a id="btnNext11" class="submit button btn1" onclick="registerUserStep10()">
                <img src="<%= ResolveUrl("~/Images/marker/icon-large-0.png")%>" /><span class="buttonText">Next Step</span>  &#10151;
            </a>
        </div>
        <div style="clear: both"></div>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function () {
        $('#Answer4').multipleSelect();
        $('#Answer5').multipleSelect();
        $('#Answer6').multipleSelect();
    });

    function gotoStep11() {
        $("#step10").hide();
        $("#step11").show();
    }
    function registerUserStep10() {

        if (!Page_ClientValidate('RegisterUserStep9')) {
            return false;
        }
        $.ajax({
            url: rootServerPath + "Handlers/RegisterUser.ashx",
            type: "POST",
            data: {
                step: '10',
            },
            dataType: "json",
            success: function (result) {
                gotoStep11();
            },
            error: function (xhr, status) {
                alert("An error occurred: " + status);
            }
        });
    }
</script>