<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WindowBoxDisplay.aspx.cs" Inherits="WindowBox_WindowBoxDisplay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/css" />
</head>
<body>
    <form id="form1" runat="server">
        <style type="text/css">
            body {
                padding: 10px;
                min-width: 0px;
                font-family: Arial;
            }
        </style>
        <div style="height: 360px">
            <div style="height: 100%;width:25%;float:left;padding-top: 70px">
                <p>
                    <img src='Images/USDA_logo.png' />
                </p>
                <p>
                    <img src='Images/pollinator partnership.jpg' />
                </p>
                <p>
                    <h4 style="font-size: 14px;font-weight:bold">Protect their lives. Preserve ours.</h4>
                </p>
            </div>
            <div style="height: 100%;width:50%;float:left;text-align:center">
                <h1>Josh McLoin's Window Box</h1>
                <h4>California, United States of America</h4>
                <img src='Images/plant_window.png'/>
            </div>
            <div style="height: 100%;width:25%;float:left">
                <a href="#" style="float:right;">Login</a>
                <div style="margin-top: 150px;text-align: center"><h3>SHARE</h3></div>
                <ul class="social" style="margin-left:0px">
                    <li title="Share now!"><a class="fa fa-share-alt solo" href="#"><span>Share</span></a>
                        <ul class="fallback" style="margin-left: -110px;right:60px;">
                        <li title="Share on Facebook"><a class="fa fa-facebook solo" href="#" onClick="window.open('http://www.facebook.com/sharer.php?u=<%= PageURL %>','SHARE - Get on the Map Today!','width=600,height=400')"><span>Facebook</span></a></li>
                        <li title="Share on Twitter"><a class="fa fa-twitter solo" href="#"  onClick="window.open('http://twitter.com/share?url=<%= PageURL %>&amp;text=SHARE - Get on the Map Today!','Pollinator Partnership - Get on the map','width=600,height=400')"><span>Twitter</span></a></li>
                        <li title="Share on Google plus"><a class="fa fa-google-plus solo" href="#" onClick="window.open('https://plus.google.com/share?url=<%= PageURL %>','SHARE - Get on the Map Today!','width=600,height=400')"><span>Google+</span></a></li>
                        <li title="Share on LinkedIn">
                            <a class="fa fa-linkedin solo" href="http://www.linkedin.com/shareArticle?mini=true&url=<%= PageURL %>" target="_blank"><span>LinkedIn</span></a>
                        </li>
                        <li title="Share on Pinterest"><a class="fa fa-pinterest solo" href="javascript:void((function()%7Bvar%20e=document.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','http://assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);document.body.appendChild(e)%7D)());" target="_blank"><span>Pinterest</span></a></li>
                        <li title="Send from Gmail"><a class="fa fa-envelope solo" href="mailto:?Subject=SHARE - Get on the Map Today!&Body=I%20saw%20this%20and%20thought%20of%20you!%20 <%= PageURL %>" target="_blank"><span>Email</span></a></li>
                        </ul>
                    </li>
                    <li title="Share on Facebook"><a class="fa fa-facebook solo" href="#" onClick="window.open('http://www.facebook.com/sharer.php?u=<%= PageURL %>','SHARE - Get on the Map Today!','width=600,height=400')"><span>Facebook</span></a></li>
                    <li title="Share on Twitter"><a class="fa fa-twitter solo" href="#" onClick="window.open('http://twitter.com/share?url=<%= PageURL %>&amp;text=SHARE - Get on the Map Today!','SHARE - Get on the Map Today!','width=600,height=400')"><span>Twitter</span></a></li>
                    <li title="Share on Google plus"><a class="fa fa-google-plus solo" href="#" onClick="window.open('https://plus.google.com/share?url=<%= PageURL %>','SHARE - Get on the Map Today!','width=600,height=400')"><span>Google+</span></a></li>
                </ul> 
            </div>
        </div>
        
        <div style="clear: both;margin-top: 0px;">
            <div style="line-height: 40px;background-color: #B6D7A8;color:white;padding:0 0 0 5px"><h3>Window Box Information</h3></div>
        </div>
        <div style="clear: both;background-color: #009E0F;height:220px;">
            <div style="width: 25%;float:left;text-align: center;color:white">
                <h4 style="color:white;margin-top:5px">IRL Photo</h4>
                <img src='PlantImages/window_box_photo_upload.png' style="height:150px"/> 
            </div>
            <div style="width: 50%;float:left;text-align:center">
                <h4 style="color:white;margin-top:5px">Pollinator Impact</h4>
    
                <img src='<%= ResolveUrl("Images/pollinator_impact.png") %>' style="height:150px"/>
            </div>
            <div style="width: 25%;float:left;text-align: center;color:white">
                <h4 style="color: white;text-align:left;margin-top:5px">Plant List</h4>
                <div style="margin-top:-15px">
                    <h4 style="color:yellow;text-align:left;font-size: 12px">Aquilegia</h4>
                    <label style="color:yellow;font-size: 10px;margin-top:-5px;line-height:5px;font-weight: 300;font-style:italic">Aquilegia caerulea</label>
                </div>
                <div style="margin-top:-5px">
                    <h4 style="color:yellow;text-align:left;font-size: 12px">Asclepias</h4>
                    <label style="color:yellow;font-size: 10px;margin-top:-5px;line-height:5px;font-weight: 300;font-style:italic">Asclepias tuberosa</label>
                </div>
                <div style="margin-top:-5px">
                    <h4 style="color:white;text-align:left;font-size: 12px">Amelanchier</h4>
                    <label style="color:white;font-size: 10px;margin-top:-5px;line-height:5px;font-weight: 300;font-style:italic">Amelanchier arborea</label>
                </div>
                <div style="margin-top:-5px">
                    <h4 style="color:white;text-align:left;font-size: 12px">Balsamorhiza</h4>
                    <label style="color:white;font-size: 10px;margin-top:-5px;line-height:5px;font-weight: 300;font-style:italic">Balsamorhiza sagittata</label>
                </div>
            </div>
        </div>
        <div style="clear: both;background-color:orange;height:60px;">
            <div style="font-size: 30px;color:white;font-weight: bold;text-align: center;height: 100%;padding-top:15px">Create Your Own Window Box Today!</div>
            <a href="CreateWindowBox.aspx" id="btnSeeAll" class="button btn36" style="font-size: 16px ; font-weight: 300;font-size:20px;float:right;line-height:3px;margin: -45px 20px 30px 0">Start Here</a>
        </div>
    </form>
</body>
</html>
