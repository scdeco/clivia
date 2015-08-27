<!DOCTYPE html>
<html>
<head>
	<title>Line Items</title>
	<%@taglib prefix="ex" uri="/WEB-INF/miniataweb-tags.tld"%>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
	<shared:header/> 
</head>
<body>
	<div kendo-grid="lineitems" k-options="lineitemsOptions" k-rebind="lineitemsOptions.dataSource.filter"></div>
</body>
</html>