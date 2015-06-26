<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test_IE.aspx.cs" Inherits="Test_IE" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<style type="text/css">
@charset 'UTF-8';

@font-face {
  font-family: 'FontAwesome';
  src: url('css/fonts/fontawesome-webfont.eot?v=4.1.0');
  src: url('css/fonts/fontawesome-webfont.eot?#iefix&v=4.1.0') format('embedded-opentype'), url('css/fonts/fontawesome-webfont.woff?v=4.1.0') format('woff'), url('css/fonts/fontawesome-webfont.ttf?v=4.1.0') format('truetype'), url('css/fonts/fontawesome-webfont.svg?v=4.1.0#fontawesomeregular') format('svg');
  font-weight: normal;
  font-style: normal;
}    
.fa-twitter-square:before {
  content: "\f081";
}
.fa-twitter:before {
  content: "\f099";
}
ul.social
		{
			/*overflow: hidden;*/
		}

			ul.social li
			{
				display: inline-block;
			}

			ul.social li:first-child
			{
				margin-left: 0;
			}

			ul.social li a
			{
				display: inline-block;
				width: 3em;
				height: 3em;
				text-align: center;
				border-radius: 5px;
				background: #888;
				-moz-transition: background-color .25s ease-in-out;
				-webkit-transition: background-color .25s ease-in-out;
				-o-transition: background-color .25s ease-in-out;
				-ms-transition: background-color .25s ease-in-out;
				transition: background-color .25s ease-in-out;
			}
			
				ul.social li a:before
				{
					color: #fff;
					font-size: 2em;
					line-height: 1.5em;
				}
			
			ul.social li a.fa-share-alt			{ background: #3FB23F; }
			ul.social li a.fa-share-alt:hover	{ background: #52ba52; }
			ul.social li a.fa-facebook			{ background: #3c5a98; }
			ul.social li a.fa-facebook:hover	{ background: #4c6aa8; }
			ul.social li a.fa-twitter			{ background: #2daae4; }
			ul.social li a.fa-twitter:hover		{ background: #3dbaf4; }
			ul.social li a.fa-pinterest			{ background: #c4376b; }
			ul.social li a.fa-pinterest:hover	{ background: #d4477b; }
			ul.social li a.fa-linkedin			{ background: #006599; }
			ul.social li a.fa-linkedin:hover	{ background: #1075a9; }
			ul.social li a.fa-tumblr			{ background: #2b4661; }
			ul.social li a.fa-tumblr:hover		{ background: #3b5671; }
			ul.social li a.fa-google-plus		{ background: #da2713; }
			ul.social li a.fa-google-plus:hover	{ background: #ea3723; }
			ul.social li a.fa-envelope		    { background: #da2713; }
			ul.social li a.fa-envelope:hover	{ background: #ea3723; }

.social { position:relative;}
.social li ul {position:absolute;background:#FFF; bottom:2.7em; right:0em; width:auto;box-shadow: 0 0 5px rgba(0, 0, 0, 0.5); padding:5px; border:1px solid #ddd; }
.social li ul.fallback {display:none; z-index: 5;}
.social li:hover ul.fallback {display:block;}
ul.fallback:before {
    border-left: 12px solid rgba(0, 0, 0, 0);
    border-right: 12px solid rgba(0, 0, 0, 0);
    border-top: 12px solid #DDDDDD;
    bottom: -12px;
    content: "";
    display: inline-block;
    left: 150px;
    position: absolute;
}
ul.fallback:after {
    border-left: 10px solid rgba(0, 0, 0, 0);
    border-right: 10px solid rgba(0, 0, 0, 0);
    border-top: 10px solid #FFFFFF;
    bottom: -9px;
    content: "";
    display: inline-block;
    left: 152px;
    position: absolute;
}
</style>
</head>
<body>
    <form id="form1" runat="server">
        <ul class="social" style="margin-right: 139px; margin-top: 10px;">
            <li>
                <a class="fa fa-share-alt solo" href="#"><span>Share</span></a>
                <ul class="fallback">
                    <li><a class="fa fa-facebook solo" href="#" onClick="window.open('http://www.facebook.com/sharer.php?u=','Pollinator Partnership - Get on the map','width=600,height=400')"></a></li>
                    <li><a class="fa fa-twitter solo" href="#"  onClick="window.open('http://twitter.com/share?url=&amp;text=Pollinator Partnership - Share+this+map+:','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Twitter</span></a></li>
                    <li><a class="fa fa-google-plus solo" href="#" onClick="window.open('https://plus.google.com/share?url=','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Google+</span></a></li>
                    <li>
                        <a class="fa fa-linkedin solo" href="http://www.linkedin.com/shareArticle?mini=true&url=" target="_blank"><span>LinkedIn</span></a>
                    </li>
                    <li>
                        <a class="fa fa-pinterest solo" href="javascript:void((function()%7Bvar%20e=document.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','http://assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);document.body.appendChild(e)%7D)());" target="_blank"><span>Pinterest</span></a>
                    </li>
                    <li>
                        <a class="fa fa-envelope solo" href="mailto:?Subject=Share Map - Pollinator&Body=I%20saw%20this%20and%20thought%20of%20you!%20 " target="_blank"><span>Email</span></a>
                    </li>
                </ul>
            </li>
            <li><a class="fa fa-facebook solo" href="#" onClick="window.open('http://www.facebook.com/sharer.php?u=','Pollinator Partnership - Get on the map','width=600,height=400')"></a></li>
            <li><a class="fa fa-twitter solo" href="#" onClick="window.open('http://twitter.com/share?url=&amp;text=Pollinator Partnership - Share+this+map+:','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Twitter</span></a></li>
                <li><a class="fa fa-google-plus solo" href="#" onClick="window.open('https://plus.google.com/share?url=','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Google+</span></a></li>
        </ul>  
    </form>
</body>
</html>
