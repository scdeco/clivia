<script>
angular.module("embdesign",	["kendo.directives","clivia"]).

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
		defaultThreadColor:{r:100,g:100,b:100,a:0.05},
		cursorThreadColor:{r:0,g:255,b:0,a:1},
		defaultThreadColors:[{r:0,	g:255,	b:0 },
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

		getThreadColorHex:function(code){
			var c=DictThread.getThreadColor(code);
			return (c===this.defaultThreadColor)?"":"#" + ((1 << 24) + (c.r << 16) + (c.g << 8) + c.b).toString(16).slice(1);
		},
		
		getThreadColors:function(threadCodes){
			var threadColors=[DictThread.defaultThreadColor],
				codeList=threadCodes.split(',');
			
			for(var i=0;i<codeList.length;i++){
				threadColors.push(DictThread.getThreadColor(codeList[i]))
			}
			return threadColors;
		},
		
		getRunningSteps:function(steps,stepCount){
			var result=[];
			if(steps)
				result=steps.split('-',stepCount);
			for(var i=result.length;i<stepCount;i++)
				result.push('0');
			return result;
		},
		
		normalizeThreadCode:function(threadCode){
			var sCode=threadCode.trim().toUpperCase();
            if (sCode){
	                //default thread type is Sulkey
                var n;
	            if ("MS6".indexOf(sCode.charAt(0)) < 0 && sCode.length == 4 && parseInt(sCode))
	                    sCode = "S" + sCode;
	        }
	        return sCode;			
		},

		normalizeThreadCodes:function(threadCodes,stepCount){
			var limit=stepCount<15?stepCount:15;
			var codeList=threadCodes.split(',',limit);
			for(var i=0;i<codeList.length;i++)
				codeList[i]=normalizeThreadCode(codeList[i]);
			return codeList.join();
		},
		
		normalizeRunningStep:function(runningStep){
			var step=runningStep.trim().toUpperCase();
			if(!(step==='D'||step==='A'||step==='S'||step==='STOP')){		//3D or Applicae
				step=parseInt(step);
				if(step>=0)
					step=step.toString();
				else
					step='0';
			}
			return step;
		},
		
		normalizeRunningSteps:function(runningSteps,stepCount){
			var stepList=runningSteps.split("-",stepCount);
			for(var i=0;i<stepList.length;i++)
				stepList[i]=normalizeRunningSteps(stepList[i]);
			return stepList.join("-");
		},
		
		getDefaultColorModel:function(){
			
			var colorModel=[DictThread.defaultThreadColor];
			var threadColors=DictThread.defaultThreadColors;
			for(var i=0,colour; i<255; i++)
				colorModel.push(threadColors[i%15]);
			return colorModel;
		},

		//colorway={threadCodes:"1024,1043",runningSteps:"1-2-1-2",alaphaSteps:"0-0-1-0",alpha:0.1};
		//stepCount=4;
		getColorModel:function(colorway,stepCount){
			var colorModel;
			if(!colorway || (!colorway.threadCodes && !colorway.runningSteps)){
				colorModel=this.getDefaultColorModel();
			}else{
				
				colorModel=[DictThread.defaultThreadColor];
				
				var threadColors=DictThread.getThreadColors(colorway.threadCodes);
				var runningSteps=DictThread.getRunningSteps(colorway.runningSteps,stepCount);
				var alphaSteps=DictThread.getRunningSteps(colorway.alphaSteps,stepCount);
				
				var alpha=typeof colorway.alpha==='undefined'?0:colorway.alpha;
				
				for(var i=0,idx,c,a; i<stepCount; i++){
					
					idx=(i>=colorway.runningSteps.length)?0: parseInt(runningSteps[i]);
					if(idx>=16)
						c=DictThread.cursorThreadColor;
					else if (idx<threadColors.length)
						c=threadColors[idx];
					else
						c=threadColors[0];
					
					if(alpha)
						c={r:c.r,g:c.g,b:c.b,a:alphaSteps[i]==='1'?1:alpha}
					colorModel.push(c);
				}
			}
			return colorModel;
		},
		
			
	};
	
	DictThread.retrieve();
	
	return  DictThread;
}]).
		
factory("DstDesign",["$http",function($http){
	
	var DstDesign=function(id){
		this.initDesign();
		if(!!id) this.getDst(id);
	}
	
	DstDesign.prototype={
			
		initDesign:function(){
			this.width="";
			this.height="";
			this.startX="";
			this.startY="";
			this.left="";
			this.top="";
			this.right="";
			this.bottom="";
			this.stitchCount="";
			this.stepCount="";
			this.trimCount="";
			this.designNumber="";				
			
			this.pixelWidth=0;
			this.pixelHeight=0;	
			this.stitchList=[];	
			this.stepList=[];
			},
		
		isValid:function(){
			return this.stitchList.length>0;
		},
		
		getDst:function(dstId){
		
			var url="/miniataweb/library/embdesign/getstitches?id="+dstId;
			var self=this;
			this.initDesign();
			
			$http.get(url).
				success(function(data, status, headers, config) {
					var design=data.data;
					for(var property in design){
						if(design.hasOwnProperty(property))
							self[property]=design[property];
					}
				}).
				error(function(data, status, headers, config) {
				});								
		},
			
		drawStep:function(ctx,colour,stepIndex,scale){
		
			var stitchList=this.stitchList,
				firstStitch=this.stepList[stepIndex].firstStitch,
				lastStitch=this.stepList[stepIndex].lastStitch,
				prevStitchIsJump=true;
			
			ctx.strokeStyle="rgba("+colour.r+","+colour.g+","+colour.b+","+(typeof colour.a==='undefined'?1:colour.a)+")";   //+",1)";
			ctx.beginPath();
			
			for(var i=firstStitch, currStitch; i<=lastStitch; i++){
				currStitch=stitchList[i];
				if(!currStitch) 
					break;
		
				if (currStitch.f === 1){
					if(prevStitchIsJump){
						ctx.moveTo(Math.round(currStitch.x*scale)+0.5,Math.round(currStitch.y*scale)+0.5);
						prevStitchIsJump=false;
					}else{
						ctx.lineTo(Math.round(currStitch.x*scale)+0.5,Math.round(currStitch.y*scale)+0.5);
					}
				}else{
					prevStitchIsJump=true;
				}
			}
			ctx.stroke();
			
		},
		
		drawDesign:function(ctx,colorModel,scale){
			for(var stepIndex=0,colorIndex; stepIndex < this.stepCount;stepIndex++){
				colorIndex=stepIndex<(colorModel.length-1)?stepIndex+1:0;
 				this.drawStep(ctx,colorModel[colorIndex],stepIndex,scale);
			}
		},
	}
	
	return DstDesign;
		
}]).

factory("DstCanvas",["DstDesign","DictThread",function(DstDesign,DictThread){
	
	var SCREEN_PPM=1280/340,SCREEN_DESIGN_RATIO=SCREEN_PPM/10;
	
	var DstCanvas=function(dstDesign){
		
		this.canvas=document.createElement('canvas');
		this.canvas.id=this.createElementId();
		//this.canvas.style.visibility='hidden';
		this.ctx=this.canvas.getContext("2d");
		document.body.appendChild(this.canvas);
		this.imageObj=document.getElementById(this.canvas.id);
		
		this.ctx.lineWidth=1;
		
		this.threadCodes="";
		this.runningSteps="";
		this.dstDesign=null;
		this.setDstDesign(dstDesign)
		this.colorModel=null;			//colorModel used in current drawing
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
				this.canvas.width=Math.round(this.dstDesign.pixelWidth*SCREEN_DESIGN_RATIO)+1;		//original size of image
				this.canvas.height=Math.round(this.dstDesign.pixelHeight*SCREEN_DESIGN_RATIO)+1;
			}else{
				this.dstDesign=null;
				this.canvas.width=0;
				this.canvas.height=0;
			}
		},
		
		clearCanvas:function(){
			this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
			this.colorModel=null;
		},

		setColorway:function(threadCodes,runningSteps){
			this.threadCodes=threadCodes,
			this.runningSteps=runningSteps;
		},
		
		isNewColorModel:function(colorModel){
			if(!this.colorModel)
				return true;
			if(this.colorModel.length!=colorModel.length) 
				return true;
			for(var i=0;i<colorModel.length;i++){
				if(colorModel[i]!==this.colorModel[i]){
					return true;
				}
			}
			
			return false;
		},
		
		//if typeof colorway==="undefined", use delautColorModel
		//if colorway==={}, use thredCodes or runningSteps of this dstCanvas
		drawDesign:function(colorway){
			if(!this.dstDesign.isValid) 
				return;
	
			if(colorway){
				if(!colorway.threadCode)
					colorway.threadCodes=this.threadCodes;
				if(!colorway.runningSteps)
					colorway.runningSteps=this.runningSteps;
			};
			
			var colorModel=DictThread.getColorModel(colorway,this.dstDesign.stepCount);
			
			if (this.isNewColorModel(colorModel)){
				this.colorModel=colorModel;
				this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
				this.dstDesign.drawDesign(this.ctx,colorModel,SCREEN_DESIGN_RATIO);
			}
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
	
}])

.factory("DstPaint",["DictThread","DstDesign","DstCanvas","DstStage","GridWrapper",
		function(DictThread,DstDesign,DstCanvas,DstStage,GridWrapper){
	
	var MAX_THREAD_COUNT=15;

	var paletteColors=[
            "#fefefe", "#c4c4c4", "#787878", "#202020",
            "#c6d9f0", "#8db3e2", "#548dd4", "#17365d",
            "#f0d0c9", "#e2a293", "#d4735e", "#65281a",
            "#eddfda", "#dcc0b6", "#cba092", "#7b4b3a",
            "#fcecd5", "#f9d9ab", "#f6c781", "#c87d0e",
            "#e1dca5", "#d0c974", "#a29a36", "#514d1b",
	       ];
	
	var threadGridColumns=[{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 20,
			}, {			
				name:"colour",
			    title: " ",
			    width: 30,
			    template: "<span #if(colour){# class='colorCell' #}# style='background-color:#= colour #;'>&nbsp;</span>"
			}, {			
				name:"thread",
			    field: "code",
			    title: "Thread",
			}];
	
	var stepGridColumns=[{
		        name:"lineNumber",
		        title: " ",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 20,
			}, {			
				name:"stitchCount",
			    title: "St.",
			    width: 45,
			    field:"stepStitchCount",
			    attributes:{style:"text-align:right;"},
			    editor:function(container, options) {
			         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
			     },
			}, {			
				name:"colour",
			    title: " ",
			    width: 30,
			    template: "<span #if(threadIndex){# class='colorCell' #}# style='background-color:#= renderingPaint.getThreadColor(threadIndex) #;'>&nbsp;</span>"
			}, {			
				name:"code",
			    field: "code",
			    title: "Thread",
			}, {			
				name:"threadIndex",
			    title: "#",
			    field:"threadIndex",
			    attributes:{style:"text-align:right;"},
			    editor:function(container, options) {
			         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
			     },
			    width: 30
			}];
	
    var dstPaint=function(config){
    		this.gwThread=new GridWrapper("dstThreadGrid");
			this.gwThread.setColumns(threadGridColumns);
			this.gwThread.enableEnterMoveDown();
			
    		this.gwStep=new GridWrapper("dstStepGrid");
			this.gwStep.setColumns(stepGridColumns);
			this.gwStep.enableEnterMoveDown();
			
			var thisPaint=this;
			this.gwStep.dragSorted=function(){
				thisPaint.parseRunningSteps();
			}

			this.threadList=new kendo.data.ObservableArray([]);
			this.runningStepList=new kendo.data.ObservableArray([]);
			
			this.dstCanvas={};
			this.dstStage=new DstStage({container:config.stage,
		          width: 1024,
		          height: 800});
	}
    
    dstPaint.prototype={

			clearThreadList:function(){			//clear contents(code,colour) of dataSource of threadGrid
				for(var i=0;i<this.threadList;i++){
					this.threadList[i].code="";
					this.threadList[i].colour="";
				}
				
			},
			
			clearRunningStepList:function(){		//clear contents(code,threadIndex) of dataSource of stepGrid
				for(var i=0;i<this.runningStepList.length;i++){
					this.runningStepList[i].code="";
					this.runningStepList[i].threadIndex="";
				}
			},
			
			initColorwayList:function(){	//stepList(stepGrid) and runningStepList(stepGrid)
				this.threadList.splice(0,this.threadList.length)
				this.runningStepList.splice(0,this.runningStepList.length)
				if(this.dstCanvas.dstDesign){
					var design=this.dstCanvas.dstDesign,
						stepList=design.stepList,
						stepCount=design.stepCount,
						threadCount=stepCount<MAX_THREAD_COUNT?stepCount:MAX_THREAD_COUNT;
					
					for(var i=0;i<threadCount;i++)
						this.threadList.push({code:"",colour:""});
					
					for(var i=0,stepStitchCount;i<stepCount;i++){
						stepStitchCount=(stepList[i].lastStitch-stepList[i].firstStitch).toString();
						this.runningStepList.push({code:"",threadIndex:"",stepStitchCount:stepStitchCount});
					}
				}
			},
			
			parseThreads:function(){	//from this.threadList to this.dstCanvas.threadCodes
				var threads=[],thread;
				for(var i=0;i<this.threadList.length;i++){
					thread=this.threadList[i];
					if(!thread.code)
						break;
					threads.push(thread.code);
				}
				if(threads!==this.dstCanvas.threadCodes){
					this.dstCanvas.threadCodes=threads.join();
				}
			},
			
			populateThreads:function(){  //from this.dstCanvas.threadCodes to this.threadList
				var threadCodes=this.dstCanvas.threadCodes;
				if(threadCodes){
					
				}else{
					this.clearThreads();
				}
					
			},
			
			parseRunningSteps:function(){	//from this.runningStepList to this.dstCanvas.runningSteps
				var steps=[],step;
				for(var i=0;i<this.runningStepList.length;i++){
					step=this.runningStepList[i];
					if(!step.code)
						break;
					steps.push(step.threadIndex);
				}
				if(steps!==this.dstCanvas.runningSteps){
					this.dstCanvas.runningSteps=steps.join('-');
				}
			},
			
			populateRunningSteps:function(){	//from this.dstCanvas.runningSteps to this.runningStepList
				var runningSteps=this.dstCanvas.runningSteps;
				if(runningSteps){
					
				}else{
					this.clearRunningSteps();
				}
			},
			
			getThreadIndex:function(threadCode){
				var index=-1;
				if(threadCode)
					for(var i=0;i<this.threadList.length;i++){
						if(this.threadList[i].code===threadCode){
							index=i;
							break;
						}
					}
				return index;
			},
			
			getThreadColor:function(threadIndex){
				var index=parseInt(threadIndex);
				var thread=(index>0 && index<=this.threadList.length)?this.threadList[--index]:"";
				var	colour=thread?thread.colour:"";
				return colour;
			},

			
			setDstCanvas:function(dstCanvas){
				this.dstCanvas=dstCanvas;
				this.initColorwayList();
			},
			
			wrapThreadGrid:function(){
				this.gwThread.wrapGrid();
			},

			wrapStepGrid:function(){
				this.gwStep.wrapGrid();
			},
			
			backgroundColorPaletteOptions:function() {
				return {
			        palette: paletteColors
				};
			},
			
			threadGridOptions:function(){
				var self=this;
				return {
					columns:threadGridColumns,
			        editable: true,
			        selectable: "cell",
			        navigatable: true,			
			        autoSync:true,
					dataSource:this.threadList,
					save:function(e){
	                	 console.log("thread save:");
			       		if (typeof e.values=== 'undefined')
				       			return;
			       		if (typeof e.values.code=== 'undefined')
			       			return;
			       		var code=DictThread.normalizeThreadCode(e.values.code);
			       		if(code===e.model.code)
			       			return;
			       			
	  	        		e.preventDefault();

	  	        		var index=(self.gwThread.getDataItemIndex(e.model)+1).toString();
	  	        		
		          		e.model.set("code","");
		          		e.model.set("colour","");
	  	        		if(self.getThreadIndex(code)<0){	//code not exists in the threadList
		  	        		var colour=DictThread.getThreadColorHex(code);
		  	        		if(colour){
		  	        			e.model.set("code",code);
		  	        			e.model.set("colour",colour);
		  	        		}
	  	        		}
	  	        		if(e.model.get("code")==""){
	  	        			
	  	        			self.gwThread.enterKeyDown=false;
	  	        		}
	  	        		
		          		var template = kendo.template(this.columns[1].template),
		                	cell = e.container.parent().children('td').eq(1);
	                    cell.html(template(e.model));
	                    
	                    for(var i=0,steps=self.runningStepList;i<steps.length;i++){
	                    	if(steps[i].threadIndex===index){
	                    		steps[i].code=code;
	                    		steps[i].colour=colour;
	                    	}
	                    }
	                    self.gwStep.grid.refresh();
	                    self.parseThreads();
						self.drawDesign({});
					}
				}
			},
			
			drawDesign:function(){			//editing mode, called from events of gwStep.grid and gwThread.grid
				var colorway={};
				var cell=this.gwStep.getCurrentCell();
				if (cell && cell.cellIndex>0){		//cellIndex>0
					var cellIndex=cell.cellIndex;
					var row=this.gwStep.getCurrentRow();
					var rowIndex=row.rowIndex;
					
					var steps="",alphaSteps="";
					
					stepList=this.runningStepList;
					for(var i=0,idx,a;i<stepList.length;i++){
						idx=parseInt(stepList[i].threadIndex);
						if(!idx)
							idx=0;
						switch(cellIndex){					//threadIndex
							case 4:
								if(i==rowIndex){
									idx=(idx>0)?idx:16;
									a="1";
								}else{
									a="0";
								}
								break;
							case 3:							//code column
								if(i==rowIndex){
									idx=16;
									a="1";
								}else{
									a=idx>0?'1':'0';
								}
								break;
							case 2:							//colour column
								if(i==rowIndex){
									idx=(idx>0)?idx:16;
									a="1";
								}else{
									a="0";
								}
								break;
							case 1:							//ST. COLUMN
								if(i==rowIndex){
									idx=16;
									a="1";
								}else{
									a="0";
								}
								
						};
						
						steps+="-"+idx;
						alphaSteps+="-"+a;
					}
					colorway.runningSteps=steps.substring(1);
					colorway.alphaSteps=alphaSteps.substring(1);
					colorway.alpha=cellIndex==4?0.15:0.03;
				}
				
				this.dstCanvas.drawDesign(colorway);
				this.dstStage.draw();
			},

			stepGridOptions:function(){
				var self=this;
				return {
					columns:stepGridColumns,
			        editable: true,
			        selectable: "cell",
			        navigatable: true,	
			        autoSync:true,
					dataSource:this.runningStepList,

					change:function(e){
						console.log("step change:");
						self.drawDesign();
					},
					
					edit:function(e){
						console.log("step  edit:");
						self.drawDesign();
				    },
				    
					save:function(e){
	                	 console.log("step save1:");

			       		if(typeof e.values.code!== 'undefined'){
		                	 console.log("step save2:");
			       			var code=e.values.code;
		  	        		if(code.trim()==="."){
		  	        			self.gwStep.copyPreviousRow();
		  	        			var di=self.gwStep.getCurrentDataItem();
				          		e.model.set("code",di.code);
				          		e.model.set("threadIndex",di.threadIndex);
		  	        			
		  	        		}else{
				          		e.model.set("code","");
				          		e.model.set("threadIndex","");

			                	 console.log("step save3:");
				          		
			  	        		code=DictThread.normalizeThreadCode(code);
			       				var thread=null;
			  	        		var index=parseInt(code);
			  	        		if(index>0 && index<=self.threadList.length){
			  	        			index--;
			  	        		}else{
			  	        			index=self.getThreadIndex(code);
			  	        		}
			  	        		
			  	        		if(index<0){
			  	        			var colour=DictThread.getThreadColorHex(code);
			  	        			if(colour){
			  	        				for(index=0;index<self.threadList.length;index++)
			  	        					if(!self.threadList[index].code)
			  	        						break
				  	        			if(index===self.threadList.length)	
				  	        				index=-1;
				  	        			else{
				  	        				thread=self.threadList[index];
				  	        				thread.code=code;
				  	        				thread.colour=colour;
				  	        				self.gwThread.grid.refresh();
				  	        				self.parseThreads();
				  	        			}
			  	        			}
			  	        		}
			  	        		
			  	        		if(index>=0){
			  	        			thread=self.threadList[index];
				                	 console.log("step save4:");
			  	        			e.model.set("code",thread.code);
					          		e.model.set("threadIndex",(index+1).toString());
				                	 console.log("step save5:");
			  	        		}
		  	        		}
		                	 console.log("step save6:");
		 		       			
			          		var template = kendo.template(this.columns[2].template),
			                	cell = e.container.parent().children('td').eq(2);
		                    cell.html(template(e.model));
		                    
		                    self.parseRunningSteps();
		  	        		e.preventDefault();
							self.drawDesign();
			          	}
			       		
					},	//end of save
					
		       		dataBinding:function(e){
		       			console.log("binding");
		       			renderingPaint=self;
		       		}

				}
			}			//end of stepGridOptions
    	} //end of prototype	
    
    	return dstPaint;
}]);


</script>