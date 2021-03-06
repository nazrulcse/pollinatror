/**
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	--------------------------------------------------------------------
	
	Simple banner rotator. Version: 1.4.0
	Download and support: http://www.spyka.net 
	(c) Copyright 2008, 2009 spyka Web Group
	

	For full documentation:  http://www.spyka.net/docs/simple-banner-rotator
	For support:			 http://www.spyka.net/forums


**/

//								EDIT FROM HERE
///////////////////////////////////////////////////////////////////////////////////

/**
		Script settings
**/

var settings = {
	
	'force_size':			0,         		// 	if set to 1 all banners will be resized to the width and height in the next to settings
	'img_width':			468,			//	width to resize all banners to, only takes effect if above is 1
	'img_height':			60, 			// 	height to resize all banners to, only takes effect if above is 1
	
	'refresh_time':			5000,			//	the seconds between refreshs of the banners - use 0 to disable
	'refresh_max':			9000,				//	maximum number of refreshs on each page load
	
	'duplicate_banners':	0,				//	keep as 0 to make sure the same banner won't show on the same page. will only take effect
											//  if show_banners(); is used more than once. You must make sure you have enough banners to fill
											//  all the slots else the browser may freeze or give a stack overflow error
	
	'location_prefix': 		'listlogo-',	//	The prefix of the IDs of the <div> which wraps the banners - this div is generated dynamically.
											//  a number will be added on the end of this string. adLocation- was used by default before version 1.4.x
											
	'location_class':		'swb',			//  A class to add to all of the <div>s which wrap the banners, ideal to use for styling banners - use .swb img in your CSS	
	
	'window': 				'_self',		//	Window to open links in, _self = current, _blank = new. Use _top if in a frame!		
	
	'default_ad_loc':		'default',		//	The default adLocation. This is assigned to any banners not given an adLocation in the below banner list
    //  There is no real reason to need to change this
    'sequence':true
}


/**
		Banners
**/
// banner list syntax: new banner(website_name, website_url, banner_url, show_until_date, adlocation),  DATE FORMAT: dd/mm/yyyy
// if you're not using adlocations just leave it empty like '' as in the last example here
// to make sure a banner is always rotating, just set the date far into the future, i.e. year 3000

/*var banners = [
	new banner('AwesomeStyles',			'http://www.awesomestyles.com', 			'images/4.jpg', 	'30/04/2019',	'bottom'),
	new banner('Just Free Templates',	'http://www.justfreetemplates.com', 		'images/5.jpg',		'10/04/2019',	'bottom'),
	new banner('Flashden', 				'http://www.flashden.net/?ref=spykawg', 	'images/3.jpg',		'30/04/2019',	'top'),
	new banner('ThemeForest', 			'http://www.themeforest.net/?ref=spykawg', 	'images/2.jpg', 	'10/04/2019',	'top'),
	new banner('GraphicRiver', 			'http://www.graphicriver.net/?ref=spykawg', 'images/1.jpg', 	'30/04/2019',	'top'),
	new banner('Dreamhost',				'http://www.dreamhost.com/r.cgi?259541',	'images/6.gif',		'30/04/2019',	'')
]*/

//         				There is no need to edit below here
///////////////////////////////////////////////////////////////////////////////////

/*****
"global" vars
*****/
var used				= 0;
var location_counter	= 0;
var refresh_counter 	= 1;
var map = new Array();
var currentDisplayIndex = new Array();


/*************
	function banner()
	creates a banner object
*************/
function banner(name, url, image, date, loc)
{
	this.name	= name;
	this.url	= url;
	this.image	= image;
	this.date	= date;
	this.active = 1;
	this.oid = 0;
	
	// if no adlocation is given use the default a adlocation setting
	// this is used if adlocations aren't being used or using pre-1.4.x code
	if(loc != '')
	{
		this.loc = loc;
	}
	else
	{
		this.loc = settings.default_ad_loc;
	}
}


/*************
	function show_banners()
	writes banner <div> HTML and maps ad locations to <div> ID tags
*************/
function show_banners(banner_location)
{
	// increase the counter ready for further calls
	location_counter = location_counter + 1;

	// this part maps the adlocation name supplied by the user to the adlocation
	// ID used by the script
	if(banner_location != '' && banner_location != undefined)
	{
		map[location_counter] = banner_location;
	}
	else
	{
		map[location_counter] = settings.default_ad_loc;
	}

	// writes banner html
	var html = '<div id="' + settings.location_prefix + location_counter + '" class="' + settings.location_class + '"></div>';
	document.write(html);
	// calls the display banners script to fill this ad location
	display_banners(location_counter);
	
}



/*************
	function display_banners()
	displays banners for a given location number
*************/
function display_banners(location)
{
	// used in this function to hold tempoary copy of banners array
	var location_banners	= new Array();
	
	// if no location is given, do nothing
	if(location == '' || !location || location < 0)
	{
		return;
	}
	
	// get total banners
	var am	= banners.length;
	
	// all banners have been displayed in this pass and the user doesnt
	// want to have duplicate banners showing
	if((am == used) && settings.duplicate_banners == 0) {
		return;
	}

	// new for 1.4.x, this takes the list of banners and creates a tempoary list
	// with only the banners for the current adlocation in
	for(i = 0; i < (banners.length); i++)
	{
		banners[i].oid = i;
		if((banners[i].loc == map[location]) && (banners[i].active == 1))
		{
			location_banners.push(banners[i]);
		}
	}
	var bn;
	if (settings.sequence) {
	    if (currentDisplayIndex[location] == undefined)
	        currentDisplayIndex[location] = 0;
	    else if (currentDisplayIndex[location] == location_banners.length)
	        currentDisplayIndex[location] = 0;
	    bn = location_banners[currentDisplayIndex[location]];
	    currentDisplayIndex[location] = currentDisplayIndex[location] + 1;
	}
	else {
	    // same as 1.2.x - finds the banner randomly
	    var rand = Math.floor(Math.random() * location_banners.length);	   
	    bn = location_banners[rand];
	}
	
	// creates html
	var image_size 	= (settings.force_size == 1) ? ' width="' + settings.img_width + '" height="' + settings.img_height + '"' : '';
	var html 		= '<a href="' + bn.url + '" title="' + bn.name + '" target="' + settings.window + '"><img border="0" src="' + bn.image + '"' + image_size + ' alt="' + bn.name + '" /></a>';
	
	// calculates the date from inputted string, expected formate is DD/MM/YYYY
	var now		= new Date(); 
	var input	= bn.date;
	input		= input.split('/', 3);
	
	// creates a date object with info
	var end_date	= new Date();
	end_date.setFullYear(parseInt(input[2]), parseInt(input[1]) - 1, parseInt(input[0]));
	
	// compares curent date with banner end date
	if((now < end_date) && bn.active == 1) 
	{
		// attempt to find adlocation div
		var location_element = document.getElementById(settings.location_prefix + location);
		
		// couldn't find it, if this message shows there is a problem with show_banners
		if(location_element == null)
		{
			alert('spyka Webmaster banner rotator\nError: adLocation doesn\'t exist!');
		}
		// output banner HTML
		else
		{
			location_element.innerHTML = html;
			
			// if the user doesn't want the same banner to show again deactive it and increase
			// the users banners counter
			if(settings.duplicate_banners == 0)
			{
				banners[bn.oid].active = 0;
				used++;
			}
			return;
		}
	}
	else
	{
		// inactive banner, find another
		// if no banners fit this adlocation you'll have an endless loop !
		display_banners(location);
	}
	return;
}



/*************
	function refresh_banners()
	resets counters and active settings
*************/
function refresh_banners()
{
	if((refresh_counter == settings.refresh_max) || settings.refresh_time < 1)
	{
		clearInterval(banner_refresh);  
	}
	used = 0;
	for(j = 0; j < (banners.length); j++)
	{
		banners[j].active = 1;
	}

	for(j = 1; j < (location_counter+1); j++)
	{
		display_banners(j);
	}
	refresh_counter++;
}



// set timeout
var banner_refresh = window.setInterval(refresh_banners, settings.refresh_time);