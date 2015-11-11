<!DOCTYPE html>
<html>
<head>
	<title>test</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<shared:header/> 
</head>
<body ng-app="kineticApp">
	<div ng-controller="testCtrl">
	
		<div id="container">
		</div>
		
		<button ng-click="getDstImage()" >Get DST</button>
		<button ng-click="addDstImage()" >Add</button>
		<button ng-click="testDstImage()" >Test</button>
		<div>
		<img id="dstImage" ng-src="data:image/png;base64,{{dst.dstImage}}" alt="image" style="width:auto;height:100%;">
		</div>
		
		<canvas id="myCanvas" width="423" height="307" style="width:159px;height:auto"></canvas>
		
	</div>
	 
	
<script>
var orderApp = angular.module("kineticApp",
		["kendo.directives"]);

orderApp.controller("testCtrl",["$scope","$http",function($scope,$http){
	$scope.dst={};
	
	var ANCHOR_HALF_SIZE=2,ANCHOR_SIZE=ANCHOR_HALF_SIZE*2+1;
	function CliviaAnchor(x,y,id,name) {
		var config={
            x: x,
            y: y,
            width: ANCHOR_SIZE,
			height: ANCHOR_SIZE,
            stroke: 'black',
           	fill: 'white',
            strokeWidth: 1,
            id:id,
            name: name,
            draggable: true,
        };
        this._initAnchor(config);
        this.on('dragmove', function () {
        	this.getParent().update(this);
        });
        this.on('mousedown touchstart', function () {
        	this.getParent().draggable(false);
        });
        this.on('dragend', function () {
        	parent=this.getParent();
        	parent.draggable(parent.selectedDraggable);
            parent.update(this);
        });
        
        // add hover styling
        this.on('mouseover', function () {
            document.body.style.cursor = this.name()+"-resize";
        });
        this.on('mouseout', function () {
            document.body.style.cursor = 'default';
        });

    };
    CliviaAnchor.prototype = {
        _initAnchor: function(config) {
            Kinetic.Rect.call(this, config);
            },
        myFunc : function(){
        }
    };
	Kinetic.Util.extend(CliviaAnchor, Kinetic.Rect);	
	
	
	function CliviaSelector(){
		
		this.selected=null;
		this.selectedDraggable=true;
		this.anchors=[];
		this.lines=[];
		
		var config={
				visible:false
				};
		this._initSelector(config);
	}
	
	CliviaSelector.prototype={
			
		_initSelector:function(config){
			Kinetic.Group.call(this,config);
			this.anchors.push(new CliviaAnchor(0,0,"nw","nwse"));
			this.anchors.push(new CliviaAnchor(0,0,"w","ew"));
			this.anchors.push(new CliviaAnchor(0,0,"sw","nesw"));
			this.anchors.push(new CliviaAnchor(0,0,"n","ns"));
			this.anchors.push(new CliviaAnchor(0,0,"s","ns"));
			this.anchors.push(new CliviaAnchor(0,0,"ne","nesw"));
			this.anchors.push(new CliviaAnchor(0,0,"e","ew"));
			this.anchors.push(new CliviaAnchor(0,0,"se","nwse"));

			var selector=this;
			for(var i=0;i<8;i++){
				anchor=this.anchors[i];
				this.add(anchor);
			}			
		},
			
		setSelected:function(selected){
			if(selected===this.selected) return;
			if(this.selected!=null){
				//remove this object from selector and put back into it's original parent. 
				//ZIndex and draggable properties are recoverd as well.
				var ap=this.getAbsolutePosition();
				this.getParent().add(this.selected);
				this.selected.setAbsolutePosition({x:ap.x+ANCHOR_HALF_SIZE,y:ap.y+ANCHOR_HALF_SIZE});
				this.selected.setZIndex(this.getZIndex());
				this.selected.draggable(this.selectedDraggable);
				this.selected=null;
			};
			if(selected!=null){
				this.selected=selected;
				this.selectedDraggable=selected.draggable();
				selected.draggable(false);
				this.draggable(this.selectedDraggable);
				
				var parent=selected.getParent();
				var zIndex=selected.getZIndex();
				var ap=selected.getAbsolutePosition();
							  
				var w=selected.getWidth()+ANCHOR_HALF_SIZE*2;
				var h=selected.getHeight()+ANCHOR_HALF_SIZE*2;

				parent.add(this);
				this.setZIndex(zIndex);
				this.add(selected);
				selected.moveToBottom();

				ap.x-=ANCHOR_HALF_SIZE;
				ap.y-=ANCHOR_HALF_SIZE;

				this.show();

				this.adjust(ap,w,h);
			}
			else{
				this.hide();
			}
			this.drawLayer();
		},
		
		drawLayer:function(){
			var layer=this.getLayer();
			
			//apply filters, otherwise image will not be resized
			var filters=this.selected.filters();
			if(filters!==undefined && filters.length>0){
				this.selected.cache();
				this.selected.filters(filters);
			}
			
			if(layer) layer.draw();
		},
		
		update:function(anchor){
				var ap,ap0,ap1;
		        switch (anchor.name()) {
		            case 'nwse':
		            	ap0=this.anchors[0].getAbsolutePosition();	//nw
		            	ap1=this.anchors[7].getAbsolutePosition();	//se
		            	w=Math.abs(ap1.x-ap0.x)+ANCHOR_SIZE;
		            	h=Math.abs(ap1.y-ap0.y)+ANCHOR_SIZE;
		            	ap=ap0;
		            	break;
		            case 'nesw':
		            	ap0=this.anchors[2].getAbsolutePosition();	//sw
		            	ap1=this.anchors[5].getAbsolutePosition();	//ne
		            	w=Math.abs(ap1.x-ap0.x)+ANCHOR_SIZE;
		            	h=Math.abs(ap1.y-ap0.y)+ANCHOR_SIZE;
		            	ap={x:ap0.x,y:ap1.y};
		            	break;
		            case 'ns':
		            	ap0=this.anchors[3].getAbsolutePosition();	//n
		            	ap1=this.anchors[4].getAbsolutePosition();	//s
		            	ap2=this.anchors[0].getAbsolutePosition();	//nw
		            	w=this.getWidth();
		            	h=Math.abs(ap1.y-ap0.y)+ANCHOR_SIZE;
		            	ap={x:ap2.x,y:ap0.y};
		            	break;
		            case 'ew':
		            	ap0=this.anchors[1].getAbsolutePosition();	//w
		            	ap1=this.anchors[6].getAbsolutePosition();	//e
		            	ap2=this.anchors[0].getAbsolutePosition();	//nw
		            	w=Math.abs(ap1.x-ap0.x)+ANCHOR_SIZE;
		            	h=this.getHeight();
		            	ap={x:ap0.x,y:ap2.y};
		            	break;
		        }
		        this.adjust(ap,w,h);
		        this.drawLayer();
		},
		
		adjust:function(ap,w,h){
			this.setAbsolutePosition(ap);
			this.setWidth(w);
			this.setHeight(h);
			
			var selected=this.selected;
			
			selected.setPosition({x:ANCHOR_HALF_SIZE,y:ANCHOR_HALF_SIZE});
			selected.setWidth(w-ANCHOR_HALF_SIZE*2);
			selected.setHeight(h-ANCHOR_HALF_SIZE*2);
			
			var anchors=this.anchors;
			
			anchors[0].setPosition({x:0,            		y:0});
			anchors[1].setPosition({x:0,					y:h/2-ANCHOR_HALF_SIZE});
			anchors[2].setPosition({x:0,					y:h-ANCHOR_SIZE});
			anchors[3].setPosition({x:w/2-ANCHOR_HALF_SIZE,	y:0});
			anchors[4].setPosition({x:w/2-ANCHOR_HALF_SIZE,	y:h-ANCHOR_SIZE});
			anchors[5].setPosition({x:w-ANCHOR_SIZE,		y:0});
			anchors[6].setPosition({x:w-ANCHOR_SIZE,		y:h/2-ANCHOR_HALF_SIZE});
			anchors[7].setPosition({x:w-ANCHOR_SIZE,		y:h-ANCHOR_SIZE});			
		},
	}
	Kinetic.Util.extend(CliviaSelector, Kinetic.Group);	
	
	Kinetic.Filters.EmbFilter = function(imageData) {
		var model = this.embColorModel();
		var r=model.r, g=model.g, b=model.b ;
		var data=imageData.data, len=data.length;
		var idx,i;
 		for(i=0; i<len; i+=4){
			idx=data[i];
			
			if(data[i]!==data[i+1]||data[i+1]!==data[i+2]){
				idx=idx;
			}
			
			if(idx>0){
				idx=idx-50;
				data[i]=r[idx];
				data[i+1]=g[idx];
				data[i+2]=b[idx];
//				data[i+3]=255;
			}else{
//  				data[i]=0;
// 				data[i+1]=0;
// 				data[i+2]=0; 
// 				data[i+3]=0;
			}
		} 
	};
	
	Kinetic.Factory.addGetterSetter(Kinetic.Image, 'embColorModel', 0, null, Kinetic.Factory.afterSetFilter);
	

        var stage = new Kinetic.Stage({
            container: 'container',
            width: 930,
            height: 400
        });

        var layer = new Kinetic.Layer();

        
        var selector=new CliviaSelector();
        
        var redRect = new Kinetic.Rect({
            x: 270,
            y: 100,
            name: 'red',
            width: 100,
            height: 100,
            fill: 'red',
            stroke: 'black',
            strokeWidth:7,
            opacity: 0.5,
            draggable:true
        });
        
        redRect.on('mousedown',function(){
        	selector.setSelected(this);
        });
        
        var greenRect = new Kinetic.Rect({
            x: 21,
            y: 21,
            name: 'green',
            width: 100,
            height: 100,
            fill: 'green',
            stroke: 'black',
            strokeWidth: 1,
            opacity: 0.9,
            dashArray: [29, 20, 0.001, 20],
        	draggable:true
        });
        
        greenRect.on('mousedown',function(){
        	selector.setSelected(this);
        });

        
        var blueRect = new Kinetic.Rect({
            x: 280,
            y: 210,
            name: 'green',
            width: 100,
            height: 100,
            fill: 'blue',
            stroke: 'black',
            strokeWidth: 1,
            opacity: 0.9,
            dashArray: [29, 20, 0.001, 20],
        	draggable:false
        });
        
        blueRect.on('mousedown',function(){
        	selector.setSelected(this);
        });
        
        
        layer.add(redRect);
        layer.add(greenRect);
        layer.add(blueRect);
        stage.add(layer);
        stage.draw();
    
    var dstId=1;
    
	$scope.getDstImage=function(){
			var url="/miniataweb/library/embdesign/getstitches?id="+dstId;
			$http.get(url).
				success(function(data, status, headers, config) {
				    	$scope.dst.embDesign=data.data;
				    	$scope.drawDstImage();
				    	
				}).
				error(function(data, status, headers, config) {
					$scope.dst.dstembDesign=null;
				   });					
			dstId++;
	};
	
	var colorModel=	{
			r:[0,  0,  0,255,255,  0,255,  0,  0,153,255,153,153,255,0,255],
			g:[0,255,  0,  0,255,255,  0,153,  0,  0,153,  0,102,255,0,126],
			b:[0,  0,255,  0,  0,255,255,  0,153,  0, 51,204, 51,255,0,204]
	};
	
	

	
	$scope.addDstImage=function(){
		var imageObj=document.getElementById("dstImage"+(dstId-1));
		var image1=new Kinetic.Image({
			x:0,
			y:0,
			width:parseInt(imageObj.style.width),
			height:parseInt(imageObj.style.height),
//			stroke:"black",
			strokewidth:0,
//			opacity: 0.01,
			image:imageObj,
			draggable:true,
			embColorModel:colorModel,
		});

		image1.on('mousedown',function(){
		
        	selector.setSelected(this);
        	
        });
		layer.add(image1);
		
		//must after added into layer and stage
		image1.cache();		
		image1.filters([Kinetic.Filters.EmbFilter]);
		
		layer.draw();
		
	};
	
	stage.getContent().addEventListener("mousedown",function(evt){
//		alert("mousedown");
	});

	$scope.testDstImage=function(){
	    var c=document.getElementById("myCanvas");
		var ctx=c.getContext("2d");

		var img=document.getElementById("dstImage");
		var imgData=ctx.getImageData(10,10,img.width,img.height);

		var c=document.getElementById("myCanvas");
		var ctx=c.getContext("2d");
	    ctx.drawImage(img,10,10,img.width,img.height);		
		
		};	
	$
	$scope.drawDstImage=function(){
		
		var screenRatio=1280/340;
		if($scope.dst.embDesign.stitchCount===0) return;

		var canvas=document.createElement('canvas')
		
		canvas.id="dstImage"+(dstId-1);
		canvas.width = $scope.dst.embDesign.pixelWidth;
		canvas.height = $scope.dst.embDesign.pixelHeight;
		
		var w=parseInt(canvas.width/10*screenRatio),
			h=parseInt(canvas.height/10*screenRatio)
		
		canvas.style.width=w+'px';
		canvas.style.height=h+'px';
		
		var ctx=canvas.getContext("2d");
		ctx.lineWidth=1.3;
/* 	ctx.strokeStyle="rgb(255,0,0)";
				ctx.beginPath();
				ctx.moveTo(10,10);
				ctx.lineTo(19,19);
				ctx.stroke();
				ctx.closePath();
 */		
	
		for(var stepIndex=0;stepIndex<$scope.dst.embDesign.stepCount;stepIndex++)
			$scope.drawDstStep(stepIndex,ctx);
 		document.body.appendChild(canvas);
	}
	
	$scope.drawDstStep=function(stepIndex,ctx){
		var step=$scope.dst.embDesign.stepList[stepIndex];
		var colorIndex=stepIndex+1;
		
//		ctx.strokeStyle="rgb("+colorModel.r[colorIndex]+","+colorModel.g[colorIndex]+","+colorModel.b[colorIndex]+")";
		ctx.strokeStyle="rgba("+(colorIndex+50)+","+(colorIndex+50)+","+(colorIndex+50)+",255)";
		
		var currStitch;
		var stitchList=$scope.dst.embDesign.stitchList
		var prevStitch=stitchList[step.firstStitch];

		for(var i=step.firstStitch+1;i<=step.lastStitch;i++){
			currStitch=stitchList[i];
			if(!currStitch) 
				break;
			//FunctionCode.JUMP||FunctionCode.STOP
			if (currStitch.f == 2||prevStitch.f == 3|| prevStitch.f == 9){
				if ($scope.dst.showTrim){
/* 					float[] dash1 = {2f,0f,2f};
					BasicStroke bs1 = new BasicStroke(1,BasicStroke.CAP_BUTT,BasicStroke.JOIN_ROUND,1.0f,dash1,2f);
					g2d.setStroke(bs1);
					g2d.drawLine(prevStitch.xImage,prevStitch.yImage,currStitch.xImage,currStitch.yImage);
 */				}
			}else{
				ctx.beginPath();
				ctx.moveTo(prevStitch.x,prevStitch.y);
				ctx.lineTo(currStitch.x,currStitch.y);
				ctx.stroke();
				ctx.closePath();
			}
			prevStitch=currStitch;
		}
	}

}]);
	
</script>
</body>
</html>
