<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterUserProgress.ascx.cs" Inherits="Controls_RegisterUserProgress" %>
 <link href="<%= ResolveUrl("~/Content/themes/base/jquery.ui.theme.css") %>" rel="stylesheet" />
 <link href="<%= ResolveUrl("~/Content/themes/base/jquery.ui.progressbar.css") %>" rel="stylesheet" />

 <div class="floatRight regiesterProgressbarText" style="margin-top: 14px;margin-right: 10px;display:none">
    <%=Percent%>% complete
</div>
 
<div class="floatRight regiesterProgressbar" style="margin-top: 10px;margin-right: 5px; width: 200px;display:none">
    <div id="progressbar<%=Step%>"></div>
</div>
<div style="clear: both"></div>

<script>    
    $("#progressbar<%=Step%>").progressbar({
            value: <%=Percent%>*3,
            max: 300
     });
</script>