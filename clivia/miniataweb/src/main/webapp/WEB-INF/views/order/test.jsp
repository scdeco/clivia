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
		<button ng-click="addDstImage()" >Add</button>
		<button ng-click="testDstImage()" >Test</button>

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
      				ng-model="dstBackgroundColor" 
      				k-options="dstBackgroundColorOptions">
      			</div>
			</div>	<!-- first-pane-->
			
      		<div id="dst-second-pane" >
   				<div id="container" ng-style="{'background-color':dstBackgroundColor}">
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
			       		<button ng-click="drawDstImage()" >Draw</button>
			       </div>
			       
			       <div id="dst-thread-pane">
			       		Threads:
			       		<textarea ng-model="threadCodes" 
			       				  ng-trim="true"
			       				  style="width:100%;resize: vertical;"></textarea>
			       				  
			    		<div kendo-sortable="dstThreadGridSortable"	k-options="dstThreadGridSortableOptions">
							<div  kendo-grid="dstThreadGrid" id="dstThreadGrid" k-options="dstThreadGridOptions" ></div>
						</div>
			       		
			       </div>
			       
			       <div id="dst-step-pane">
			       		Running Steps:
			       		<textarea ng-model="runningSteps" 
			       				  ng-trim="true"
			       				  style="width:100%;resize: vertical;"></textarea>
			       </div>
			       
		       </div>
		       
			</div>	<!-- third-pane-->
			
		</div>
			
	   
	</div>

		
	</div>
	 
	
<script>
var orderApp = angular.module("embDesignApp",
		["kendo.directives","embdesign","cliviagrid"]);

orderApp.controller("testCtrl",["$scope","DstDesign","DstCanvas","DstStage","GridWrapper",function($scope,DstDesign,DstCanvas,DstStage,GridWrapper){
	
	$scope.dstBackgroundColorOptions={
	        columns: 1,
	        tileSize: {
	            width: 34,
	            height: 19
	        },
	        palette: [
	            "#f0d0c9", "#e2a293", "#d4735e", "#65281a",
	            "#eddfda", "#dcc0b6", "#cba092", "#7b4b3a",
	            "#fcecd5", "#f9d9ab", "#f6c781", "#c87d0e",
	            "#e1dca5", "#d0c974", "#a29a36", "#514d1b",
	            "#c6d9f0", "#8db3e2", "#548dd4", "#17365d"
	        ],
	}
	
	var gwThread=new GridWrapper("dstThreadGrid");
	
	var threadGridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 15,
			}, {			
				name:"colour",
			    field: "colour",
			    title: " ",
			    width: 20
			}, {			
				name:"thread",
			    field: "thread",
			    title: "Thread",
			}];
	gwThread.setColumns(threadGridColumns);
	
	
	
	$scope.dstThreadGridOptions={
			columns:threadGridColumns,
	        editable: true,
	        selectable: "cell",
	        navigatable: true,			
	}
	
	$scope.dst={};
	
	
        var stage = new DstStage({container: 'container',
						          width: 1024,
						          height: 800});
 
//    	stage.getContent().addEventListener("mousedown",function(evt){
//    		alert("mousedown");
//    	});

        var layer = stage.createLayer(true);
    
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
		
		stage.add(dstImage);
		
	};
	
	$scope.drawDstImage=function(){
		dstCanvas.setColorway($scope.threadCodes,$scope.runningSteps);
 		dstCanvas.drawDesign();
 		stage.draw();
 		
	}
	

	$scope.getDstImage=function(){
		
		dstDesign.getDst(1);
	}

}]);
	
</script>
</body>
</html>
