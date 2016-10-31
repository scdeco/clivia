<!DOCTYPE html>
<html ng-app="accountingApp">
<head>

	<title>Invoice</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 

	<%@include file="../crm/crm-script.jsp"%>
 	<%@include file="ac-script.jsp"%>
 	

</head>
<body>
	<div invoice="invoice"></div>
	
</body>
</html>