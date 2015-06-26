var googleMap;
var geocoder;
var lastWindow;
var markers = [];
var markerArrays = [];
var markerCluters = new Array();
var data = [];
var searchRequest;

//var pollinator_size = {"1": "Small planter or balcony (30 square feet or less)", "2": "Small garden (30 to 100 square feet)", "3": "Large garden (100 to 1000 square feet)", "4": "Small Yard (1000 to 5000 square feet)", "5": "Medium Yard (1\/2 Acre or less)", "6": "Large Yard (1 Acre or less)", "7": "Field (1 to 5 Acres)", "8": "Large Field (5 to 10 Acres)", "9": "I Dont Know"};

var pollinator_type = [];
if (typeof typejson !== 'undefined') {
    for (n in typejson) {
        pollinator_type[typejson[n]["ID"]] = typejson[n]["Name"];
    }
}
var pollinator_size = [];
if (typeof sizejson !== 'undefined') {
    for (n in sizejson) {
        pollinator_size[sizejson[n]["ID"]] = sizejson[n]["Name"];
    }
}

var CountryAbbr = {};
if (typeof countryjson !== 'undefined') {
    for (n in countryjson) {
        CountryAbbr[countryjson[n]["ID"]] = countryjson[n]["Name"];
    }
}

var pollinatorTypeMapColor = ["#507e90", "#9f0047", "#92009f", "#357100", "#b00000", "#5a9300", "#406e60", "#007fba", "#007d85", "#557d85"];
var numPolinatorType = 9;
for (var i = 0; i <= numPolinatorType; i++) {
    markerTs = [];
    markerArrays.push(markerTs);
}


var pollinatorTypeImageName = ["Garden", "School", "Farm", "Government", "ROW", "Church", "Corporate", "Nonprofit", "Other"];

var StateAbbr = {
    "AL": "Alabama",
    "AK": "Alaska",
    "AS": "American Samoa",
    "AZ": "Arizona",
    "AR": "Arkansas",
    "CA": "California",
    "CO": "Colorado",
    "CT": "Connecticut",
    "DE": "Delaware",
    "DC": "District Of Columbia",
    "FM": "Federated States Of Micronesia",
    "FL": "Florida",
    "GA": "Georgia",
    "GU": "Guam",
    "HI": "Hawaii",
    "ID": "Idaho",
    "IL": "Illinois",
    "IN": "Indiana",
    "IA": "Iowa",
    "KS": "Kansas",
    "KY": "Kentucky",
    "LA": "Louisiana",
    "ME": "Maine",
    "MH": "Marshall Islands",
    "MD": "Maryland",
    "MA": "Massachusetts",
    "MI": "Michigan",
    "MN": "Minnesota",
    "MS": "Mississippi",
    "MO": "Missouri",
    "MT": "Montana",
    "NE": "Nebraska",
    "NV": "Nevada",
    "NH": "New Hampshire",
    "NJ": "New Jersey",
    "NM": "New Mexico",
    "NY": "New York",
    "NC": "North Carolina",
    "ND": "North Dakota",
    "MP": "Northern Mariana Islands",
    "OH": "Ohio",
    "OK": "Oklahoma",
    "OR": "Oregon",
    "PW": "Palau",
    "PA": "Pennsylvania",
    "PR": "Puerto Rico",
    "RI": "Rhode Island",
    "SC": "South Carolina",
    "SD": "South Dakota",
    "TN": "Tennessee",
    "TX": "Texas",
    "UT": "Utah",
    "VT": "Vermont",
    "VI": "Virgin Islands",
    "VA": "Virginia",
    "WA": "Washington",
    "WV": "West Virginia",
    "WI": "Wisconsin",
    "WY": "Wyoming"
};


function initialize() {
    geocoder = new google.maps.Geocoder();
    googleMap = new google.maps.Map(document.getElementById('map-canvas'), {
        center: new google.maps.LatLng(42.381064, -96.338008),
        zoom: 10,
        scrollwheel: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    if (typeof sponsorlink !== 'undefined') {
        var logoControlDiv = document.createElement('div');
        MapLogoControl(logoControlDiv);
        logoControlDiv.index = 0; // used for ordering
        googleMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(logoControlDiv);
    }

    if (getCookie("mousewwheel") == "1") {
        $("input[id='mousewwheel']").attr("checked", true);
        googleMap.setOptions({ scrollwheel: true });
    }

    var searchControlDiv = document.createElement('div');
    MapSearchControl(searchControlDiv);
    searchControlDiv.index = 0; // used for ordering
    googleMap.controls[google.maps.ControlPosition.TOP_RIGHT].push(searchControlDiv);
    setData();

}

function MapLogoControl(controlDiv) {
    if (typeof sponsorlink !== 'undefined') {
        var sponsorcount = sponsorlink.length;
        if (sponsorcount > 0) {

            controlDiv.style.padding = '5px';
            controlDiv.style.position = 'relative';
            controlDiv.style.textAlign = 'center';

            var logo = document.createElement('img');
            logo.id = "map-sponsor";
            var num = Math.floor(Math.random() * sponsorcount);
            logo.src = rootServerPath + sponsorlink[num]["PhotoUrl"];
            logo.style.cursor = 'pointer';

            controlDiv.appendChild(logo);

            google.maps.event.addDomListener(logo, 'click', function () {
                window.open(sponsorlink[num]["Website"], '_blank');
            });
        }
    }
}

function MapSearchControl(controlDiv) {
    controlDiv.style.padding = '5px 0px';
    controlDiv.style.position = 'relative';
    controlDiv.id = "searchmaps";

    var searchbox = document.createElement('input');
    searchbox.type = "text";
    searchbox.id = "sq";
    controlDiv.appendChild(searchbox);

    var searchsubmit = document.createElement('input');
    searchsubmit.type = "button";
    searchsubmit.id = "btns";
    searchsubmit.value = "Search";
    controlDiv.appendChild(searchsubmit);

    if (typeof widget !== 'undefined' && widget == true) {
        var link_popout = document.createElement('input');
        link_popout.type = "button";
        link_popout.id = "linkpopout";
        controlDiv.appendChild(link_popout);

        google.maps.event.addDomListener(link_popout, 'click', function () {
            window.open(link, "_blank");
        });

    }

    google.maps.event.addDomListener(searchsubmit, 'click', function () {
        doSearch();
        $("#tool-box").click();
    });

    google.maps.event.addDomListener(searchbox, 'keydown', function (event) {
        if (event.which == 13) {
            searchsubmit.focus();
            doSearch();
            $("#tool-box").click();
            return false;
        }
    });

}

/* GVIZ - get data from Fusion Tables */

function setData() {
    if ($("#isSearching").val() === "true") {
        if (searchRequest) {
            searchRequest.abort();
            //console.log("abort before request");
        }
    }

    var keyword;
    if ($("#txtSearchPolAdv").val() == "") {
        keyword = $("input[id='sq']").val();
        $("#txtSearchPolAdv").val(keyword);
    }
    else {
        keyword = $("#txtSearchPolAdv").val();
    }

    var userType = '';
    var pollinatorType = '';
    var findOutFilter = '';

    if (typeof widget !== 'undefined' && widget == true) {
        var PremiumValue = 0;
        var PollinatorLocationType = $('#PollinatorType').val();
        if (PollinatorLocationType !== null) {
            var PremiumIndex = PollinatorLocationType.indexOf("premium");
            if (PremiumIndex > -1) {
                PollinatorLocationType.splice(PremiumIndex, 1);
                userType = userType + '1,2,3';
            }
            if (PollinatorLocationType != null) {
                if (PollinatorLocationType.length > 0)
                    pollinatorType = PollinatorLocationType.join();
            }
        }
    }
    else {
        var chkShare = $("#chkShare").is(":checked");
        var chkBFF = $("#chkBFF").is(":checked");

        if (chkShare == true) {
            userType = ',0';
        }
        if (chkBFF == true) {
            userType = userType + ',1,2,3';
        }
        if (userType.length > 0)
            userType = userType.substr(1);

        if (typeof typejson != 'undefined') {
            for (n in typejson) {
                if (typejson[n]["ID"]) {
                    if ($("#chkType" + typejson[n]["ID"]).is(":checked")) {
                        pollinatorType = pollinatorType + ',' + typejson[n]["ID"];
                    }
                }
            }
            if (pollinatorType.length > 0)
                pollinatorType = pollinatorType.substr(1);
        }
        /*for (var i = 1; i <= 12; i++) {
            if ($("#chkFilter"+i).is(":checked") == true) {
                findOutFilter = findOutFilter + ',' + i;
            }
        }
        if (findOutFilter.length > 0)
            findOutFilter = findOutFilter.substr(1);*/
        var ddlFilterFindOut = $('#ddlFilterFindOut').val();
        if (ddlFilterFindOut != null && ddlFilterFindOut.length > 0)
            findOutFilter = ddlFilterFindOut.join();
    }

    /*console.log("userType:" + userType);
    console.log("pollinatorType:" + pollinatorType);
    console.log("findOutFilter:" + findOutFilter);  */

    $("#isSearching").val(true);

    var request = $.ajax({
        url: rootServerPath + "Handlers/getMarker.ashx",
        type: "GET",
        data: {
            'keyword': keyword,
            'userType': userType,
            'findOutFilter': findOutFilter,
            'pollinatorType': pollinatorType,
        },
        dataType: "json",
        success: function (result) {
            data = result;
            parserData(null, null, 0);
        }
    });
    searchRequest = request;

    request.done(function (msg) {
    });
    request.fail(function (jqXHR, textStatus) {
        if (textStatus != "abort") {
            console.log("Request failed: " + textStatus);
            $("#isSearching").val(false);
            $('#imgLoadOnSelect').css('display', 'none');
            $("input[type='checkbox']").removeAttr("disabled");
        }
    });
}

function parserData(keyword, type, premium) {
    if (typeof data == 'undefined' || data == null) {
        $("#isSearching").val(false);
        $('#imgLoadOnSelect').css('display', 'none');
        $("input[type='checkbox']").removeAttr("disabled");
        $("input[name='ddlFilterFindOut']").removeAttr("disabled");
        $('#ddlFilterFindOut').multipleSelect('enable');
        if (typeof widget !== 'undefined' && widget == true) {
            $('#PollinatorType').multipleSelect('enable');
            $("input[name='selectItemPollinatorType']").removeAttr("disabled");
        }
        return;
    }

    numRows = data.length;
    htmlresult = "<ul>";
    htmlresultuname = "";
    untitle = 0;
    $.each(data, function (index, row) {
        showMarker(index);
        if (row['OrganizationName'] != '' && row['OrganizationName'] != null) {
            htmlresult += '<li onclick="setCenter(' + index + ',0)"><a href="javascript:;">' + row['OrganizationName'].replace(/(<([^>]+)>)/ig, "") + '</a></li>';
        } else {
            untitle++;
            htmlresultuname += '<li onclick="setCenter(' + index + ',0)"><a href="javascript:;">Unknown Organization #' + untitle + '</a></li>';
        }
    });


    for (var i = 0; i <= numPolinatorType; i++) {
        var clusterStyles = [
             {
                 height: 35,
                 width: 35,
                 anchor: [0, 0],
                 textColor: 'white',//'#ff00ff',
                 textSize: 10,
                 backgroundColor: pollinatorTypeMapColor[i],
                 opacity:'0.5',
                 borderRadius: '50%'
                 
             }, {
                 height: 45,
                 width: 45,
                 anchor: [0, 0],
                 textColor: 'white',//'#ff0000',
                 textSize: 11,
                 backgroundColor: pollinatorTypeMapColor[i],
                 opacity: '0.5',
                 borderRadius: '50%'
             }, {

                 height: 55,
                 width: 55,
                 anchor: [0, 0],
                 textColor: 'white',//'#ffffff',
                 textSize: 12,
                 backgroundColor: pollinatorTypeMapColor[i],
                 opacity: '0.5',
                 borderRadius: '50%'
             }
        ];

        if (markerCluters[i]) {
            markerCluters[i].clearMarkers();
        }

        markerCluters[i] = new MarkerClusterer(googleMap, markerArrays[i], {
             maxZoom: '10',
            // gridSize: size,
            styles: clusterStyles
        });
    }



    htmlresult += htmlresultuname;
    htmlresult += "</ul>";

    if (numRows == 1) {
        var coordinate = new google.maps.LatLng(data[0]['Latitude'], data[0]['Longitude']);
        googleMap.setOptions({ center: coordinate, zoom: 4 });
    } else if (numRows > 1) {
        var coordinate = new google.maps.LatLng(42.381064, -96.338008);
        googleMap.setOptions({ center: coordinate, zoom: 4 });
    } else {
        var coordinate = new google.maps.LatLng(39, 39);
        googleMap.setOptions({ center: coordinate, zoom: 4 });
        htmlresult = "<div>No entries match.</div>";
    }
    $("#map-search-result").html(htmlresult);
    $("#orgtitle").html("Organization (" + numRows + ")");


    $("#isSearching").val(false);
    $('#imgLoadOnSelect').css('display', 'none');
    $("input[type='checkbox']").removeAttr("disabled");

    /* Group marker
        markerClusterer = new MarkerClusterer(map, markers, {
            maxZoom: 7,
            minZoom: 5,
            gridSize: 90
        });
    */
    $('#ddlFilterFindOut').multipleSelect('enable');
    $("input[name='ddlFilterFindOut']").removeAttr("disabled");
    if (typeof widget !== 'undefined' && widget == true) {

        if ($('#PollinatorType').data('change') == 'true') {
            $('#imgLoadOnSelect').css('display', 'none');
            $('#PollinatorType').data('change', 'false');
            $('#PollinatorType').multipleSelect('enable');
            $("input[name='selectItemPollinatorType']").removeAttr("disabled");
        }
    }
}

function setCenter(pid, zoom) {
    var coordinate = new google.maps.LatLng(data[pid]['Latitude'], data[pid]['Longitude']);
    if (zoom != 0) {
        var zoomin = map.getZoom();
        if (zoomin < 8) {
            zoomin = 8;
        } else if (zoomin < 21) {
            zoomin += 1;
        }
    } else {
        zoomin = 8;
    }

    googleMap.setOptions({ center: coordinate, zoom: zoomin });

    showInfoWindow(pid);
}


function showmore(ele) {
    console.log($(ele));
    $(ele).next(".moredesc").css("display", "block");
    $(ele).hide();
}

function youtubevideo(url) {
    var v = null;
    var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    var match = url.match(regExp);
    if (match && match[2].length == 11) {
        v = match[2];
    }
    return v;
}

function infoWindowsHtml(pid, userType, org, desc, addr, size, type, img, utube, web, user) {

    var infohtml = "";
    if (org !== "" && org !== null) {
        org = org.replace(/(<([^>]+)>)/ig, "");
    }
    else {
        if (userType == "0")//share
        {
            org = "SHARE Member";
        }
        else {
            org = "BFF Member";
        }
    }
    infohtml += "<h2 class='info-window-header'>" + org + "</h2><hr />";
    infohtml += "<div class='googft-info-window'>"
    infohtml += "<div style='width:50%; float:left'>";

    infohtml += "<ul class='info'>"
    // console.log("type:" + type + ",size:" + size + ",addr" + addr);
    /* if ((type > 0 && type < 10) || (size > 0 && size < 10)) {
         infohtml += "<li class='pollinator-size' style='white-space: pre-line;'>";
         if (type > 0 && type < 10) {
             infohtml += pollinator_type[type];
             if ((size > 0 && size < 10) && size != 9) {
                 infohtml += ", ";
             }
         }
         if ((size > 0 && size < 10) && size != 9) {
             infohtml += pollinator_size[size];
         }
         infohtml += "</li>";
     }*/
    if (addr !== "" && addr !== null) {
        addr = addr.replace(/(<([^>]+)>)/ig, "");
        infohtml += "<li>" + addr + "</li>";
    }

    if (userType != "0" && web !== "" && web !== null) {
        web = web.replace(/(<([^>]+)>)/ig, "");
        if (web.indexOf("http://") == -1) {
            web = "http://" + web;
        }
        infohtml += "<li><strong>Website</strong>: <a href='" + web + "' target='_blank'>" + web + "</a></li>";
    }

    infohtml += "</ul>";

    infohtml += "</div>";
    infohtml += "<div style='width:50%; float:right'>";
    if (img !== "" && img !== null) {

        var img_url;
        if (img.indexOf(';') != -1) {
            var img_arr = img.split(';');
            img_url = img_arr[0].trim();
        } else {
            img_url = img.trim();
        }
        if (img_url.indexOf('UploadFiles') > -1) {
            img_url = rootServerPath + img_url;
        }
    }
    else {
        if (userType == "0") {//share
            img_url = rootServerPath + "Images/SHARElogoNoTextFINAL.png";
        }
        else {
            img_url = rootServerPath + "Images/logo/Bee-Friendly-Farmer-Logo.png";
        }
    }

    // infohtml += "<li><strong>Photo</strong>:<br />";
    infohtml += "<p class='img'><a href='" + img_url + "' target='_blank'><img src='" + img_url + "' onerror='this.src = \"" + rootServerPath + "Images/none.png\"; $(this).parent().parent().parent().hide();' /></a></p>";
    // infohtml += "</li>";
    infohtml += "</div>";
    infohtml += "<div style='clear:both'></div>";

    if (userType != "0" && desc !== "" && desc !== null) {
        desc = desc.replace(/(<([^>]+)>)/ig, "");
        infohtml += "<div>";
        infohtml += "<p> Description </p>";
        infohtml += "<p style='padding-left:20px;'>" + desc + "</p>";
        infohtml += "</div>";
    }


    if (utube !== "" && utube !== null) {
        console.log("/// UTUBE: " + utube);
        infohtml += "<li><strong>Video</strong>:<br />";
        if (utube.indexOf(';') != -1) {
            var utube_arr = utube.split(';');
            var videoarr = [];
            jQuery.each(utube_arr, function (ui, video) {
                var vi = youtubevideo(video);
                videoarr[ui] = " <a href='" + video.trim() + "' target='_blank'><img src='http://img.youtube.com/vi/" + vi + "/1.jpg' onload='if(this.src.indexOf(\"null\") !== -1) {$(this).hide();}'></a>";
            });
            infohtml += videoarr.join(" ") + "</li>";
        } else {

            var vi = youtubevideo(utube);
            console.log("/// UTUBE2(vi): " + vi);
            infohtml += "<li><a href='" + utube.trim() + "' target='_blank'><img src='http://img.youtube.com/vi/" + vi + "/1.jpg' onload='if(this.src.indexOf(\"null\") !== -1) {$(this).hide();}'></a></li>";
        }
    }

    infohtml += "</div>";


    infohtml += "<ul class='callout-link-bottom'><li><a href='javascript:setCenter(" + pid + ",1);' style='color: #3764A0'>Go here</a></li>";
    if (user !== "") {
        if (img !== "" && img !== null) {
            if (img.indexOf(';') != -1) {
                infohtml += "<li><a href='" + rootServerPath + "PollinatorInfo?user=" + user + "' target='_bank' style='color: #3764A0'>See more photos</a></li>";
            }
        }
    }
    infohtml += "</ul>";

    return infohtml;
}

function isempty(x) {
    if (x !== "" && x !== " " && x != null)
        return true;
}

function showMarker(index) {
    var coordinate = new google.maps.LatLng(data[index]['Latitude'], data[index]['Longitude']);
    if (data[index]['MembershipLevel'] == 1) {
        var zind = 2;
        //  var icon = rootServerPath + "Images/marker/icon-large-0.png";
    } else {
        var zind = 1;
        //   var icon = rootServerPath + "Images/marker/icon-small-" + data[index]['PollinatorType'] + ".png";
        //var icon = rootServerPath + "Images/icon/" + pollinatorTypeImageName[data[index]['PollinatorType']-1] + ".png";
    }

    var pinColor = pollinatorTypeMapColor[data[index]['PollinatorType']].replace("#", "");//"9f0047";
    var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
        new google.maps.Size(21, 34),
        new google.maps.Point(0, 0),
        new google.maps.Point(10, 34));
    var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
        new google.maps.Size(40, 37),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 35));

    var marker = new google.maps.Marker({
        map: googleMap,
        position: coordinate,
        icon: pinImage,
        shadow: pinShadow,
        opacity: 0.7,
        /* icon: new google.maps.MarkerImage(
             icon,
                new google.maps.Size(18, 18), //size
             new google.maps.Point(0, 0), //origin
             new google.maps.Point(0, 0) //anchor 
             ),*/
        zIndex: zind
    });
    markers.push(marker);
    markerArrays[data[index]['PollinatorType']].push(marker);  
    google.maps.event.addListener(marker, 'click', function (event) {
        showInfoWindow(index);
    });
}

function showInfoWindow(index) {

    if ($.inArray(data[index]['LandscapeState'], StateAbbr) != -1) {
        var state = StateAbbr[data[index]['LandscapeState']];
    } else {
        var state = data[index]['LandscapeState'];
    }

    if (CountryAbbr.hasOwnProperty(data[index]['LandscapeCountry']) == true) {
        var country = CountryAbbr[data[index]['LandscapeCountry']];
    } else {
        var country = data[index]['LandscapeCountry'];
    }

    var addr = [/*data[index]['LandscapeStreet'], */data[index]['LandscapeCity'], state, country];
    addr = addr.filter(isempty);

    html = infoWindowsHtml(index, data[index]['MembershipLevel'], data[index]['OrganizationName'], data[index]['Description'], addr.join(", "), data[index]['PollinatorSize'], data[index]['PollinatorType'], data[index]['PhotoUrl'], data[index]['YoutubeUrl'], data[index]['Website'], data[index]['UserId']);

    if (lastWindow) lastWindow.close();
    var coordinate = new google.maps.LatLng(data[index]['Latitude'], data[index]['Longitude']);
    lastWindow = new google.maps.InfoWindow({
        position: coordinate,
        content: html
    });


    lastWindow.open(googleMap, markers[index]);
    //map.setOptions({ center: coordinate });

}

function setAllMap(googleMap) {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(googleMap);
    }
}

function clearMarkers() {
    if (lastWindow) lastWindow.close();
    setAllMap(null);
}


function showMarkers() {
    setAllMap(googleMap);
}

function deleteMarkers() {
    clearMarkers();
    markers = [];
    for (var i = 0; i <= numPolinatorType; i++) {
        markerArrays[i] = [];
    }
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i].trim();
        if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
    }
    return "";
}

function doSearch() {

    $('#imgLoadOnSelect').css('display', 'block');
    //  $("input[type='checkbox']").attr("disabled", true);
    deleteMarkers();
    setData();
}

function showAllPolinatorType() {
    if (typeof typejson != 'undefined') {
        for (n in typejson) {
            if (typejson[n]["ID"]) {
                $("#chkType" + typejson[n]["ID"]).attr("checked", true);

            }
        }
        //  $("input[id='sq']").val("");
        doSearch();
    }
}

$(document).ready(function () {


    if (typeof orgjson != 'undefined') {        
        for (n in orgjson) {
            if (orgjson[n]["ID"]) {                  
                    $("#ddlFilterFindOut").append('<option value=' + orgjson[n]["ID"] + '>' + orgjson[n]["Name"] + '</option>');
            }
        }
    }
    

    if (typeof typejson != 'undefined') {
        if (typeof widget !== 'undefined' && widget == true) {
            for (n in typejson) {
                if (typejson[n]["ID"]) {                  
                    $("#PollinatorType").append('<option value=' + typejson[n]["ID"] + '>' + typejson[n]["Name"] + '</option>');
                }
            }
        }
        else {
            for (n in typejson) {
                if (typejson[n]["ID"]) {
                    var index = typejson[n]["ID"] - 1;
                    // $("#PollinatorType").append('<option value=' + typejson[n]["ID"] + '>' + typejson[n]["Name"] + '</option>');
                    var innerHTML = '<div style="text-align: center">' +
                                        '<div style="background-color:#B3D1FF;border-radius:10px; padding: 20px;">' +
                                             '<img class="imgPollinatorTypeFilter" src="' + rootServerPath + 'Images/FilterImage/' + pollinatorTypeImageName[index] + '.JPG" />' +
                                         '</div>' +
                                        '<div style="margin-top: 10px;margin-bottom: -5px">' +
                                            '<label style="text-align: center" title="' + typejson[n]["Name"] + '">' +
                                            ' <input type="checkbox" id="chkType' + typejson[n]["ID"] + '" onchange="doSearch();" />' +
                                             '<span ><img style="display:inline;;width: 18px;height: 18px;" src="' + rootServerPath + 'Images/icon/' + pollinatorTypeImageName[index] + '.png">' +
                                             '<span style="display:inline">&nbsp;' + typejson[n]["Name"] + '</span></span></label>' +
                                        '</div>' +
                                 '</div>';
                    $(".bxslider").append('<li>' + innerHTML + '</li>');
                }
            }
            $('.bxslider').bxSlider({
                minSlides: 3,
                maxSlides: 4,
                slideWidth: 200,
                slideMargin: 30
            });
        }

    }

    $("input[id='mousewwheel']").change(function () {
        if ($("input[id='mousewwheel']").attr('checked')) {
            googleMap.setOptions({ scrollwheel: true });
            setCookie("mousewwheel", 1, 365);
        } else {
            googleMap.setOptions({ scrollwheel: false });
            setCookie("mousewwheel", 0, 365);
        }
    });

    $("#tool-box").click(function () {
        if ($("#map-canvas").width() > 900) {
            $("#map-canvas").css("width", "-=266");
            $("#tool-box").hide();
            $(".map-search").show();
        }
    });
    $(".map-tool-icon-close").click(function () {
        if ($("#map-canvas").width() < 900) {
            $("#map-canvas").css("width", "+=266");
            $("#tool-box").show();
            $(".map-search").hide();
        }

    });

    $("#txtSearchPolAdv").keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            event.preventDefault();
            $("input[id='sq']").val("");
            doSearch();
        }
    })

    $('#ddlFilterFindOut').change(function () {
        $('#imgLoadOnSelect').css('display', 'block');
        $('#ddlFilterFindOut').multipleSelect('disable');
        $("input[name='ddlFilterFindOut']").attr("disabled", true);
        $(this).data('change', 'true');

        $("input[id='sq']").val("");
        doSearch();;
    }).multipleSelect({ placeholder: "Please select", });

    if (typeof widget !== 'undefined' && widget == true) {
        $('#PollinatorType').change(function () {
            $('#imgLoadOnSelect').css('display', 'block');
            $('#PollinatorType').multipleSelect('disable');
            $("input[name='selectItemPollinatorType']").attr("disabled", true);
            $(this).data('change', 'true');

            $("input[id='sq']").val("");
            doSearch();
        }).multipleSelect({
            selectAll: false,
            placeholder: "Please select",
            iconer: function (value) {
                if (value == 'premium') {
                    return rootServerPath + 'Images/marker/icon-large-0.png';
                }
                if (value == '1') {
                    return rootServerPath + 'Images/marker/icon-small-1.png';
                }
                if (value == '2') {
                    return rootServerPath + 'Images/marker/icon-small-2.png';
                }
                if (value == '3') {
                    return rootServerPath + 'Images/marker/icon-small-3.png';
                }
                if (value == '4') {
                    return rootServerPath + 'Images/marker/icon-small-4.png';
                }
                if (value == '5') {
                    return rootServerPath + 'Images/marker/icon-small-5.png';
                }
                if (value == '6') {
                    return rootServerPath + 'Images/marker/icon-small-6.png';
                }
                if (value == '7') {
                    return rootServerPath + 'Images/marker/icon-small-7.png';
                }
                if (value == '8') {
                    return rootServerPath + 'Images/marker/icon-small-8.png';
                }
                if (value == '9') {
                    return rootServerPath + 'Images/marker/icon-small-9.png';
                }
                if (value == '0') {
                    return rootServerPath + 'Images/marker/icon-small-0.png';
                }
            },
            styler: function (value) {
                if (value == 'premium') {
                    return 'background-color: #fffae5; color: #038b00; font-weight: bold';
                }
                return 'color:' + pollinatorTypeMapColor[parseInt(value)] + ';';            
            }
        });
    }
});

new google.maps.event.addDomListener(window, 'load', initialize);
