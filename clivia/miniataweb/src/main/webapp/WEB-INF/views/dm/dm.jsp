<!DOCTYPE html>
<html>
<head>
	<title>test</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<shared:header/> 
	
	<%@include file="embdesign.jsp"%>
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
</head>
<body ng-app="embDesignApp" spellcheck="false">
	<div ng-controller="dmCtrl">
	   <div kendo-toolbar id="dstToolbar" k-options="dstToolbarOptions"></div>
	
		<div dst-paint="myDstPaint"></div>
	</div>
</body>
<script>
var designApp = angular.module("embDesignApp",
		["kendo.directives","embdesign"]);
		
designApp.controller("dmCtrl",
		["$scope",function($scope){
			var id=3;
			$scope.dstToolbarOptions={items: [{
		        type: "button",
		        text: "New",
		        id:"btnNew",
		        click: function(e) {
		        	$scope.myDstPaint.setDstDesign(--id)
		       		 }
		    }, {
		        type: "button",
		        text: "Open",
		        id:"btnOpen",
		        click: function(e) {
			        }
		    }, {
		        type: "separator",
		    }, {	
		        type: "button",
		        text: "Print",
		        id: "btnPrint",
		        click: function(e){
		        	$scope.myDstPaint.print();
		        	}  
		    }, {
		        type: "separator",
}]};
		}]);

</script>
<style>

	.k-splitter {
		border-width: 0;
	}
	
	
 	.k-toolbar{
		border-width: 0;
		padding: 0;
		margin: 0;
		height:36px;	//default 36px
		}
		
	.k-grid{
		font-size: 11px;
        margin: 0;
        padding: 0;
        border-width: 0;
/*         height: 100%; /* DO NOT USE !important for setting the Grid height! */ */
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

	.k-grid-content tr td{
 	   border-bottom: 1px dotted gray;
		}		
		
 	/* show horizontal grid line		 */
/* 	.k-grid-content tr:not(:last-child) td{
 	   border-bottom: 1px dotted gray;
		}		
  	.k-grid-content tr:last-child td{
 	   border-bottom: 1px dashed gray;
		}   */
				
	/* 	grid coloumn header */
 	.k-grid-header tr:last-child th{ 
	   font-weight: bold; 
  	   text-align: center;
		}
		
	.k-grid .gridLineNumber{
		text-align: right;
	}		 

	.k-grid td
	{
	    padding-top: 2px;
	    padding-bottom: 2px;
	}
	.k-grid .k-textbox{
		padding: 0px;
		height:19px;
	}

	textarea{
		font-size: 11px;
		margin:3px 0px;
	}
	
	.colorCell{
		float: left; 
		width: 100%; 
		border:1px solid black; 
		border-radius:2px 2px 2px;
		height:12px;
		}
	.k-dirty {
  		border-width:0;
	}
	
	.k-slider .k-label{
		visibility: hidden;
	}
	
	.k-tabstrip {
		font-size: 11px;
        margin: 0;
        padding: 0;
        border-width: 0;	
        height:100%;
	}
	
	.k-tabstrip span.k-link{
	    margin: 0 ;
        padding: 2px 3px;
	}
	
	.k-tabstrip .k-content{
        margin: 0;
        padding: 0;
        border-width: 0;		
	}
	
 	#dst-info-pane{ 
 		overflow:hidden; 
 	} 


	
</style>

</html>