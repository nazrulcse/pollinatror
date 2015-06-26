<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddToWindowBox.aspx.cs" Inherits="WindowBox_AddToWindowBox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> 
    
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
    
    <link href="../css/bootstrap-modal.css" rel="stylesheet" />
    

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/css" />
</head>
<body>
    <form id="form1" runat="server">
                
    <!--
        References: 
        http://www.tutorialspoint.com/bootstrap/bootstrap_tooltip_plugin.htm
        http://www.tutorialspoint.com/bootstrap/bootstrap_popover_plugin.htm
        -->
                
    <style type="text/css">
        body {
            border: 0px;
            min-width: 0px;
            overflow: hidden;
        }

        .pollinator-hyperlink {
            color: blue !important;
        }

        .pollinator-hyperlink:hover
        { 
            color: orange !important;
            text-decoration: none;
        }

        .popover{
            max-width:500px;
        }

        ul.circular-box {
            list-style: none;
            width: 600px;
            margin: auto;
            margin-top: 20px;
            counter-reset: numList;
        }
        ul.circular-box li {
            margin: 0 20px 0 20px;
            padding: 0 40px 0 40px;
            float: left;
            height: 80px;
        }
        ul.circular-box li:before {
            counter-increment: numList;
            content: counter(numList);
    
            float: left;
            position: absolute;
    
            font: bold 12px sans-serif;
            font-size: 40px;
            text-align: center;
            color: #000;
            line-height: 80px;
    
            width: 80px; height: 80px;
            background: #ffffff;
            border: solid 1px gray;
    
            -moz-border-radius: 40px;
            border-radius: 40px;
            cursor: url(Images/tick.png), auto;
        }

        ul.circular-box li.occupied:before {
            background-color: gray;
        }

        ul.circular-box li.picked:before {
            background-color: #419641;
            cursor: default;
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
    </style>
        
    <script>
        $(document).ready(function () {
            $('ul.circular-box li').hover(function () {
                if ($(this).hasClass('occupied') == true || $(this).hasClass('picked') == true)
                {
                    if($(this).attr('data-trigger') != "hover") {
                        $(this).attr('data-trigger', 'hover');
                        $(this).attr('data-toggle', 'popover');
                        $(this).attr('data-container', 'body');
                        $(this).attr('data-placement', 'top');

                        var plantName = '<h4><%= Request.QueryString["plant_name"] %></h4>';
                        var image = '<img src="<%= Request.QueryString["plant_img"] %>"" style="width: 150px;height:150px"/>';
                        var description = "<div style='width:auto'>Aronia is a genus of deciduous shrubs, the chokeberries, in the family Rosaceae, native to eastern North America and most commonly found in wet woods and swamps.</p><p><a href='#' style='width:100%;text-align:center;display:block;' class='pollinator-hyperlink'>More Info</a></div>";
                        
                        $(this).attr('data-content', '<div style="float:left;width:150px;margin:0 10px 10px 0;">' + plantName + image + '</div> ' + description);

                        $("[data-toggle='popover']").popover({ html: true });
                        $("[data-toggle='tooltip']").tooltip();
                    }

                    $(this).popover('show');
                } else {
                    //
                    // $(this).popover('disable').popover("hide");
                    //alert($(this).attr('data-trigger'))
                    //if ($(this).attr('data-content') != "") {
                    //    $(this).attr('data-trigger', '');
                    //    $(this).attr('data-toggle', '');
                    //    $(this).attr('data-container', '');
                    //    $(this).attr('data-placement', '');
                    //    $("[data-toggle='popover']").popover({ html: true });
                    //    $("[data-toggle='tooltip']").tooltip();
                    //}
                }
            });
            
            $('ul.circular-box li').click(function () {
                    //Remove mark on the unoccupied boxes
                    $('ul.circular-box li').each(function () {
                        if ($(this).hasClass('occupied') == false)
                            $(this).removeClass('picked');
                    });
                    
                    //Add green mark on the available box
                    $(this).addClass('picked');
            });
            
            $('#btnAddPlants').on('click', function (e) {
                $('#confirmAddPlant').modal({ backdrop: 'static', keyboard: false })
                    .one('click', '#AddPlant_Yes', function (e) {
                    });
            });
        });
    </script>
        
    <div id="confirmAddPlant" class="modal fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" 
                    aria-hidden="true">×</button>
           <h3 id="H2">Notice</h3>
        </div>
        <div class="modal-body">
            Are you sure you want to add your plant to that position?
        </div>
      <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn" id="AddPlant_No"><span class="glyphicon glyphicon-remove"></span>&nbsp;&nbsp;No</button>
        <button type="button" data-dismiss="modal" class="btn btn-success" id="AddPlant_Yes"><span class="glyphicon glyphicon-check"></span>&nbsp;&nbsp;Yes</button>
      </div>
    </div>
             
                
    <div style="float:left;width:auto;padding:10px">
        <img src='<%= Request.QueryString["plant_img"] %>' style="width: 250px;height:250px"/>
    </div>
    <div style="">
        <h2><%= Request.QueryString["plant_name"] %></h2>
        <p>
            <%= Request.QueryString["plant_name"] %> is a species of flowering plant in the sunflower tribe of the plant family Asteraceae known by the common name arrowleaf balsamroot.
        </p>
    </div>
      
        
    <div style="clear:both;text-align:center;" class="clearfix">
        <h2>Add to Window Box</h2>
        
	    <ul class="circular-box">
		    <li class="occupied" title="This slot is already full"></li>
		    <li></li>
		    <li></li>
		    <li></li>
	    </ul>
    </div>
        
    <div style="clear: both;margin-top:30px" class="clearfix">
        <a href="#" onclick="document.location = document.referrer;" style="float:left" class="pollinator-hyperlink">Back to all plants view</a>
        <a href="#" id="btnAddPlants" class="button btn36" style="font-size: 16px ; font-weight: 300;font-size:20px;float:right;line-height:10px;margin:0px 60px 30px 0;">Add Plants</a>
    </div>
        
    </form>
</body>
</html>
