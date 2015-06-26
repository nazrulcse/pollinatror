<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AllPlantsView.aspx.cs" Inherits="WindowBox_AllPlantsView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> 
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <script src="../Scripts/ToggleButton/jquery.checkable.js"></script>
        <link href="../Scripts/ToggleButton/SwitchButton.css" rel="stylesheet" />
        <script>
            $(document).ready(function() {
                $(".switch").checkable();
                $("[data-name=local_only]").checkable("check", true);

                $('ul li img').click(function () {
                    document.location = "AddToWindowBox.aspx?plant_img=" + $(this).attr('src') + "&plant_name=" + $(this).parent().find('div').text();
                });
                
                $('ul li').hover(function () {
                    $(this).find('img').css('opacity', '0.5');
                    $(this).attr('title', 'Pick this plant?');
                }, function () {
                    $(this).find('img').css('opacity', '1');
                });
            });
        </script>
        
        <style type="text/css">
            body {
                padding: 10px;
            }
            .dropdown {
                height: 30px;
                margin-right: 10px;
            }

            .right-inner-addon
            {
                position: relative;
                float: right;
                margin: 0 5px 0 0;
            }

            .right-inner-addon input
            {
                padding-left: 30px;
            }

            .right-inner-addon i
            {
                position: absolute;
                padding: 10px 12px;
                pointer-events: none;
            }

            /* Clearfix for all container boxes */   
            .clearfix:after {  
                visibility: hidden;  
                display: block;  
                font-size: 0;  
                content: " ";  
                clear: both;  
                height: 0;  
                }  
            * html .clearfix             { zoom: 1; } /* IE6 */  
            *:first-child+html .clearfix { zoom: 1; } /* IE7 */

            /*Custom scrollbar for browser*/
            ::-webkit-scrollbar {
                width: 12px;
            }
 
            ::-webkit-scrollbar-track {
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3); 
                border-radius: 10px;
            }
 
            ::-webkit-scrollbar-thumb {
                border-radius: 10px;
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5); 
            }  
            
            ul {list-style-type:none;}
            ul li {width:160px;float: left;cursor: url(Images/tick.png), auto;}
            ul li div { height: 40px;color: white;}
            @media screen and (max-width:520px) {
                ul li#three {clear:both;float:left;}
                ul li#four {float:left;}
            }
        </style>
                
    <h1 style="margin-top: -5px;text-align:center">All Pollinators</h1>
        
    <div style="height: 70px;background-color: #B6D7A8;padding:30px 10px 0 10px">
        <asp:DropDownList runat="server" ID="ddlAttributes" CssClass="dropdown">
            <asp:ListItem Text="Sun"></asp:ListItem>
            <asp:ListItem Text="Partial Sun"></asp:ListItem>
            <asp:ListItem Text="Shade"></asp:ListItem>
            <asp:ListItem Text="Dry"></asp:ListItem>
            <asp:ListItem Text="Well-drained"></asp:ListItem>
            <asp:ListItem Text="Moist/wet"></asp:ListItem>
            <asp:ListItem Text="Flooded"></asp:ListItem>
            <asp:ListItem Text="Sandy"></asp:ListItem>
        </asp:DropDownList>

        <asp:DropDownList runat="server" ID="ddlColor" CssClass="dropdown">
            <asp:ListItem Text="Yellow"></asp:ListItem>
            <asp:ListItem Text="Green"></asp:ListItem>
            <asp:ListItem Text="Pink"></asp:ListItem>
            <asp:ListItem Text="Purple"></asp:ListItem>
            <asp:ListItem Text="White"></asp:ListItem>
            <asp:ListItem Text="Red"></asp:ListItem>
            <asp:ListItem Text="Orange"></asp:ListItem>
        </asp:DropDownList>
                
        <asp:DropDownList runat="server" ID="ddlSeason" CssClass="dropdown">
            <asp:ListItem Text="February-March"></asp:ListItem>
            <asp:ListItem Text="March-April"></asp:ListItem>
            <asp:ListItem Text="April-August"></asp:ListItem>
            <asp:ListItem Text="April-June"></asp:ListItem>
            <asp:ListItem Text="June-August"></asp:ListItem>
            <asp:ListItem Text="July-October"></asp:ListItem>
            <asp:ListItem Text="May-June"></asp:ListItem>
            <asp:ListItem Text="July-September"></asp:ListItem>
            <asp:ListItem Text="May-July"></asp:ListItem>
            <asp:ListItem Text="May-June"></asp:ListItem>
            <asp:ListItem Text="July-September"></asp:ListItem>
            <asp:ListItem Text="April-Sep"></asp:ListItem>
            <asp:ListItem Text="September-October"></asp:ListItem>
            <asp:ListItem Text="June-October"></asp:ListItem>
            <asp:ListItem Text="August-September"></asp:ListItem>
        </asp:DropDownList>
        
        <div class="right-inner-addon">
            <i class="glyphicon glyphicon-search"></i><asp:TextBox Width="150px" CssClass="form-control" type="search" ID="txtSearch" placeholder="Search" runat="server" MaxLength="60"></asp:TextBox>

        </div>
        
        <div style="float: right;margin:-23px 20px 0 0;">
            <div style="font-size: 13px;margin-bottom: 3px;color:white;font-weight: bold">Local Only</div>
            <div class="switch" data-name="local_only" data-checked="true" data-value="true">
                <div class="helper"></div>
            </div>
        </div>
    </div>
        
    <ul style="background-color: green;padding-top: 20px;" class="clearfix">
        <li>
            <img src='PlantImages/Aronia_arbutifolia.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aronia Arbutifolia</div>
        </li>
        <li>
            <img src='PlantImages/Aster_spp.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aster Spp</div>
        </li>
        <li>
            <img src='PlantImages/Balsamorhiza_sagittata.jpg' style="width: 150px;height:150px"/>
            <div style="text-align: center">Balsamorhiza Sagittata</div>
        </li>
        <li>
            <img src='PlantImages/Asclepias_incarnata.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Asclepias Incarnata</div>
        </li>
        <li>
            <img src='PlantImages/Achillea_millefolium.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Achillea millefolium</div>
        </li>
        <li>
            <img src='PlantImages/Aconitum_columbianum.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aconitum columbianum</div>
        </li>
        <li>
            <img src='PlantImages/Adenostoma_fasciculatum.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Adenostoma fasciculatum</div>
        </li>
        <li>
            <img src='PlantImages/Actaea_racemosa.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Actaea racemosa</div>
        </li>
                
        <li>
            <img src='PlantImages/Amelanchier_arborea.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Amelanchier arborea</div>
        </li>
        <li>
            <img src='PlantImages/Amorpha_canescens.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Amorpha canescens</div>
        </li>
        <li>
            <img src='PlantImages/Aquilegia_canadensis.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aquilegia canadensis</div>
        </li>
        <li>
            <img src='PlantImages/Aquilegia_coerulea.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aquilegia coerulea</div>
        </li>
        <li>
            <img src='PlantImages/Apocynum_cannabinum.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Apocynum cannabinum</div>
        </li>
        <li>
            <img src='PlantImages/Anemone_spp.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Anemone spp</div>
        </li>
        <li>
            <img src='PlantImages/Apios_americana.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Apios americana</div>
        </li>
        <li>
            <img src='PlantImages/Aristolochia_californica.jpg' style="width: 150px;height:150px"/> 
            <div style="text-align: center">Aristolochia californica</div>
        </li>
    </ul>
    </form>
</body>
</html>
