<!DOCTYPE html>
<html>
<head>
	<title>test</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<shared:header/> 
	
	<%@include file="../common/embdesign.jsp"%>
	<%@include file="../common/gridwrapper.jsp"%>
</head>
<body ng-app="embDesignApp">
	<div ng-controller="testCtrl">
		
		<button ng-click="getDstImage()" >Get DST</button>
    	<button ng-click="setCanvas()" >setCanvas</button>
		<button ng-click="addDstImage()" >Add</button>
    	<button ng-click="drawDstImage()" >Draw with colorway</button>

    <div class="k-header wide" >
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
      			ng-resize="resizeStage()"
      	
				k-panes="[{ collapsible: false, resizable: false, size: '38px'},
                		  { collapsible: false},
                  		  { collapsible: true, resizable: true,size:'200px'}]"
		    	style="height:900px;">      	
      	
      	
      		<div id="dst-first-pane">
      			<div kendo-color-palette
      				ng-model="dstPaint.backgroundColor" 
      				k-options="dstPaint.backgroundColorOptions()">
      			</div>
			</div>	<!-- first-pane-->
			
      		<div id="dst-second-pane" >
   				<div id="container" ng-style="{'background-color':dstPaint.backgroundColor}">
				</div>
			</div>	<!-- second-pane-->
			
      		<div id="dst-third-pane">
		      	<div kendo-splitter="DstInfoSplitter"  
		      		 k-orientation="'vertical'" 
					 k-panes="[{ collapsible: true, resizable: false, size: '120px'},
		                		  { collapsible: true,size:'250px'},
		                  		  { collapsible: false, resizable: true}]"
		             style="height:100%;">
		             
			       <div id="dst-info-pane">
			       </div>
			       
			       <div id="dst-thread-pane">
			       		Threads:
			       		<textarea ng-model="dstPaint.dstCanvas.threadCodes" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  style="width:100%;resize: vertical;"></textarea>
			       				  
			    		<div kendo-sortable="dstThreadGridSortable"	k-options="dstPaint.threadGridSortableOptions">
							<div  kendo-grid="dstThreadGrid" id="dstThreadGrid" k-options="dstPaint.threadGridOptions()" ></div>
						</div>
			       		
			       </div>
			       
			       <div id="dst-step-pane">
			       		Running Steps:
			       		<textarea ng-model="dstPaint.dstCanvas.runningSteps" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  style="width:100%;resize: vertical;"></textarea>
			    		<div kendo-sortable="dstStepGridSortable"	k-options="dstPaint.stepGridSortableOptions">
							<div  kendo-grid="dstStepGrid" id="dstStepGrid" k-options="dstPaint.stepGridOptions()" ></div>
						</div>
			       </div>
			       
		       </div>
		       
			</div>	<!-- third-pane-->
			
		</div>
			
	   
	</div>

		
	</div>
	 
	
<script>
var orderApp = angular.module("embDesignApp",
		["kendo.directives","embdesign"]);

orderApp.controller("testCtrl",
		["$scope","DstPaint","DstDesign","DstCanvas","DstStage",
		function($scope,DstPaint,DstDesign,DstCanvas,DstStage){
			
	//{code:"S0561",r:255,g:0,b:0},{code:"S1011",r:125,g:125,b:125},{code:"S1043",r:0,g:0,b:255}
	//var runningStepList=new kendo.data.ObservableArray([{code:"S1043",codeIndex:1}]);

	$scope.dstPaint=new DstPaint({stage:"container"});
	
    $scope.$on("kendoWidgetCreated", function(event, widget){
        // the event is emitted for every widget; if we have multiple
        // widgets in this controller, we need to check that the event
        // is for the one we're interested in.
        if (widget ===$scope.dstThreadGrid) {
        	$scope.dstPaint.wrapThreadGrid();
        }
        if (widget ===$scope.dstStepGrid) {
        	$scope.dstPaint.wrapStepGrid();
        }
    });
	
	
	
/*         var stage = new DstStage({container: 'container',
						          width: 1024,
						          height: 800}); */
 
//    	stage.getContent().addEventListener("mousedown",function(evt){
//    		alert("mousedown");
//    	});

/*         var layer = stage.createLayer(true); */
    
    var dstDesign=new DstDesign();
    var dstCanvas=new DstCanvas(dstDesign);
	
	$scope.addDstImage=function(){
		
		var dstImage=new Kinetic.Image({
			x:0,
			y:0,
			draggable:true,
			width:dstCanvas.getOriginalWidth(),
			height:dstCanvas.getOriginalHeight(),
			image:dstCanvas.imageObj
		});
		
		$scope.dstPaint.dstStage.add(dstImage);
	};
	
	
	$scope.drawDstImage=function(){
 		dstCanvas.drawDesign();
 		$scope.dstPaint.dstStage.draw();
	}
	
	$scope.setCanvas=function(){
 		dstCanvas.drawDesign();
 		$scope.dstPaint.setDstCanvas(dstCanvas);
	}

	$scope.getDstImage=function(){
		
		dstDesign.getDst(4);
	}

}]);
	
</script>
</body>
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
		height:21px;
	}

	textarea{
		margin:3px 0px;
	}
	
	.colourCell{
		float: left; 
		width: 100%; 
		border:1px solid black; 
		border-radius:2px 2px 2px;
		height:12px;
		}
	.k-dirty {
  		border-width:0;
	}
</style>

</html>
