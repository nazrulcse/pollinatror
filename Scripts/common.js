//Bind data to dropdowlist
function fillSelect(data, dropdownlistID, firtItem) {
    $('#' + dropdownlistID).empty();
    if (firtItem !== 'undefined' && firtItem != '' && firtItem.indexOf("|") > 0) {
        var firtVal = firtItem.split("|")[0];
        var firtName = firtItem.split("|")[1];
        $('#' + dropdownlistID).append($("<option></option>").val(firtVal).html(firtName));
    }
    $.each(data, function (i, item) {
        if (item.ID !== 'undefined') {
            $('#' + dropdownlistID).append($("<option></option>").val(item.ID).html(item.Name));
        }
    });
}


function CheckExistUserName(textboxID, lblUserAvailability, validateControlID) {
    var userName = $('#' + textboxID).val();

    //send to webservice
    var dataTransfer = JSON.stringify({
        UserName: userName
    });
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "Register.ashx?UserName=" + userName,
        data: dataTransfer,
        dataType: "json",
        success: function (data, status) {

            //alert(data);
            var result = data.toString();
            //alert('thah cog; ' + result);

            if (result == 'true') {
                $('#' + lblUserAvailability).html("Username already exists. Please enter a different user name.");
                $('#' + lblUserAvailability).removeClass("available");
                $('#' + lblUserAvailability).addClass("taken");
                $('#' + textboxID).focus();
            }
            else {
                $('#' + lblUserAvailability).html("Username is available!");
                $('#' + lblUserAvailability).removeClass("taken");
                $('#' + lblUserAvailability).addClass("available");
            }
        },
        error: function (data, status, e) {
            //alert('that bai');
            console.log(data);
            //alert(e);
        }
    });

}



function Check_cbxUseAsBillingAddress(subPrefix) {
    if ($('#cbxUseAsBillingAddress').prop('checked')) {
        $('#' + subPrefix + 'txtPreBillingAddress').val($('#' + subPrefix + 'txtPreLandscapeStreet').val());
        $('#' + subPrefix + 'txtPreBillingCity').val($('#' + subPrefix + 'txtPreLandscapeCity').val());
        $('#' + subPrefix + 'txtPreBillingState').val($('#' + subPrefix + 'txtPreLandscapeState').val());
        $('#' + subPrefix + 'txtPreBillingZipcode').val($('#' + subPrefix + 'txtPreLandscapeZipcode').val());

        //hide validate controls
        if ($('#' + subPrefix + 'txtPreBillingAddress').val() != '')
            $('#' + subPrefix + 'rfvPreBillingAddress').css("display", "none");

        if ($('#' + subPrefix + 'txtPreBillingCity').val() != '')
            $('#' + subPrefix + 'rfvPreBillingCity').css("display", "none");

        if ($('#' + subPrefix + 'txtPreBillingState').val() != '')
            $('#' + subPrefix + 'rfvPreBillingState').css("display", "none");

        if ($('#' + subPrefix + 'txtPreBillingZipcode').val() != '')
            $('#' + subPrefix + 'rfvPreBillingZipcode').css("display", "none");

    } else {
        //show validate
        if ($('#' + subPrefix + 'txtPreBillingAddress').val() != '')
            $('#' + subPrefix + 'rfvPreBillingAddress').css("display", "inline");

        if ($('#' + subPrefix + 'txtPreBillingCity').val() != '')
            $('#' + subPrefix + 'rfvPreBillingCity').css("display", "inline");

        if ($('#' + subPrefix + 'txtPreBillingState').val() != '')
            $('#' + subPrefix + 'rfvPreBillingState').css("display", "inline");

        if ($('#' + subPrefix + 'txtPreBillingZipcode').val() != '')
            $('#' + subPrefix + 'rfvPreBillingZipcode').css("display", "inline");

        //reset value
        $('#' + subPrefix + 'txtPreBillingAddress').val('');
        $('#' + subPrefix + 'txtPreBillingCity').val('');
        $('#' + subPrefix + 'txtPreBillingState').val('');
        $('#' + subPrefix + 'txtPreBillingZipcode').val('');
    }
}

function SelectPremiumLevel(level, subPrefix) {
    $('#' + subPrefix + 'HiddenPremiumLevel').val(level);
    if (level==1) {
        $('#divLevel1').addClass('membershipSelected');
        $('#divLevel2').removeClass('membershipSelected');
        $('#divLevel3').removeClass('membershipSelected');

        $('#btnLevel1').html('Your');
        $('#btnLevel2').html('Select');
        $('#btnLevel3').html('Select');

        
        $('#btnLevel1').addClass('btn15');
        $('#btnLevel1').removeClass('btn9');

        $('#btnLevel2').addClass('btn9');
        $('#btnLevel2').removeClass('btn15');

        $('#btnLevel3').addClass('btn9');
        $('#btnLevel3').removeClass('btn15');
    }
    else if (level == 2) {
        $('#divLevel2').addClass('membershipSelected');
        $('#divLevel1').removeClass('membershipSelected');
        $('#divLevel3').removeClass('membershipSelected');

        $('#btnLevel2').html('Your');
        $('#btnLevel1').html('Select');
        $('#btnLevel3').html('Select');


        $('#btnLevel2').addClass('btn15');
        $('#btnLevel2').removeClass('btn9');

        $('#btnLevel1').addClass('btn9');
        $('#btnLevel1').removeClass('btn15');

        $('#btnLevel3').addClass('btn9');
        $('#btnLevel3').removeClass('btn15');
    }
    else {
        $('#divLevel3').addClass('membershipSelected');
        $('#divLevel1').removeClass('membershipSelected');
        $('#divLevel2').removeClass('membershipSelected');

        $('#btnLevel3').html('Your');
        $('#btnLevel1').html('Select');
        $('#btnLevel2').html('Select');


        $('#btnLevel3').addClass('btn15');
        $('#btnLevel3').removeClass('btn9');

        $('#btnLevel1').addClass('btn9');
        $('#btnLevel1').removeClass('btn15');

        $('#btnLevel2').addClass('btn9');
        $('#btnLevel2').removeClass('btn15');
    }
}

//Change style when choice Normal User/Premium User
function ShowRegisterForm(memberType) {
    if (memberType == 'premium') {
        $('#divRowRegPremium').show();
        $('#divRowRegNormal').hide();

        //set focus
        $('#MainContent_Register1_LoginView1_txtPreFirstName').focus();
    }
    else {
        $('#divRowRegNormal').show();
        $('#divRowRegPremium').hide();
    }
}

function SwitchUserUpdateForm(memberType) {
    if (memberType == 'premium') {
        $('#divRowRegPremium').show();
        $('#divRowRegNormal').hide();
        //set focus
        $('#MainContent_txtNorFirstName').focus();
    }
    else {
        $('#divRowRegNormal').show();
        $('#divRowRegPremium').hide();

        //set focus
        $('#MainContent_txtNorFirstName').focus();
    }
}
