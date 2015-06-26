<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftSidebar.ascx.cs" Inherits="WindowBox_Admin_Controls_LeftSidebar" %>
<link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
<script>
    function linkUser() {
        document.location.href = "<%=ResolveUrl("~/WindowBox/Admin/User")%>";
    }
    function linkFlower() {
        document.location.href = "<%=ResolveUrl("~/WindowBox/Admin/Flower")%>";
    }   
    function linkWindowBox() {
        document.location.href = "<%=ResolveUrl("~/WindowBox/Admin/WindowBox")%>";
    }
    function linkStatistic() {
        document.location.href = "<%=ResolveUrl("~/WindowBox/Admin/Statistic")%>";
    }
    function linkAdmin() {
        document.location.href = "<%=ResolveUrl("~/WindowBox/Admin/Admin")%>";
     }
</script>
<div style="border: 2px solid #808080">
    <div style="background-color: orange; padding: 10px">
        <div style="float: left;border-radius:50%;width:40px;height:40px;border:1px solid black;text-align:center">
            <i class="fa fa-user" style="color: white; font-size: 30px"></i>
        </div>
        <div style="float: left; text-align: center; width: 70%; padding-top: 15px">
            {Username}
        </div>
        <div style="float: right">
            <a style="text-decoration: underline; cursor: pointer;">logout
            </a>
        </div>
        <div style="clear: both">
        </div>
    </div>
    <div class="leftmenu">
        <h3>Users</h3>
        <p>
            <span onclick="linkUser();">All Users (##)<br />
            </span>
            <span onclick="linkUser();">Incomplete Users (##)<br />
            </span>
            <span onclick="linkUser();">Email Only (##)<br />
            </span>
            <span onclick="linkUser();">Full Users (##)<br />
            </span>
        </p>

        <h3>Flowers</h3>
        <p>
            <span onclick="linkFlower();">All Flowers (##)<br />
            </span>
            <span  onclick="linkFlower();">Missing Images (##)<br />
            </span>
        </p>

        <h3>Window Boxes</h3>
        <p>
            <span onclick="linkWindowBox();">All Window Boxes (##)<br />
            </span>
            <span onclick="linkWindowBox();">Unclaimed (##)<br />
            </span>
            <span onclick="linkWindowBox();">Claimed (##)<br />
            </span>
        </p>

        <h3 style="cursor:pointer" onclick="linkStatistic();">Statistics</h3>

        <h3 style="cursor:pointer" onclick="linkAdmin();">Admin</h3>

    </div>
</div>

<style>
    .col_left
    {
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        height: auto;
        width: 250px;
        display: block;
        float: left;
        /*background-color: orange;*/
        padding: 10px;
    }

    .col_main
    {
        display: block;
        position: absolute;
        height: auto;
        bottom: 0;
        top: 0;
        left: 280px;
        right: 0;
    }

    .leftmenu
    {
        padding-left: 10px;
    }

    .leftmenu h3
    {
        margin: 25px 0px 0px 0px;
    }

    .leftmenu p
    {
        margin: 5px 0px 0px 0px;
        line-height: 30px;
    }
    .leftmenu  p span
    {
        cursor:pointer;
    }

    .divtable
    {
        padding-top: 30px;
    }

    .table-hover
    {
        border: solid 1px #ddd;
    }

    .table-hover > tbody > tr > th
    {
        background-image: linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%);
        pointer-events: none;
        padding: 15px 8px 8px 8px;
        font-size:14px;
         height: 60px;
         white-space:nowrap;
    }

    .table-hover > tbody > tr > td
    {
        height: 50px;
        padding: 15px 8px 8px 8px;
    }

    .table-hover > tbody > tr:nth-of-type(even)
    {
        background-color: #f9f9f9;
    }

    .table-hover > tbody > tr:hover 
    {
        background-color: #f5f5f5;
    }
      tr:last-of-type
    {
        background-color: white !important;
    }
    .pager div
    {
        margin-top: 20px;
    }

    .pager div
    {
        margin-top: 20px;
    }

    .pager select
    {
        width: 54px;
        height: 30px;
        color: black;
        padding: 0px;
        padding-left: 3px;
        padding-right: 3px;
        display: inline;
    }

    .pagination
    {
        display: inline-block;
        padding-left: 0;
        margin: 0px;
        border-radius: 4px;
    }

    .pagination > li
    {
        display: inline;
    }

    .pagination > li > a, .pagination > li > span
    {
        position: relative;
        float: left;
        padding: 6px 12px;
        margin-left: -1px;
        line-height: 1.42857143;
        /*  color: #337ab7;
        text-decoration: none;*/
        text-decoration: underline;
        color: blue;
        background-color: #fff;
        border: 1px solid #ddd;
        cursor: pointer;
    }

    .pagination > .active > a, .pagination > .active > span,
     .pagination > .active > a:hover, .pagination > .active > span:hover,
     .pagination > .active > a:focus, .pagination > .active > span:focus
    {
        background-image: linear-gradient(rgb(245, 245, 245) 0px, rgb(232, 232, 232) 100%);
        cursor: default;
        z-index: 2;
    }

    .link
    {
        text-decoration: underline;
        color: blue;
        cursor: pointer;
    }
</style>
