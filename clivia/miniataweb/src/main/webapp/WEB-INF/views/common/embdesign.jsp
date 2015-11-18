<script>
angular.module("embdesign",	["kendo.directives"]).

factory("Selector",function(){
	var ANCHOR_HALF_SIZE=3,ANCHOR_SIZE=ANCHOR_HALF_SIZE*2+1;
	var Anchor=function(x,y,id,name) {
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
		this.originalCursor='default';
		this.curosr=name+"-resize";
		
        this.on('dragmove', function () {
        	this.getParent().update(this);
        });
        this.on('mousedown touchstart', function () {
        	this.getParent().draggable(false);
        });
        this.on('dragend', function () {
        	var p=this.getParent();
        	p.draggable(p.selectedDraggable);
            p.update(this);
        });
        
        // add hover styling
        this.on('mouseover', function () {
        	this.originalCursor=document.body.style.cursor;
            document.body.style.cursor =this.curosr;
        });
        this.on('mouseout', function () {
            document.body.style.cursor = this.originalCursor;
        });
    };
    
    Anchor.prototype = {
        _initAnchor: function(config) {
            Kinetic.Rect.call(this, config);
            },
        myFunc : function(){
        }
    };
	Kinetic.Util.extend(Anchor, Kinetic.Rect);	
	
	
	var Selector=function(){
		
		this.selected=null;
		this.selectedDraggable=true;
		this.anchors=[];
		this.lines=[];
		this.keepRatio=true;
		this.ratio=1;
		
		var config={
				visible:false
				};
		this._initSelector(config);
	}
	
	Selector.prototype={
			
		_initSelector:function(config){
			Kinetic.Group.call(this,config);
			this.anchors.push(new Anchor(0,0,"nw","nwse"));
			this.anchors.push(new Anchor(0,0,"w","ew"));
			this.anchors.push(new Anchor(0,0,"sw","nesw"));
			this.anchors.push(new Anchor(0,0,"n","ns"));
			this.anchors.push(new Anchor(0,0,"s","ns"));
			this.anchors.push(new Anchor(0,0,"ne","nesw"));
			this.anchors.push(new Anchor(0,0,"e","ew"));
			this.anchors.push(new Anchor(0,0,"se","nwse"));

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
				this.ratio=w/h;

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
				var ap,ap0,ap1;		//Absolute Position
				var ow=this.getWidth(),oh=this.getHeight();		//width and height before adjusted
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
				
				if(this.keepRatio)
					if (Math.abs(w-ow)>=Math.abs(h-oh))
						h=(w/this.ratio)|0;
					else
						w=(h*this.ratio)|0;
				
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
	Kinetic.Util.extend(Selector, Kinetic.Group);	
	
	return Selector;
}).


factory("DictThread",["$http",function($http){		//service
	var DictThread={
		threads:[],
		defaultThreadColor:{r:100,g:100,b:100},
		defaultThreadColors:[{r:0,	g:255,	b:0	},
		     				{r:0,	g:0,	b:255},
		     				{r:255,	g:0,	b:0},
		     				{r:255,	g:255,	b:0},
		     				{r:0,	g:255,	b:255},
		     				{r:255,	g:0,	b:255},
		     				{r:0,	g:153,	b:0},
		     				{r:0,	g:0,	b:153},
		     				{r:153,	g:0,	b:0},
		     				{r:255,	g:153,	b:51},
		     				{r:153,	g:0,	b:204},
		     				{r:153,	g:102,	b:51},
		     				{r:255,	g:126,	b:204},
		     				{r:28,	g:176,	b:193},
		     				{r:112,	g:56,	b:56}],
		retrieve:function(){
			var url="http:///192.6.2.108:8080/miniataweb/datasource/dictEmbroideryThreadDao/read"
			$http.get(url).
				success(function(data, status, headers, config) {
			    	ts=[];
			    	for(var i=0,t,d;i<data.length;i++){
			    		d=data[i];
			    		t={code:d.code,r:d.red,g:d.green,b:d.blue};
			    		ts.push(t);
			    	}
			    	DictThread.threads=ts
				}).
				error(function(data, status, headers, config) {
				});
					
		},			
		
		getDefaultColorModel:function(){
			var colorModel=[DictThread.defaultThreadColor];
			var threadColors=DictThread.defaultThreadColors;
			for(var i=0; i<255; i++)
				colorModel.push(threadColors[i%15]);
			return colorModel;
		},

		getThreadColor:function(code){
			var c=DictThread.defaultThreadColor;
			if(code){
				code=code.trim().toUpperCase();
				var threads=DictThread.threads;
				for(var i=0;i<threads.length;i++ )
					if(threads[i].code===code){
						c=threads[i];
						break;
					}
			}
			return c;
		},
		
		getThreadColors:function(threadCodes){
			var threadColors=[DictThread.defaultThreadColor],
				codeList=threadCodes.split(',');
			
			for(var i=0;i<codeList.length;i++){
				threadColors.push(DictThread.getThreadColor(codeList[i]))
			}
			return threadColors;
		},
		
		
		getColorModel:function(colorway,stepCount){
			var colorModel;
			if(!colorway.threadCodes||!colorway.runningSteps||!stepCount){
				colorModel=this.getDefaultColorModel();
			}else{
				colorModel=[DictThread.defaultThreadColor];
				
				
				threadColors=DictThread.getThreadColors(colorway.threadCodes);
				runningSteps=colorway.runningSteps.split('-',stepCount);
				
				for(var i=0,idx;i<stepCount;i++){
					idx=(i>=colorway.runningSteps.length)?0: parseInt(runningSteps[i]);
					if(!(idx>=0))
						idx=0;
					colorModel.push(threadColors[idx]);
				}
			}
			return colorModel;
		},
		
			
	};
	
	DictThread.retrieve();
	
	return  DictThread;
}]).
		
factory("DstDesign",["$http","DictThread",function($http,DictThread){
	
	var DstDesign=function(id){
		this.pixelWidth=0;
		this.pixelHeight=0;	
		this.stitchCount=0;
		this.stitchList=[];
		this.stepCount=0;
		this.stepList=[];
		
		if(!!id) this.getDst(id);
	}
	
	DstDesign.prototype={
			
		initDst:function(){
			this.pixelWidth=0;
			this.pixelHeight=0;	
			this.stitchCount=0;
			this.stitchList=[];	
			this.stepCount=0;
			this.stepList=[];
			},
		
		getDst:function(dstId){
		
			var url="/miniataweb/library/embdesign/getstitches?id="+dstId;
			var self=this;
			
			$http.get(url).
				success(function(data, status, headers, config) {
					var design=data.data;
					self.pixelWidth=design.pixelWidth;
					self.pixelHeight=design.pixelHeight;
					self.stitchCount=design.stitchCount;
					self.stitchList=design.stitchList;
					self.stepCount=design.stepCount;
					self.stepList=design.stepList;
				}).
				error(function(data, status, headers, config) {
					self.initDst();
				});								
			},
			
		drawStep:function(ctx,color,stepIndex,highLight,ratio){
		
			var stitchList=this.stitchList,
				firstStitch=this.stepList[stepIndex].firstStitch,
				lastStitch=this.stepList[stepIndex].lastStitch,
				prevStitchIsJump=true;
			
			ctx.strokeStyle="rgb("+color.r+","+color.g+","+color.b+")";   //+",1)";
			ctx.beginPath();
			
			for(var i=firstStitch, currStitch; i<=lastStitch; i++){
				currStitch=stitchList[i];
				if(!currStitch) 
					break;
		
				if (currStitch.f === 1){
					if(prevStitchIsJump){
						ctx.moveTo(Math.round(currStitch.x*ratio)+0.5,Math.round(currStitch.y*ratio)+0.5);
						prevStitchIsJump=false;
					}else{
						ctx.lineTo(Math.round(currStitch.x*ratio)+0.5,Math.round(currStitch.y*ratio)+0.5);
					}
				}else{
					prevStitchIsJump=true;
				}
			}
			ctx.stroke();
			
		},
		
		drawDesign:function(ctx,colorway,ratio){
			var colorModel=DictThread.getColorModel(colorway,this.stepCount);
			for(var stepIndex=0; stepIndex < this.stepCount;stepIndex++){
 				this.drawStep(ctx,colorModel[stepIndex+1],stepIndex,true,ratio);
			}
		},
	}
	
	return DstDesign;
		
}]).

factory("DstCanvas",["DstDesign",function(DstDesign){
	
	var SCREEN_PPM=1280/340,SCREEN_DESIGN_RATIO=SCREEN_PPM/10;
	
	var DstCanvas=function(dstDesign){
		
		this.canvas=document.createElement('canvas');
		this.canvas.id=this.createElementId();
		//this.canvas.style.visibility='hidden';
		this.ctx=this.canvas.getContext("2d");
		document.body.appendChild(this.canvas);
		this.imageObj=document.getElementById(this.canvas.id);
		
		this.ctx.lineWidth=1;
		
		this.colorway={threadCodes:"",runningSteps:""};
		this.dstDesign=null;
		this.setDstDesign(dstDesign)
	}
	
	DstCanvas.prototype={

		createElementId:function(){
				if(angular.isUndefined(DstCanvas.prototype.randomId))
					DstCanvas.prototype.randomId=0;
					
				return "DstCanvas"+(++DstCanvas.prototype.randomId);
			},
			
		getOriginalWidth:function(){
			return this.canvas.width;
		},
		getOriginalHeight:function(){
			return this.canvas.height;
		},

		setDstDesign:function(dstDesign){
			if(angular.isDefined(dstDesign)){
				this.dstDesign=dstDesign;
			}else{
				this.dstDesign=null;
				this.canvas.width=0;
				this.canvas.height=0;
			}
		},
		
		clearCanvas:function(){
			this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
		},

		setColorway:function(threadCodes,runningSteps){
			this.colorway.threadCodes=threadCodes,
			this.colorway.runningSteps=runningSteps;
		},
		
		drawDesign:function(){
	
			this.canvas.width=Math.round(this.dstDesign.pixelWidth*SCREEN_DESIGN_RATIO)+1;
			this.canvas.height=Math.round(this.dstDesign.pixelHeight*SCREEN_DESIGN_RATIO)+1;
			this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
			
			if(this.dstDesign)
				this.dstDesign.drawDesign(this.ctx,this.colorway,SCREEN_DESIGN_RATIO);
		},
	}
	
	return DstCanvas; 
}]).


factory("DstStage",["Selector",function(Selector){
	var DstStage=function(config){	//{container: 'container', width: 1024, height: 800}

		this.stage=new Kinetic.Stage(config);
		this.backGroundLayer=new Kinetic.Layer();
		this.stage.add(this.backGroundLayer);
		this.selector=new Selector();
		this.currentLayer=this.backGroundLayer;
	}
	
	DstStage.prototype={
			createLayer:function(addToStage){
				var newLayer=new Kinetic.Layer();
				if(addToStage)
					this.stage.add(newLayer);
				this.currentLayer=newLayer;
				return newLayer;
			},
			addLayer:function(layer){
				this.stage.add(layer);
			},
			add:function(object){
				var self=this;
				object.on("mousedown",function(){
						self.selector.setSelected(object);
				});
				this.currentLayer.add(object);
				this.currentLayer.draw();
			},
			draw:function(){
				this.currentLayer.draw();
			}
	}
	
	return DstStage;
	
}]);


</script>