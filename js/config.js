
window._skel_panels_config = {
	preset: 'standard'
};
$(document).ready(function () {
    $("#tabContent").find("[id^='tab']").hide(); // Hide all content
    $("#tabs li:first").attr("id","current"); // Activate the first tab
    $("#tabContent #tab1").fadeIn(); // Show first tab's content

    $("#tabContent").find("[class^='separatorLine']").hide();//hide seperatorLine
    $('#tabs a').click(function(e) {
        e.preventDefault();
        if ($(this).closest("li").attr("id") == "current"){ //detection for current tab
         return;       
        }
        //Vinh add them cho Tab Show More
        else if ($(this).attr("class") == "tabShowMore") {
            $("#tabContent").find("[id^='tab']").show(); // Hide all content
            $("#tabs li").attr("id", ""); //Reset id's
            $(this).parent().attr("id", "current"); // Activate this

            $("#tabContent").find("[id^='showtab']").hide();//show Next/Back Step...
            $("#tabContent").find("[class^='separatorLine']").show();
        }
        else{             
          $("#tabContent").find("[id^='tab']").hide(); // Hide all content
          $("#tabs li").attr("id",""); //Reset id's
          $(this).parent().attr("id","current"); // Activate this
          $('#' + $(this).attr('name')).fadeIn(); // Show content for the current tab

          $("#tabContent").find("[id^='showtab']").show();//show Next/Back Step...
          $("#tabContent").find("[class^='separatorLine']").hide();//hide seperatorLine
        }
    });

    //Vinh.ngo add nav for Next Step/Back Step
    $('.tabnav a').click(function (e) {
        e.preventDefault();
        var showedTabID = $(this).attr("id").replace("show", "");
            $("#tabContent").find("[id^='tab']").hide(); // Hide all content
            $("#tabs li").attr("id", ""); //Reset id's
            $('.' + showedTabID).closest("li").attr("id", "current"); // Activate this
            $('#' + showedTabID).fadeIn(); // Show content for the current tab
    });
});
$(function() {
				
				//var foo = $('#gallery');
				//foo.poptrox({
				//	usePopupCaption: true
				//});
			
});