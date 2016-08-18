<!DOCTYPE html>
<html ng-app="queryApp">
<head>

	<title>Query</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>

	<shared:header/> 
	
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
	<%@include file="query-script.jsp"%>
	
</head>

<body  ng-controller="queryCtrl" spellcheck="false">

<div kendo-splitter="querySplitter"
	
		k-panes="[{ collapsible: false, resizable:false, size: '35px'},
                  { collapsible: false,size:'550px'},
                  { collapsible: true, resizable: true}]"
        k-options="query.splitterOptions"
		style="height:900px;">
		 
	<div id="top-pane">
		
	</div>	<!-- top pane of outter splitter -->
	
	<div id="middle-pane">
		<div kendo-toolbar id="queryToolbar" k-options="queryToolbarOptions"></div>
		<div  query-grid="queryGrid"  c-grid-no="queryGridNo"></div>
	</div> <!-- middle pane of outter splitter -->
	
	<div id="bottom-pane" style="height:300px;">
	</div> <!-- bottom pane of outter splitter -->
	
	
</div>	<!-- end of querySplitter -->

<div kendo-window="chooseColumnWindow" 
			k-width="300"
		 	k-height="550"
		 	k-position="{top: 50, left: 100 }"	
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'Choose Column'"
		 	k-pinned="true"
		 	k-visible="false"
		 	k-modal="true">

		<button ng-click="chooseColumnOk()" style="margin-left: 45px; margin-right: 10px; width:50px;">Ok</button>
		<button ng-click="chooseColumnCancel()" style="margin-right: 10px; width:50px;">Cancel</button>

		<ul style="list-style-type: none;">
			<li>
				<input type="checkbox" ng-model="allColumnsChecked" ng-change='chooseAllColumns(allColumnsChecked)'>Check/Uncheck all
			</li>
			<li>
				<hr/>
			</li>
			
			<li ng-repeat="column in columns">
	 			<input type="checkbox" checklist-model="choosedColumns" checklist-value="column"> {{column.title}}
			</li>
		</ul>	
</div>

<div kendo-window="summaryWindow" 
			k-width="1200"
		 	k-height="900"
		 	k-position="{top: 40, left: 100 }"
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'Summary'"
		 	k-pinned="true"
		 	k-visible="false"
		 	k-modal="false"
		 	k-actions="['Minimize', 'Maximize','Close']">
		 	
		 <div upc-summary="upcSummary"></div>
		 
</div>

<div kendo-window="analysisWindow" 
			k-width="900"
		 	k-height="600"
		 	k-position="{top: 40, left: 100 }"
		 	k-resizable="true"
			k-draggable="true"
		 	k-title="'Sales Report'"
		 	k-pinned="true"
		 	k-visible="false"
		 	k-modal="false"
		 	k-actions="['Minimize', 'Maximize','Close']">
		 	
		 <div sales-analysis="garAnalysis" ></div>
		 
</div>



</body>
<style>
	.k-dirty {
  		border-width:0;
	}
	
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
