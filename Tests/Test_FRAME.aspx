<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test_FRAME.aspx.cs" Inherits="Tests_Test_FRAME" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label runat="server" id="lblDebug"></asp:Label>
        <iframe width="560" height="315" src="http://demo.evizi.com:8088/MapWidget.aspx" frameborder="0"></iframe>
    </form>
</body>
</html>
