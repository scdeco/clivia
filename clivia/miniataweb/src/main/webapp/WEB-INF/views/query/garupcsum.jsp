<!-- <!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>DD Summary</title>

    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.1.412/styles/kendo.common.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.1.412/styles/kendo.rtl.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.1.412/styles/kendo.silver.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.1.412/styles/kendo.mobile.all.min.css"/>

    <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script src="http://kendo.cdn.telerik.com/2016.1.412/js/jszip.min.js"></script>
    <script src="http://kendo.cdn.telerik.com/2016.1.412/js/kendo.all.min.js"></script>
</head> -->


<!DOCTYPE html>
<html ng-app="queryApp">
<head>

	<title>Query</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	<%@include file="garupcsum-script.jsp"%>

	
	
</head>

<body ng-controller="queryCtrl" spellcheck="false">
	<div kendo-toolbar id="queryToolbar" k-options="queryToolbarOptions"></div>
    <div kendo-spreadsheet="spreadsheet" k-options="spreadsheetOptions" style="width:100%;height:800px;"></div>
</body>
</html>

