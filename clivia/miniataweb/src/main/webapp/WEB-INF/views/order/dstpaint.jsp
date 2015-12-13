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
		<button ng-click="addEmbImage()" >Add</button>
    	<button ng-click="print()" >Print</button>

    <div class="k-header wide" >
      	<div 	kendo-splitter="DstSplitter"  
      			k-orientation="'horizontal'" 
      			
      	
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
      			<div thread-matcher="myThreadMatcher" c-emb-canvas="embCanvas"></div>
			</div>	<!-- third-pane-->
		</div>
			
	</div>

		
	</div>
	 
	
<script>
var orderApp = angular.module("embDesignApp",
		["kendo.directives","embdesign"]);

orderApp.controller("testCtrl",
		["$scope","EmbPaint","DstDesign","EmbCanvas","EmbStage",
		function($scope,EmbPaint,DstDesign,EmbCanvas,EmbStage){
			
	//{code:"S0561",r:255,g:0,b:0},{code:"S1011",r:125,g:125,b:125},{code:"S1043",r:0,g:0,b:255}
	//var runningStepList=new kendo.data.ObservableArray([{code:"S1043",codeIndex:1}]);

    $scope.dstDesign=new DstDesign();

    $scope.embStage=new EmbStage({container:'container',
        width: 1024,
        height: 800});
	
	$scope.embCanvas=new EmbCanvas($scope.dstDesign);

	$scope.embImage=new Kinetic.Image({
		x:0,
		y:0,
		draggable:true,
		width:$scope.embCanvas.getOriginalWidth(),
		height:$scope.embCanvas.getOriginalHeight(),
		image:$scope.embCanvas.imageObj
	});
	
	$scope.embStage.add($scope.embImage);
	
	var onImageChanged=function(e){
		$scope.embStage.draw();
	}
	
	var onDesignChanged=function(e){
		//e is dstDesign
		
		if($scope.myThreadMatcher 
				&&  $scope.myThreadMatcher.embCanvas 
				&&  $scope.myThreadMatcher.embCanvas.embDesign===e){
			
			$scope.myThreadMatcher.initColorwayList();
		}
	}
	
	$scope.dstDesign.change.addListener($scope.embCanvas,onDesignChanged);
	$scope.embCanvas.imageChanged.addListener($scope.embStage,onImageChanged);

    $scope.dstDesign.getDst(2);
	
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
