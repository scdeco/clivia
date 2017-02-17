<!DOCTYPE html>
<html ng-app="crmApp">
<head>

	<title>CRM</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 

	<%@include file="crm-script.jsp"%>
	
</head>

<body  ng-controller="crmCtrl">

<div kendo-splitter="crmSplitter"
	
		k-panes="[{ collapsible: false, resizable:false, size: '35px'},
                  { collapsible: false,size:'550px'},
                  { collapsible: true, resizable: true}]"
        k-options="crmsplitterOptions"
		style="height:900px;">
		 
	<div id="top-pane">
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane" style="height:914px">
		<div kendo-toolbar id="crmToolbar" k-options="crmToolbarOptions"></div>
		<div  kendo-grid="crmCompanyGrid"  k-options="crmCompanyGridOptions"></div>
	</div> <!-- middle pane of outter splitter -->
	
<!-- 	<div id="bottom-pane" style="height:200px;">
	</div> bottom pane of outter splitter -->
	
</div>	<!-- end of crmSplitter -->

<div kendo-window="companyWindow"
		k-width="1200"
	 	k-height="700"
	 	k-position="{top: 50, left: 100 }"	
	 	k-resizable="true"
		k-draggable="true"
	 	k-title="'Company'"
	 	k-visible="false" 
	 	k-actions="['Minimiz','Maximize','Close']"
	 	k-pinned="true"
	 	k-modal="false"
	 	k-options="companyWindowOptions">

	<div company="companyCard"></div>
</div>

</body>
<style>

	.k-grid td
	{
		white-space: nowrap;
	}

	/*re-size TabStrip to 100% of the Pane width/height.*/
	.k-tabstrip{
	   	position: absolute;
     	top: 0;
    	bottom: 0;
    	left: 0;
    	right: 0;
    	width: auto;
    	height: auto;
    	border-width: 0;
	}
 
	.k-tabstrip > .k-content {
    	position: absolute;
    	top: 31px;
    	bottom: 0;
    	left: 0;
    	right: 0;
	}	
	

	/*re-size Grid that has no pager to 100% of it's container's width/height.*/
	#inventoryUpcGrid{
	  	position: absolute;
	    top: 0;
	    bottom: 0;
	    left: 0;
	    right: 0;
	    width: auto;
	    height: auto;	
	}
	
	#inventoryUpcGrid > .k-grid-content {
	    position: absolute;
	    top: 25px;
	    bottom: 0;
	    left: 0;
	    right: 0;  
	    width: auto;
	    height: auto;	
	}
	
	table {
		table-layout:fixed;
	}
	
	table td.header {
		text-align:right;
	}
	
	.options{
		padding: 0;
	}
     .options li {
         list-style: none;
         padding-right: 1em;
         display: inline;
     }	
     

</style>
</html>

</html>