<!DOCTYPE html>
<html ng-app="crmApp">
<head>

	<title>Company</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
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
			Deparment: checkboxes
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
		<div kendo-toolbar id="crmToolbar" k-options="crmToolbarOptions"></div>
		<div  kendo-grid="crmCompanyGrid"  k-options="crmCompanyGridOptions"></div>
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:200px;">
	</div> <!-- bottom pane of outter splitter -->
	
</div>	<!-- end of crmSplitter -->

<div kendo-window="companyWindow"
		k-width="850"
	 	k-height="810"
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

	html,body{
	    margin:0;
	    padding:0;
	    height:100%;
	}

	.k-splitter {
		border-width: 0;
		height: 100%;
	}
	
	
 	.k-toolbar{
 		border-width:0;
		padding: 0;
		margin: 0;
		height:36px;
        border-bottom:1px solid silver;
		}
		
	.k-grid{
		font-size: 12px;
        margin: 0;
        padding: 0;
        border-width: 0;
      	}

	/* 	do not show background color of grid editing cell */
	.k-grid .k-edit-cell { 
		background: transparent; 
		
		}
		
	/*highlight line number of editing row, might not be the first column 	td:first-child  */
	.k-grid .k-grid-edit-row td.gridLineNumber{
		color:blue;
		font-weight: bold;
		
	}

 	/* show horizontal grid line		 */

	.k-grid-content tr:not(:last-child) td{
 	   border-bottom: 1px dotted gray;
		}		
	.k-grid-content tr:last-child td{
 	   border-bottom: 1px solid silver;
		}		
		
	.k-grid .gridLineNumber{
	}		 

	.k-grid td
	{
		white-space: nowrap;
	}

	.k-grid .numberColumn,.gridLineNumber{
		text-align: right;
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
     
     #fieldlist {
        margin: 10px;
        padding: 0;
     }
     #fieldlist li {
         list-style: none;
         padding-bottom: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
          padding-bottom: .2em;
      }
      
      textarea { 
      	resize: vertical; 
      }     
     
	

</style>
</html>

</html>