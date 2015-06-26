<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftSidebar.ascx.cs" Inherits="WindowBox_LeftSidebar" %>

<style type="text/css">
ul.plant-list{
  width:100%;
  margin-bottom:20px;
    padding: 0px;
  overflow:hidden;
}
ul.plant-list li{
  line-height:1.5em;
  width:50%;
  float:left;
  display:inline;
    margin-bottom: 15px;
}

ul.plant-list li img
{
    border: solid 2px white;
} 
</style>

<h3 style="color:white;margin-bottom: 20px;">Your Window Box</h3>

<p>
    <div style="float:left">
        <h3 style="margin-top:0px;">Account Info</h3>
    </div>
    <div style="float:right">
        <a href="#">edit</a>
    </div>
</p>

<p style="color:white;line-height:20px;font-size: 14px;clear:both">
FULLNAME  <br />
CITY/STATE <br/>
EMAIL <br/>
DISPLAY NAME
</p>

<p>
    <div style="float:left">
        <h3 style="margin-top:0px;">Your Plants</h3>
    </div>
    <div style="float:right">
        <a href="#">edit</a>
    </div>
    
    <ul class="plant-list">
        <li>
           <img src='<%= ResolveUrl("../PlantImages/Aronia_arbutifolia.jpg") %>' style="width: 80px;height:60px"/> 
        </li>
        <li>
            <img src='<%= ResolveUrl("../PlantImages/Aster_spp.jpg") %>' style="width: 80px;height:60px"/> 
        </li>
        <li>
            <img src='<%= ResolveUrl("../PlantImages/Balsamorhiza_sagittata.jpg") %>' style="width: 80px;height:60px"/> 
        </li>
        <li>
            <img src='<%= ResolveUrl("../PlantImages/Asclepias_incarnata.jpg") %>' style="width: 80px;height:60px"/> 
        </li>
    </ul>
</p>

<p>
    <img src='<%= ResolveUrl("../Images/USDA_logo.png") %>' />
</p>

<p>
    <img src='<%= ResolveUrl("../Images/pollinator partnership.jpg") %>' />
</p>

<p>
    <h4 style="font-size: 14px;font-weight:bold">Protect their lives. Preserve ours.</h4>
</p>

<a href="#" id="btnSeePublicProfile" class="button btn36" style="font-size: 16px ; font-weight: 700;">See Public Profile</a>