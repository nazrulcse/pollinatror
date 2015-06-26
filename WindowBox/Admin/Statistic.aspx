<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Statistic.aspx.cs" Inherits="WindowBox_Admin_Statistic" %>

<%@ Register Src="~/WindowBox/Admin/Controls/LeftSidebar.ascx" TagPrefix="uc" TagName="LeftSidebar" %>
<%@ Register Src="~/WindowBox/Admin/Controls/TopSidebar.ascx" TagPrefix="uc" TagName="TopSidebar" %>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <div class="col_left">
            <uc:LeftSidebar runat="server" ID="LeftSidebar" />
        </div>

        <div class="col_main">
            <uc:TopSidebar runat="server" Name="Statistics" ID="TopSidebar" />

            <div style="margin: 50px auto 10px;max-width:850px">

                <div  class="box">
                    # Users
                </div>

                <div  class="box" style="margin-left:0.5%;margin-right:0.5%">
                    # Boxes
                </div>

                <div class="box">
                    # Flowers
                </div>
                <div style="clear: both">
                </div>


            </div>

             <div style="margin: 10px auto 10px;max-width:850px">

                <div  class="box">
                    # Views
                </div>

                  <div  class="box" style="margin-left:0.5%;margin-right:0.5%">
                    # Shares
                </div>

                <div class="box">
                    # Clicks
                </div>
                <div style="clear: both">
                </div>


            </div>

            <div id="chart" style="margin: 0 auto;max-width:500px">
            </div>

        </div>

    </form>

    <style>
        .box
        {
            text-align:center;
            float: left;
            border: 1px solid #808080;
            padding-top:20px;                 
            width:33%;
           max-width:250px;
             min-width:80px;
            height:100px;
        }
    </style>
    <script>
        $(document).ready(function () {
            var chart1 = new Highcharts.Chart({
                chart: {
                    renderTo: 'chart',
                    type: 'column'
                },
                credits: {
                    enabled: false
                },
                legend: {
                    enabled: false
                },
                title: {
                    text: ''//Fruit Consumption'
                },
                xAxis: {
                    // categories: ['Apples', 'Bananas', 'Oranges']
                },
                yAxis: {
                    title: {
                        text: ''//Fruit eaten'
                    }
                },
                series: [{
                    // name: 'Jane',
                    data: [1, 0, 4]
                }, {
                    // name: 'John',
                    data: [5, 0, 3]
                }]
            });
        });
    </script>
</body>
</html>
