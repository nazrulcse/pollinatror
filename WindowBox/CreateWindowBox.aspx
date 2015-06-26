<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateWindowBox.aspx.cs" Inherits="CreateWindowBox" MasterPageFile="WindowBoxLayout.master" %>

<%@ Register Src="~/WindowBox/Controls/PlantCarousel.ascx" TagPrefix="uc1" TagName="PlantCarousel" %>
<%@ Register Src="~/WindowBox/Controls/PollinatorImpact.ascx" TagPrefix="uc1" TagName="PollinatorImpact" %>
<%@ Register Src="~/WindowBox/Controls/LeftSidebar.ascx" TagPrefix="uc1" TagName="LeftSidebar" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="LeftColumn" runat="Server">
    <uc1:LeftSidebar runat="server" ID="LeftSidebar" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainColumn" runat="Server">
    <script type="text/javascript" src="PlantDragable.js"></script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            $('#linkGuidePopup')[0].click();
        });
    </script>
    
    <style type="text/css">
       ul.step-bullet {
            font-size: 14px;
            display: block;
            padding: 0 0 0 26px;
            list-style: none;
            /*background: #ccc;*/
            overflow: hidden;
            counter-reset: numList;
            clear: both;
        }
        ul.step-bullet li {
            margin-right: 44px;
            margin-bottom: 20px;
            padding-left:30px;
            position: relative;
            line-height: 40px;
            font-weight: bold;
            color:#419641 ;
            font-size: 18px;
        }
        ul.step-bullet li:before {
            counter-increment: numList;
            content: counter(numList);
    
            float: left;
            position: absolute;
            left: -26px;
    
            font: bold 12px sans-serif;
            font-size: 20px;
            text-align: center;
            color: #fff;
            line-height: 18px;
    
            width: 40px; height: 40px;
            padding-top: 10px;
            background: #419641 ;
    
            -moz-border-radius: 20px;
            border-radius: 20px;
        }
    </style>

    <a href="#getting_started_guide_popup" id="linkGuidePopup" style="display: none">Learn more</a>
    <a href="#x" class="overlay" id="getting_started_guide_popup"></a>
    <div class="popup" style="width: 810px; height: 380px">
        <h2 style="font-weight: 700;margin:auto;text-align:center;">
            Build Your Virsual Pollinator Window Box
        </h2>

        <p>
	        <ul class="step-bullet">
		        <li>Pick Your Plants from native plants in your region (zip code)</li>
		        <li>Search plants outside your region</li>
		        <li>Add plants to Window Box</li>
		        <li>Upload photo for your Window Box</li>
		        <li>Save your Window Box and start sharing public profile</li>
	        </ul>
        </p>
        <a href="#close" class="popup-close" onclick="setFocusByControl('');"></a>
    </div>
    
    <uc1:PollinatorImpact runat="server" ID="PollinatorImpact" />
        
    <br/><br/>
    <uc1:PlantCarousel runat="server" ID="PlantCarousel" />       
</asp:Content>
