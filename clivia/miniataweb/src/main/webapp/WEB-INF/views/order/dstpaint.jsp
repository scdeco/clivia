<!DOCTYPE html>
<html>
<head>
	<title>test</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<shared:header/> 
	
	<%@include file="../common/embdesign.jsp"%>
	<%@include file="../common/gridwrapper.jsp"%>
</head>
<body ng-app="embDesignApp" spellcheck="false">
	<div ng-controller="testCtrl">
		
		<button ng-click="getDstImage()" >Get DST</button>
    	<button ng-click="setCanvas()" >setCanvas</button>
		<button ng-click="addDstImage()" >Add</button>
    	<button ng-click="print()" >Print</button>

    <div class="k-header wide" >
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
      			ng-resize="resizeStage()"
      	
				k-panes="[{ collapsible: false, resizable: false, size: '38px'},
                		  { collapsible: false},
                  		  { collapsible: true, resizable: true,size:'200px'}]"
		    	style="height:750px;">      	
      	
      	      		<!-- 		ng-model="dstPaint.backgroundColor"  -->
      		<div id="dst-first-pane">

			</div>	<!-- first-pane-->
			
      		<div id="dst-second-pane" >
   				<div id="container" ng-style="{'background-color':dstPaint.backgroundColor}">
				</div>
			</div>	<!-- second-pane-->
			
      		<div id="dst-third-pane">
		      	<div kendo-splitter="DstInfoSplitter"  
		      		 k-orientation="'vertical'" 
					 k-panes="[{ collapsible: true, resizable: true, size: '120px'},
		                		  { collapsible: true,size:'250px'},
		                  		  { collapsible: false, resizable: true}]"
		             style="height:100%;">
		             
			       <div id="dst-info-pane">
			       		<div kendo-tab-strip 
			       			 k-animation="false">
			       			<ul>
			       				<li class="k-state-active">Info</li>
			       				<li>palette</li>
			       				<li>picker</li>
			       				<li>Fabric</li>
			       				<li>Thread</li>
			       			</ul>
			      			<div>
				      			<div id="info">		<!-- tabpage of info -->
				      				<table>
				      					<tr>
				      						<td>{{dstPaint.dstCanvas.dstDesign.designNumber}}</td>
				      					</tr>
				      					<tr>
				      						<td>Stitches:</td>
				      						<td>{{dstPaint.dstCanvas.dstDesign.stitchCount}}</td>
				      						<td>Steps:</td>
				      						<td>{{dstPaint.dstCanvas.dstDesign.stepCount}}</td>
				      					</tr>
				      					<tr>
				      						<td>Width:</td>
				      						<td>{{dstPaint.dstCanvas.dstDesign.width}}</td>
				      						<td>Height:</td>
				      						<td>{{dstPaint.dstCanvas.dstDesign.height}}</td>
				      					</tr>
				      				</table>
				      			</div>
			      			</div>
			      			
			      			
			      			<div kendo-color-palette
			 	   				 ng-model="dstPaint.backgroundColor"
			       				 k-orientation="'vertical'"
			       				 k-columns="8"
			       				 k-titleSize="{'width':12}"
			       				 k-options="dstPaint.backgroundColorPaletteOptions()">
			      			</div>
			      			
			      			<div kendo-flat-color-picker
			 	   				 ng-model="dstPaint.backgroundColor"
			 	   				 k-preview="false">
			      			</div>

			      			<div>
			      				Fabric
			      			</div>
			      			
			      			<div>
			      				Thread
			      			</div>
			       		</div>
			       </div>
			       
			       <div id="dst-thread-pane">
			       		Threads:
				       		<textarea ng-model="dstPaint.dstCanvas.threadCodes" 
				       				  ng-trim="true"
				       				  class="k-textbox" 
				       				  style="width:100%;resize: vertical;"></textarea>
				       				  
				    		<div kendo-sortable="dstThreadGridSortable"	k-options="dstPaint.gwThread.getSortableOptions()">
								<div  kendo-grid="dstThreadGrid" id="dstThreadGrid" k-options="dstPaint.threadGridOptions()" ></div>
							</div>
			       </div>
			       
			       <div id="dst-step-pane">
			       		Running Steps:
			       		<textarea ng-model="dstPaint.dstCanvas.runningSteps" 
			       				  ng-trim="true"
			       				  class="k-textbox" 
			       				  style="width:100%;resize: vertical;"></textarea>
			    		<div kendo-sortable="dstStepGridSortable"	k-options="dstPaint.gwStep.getSortableOptions()">
							<div  kendo-grid="dstStepGrid" id="dstStepGrid" k-options="dstPaint.stepGridOptions()"></div>
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
	dstDesign.getDst(2);
    var dstCanvas=new DstCanvas();
	
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
	
	
	$scope.print=function(){
		var dataUrl=document.getElementById("DstCanvas1").toDataURL();
	    var windowContent = '<!DOCTYPE html>';
	    windowContent += '<html>'
	    windowContent += '<head><title>Print canvas</title></head>';
	    windowContent += '<body>'
	    windowContent += '<img src="' + dataUrl + '">';
	    windowContent += '</body>';
	    windowContent += '</html>';
	    var printWin = window.open('','','width=800,height=600');
	    printWin.document.open();
	    printWin.document.write(windowContent);
	    printWin.document.close();
	    printWin.focus();
	    printWin.print();
	    printWin.close();
	}
	
	$scope.setCanvas=function(){
		dstCanvas.setDstDesign(dstDesign)
 		dstCanvas.drawDesign();
 		$scope.dstPaint.setDstCanvas(dstCanvas);
	}

	$scope.getDstImage=function(){
		
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
