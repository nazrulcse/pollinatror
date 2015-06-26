/*
* jQuery File Upload Plugin JS Example 5.0.2
* https://github.com/blueimp/jQuery-File-Upload
*
* Copyright 2010, Sebastian Tschan
* https://blueimp.net
*
* Licensed under the MIT license:
* http://creativecommons.org/licenses/MIT/
*/

/*jslint nomen: true */
/*global $ */

function getParameterByName(name)
{
  //  getParameterByUrlAndName(window.location.href, name);
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null)
        return "";
    else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
}

function getParameterByUrlAndName(url, name) //courtesy Artem
{
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(url);
    if (results == null)
        return "";
    else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
}

//Get Customize name to display on div
function getNameCustom(name) {
    if (name.length > 32) {
        var sub1 = name.substring(1, 19);
        var sub2 = name.substring(name.length - 10);
        name = sub1 + '...' + sub2;
    }
    return name;
}
