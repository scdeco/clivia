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
			}else{
				
				this.hide();
			}
			this.drawLayer();
		},
		
		drawLayer:function(){
			var layer=this.getLayer();
			
			//apply filters, otherwise image will not be resized
			if(this.selected!=null){
				var filters=this.selected.filters();
				if(filters!=null && filters.length>0){
					this.selected.cache();
					this.selected.filters(filters);
				}
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


factory("dictThread",["$http",function($http){		//service
	var dictThread={
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
		loadThreads:function(){
			var url="http:///192.6.2.108:8080/clivia/data/dictEmbroideryThreadDao/get"
			$http.get(url).
				success(function(data, status, headers, config) {
			    	ts=[];
			    	for(var i=0,t,d;i<data.length;i++){
			    		d=data[i];
			    		t={code:d.code,r:d.red,g:d.green,b:d.blue};
			    		ts.push(t);
			    	}
			    	dictThread.threads=ts
				}).
				error(function(data, status, headers, config) {
				});
					
		},			
		
		getThreadColor:function(code){
			var c=dictThread.defaultThreadColor;
			if(code){
				code=code.trim().toUpperCase();
				var threads=dictThread.threads;
				for(var i=0;i<threads.length;i++ )
					if(threads[i].code===code){
						c=threads[i];
						break;
					}
			}
			return c;
		},

		getThreadColorHex:function(code){
			var c=dictThread.getThreadColor(code);
			return (c===this.defaultThreadColor)?"":"#" + ((1 << 24) + (c.r << 16) + (c.g << 8) + c.b).toString(16).slice(1);
		},
		
		getThreadColors:function(threadCodes){
			var threadColors=[dictThread.defaultThreadColor],
				codeList=threadCodes.split(',');
			
			for(var i=0;i<codeList.length;i++){
				threadColors.push(dictThread.getThreadColor(codeList[i]))
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

		//normalize each code and remove repeated threads
		normalizeThreadCodes:function(threadCodes,stepCount){
			var result="";
			var limit=stepCount<15?stepCount:15;
			threadCodes=threadCodes.trim();
			if(threadCodes){
				var codeList=threadCodes.split(/[+\-,]/,limit);
				for(var i=0,code;i<codeList.length;i++){
					code=this.normalizeThreadCode(codeList[i]);
					if(code && result.indexOf(code)<0)
						result+=","+code;
				}
				if(result)
					result=result.substring(1);
			}
			return result;
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
			var result="";
			runningSteps=runningSteps.trim();
			if(runningSteps){
				var stepList=runningSteps.split(/[+\-,]/,stepCount);
				for(var i=0;i<stepList.length;i++)
					stepList[i]=this.normalizeRunningStep(stepList[i]);
				result=stepList.join("-");
			}
			return result;
		},
		
		
		getDefaultColorModel:function(){
			
			var colorModel=[dictThread.defaultThreadColor];
			var threadColors=dictThread.defaultThreadColors;
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
				
				colorModel=[dictThread.defaultThreadColor];
				
				var threadColors=dictThread.getThreadColors(colorway.threadCodes);
				var runningSteps=dictThread.getRunningSteps(colorway.runningSteps,stepCount);
				var alphaSteps=dictThread.getRunningSteps(colorway.alphaSteps,stepCount);
				
				var alpha=typeof colorway.alpha==='undefined'?0:colorway.alpha;
				
				for(var i=0,idx,c,a; i<stepCount; i++){
					
					idx=(i>=colorway.runningSteps.length)?0: parseInt(runningSteps[i]);
					if(idx>=16)
						c=dictThread.cursorThreadColor;
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
	
	dictThread.loadThreads();
	
	return  dictThread;
}]).



factory("DstDesign",["$http","Event",function($http,Event){

	var initDesign=function(design){
		design.width="";
		design.height="";
		design.startX="";			
		design.startY="";
		design.left="";
		design.top="";
		design.right="";
		design.bottom="";
		design.stitchCount="";
		design.stepCount="";
		design.trimCount="";
		design.designNumber="";				
		
		design.pixelWidth=0;
		design.pixelHeight=0;	
		design.stitchList=[];	
		design.stepList=[];
	}
	
	var DstDesign=function(id){
		initDesign(this);
		this.designChanged=new Event();
		if(!!id) this.getDst(id);
		
	}
	
	DstDesign.prototype={
			
		isValid:function(){
			return this.stitchList.length>0;
		},
		
		
		getDst:function(dstId){
		
			var url="/clivia/lib/embdesign/getstitches?id="+dstId;
			var self=this;
			initDesign(this);
			
			$http.get(url).
				success(function(data, status, headers, config) {
					var design=data.data;
					for(var property in design){
						if(design.hasOwnProperty(property))
							self[property]=design[property];
					}
					self.designChanged.fireEvent([self]);
				}).
				error(function(data, status, headers, config) {
					self.designChanged.fireEvent([self]);
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

factory("EmbCanvas",["dictThread","Event",function(dictThread,Event){
	
	var SCREEN_PPM=1280/340,SCREEN_DESIGN_RATIO=SCREEN_PPM/10;
	
	var EmbCanvas=function(embDesign){
		
		this.canvas=document.createElement('canvas');
		this.canvas.id=createElementId();
		//this.canvas.style.visibility='hidden';
		document.body.appendChild(this.canvas);
		this.imageObj=document.getElementById(this.canvas.id);
		
		this.ctx=this.canvas.getContext("2d");
		this.ctx.lineWidth=1;

		this.canvas.width=0;
		this.canvas.height=0;
		
		this.embDesign=null;
		this.threadCodes="";
		this.runningSteps="";
		this.colorModel=null;			//colorModel used in current drawing
		
		
		this.imageChanged=new Event();
		
		if(embDesign)
			this.setEmbDesign(embDesign);
	}
	

	
	var randomId=0;
	var createElementId=function(){
		return "EmbCanvas"+(randomId++);
	}
	
	EmbCanvas.prototype={
			//when design changed, reset dimension and colorModel of the canvas. 
		 onDesignChanged:function(e){
			 
			 	this.colorModel=null;
			 	
				var colorway=null;
				if(this.embDesign && this.embDesign.stepCount>0){

					this.canvas.width=Math.round(this.embDesign.pixelWidth*SCREEN_DESIGN_RATIO)+1;		//original size of image
					this.canvas.height=Math.round(this.embDesign.pixelHeight*SCREEN_DESIGN_RATIO)+1;
					
					if( this.embDesign.stepCount===this.runningSteps.split(',').length)
						colorway={};
					else{
						this.threadCodes="";
					}
				}else{
					
					this.canvas.width=0;		//original size of image
					this.canvas.height=0;
				}
				//do nor draw here. Leave the job to parent controller.
				//this.drawDesign(colorway);
			},
			
		setEmbDesign:function(embDesign){
			if(this.embDesign)
				this.embDesign.designChanged.removeListener(this,onDesignChanged);
			
			if(embDesign){
				if(embDesign!==this.embDesign){	//embDesign changed
					this.embDesign=embDesign;
				}
				this.embDesign.designChanged.addListener(this,this.onDesignChanged);
				
			}else{
				this.embDesign=null;
				this.canvas.width=0;
				this.canvas.height=0;
				this.drawDesign();
			}
		},
			
		getOriginalWidth:function(){
			return this.canvas.width;
		},
		
		getOriginalHeight:function(){
			return this.canvas.height;
		},

		
		clearCanvas:function(){
			this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
			this.colorModel=null;
		},

		setColorway:function(threadCodes,runningSteps){
			this.threadCodes=threadCodes,
			this.runningSteps=runningSteps;
		},
		
		normalizeThreadCodes:function(){
			this.threadCodes=dictThread.normalizeThreadCodes(this.threadCodes);
		},
		
		normalizeRunningSteps:function(){
			if(this.embDesign)
				this.runningSteps=dictThread.normalizeRunningSteps(this.runningSteps,this.embDesign.stepCount);
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
		//if colorway==={}, use thredCodes or runningSteps of this embCanvas
		drawDesign:function(colorway){
			if(!(this.embDesign && this.embDesign.isValid())){
				this.imageChanged.fireEvent([this]);
				return;
			} 
	
			if(colorway){
				if(!colorway.threadCode)
					colorway.threadCodes=this.threadCodes;
				if(!colorway.runningSteps)
					colorway.runningSteps=this.runningSteps;
			};
			
			var colorModel=dictThread.getColorModel(colorway,this.embDesign.stepCount);
			
			if (this.isNewColorModel(colorModel)){
				this.colorModel=colorModel;
				this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
				this.embDesign.drawDesign(this.ctx,colorModel,SCREEN_DESIGN_RATIO);
				this.imageChanged.fireEvent([this]);
			}
		},

	}
	
	return EmbCanvas; 
}]).


factory("EmbMatcher",["GridWrapper","dictThread",function(GridWrapper,dictThread){
	
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
				name:"stitchCount",
			    title: "St.",
			    width: 45,
			    attributes:{style:"text-align:right;"},
			    template:"<span>#= threadStitchCount #</span>"
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
			    attributes:{style:"text-align:right;"},
			    template:"<span>#= stepStitchCount # </span>"
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
			    attributes:{style:"text-align:right;"},
			    template:"<span>#= threadIndex #</span>",
			    width: 30
			}];
	
	var embMatcher=function(){
		
		this.embCanvas={};

		this.gwThread=new GridWrapper("embThreadGrid",threadGridColumns);
		this.gwThread.enableEnterMoveDown();
		
		this.gwStep=new GridWrapper("embStepGrid",stepGridColumns);
		this.gwStep.enableEnterMoveDown();
		this.gwStep.dragSorted=function(){this.parseRunningSteps();};	//call back function

		//as dataSource of 'dstThreadGrid' and 'dstStepGrid' which are wrapped by gwThread and gwStep respectfully
		this.threadList=new kendo.data.ObservableArray([]);
		this.runningStepList=new kendo.data.ObservableArray([]);
	}
	
	embMatcher.prototype={
			
			//clear contents(code,colour) of dataSource of threadGrid
			clearThreadList:function(){			
				for(var i=0;i<this.threadList.length;i++){
					this.threadList[i].code="";
					this.threadList[i].colour="";
					this.threadList[i].threadStitchCount="";
				}
			},
			
			//clear contents(code,threadIndex) of dataSource of stepGrid
			clearRunningStepList:function(){		
				for(var i=0;i<this.runningStepList.length;i++){
					this.runningStepList[i].code="";
					this.runningStepList[i].threadIndex="";
				}
			},
			
			//threadList(threadGrid) and runningStepList(stepGrid)
			initColorwayList:function(){	
				this.threadList.splice(0,this.threadList.length)
				this.runningStepList.splice(0,this.runningStepList.length)
				if(this.embCanvas.embDesign){
					var design=this.embCanvas.embDesign,
						stepList=design.stepList,
						stepCount=design.stepCount,
						threadCount=stepCount<MAX_THREAD_COUNT?stepCount:MAX_THREAD_COUNT;
					
					for(var i=0;i<threadCount;i++)
						this.threadList.push({code:"",colour:"",threadStitchCount:""});
					
					for(var i=0,stepStitchCount;i<stepCount;i++){
						stepStitchCount=(stepList[i].lastStitch-stepList[i].firstStitch).toString();
						this.runningStepList.push({code:"",threadIndex:"",stepStitchCount:stepStitchCount});
					}
				}
			},
			
			
			//from this.threadList to this.embCanvas.threadCodes
			parseThreads:function(){	
				var threads=[],thread;
				for(var i=0;i<this.threadList.length;i++){
					thread=this.threadList[i];
					if(!thread.code)
						break;
					threads.push(thread.code);
				}
				if(threads!==this.embCanvas.threadCodes){
					this.embCanvas.threadCodes=threads.join();
				}
			},
			
			//from this.runningStepList to this.embCanvas.runningSteps
			parseRunningSteps:function(){	
				var steps=[],step;
				for(var i=0;i<this.runningStepList.length;i++){
					step=this.runningStepList[i];
					if(!step.code)
						break;
					steps.push(step.threadIndex);
				}
				if(steps!==this.embCanvas.runningSteps){
					this.embCanvas.runningSteps=steps.join('-');
				}
			},

			//from this.embCanvas.threadCodes to this.threadList
			//threadCodes must be normalized before calling this method
			populateThreads:function(){  
				var codes=this.embCanvas.threadCodes;
				
				this.clearThreadList();
				if(codes){
					var codeList=codes.split(",");
					
					if(codeList.length<=this.threadList.length){
						for(var i=0,code,c,t;i<codeList.length;i++){
							code=codeList[i];
							c=dictThread.getThreadColorHex(code);
							t=this.threadList[i];
							t.colour=c;
							t.code=code;
						}
					}
				}
			},
			
			//from this.embCanvas.runningSteps to this.runningStepList
			//runningSteps must be normalized before calling this method
			populateRunningSteps:function(){	
				var runningSteps=this.embCanvas.runningSteps;
				this.clearRunningStepList();
				if(runningSteps){
					idxList=runningSteps.split('-');
					if(idxList.length<=this.runningStepList.length){
						for(var i=0,t;i<idxList.length;i++){
							t=this.getThread(idxList[i]);
							if(t){
								step=this.runningStepList[i];
								step.code=t.code;
								step.threadIndex=idxList[i];
							}
						}
					}
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
			
			getThread:function(threadIndex){
				var index=isNaN(threadIndex)?0:parseInt(threadIndex);
				var thread=(index>0 && index<=this.threadList.length)?this.threadList[--index]:"";
				return thread;
			},
			
			
			getThreadColor:function(threadIndex){
				var thread=this.getThread(threadIndex);
				var	colour=thread?thread.colour:"";
				return colour;
			},

			setThreadStitchCount:function(){
				for(var i=0,thread,c,threadIndex;i<this.threadList.length;i++){
					thread=this.threadList[i];
					c=0;
					threadIndex=i+1;
					for(var j=0,step;j<this.runningStepList.length;j++){
						step=this.runningStepList[j];
						if(step.threadIndex==threadIndex && step.stepStitchCount){
							c+=parseInt(step.stepStitchCount);
						}
					}
					thread.threadStitchCount=c?c:"";
				}
			},
			
			
			
			normalizeColorway:function(){
				
				
			},
			
			setEmbCanvas:function(embCanvas){
				this.embCanvas=embCanvas;
				this.initColorwayList();
			},
			
			//editing mode, called from events of gwStep.grid 
			drawDesign:function(gw){
				var isStepGrid=gw.gridName==="embStepGrid";

				var colorway={};
				if(!gw){
					this.embCanvas.drawDesign(colorway);
					return;
				}
					
				var cell=gw.getEditingCell();
				if(!cell)
					cell=gw.getCurrentCell();
				
				
				if (cell){
					var cellIndex=cell.cellIndex;
					
					var row=gw.getRow(cell);						//cellIndex===3?this.gwStep.getEditingRow():this.gwStep.getCurrentRow();
					if(!row)
						return;
					
					var rowIndex=row.rowIndex+(isStepGrid?0:1);
					
					var steps="",alphaSteps="";
					
					stepList=this.runningStepList;
					
					for(var i=0,idx,a;i<stepList.length;i++){
						idx=parseInt(stepList[i].threadIndex);
						if(!idx)
							idx=0;
						a=1;
						
						var isSelected=(isStepGrid?i:idx)===rowIndex;
							
						switch(cellIndex){					
							case 1:						//stitches column
								if(isSelected){
									idx=(idx>0)?idx:16;
									a="1";
								}else{
									a="0";
								}
								break;
							case 3:							//code column
								if(isSelected){
									idx=16;
									a="1";
								}else{
									a=idx>0?'1':'0';
								}
								break;
							case 2:							//colour column
								if(isSelected){
									idx=(idx>0)?idx:16;
									a="1";
								}else{
									a="0";
								}
								break;
							case 0:							//stepIndex
								if(isSelected){
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
					colorway.alpha=cellIndex==1?0.15:0.03;
				
					this.embCanvas.drawDesign(colorway);
				}
			}, //end of drawDesign()
			
			
			getThreadGridOptions:function(scope){
				var self=this;
				return	{
					columns:threadGridColumns,
			        editable: true,
			        selectable: "cell",
			        navigatable: true,			
			        autoSync:true,
					dataSource:self.threadList,
					
					change:function(e){
						console.log("step change:");
						self.drawDesign(self.gwThread);
					},
					
					edit:function(e){
						console.log("step  edit:");
						self.drawDesign(self.gwThread);
				    },					
					save:function(e){

						if (typeof e.values=== 'undefined')
				       			return;
			       		if (typeof e.values.code=== 'undefined')
			       			return;
			       		
			       		var code=dictThread.normalizeThreadCode(e.values.code);
			       		if(code===e.model.code)
			       			return;
			       			
	  	        		e.preventDefault();

	  	        		var index=(self.gwThread.getDataItemIndex(e.model)+1).toString();
	  	        		
		          		e.model.set("code","");
		          		e.model.set("colour","");
	  	        		if(self.getThreadIndex(code)<0){	//code not exists in the threadList
		  	        		var colour=dictThread.getThreadColorHex(code);
		  	        		if(colour){
		  	        			e.model.set("code",code);
		  	        			e.model.set("colour",colour);
		  	        		}
	  	        		}
	  	        		if(e.model.get("code")==""){
	  	        			self.gwThread.enterKeyDown=false;
	  	        		}
	  	        		
	  	        		self.gwThread.updateTemplateColumns(e);
	                    
	                    for(var i=0,steps=self.runningStepList;i<steps.length;i++){
	                    	if(steps[i].threadIndex===index){
	                    		steps[i].code=code;
	                    		steps[i].colour=colour;
	                    	}
	                    }
	                    self.gwStep.grid.refresh();
	                    self.parseThreads();
						self.drawDesign(self.gwThread);
						scope.$apply();
					}
				} 
			},//end of thread grid option
			
			getStepGridOptions:function(scope){
				var self=this;
				var saving=false; //prevent recusive calling saving event function;
				return {
					columns:stepGridColumns,
			        editable: true,
			        selectable: "cell",
			        navigatable: true,	
			        autoSync:true,
					dataSource:self.runningStepList,

					change:function(e){
						self.drawDesign(self.gwStep);
					},
					
					edit:function(e){
						self.drawDesign(self.gwStep);
				    },
				    
					save:function(e){
						if(saving) return;
						saving=true;
						
			       		if(typeof e.values.code!== 'undefined'){

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
				          		
			  	        		code=dictThread.normalizeThreadCode(code);
			       				var thread=null;
			  	        		var index=parseInt(code);
			  	        		if(index>0 && index<=self.threadList.length){
			  	        			index--;
			  	        		}else{
			  	        			index=self.getThreadIndex(code);
			  	        		}
			  	        		
			  	        		if(index<0){
			  	        			var colour=dictThread.getThreadColorHex(code);
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
				  	        				
				  	        				//self.gwThread.grid.refresh();
				  	        				self.parseThreads();
				  	        			}
			  	        			}
			  	        		}
			  	        		
			  	        		if(index>=0){
			  	        			thread=self.threadList[index];
			  	        			e.model.set("code",thread.code);
					          		e.model.set("threadIndex",(index+1).toString());
			  	        		}
		  	        		}
		  	        		
		  	        		self.setThreadStitchCount();

		  	        		//The grid will not update templte column automatically when change data value in save event	
		                	self.gwStep.updateTemplateColumns(e);
		                	 
		                    self.parseRunningSteps();
		                    
		                    //let model accept code value that set by above code
		  	        		e.preventDefault();
		  	        		
							self.drawDesign(self.gwStep);
							self.gwThread.grid.refresh();
							scope.$apply();
			          	}
						saving=false;
			       		
					},	//end of save
					
		       		dataBinding:function(e){
		       			console.log("binding");
		       			//create a globle variable
		       			renderingPaint=self;
		       		}

				}
			},//end of stepGridOptions
			
			getBackgroundColorPaletteOptions:function(){
				return {
				    palette: paletteColors
				}
			}
	}
	
	return embMatcher;
}]).

directive("threadMatcher",["EmbMatcher","dictThread",function(EmbMatcher,dictThread){
	var templateUrl="../dm/threadmatcher";
	var directive={
			restrict:'EA',
			replace:false,
			scope:{
				cName:'@threadMatcher',
				cEmbCanvas:'=',
			},
	
			templateUrl:templateUrl,
			
			link:function(scope,element,attrs){
				scope.populateThreads=function(){
					var emb=scope.embMatcher;
					emb.embCanvas.normalizeThreadCodes();
					emb.populateThreads();
					emb.populateRunningSteps();
					emb.setThreadStitchCount();
                    emb.gwThread.grid.refresh();
                    emb.gwStep.grid.refresh();
				}
				
				scope.populateSteps=function(){
					var emb=scope.embMatcher;
					emb.embCanvas.normalizeRunningSteps();
					emb.populateRunningSteps();
					emb.setThreadStitchCount();
                    emb.gwThread.grid.refresh();
                    emb.gwStep.grid.refresh();
				}
				
			}, //end of link function
			controller:function($scope){
				var scope=$scope;
				
				scope.embMatcher=new EmbMatcher();
				
				scope.$on("kendoWidgetCreated", function(event, widget){
				        // the event is emitted for every widget; if we have multiple
				        // widgets in this controller, we need to check that the event
				        // is for the one we're interested in.
				        if (widget ===scope[scope.embMatcher.gwThread.gridName])
				        	scope.embMatcher.gwThread.wrapGrid(widget);
				        
				        if (widget ===scope[scope.embMatcher.gwStep.gridName]) 
				        	scope.embMatcher.gwStep.wrapGrid(widget);
				    });	
				
				//expose this directive scope to parent directive
				if(scope.cName) 
					scope.$parent[scope.cName]=scope.embMatcher;

				if(scope.cEmbCanvas)
					scope.embMatcher.setEmbCanvas(scope.cEmbCanvas);
				
				scope.threadGridOptions=scope.embMatcher.getThreadGridOptions(scope);
				scope.stepGridOptions=scope.embMatcher.getStepGridOptions(scope);
				
				
			}

		}
	
	return directive;
}]).

factory("EmbStage",["Selector",function(Selector){
	
	var EmbStage=function(config){	//{container: 'container', width: 1024, height: 800}

		this.stage=new Kinetic.Stage(config);
		this.backGroundLayer=new Kinetic.Layer();
		this.stage.add(this.backGroundLayer);
		this.selector=new Selector();
		this.currentLayer=this.backGroundLayer;
		this.clickedOnObject=false;
	}
	
	EmbStage.prototype={
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
					self.clickedOnObject=true;		//flag to indicates clicked on an object
					self.selector.setSelected(object);
				});
				this.currentLayer.add(object);
				this.currentLayer.draw();
			},
			
			//remove current selected object from stage
			remove:function(){
				var object=this.selector.selected;
				if(object){
					this.select();
					object.remove();
					//this.currentLayer.draw();
				}
			},
			
			select:function(object){
				this.selector.setSelected(object);
			},
			
			onClick:function(){
				if(!this.clickedOnObject){
					this.selector.setSelected();
				}else{
					this.clickedOnObject=false;
				}
			},
			
			draw:function(){
				this.currentLayer.draw();
			}
	}
	
	return EmbStage;
	
}]).


directive("dstPaint",["EmbMatcher","util",function(EmbMatcher,util){
	
	var templateUrl="../dm/dstpaint";
	var directive={
			restrict:'EA',
			replace:true,
			scope:{
				cName:'@dstPaint',
			},
	
			templateUrl:templateUrl,
			
			link:function(scope,element,attrs){
				
				
				scope.getPrintModel=function(embMatcher,showThreads,purgeRepeatCode){
					var model={};
					if(!embMatcher) return model;
					var embCanvas=embMatcher.embCanvas;
					if(!embCanvas) return model;
					
					
					var dst=embCanvas.embDesign;
					if(dst && dst.isValid()){
						//embCanvas.drawDesign();
						
						var list=[],line;
						var threadList=embMatcher.threadList;
						var stepList=embMatcher.runningStepList;
						var idxThreads={};
						var emptyLine={
								col0:"",
								col1:"",
								col2:"",
								col3:"",
								col4:"",
						}
						
						if(showThreads){
							for(var i=0,t;i<threadList.length;i++){
								t=threadList[i];
								if(t.code){
									line={
										col0:String(i+1),
										col1:String(t.threadStitchCount),
										col2:t.colour,
										col3:t.code,
										col4:"",
									}
									list.push(line);
								}else{
									break;
								}
							}
							list.push(emptyLine);
						}
						
						for(var i=0,idx,step,code,t;i<stepList.length;i++){
							step=stepList[i];
							idx=parseInt(step.threadIndex);
							t=(idx>0 && idx<threadList.length)?threadList[idx-1]:null;
							if(t && t.code){
								code=t.code;
								if(purgeRepeatCode){
									if(idxThreads[String(idx)]){
										code="";
									}else{
										idxThreads[String(idx)]=true;
									}
								}
								
								line={
										col0:String(i+1),
										col1:String(t.threadStitchCount),
										col2:t.colour,
										col3:code,
										col4:step.threadIndex,
								}
								
								list.push(line);
							}else{
								list.push(emptyLine);
							}
						}
						
						var topLine="",space=10;
						topLine+=dst.designNumber?(dst.designNumber+"&nbsp;&nbsp;"):"";
						topLine+="H:"+dst.height+"&nbsp;".repeat(space);
						topLine+="W:"+dst.width+"&nbsp;".repeat(space);
						topLine+="st:"+dst.stitchCount+"&nbsp;".repeat(space);
						topLine+="Step:"+dst.stepCount+"&nbsp;".repeat(space);
						
						var bottomLine="K:\Wilcom\2005934 Ontario Inc Mark's Promotional";
						
						model={
								topLine:topLine,
								bottomLine:bottomLine,
								width:dst.width,
								height:dst.height,
								list:list,
								image:embCanvas.imageObj.toDataURL(),								
						}
						
					}
					
					return model;
				}			
				
				scope.getDesignHtml=function (printModel,paperType,isLandscape){	
					
					var Paper = {
						papers :[{type:"letter",width:191, height:255}],
						getPaper :function (paperType){
							var paper;
							var papers = this.papers;
							for (var i = 0; i < papers.length; i++){
								if(papers[i].type == paperType){
									paper = papers[i];
									break;
								}
							}
							return paper;
						},
						getDefault:function (){
							return paper[0];	
						}
					}
				
					var paper = Paper.getPaper(paperType);
					if(!paper)
						Paper.getPaper(getDefault);
						
					//var layout ="portrait";
					if(isLandscape){
						var temp = paper.width;
						paper.width = paper.height;
						paper.height = temp;
					}
						
					//before change to pixel, all variable are in mm.
					var margin = 0; //mm
					var mmToPixel =3.81;	// 3.64;
					var r_table_w = 50;//mm
					var r_table_h = 240.5;//mm
					var font_family = "Times New Roman";
					var info_font_size = 80;//top info and bot info font size
					var list_font_size = 100;// list font size
					var paper_width = (paper.width - (margin*2));
					var paper_height = (paper.height - (margin*2));
					var table_width= paper.width;
					var table_height = 5;//mm
					
					//change mm to pixel
					function changeToPixel(mm){
						var pixel = mm * mmToPixel;
						return pixel;
					}
					
					// all variable are in pixel now
					var paper_w_pixel = changeToPixel(paper_width);
					var paper_h_pixel = changeToPixel(paper_height);
					var r_table_w_pixel = changeToPixel(r_table_w);
					var r_table_h_pixel = changeToPixel(r_table_h);
					var margin_pixel = changeToPixel(margin);
					var image_w_pixel = changeToPixel(printModel.width);
					var image_h_pixel = changeToPixel(printModel.height);
					var table_height_pixel = changeToPixel(table_height);
					
					
					//---------------------------------right hand list part---------------------------------------
					var error_pixel = 9;
					var error_pixel2 = 6;//fix the height of the right table 
					var error_pixel3 = 1; // fix the width of the right table
					var error_pixel4 = 34;//fix 2nd right table margin top
					var borderHeight = paper_h_pixel - table_height_pixel * 2 - error_pixel;//calculate image border height
					
				
					var threadLists = printModel.list;
					var colorDiv = 10;
					var col1Width = 25;
					var col2Width = 20;
					var col3Width = 20;
					var col4Width = 25;
					var col5Width = 20;
					
					var rightList="";
				
					//test part start here
					var row_height = 20;
					//calculate how many row needed
					var row_count = Math.floor(borderHeight/row_height)-2;
					//calculate how many col needed
					var needed_row = threadLists.length;
					var col_count = Math.ceil(needed_row/row_count);
					//calculate width for img div part
					var borderWidth = paper_w_pixel - r_table_w_pixel*col_count - error_pixel;
					//calculate width for righthand list part
					var divWidth = paper_w_pixel - borderWidth + error_pixel3;
					//if there enough space to display the list?
					if(divWidth > (paper_w_pixel*0.54)){
							alert("sorry, we cant display it!!!!");
							return;
					}
					
					rightList = "<div style='height:"+ borderHeight + "px; border: 1px solid black; width:" + divWidth +"px;"
								  +"margin-top:" + -(paper_h_pixel - table_height_pixel - error_pixel2) + "px;text-align:center; border-left-style:none;"
								  +"margin-left:" + (borderWidth)  +"px; font-family:" + font_family + "; font-size:" + list_font_size +"%;'>" 
								  +"<table style='border-collapse: collapse;width:" + divWidth + "px;'>";
					var tdDot = "";
					var tdEmpty="";
					for(var i=0;i<5;i++){
						tdDot+="<td style = 'border-bottom-style:dotted;border-bottom-width: 1px;'></td>";
						tdEmpty+="<td></td>";
					}

					for(var i = 0,t,dotRow; i < row_count; i++){
						rightList += "<tr>"
						dotRow="";
						for(var j = 0; j < col_count; j++){
							var count = j * row_count + i;
							if(count < needed_row){
								t = threadLists[count];
								
								rightList += "<td style='width:" + col1Width + "px;text-align:right;'>" + t.col0 + ".</td>"
									  +"<td style='width:" + col2Width + "px;text-align:right;'>"+ t.col1  +"</td>"
									  +"<td style='width: "+ col3Width  +"px;'><center><div style ='border:1px solid black; width:" + colorDiv + "px; height:" + colorDiv +"px; background-color:" + t.col2+ "'></div></center></td>"
									  +"<td style ='text-align:right;width:" + col4Width+ "px;'>"+ t.col3 +"</td>"
									  +"<td style ='width:" + col5Width  + "px;text-align:right'>" + t.col4+ "</td>";
								
								dotRow+=tdDot;
							}else{
								dotRow+=tdEmpty;
							}
						}
						rightList += "</tr>";
						if ((i+1)%4 == 0){
							rightList += "<tr>"+dotRow+"</tr>";
						}
					}
					rightList += "</table></div>"
					
					//image initial part
					var imgHtml="";
					var newImageH = 0;
					var newImageW = 0;
					var widthRatio = 0;
					var heightRatio = 0;
					var ratio = 0;
					
				
					//--------------------------------calculate ratio part---------------------
					widthRatio =  borderWidth/image_w_pixel;
					heightRatio =  borderHeight/image_h_pixel;
					ratio = widthRatio > heightRatio? heightRatio:widthRatio;		
					
					//---------------------image part----------------------------
					//set image div border
					imgHtml += "<div  style='width:" + borderWidth + "px;height:" + borderHeight + "px; border: 1px solid black; line-height:" + borderHeight + "px;'>"
					
					//use ratio to control image display 
					if (ratio > 1){
						ratio = 1;
						output(image_w_pixel,image_h_pixel,ratio,borderHeight);
					
					}
					
					else{
					 output(image_w_pixel,image_h_pixel,ratio,borderHeight);
					}
					
					//output image function
					function output(imgWidth,imgHeight,ratio,borderHeight){
						
						newImageW = imgWidth * ratio;
						newImageH = imgHeight * ratio;
						imgHtml += "<img src='" + printModel.image +"' alt='pattern'" 
								 + "style='display:block; width:" + newImageW + "px;height:" 
								 + newImageH + "px;" + "margin-left:auto;margin-right:auto;margin-top:"
								 + (borderHeight*0.5 - newImageH/2)+"px;'>";	
					}
					imgHtml += "</div>";
					
					//---------------------------header table part--------------------------
					ratio = ratio.toFixed(2);
					var topInfo = "<div style='height:" + table_height_pixel + "px; width:" + paper_w_pixel +"px ;border: 1px solid black;line-height:" + table_height_pixel +"px; text-align:right; border-bottom-style:none;font-family:" + font_family + "; font-size:" + info_font_size +"%;'>";
					topInfo += "Z:" + ratio + '&nbsp'.repeat(5) + printModel.topLine +"</div>";
					
					//--------------------------------bottom table part---------------------------
					var bottomInfo = "<div style='height:" + table_height_pixel + "px; width:" + paper_w_pixel +"px ;border: 1px solid black;line-height:" + table_height_pixel +"px; text-align:left; border-top-style:none;font-family:" + font_family + "; font-size:" + info_font_size +"%;'>" 
					bottomInfo +='&nbsp'.repeat(6) + printModel.bottomLine + "</div>";
					
					
					
					//-----------------------------display------------------------------------
					var display = topInfo + imgHtml + bottomInfo + rightList;
					return display;
				}	
				

				scope.print=function(){
					var printModel=scope.getPrintModel(scope.threadMatcher,false,true);
				
					var html=scope.getDesignHtml(printModel,"letter");
					
					util.print(html,true);
				}				
				
				scope.setDstDesign=function(dstDesign){
				    scope.dstDesign.getDst(dstDesign);
				}

				scope.onClick=function(){
					scope.embStage.onClick();
				}
				

			}, //end of link function
			
			controller:["$scope","util","DstDesign","EmbCanvas","EmbStage",
			            	function($scope,util,DstDesign,EmbCanvas,EmbStage){
				//{code:"S0561",r:255,g:0,b:0},{code:"S1011",r:125,g:125,b:125},{code:"S1043",r:0,g:0,b:255}
				//var runningStepList=new kendo.data.ObservableArray([{code:"S1043",codeIndex:1}]);
				
				var scope=$scope;

				
				//expose this directive scope to parent directive
				if(scope.cName) 
					scope.$parent[scope.cName]=scope;

					
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
				
				$scope.onImageChanged=function(e){
					$scope.embStage.draw();
				}
				
				$scope.onDesignChanged=function(e){
					//e is dstDesign
					$scope.embStage.select();
					if($scope.threadMatcher 
							&&  $scope.threadMatcher.embCanvas 
							&&  $scope.threadMatcher.embCanvas.embDesign===e){
						
						$scope.threadMatcher.initColorwayList();
					}
					$scope.embCanvas.drawDesign();
				}
				
				$scope.dstDesign.designChanged.addListener($scope.embCanvas,$scope.onDesignChanged);
				$scope.embCanvas.imageChanged.addListener($scope.embStage,$scope.onImageChanged);
				
				

			}],
	}
	
	return directive;
}]);



</script>