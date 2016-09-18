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
		idxCode:{},
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
			var self=this;
			$http.get(url).
				success(function(data, status, headers, config) {
			    	ts=[];
			    	for(var i=0,t,d;i<data.length;i++){
			    		d=data[i];
			    		t={code:d.code,r:d.red,g:d.green,b:d.blue,name:d.name};
			    		ts.push(t);
			    		self.idxCode[d.code]=t;
			    	}
			    	self.threads=ts
				}).
				error(function(data, status, headers, config) {
				});
					
		},			
		
		getThreadColor:function(code){
			var c=dictThread.defaultThreadColor;
			if(code){
				code=code.trim().toUpperCase();
				if(code)
					c=this.idxCode[code];
			}
			return c;
		},

		//convert{r: ,g:, b:} to "#FFAABB"
		convertRgbToHexColor:function(c){
			return "#" + ((1 << 24) + (c.r << 16) + (c.g << 8) + c.b).toString(16).slice(1);
		},
		
		getThreadColorHex:function(code){
			var c=dictThread.getThreadColor(code);
			return (c===this.defaultThreadColor)?"":this.convertRgbToHexColor(c);
		},
		
		getThreadColors:function(threadCodes){
			var threadColors=[dictThread.defaultThreadColor],
				codeList=threadCodes.split(',');
			
			for(var i=0;i<codeList.length;i++){
				threadColors.push(dictThread.getThreadColor(codeList[i]))
			}
			return threadColors;
		},
		
		getThreads:function(strCodes){
			var threads=[];
			strCodes=this.normalizeThreadCodes(strCodes);
			if(strCodes){
				var codes=strCodes.split(",");
				for(var i=0,t,code;i<codes.length;i++){
					code=codes[i];
					t=null;
					if(code)
						t=this.idxCode[code];
					if(!t)
						t={code:code,colour:"",hexColour:""};
					else{
						t={code:code,colour:t.name,hexColour:this.convertRgbToHexColor(t)};
					}
					threads.push(t);
				}
				
			}
			return threads;
			
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

		//colourway={threadCodes:"1024,1043",runningSteps:"1-2-1-2",alaphaSteps:"0-0-1-0",alpha:0.1};
		//stepCount=4;
		getColorModel:function(colourway,stepCount){
			var colorModel;
			if(!colourway || (!colourway.threadCodes && !colourway.runningSteps)){
				colorModel=this.getDefaultColorModel();
			}else{
				
				colorModel=[dictThread.defaultThreadColor];
				
				var threadColors=dictThread.getThreadColors(colourway.threadCodes);
				var runningSteps=dictThread.getRunningSteps(colourway.runningSteps,stepCount);
				var alphaSteps=dictThread.getRunningSteps(colourway.alphaSteps,stepCount);
				
				var alpha=typeof colourway.alpha==='undefined'?0:colourway.alpha;
				
				for(var i=0,idx,c,a; i<stepCount; i++){
					
					idx=(i>=colourway.runningSteps.length)?0: parseInt(runningSteps[i]);
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
		
		clearDesign:function(){
			initDesign(this);
			this.designChanged.fireEvent([this]);
		},
		
		loadDstById:function(designId){
		
			var url="/clivia/lib/emb/getdesign?id="+designId;
			var self=this;
			initDesign(this);
			
			$http.get(url).
				success(function(data, status, headers, config) {
					if(data&&data.data){
						var design=data.data;
						for(var property in design){
							if(design.hasOwnProperty(property))
								self[property]=design[property];
						}
						self.info=data.di
					}	
					self.designChanged.fireEvent([self]);
				}).
				error(function(data, status, headers, config) {
					self.designChanged.fireEvent([self]);
				});								
		},
		
		loadDstByNumber:function(designNumber){
			
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
						ctx.moveTo(currStitch.x*scale,currStitch.y*scale);
						prevStitchIsJump=false;
					}else{
						ctx.lineTo(currStitch.x*scale,currStitch.y*scale);
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

factory("EmbCanvas",["dictThread","Event","util",function(dictThread,Event,util){
	
	var SCREEN_PPM=1280/340,SCREEN_DESIGN_RATIO=SCREEN_PPM/10;
	
	var EmbCanvas=function(embDesign){
		
		this.canvas=document.createElement('canvas');
		this.canvas.id=createElementId();
		this.canvas.style.visibility='hidden';		//show or hide design's canvas--visible|hidden
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
			 	
				var colourway=null;
				if(this.embDesign && this.embDesign.stepCount>0){

					this.canvas.width=Math.round(this.embDesign.pixelWidth*SCREEN_DESIGN_RATIO)+1;		//original size of image
					this.canvas.height=Math.round(this.embDesign.pixelHeight*SCREEN_DESIGN_RATIO)+1;
					
					if( this.embDesign.stepCount===this.runningSteps.split(',').length)
						colourway={};
					else{
						this.threadCodes="";
						this.runningSteps="";
					}
				}else{
					this.threadCodes="";
					this.runningSteps="";
					this.canvas.width=0;		//original size of image
					this.canvas.height=0;
				}
				//do nor draw here. Leave the job to parent controller.
				//this.drawDesign(colourway);
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

		getThumbnail:function(){
			this.drawDesign({});
			return util.getThumbnail(this.canvas,120);
		},
		
		setColourway:function(threadCodes,runningSteps){
			this.threadCodes=threadCodes,
			this.runningSteps=runningSteps;
		},
		
		getColourway:function(){
			return {
				threads:this.threadCodes,
				runningSteps:this.runningSteps
			}
		},
		
		normalizeThreadCodes:function(){
			this.threadCodes=dictThread.normalizeThreadCodes(this.threadCodes);
		},
		
		normalizeRunningSteps:function(){
			if(this.embDesign)
				this.runningSteps=dictThread.normalizeRunningSteps(this.runningSteps,this.embDesign.stepCount);
		},
		
		
		normalizeColourway:function(){
			this.normalizeThreadCodes();
			this.normalizeRunningSteps();
			
			var codes=this.threadCodes.split(",");
			var steps=this.runningSteps.split("-");
			var newCodes="",newIndexCount=0;
			var newSteps="";
			var map={};
			for(var i=0,index,code,indStr;i<steps.length;i++){
				index=parseInt(steps[i]);
				if(index>0){
					if(index<=codes.length){
						var indStr=index.toString();
						var newIndex=map[indStr];
						if(!newIndex){
							newCodes+=","+codes[index-1];
							newIndex=++newIndexCount;
							map[indStr]=newIndex;
						}
						newSteps+="-"+newIndex;
					}else{
						newSteps+="-0";
					}
				}else{
					newSteps+="-0";
				}
			}
			if(newCodes)
				this.threadCodes=newCodes.substring(1);
			if(newSteps)
				this.runningSteps=newSteps.substring(1);
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
		
		//if typeof colourway==="undefined", use delautColorModel
		//if colourway==={}, use thredCodes or runningSteps of this embCanvas
		drawDesign:function(colourway){
			if(!(this.embDesign && this.embDesign.isValid())){
				this.imageChanged.fireEvent([this]);
				return;
			} 
	
			if(colourway){
				if(!colourway.threadCode)
					colourway.threadCodes=this.threadCodes;
				if(!colourway.runningSteps)
					colourway.runningSteps=this.runningSteps;
			};
			
			var colorModel=dictThread.getColorModel(colourway,this.embDesign.stepCount);
			
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
			
			//set design of this canvas to null and the designchanged event will be raised
			clearDesign:function(){
				this.embCanvas.embDesign.clearDesign();
			},
			
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
			
			//initialize threadList(threadGrid) and runningStepList(stepGrid) for the design of this matcher
			initColourwayList:function(){	
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
			composeThreads:function(){	
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
			composeRunningSteps:function(){	
				var steps=[],step;
				for(var i=0;i<this.runningStepList.length;i++){
					step=this.runningStepList[i];
					if(parseInt(step.stepStitchCount)===0){
						steps.push("0");
					}else{
						if(!step.code)
							break;
						steps.push(step.threadIndex);
					}
				}
				if(steps!==this.embCanvas.runningSteps){
					this.embCanvas.runningSteps=steps.join('-');
				}
			},

			//from this.embCanvas.threadCodes to this.threadList
			//threadCodes must be normalized before calling this method
			parseThreads:function(){  
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
			parseRunningSteps:function(){	
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
			
			
			parseColourway:function(){
				this.parseThreads();		//populate
				this.parseRunningSteps();	//populate
				this.setThreadStitchCount();
                this.gwThread.grid.refresh();
                this.gwStep.grid.refresh();
                this.drawDesign();

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
			
			setColourway:function(threads,runningSteps){
				
				this.embCanvas.setColourway(threads,runningSteps);

				this.embCanvas.normalizeThreadCodes();
				this.embCanvas.normalizeRunningSteps();
				
				this.parseColourway();
			},
			
			getColourway:function(){
				return this.embCanvas.getColourway();
			},
			
			getThumbnail:function(){
				return this.embCanvas.getThumbnail();
			},
			
			setEmbCanvas:function(embCanvas){
				this.embCanvas=embCanvas;
				this.initColourwayList();
			},
			
			//editing mode, called from events of gwStep.grid 
			drawDesign:function(gw){

				var colourway={};
				if(!gw){
					this.embCanvas.drawDesign(colourway);
					return;
				}
				var isStepGrid=gw.gridName==="embStepGrid";
					
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
					colourway.runningSteps=steps.substring(1);
					colourway.alphaSteps=alphaSteps.substring(1);
					colourway.alpha=cellIndex==1?0.15:0.03;
				
					this.embCanvas.drawDesign(colourway);
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
	                    self.composeThreads();
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
				  	        				self.composeThreads();
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
		                	 
		                    self.composeRunningSteps();
		                    
		                    //let model accept code value that set by above code
		  	        		e.preventDefault();
		  	        		
							self.drawDesign(self.gwStep);
							self.gwThread.grid.refresh();
							scope.$apply();
			          	}
						saving=false;
			       		
					},	//end of save
					
		       		dataBinding:function(e){
		       			//create a globle variable for template of the colour column to show step colour 
		       			renderingPaint=self;
		       		}

				}
			},//end of stepGridOptions
			
			getBackgroundColourPaletteOptions:function(){
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
			
			link:function(scope){
				
				scope.parseThreads=function(){
					scope.embMatcher.embCanvas.normalizeThreadCodes();
					scope.embMatcher.parseColourway();
				}
				
				scope.parseSteps=function(){
					scope.embMatcher.embCanvas.normalizeRunningSteps();
					scope.embMatcher.parseColourway();
				}

			}, //end of link function
			
			controller:function($scope){
				$scope.embMatcher=new EmbMatcher();
				
				$scope.parseThreadsButtonOptions={
					imageUrl:"../resources/images/i-parse.ico",
					click:$scope.parseThreads
				}
				
				$scope.parseStepsButtonOptions={
					imageUrl:"../resources/images/i-parse.ico",
					click:$scope.parseSteps
				}
				
				$scope.$on("kendoWidgetCreated", function(event, widget){
				        // the event is emitted for every widget; if we have multiple
				        // widgets in this controller, we need to check that the event
				        // is for the one we're interested in.
				        if (widget ===$scope[$scope.embMatcher.gwThread.gridName])
				        	$scope.embMatcher.gwThread.wrapGrid(widget);
				        
				        if (widget ===$scope[$scope.embMatcher.gwStep.gridName]) 
				        	$scope.embMatcher.gwStep.wrapGrid(widget);
				    });	
				
				//expose this directive scope to parent directive
				if($scope.cName) 
					$scope.$parent[$scope.cName]=$scope.embMatcher;

				if($scope.cEmbCanvas)
					$scope.embMatcher.setEmbCanvas($scope.cEmbCanvas);
				
				$scope.threadGridOptions=$scope.embMatcher.getThreadGridOptions($scope);
				$scope.stepGridOptions=$scope.embMatcher.getStepGridOptions($scope);
				
				
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
			},
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
				
				
				scope.getPrintModel=function(embMatcher,settings){
					var model={};
					if(!embMatcher) return model;
					var embCanvas=embMatcher.embCanvas;
					if(!embCanvas) return model;
					
					
					var dst=embCanvas.embDesign;
					if(dst && dst.isValid()){
						//embCanvas.drawDesign();
						
						var list=[],line,firstStepIndex;
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
						
						if(settings.showThreadList){
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
						firstStepIndex=list.length;
						
						for(var i=0,idx,step,code,t;i<stepList.length;i++){
							step=stepList[i];
							idx=parseInt(step.threadIndex);
							t=(idx>0 && idx<=threadList.length)?threadList[idx-1]:null;
							if(t && t.code){
								code=t.code;
								if(settings.purgeRepeat){
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
						topLine+="H:"+dst.height+"&nbsp;("+dst.info.heightInch.toFixed(1)+")"+ "&nbsp;".repeat(space);
						topLine+="W:"+dst.width+"&nbsp;("+dst.info.widthInch.toFixed(1)+")"+ "&nbsp;".repeat(space);
						topLine+="St:"+dst.stitchCount+"&nbsp;".repeat(space);
						topLine+="Steps:"+dst.stepCount+"&nbsp;".repeat(space);
						topLine+=dst.info&&dst.info.designNumber?(dst.info.designNumber+"&nbsp;".repeat(space)):"";
						topLine+=(dst.info&&dst.info.companyName?dst.info.companyName:"")+"&nbsp;";
						var bottomLine=""
						
						model={
								topLine:topLine,
								bottomLine:bottomLine,
								width:dst.width,
								height:dst.height,
								list:list,
								firstStepIndex:firstStepIndex,
								image:embCanvas.imageObj.toDataURL(),
								bgColour:embMatcher.backgroundColour?embMatcher.backgroundColour:"#FFFFFF",
								settings:settings,
						}
						
					}
					
					return model;
				}			
				
				//paperType:letter-8.5"x11";ledger:11"x17"				
				scope.getDesignHtml= function (printModel){	
					var bgColor=printModel.settings.bgColour?printModel.bgColour:"#FFFFFF";
					var Paper = {
						papers :[{type:"Letter",width:191, height:255},{type:"Ledger", width:260, height:416}],//191 255 272 432
						getPaper :function (paperType){
							var paper;
							var papers = this.papers;
							for (var i = 0; i < papers.length; i++){
								if(papers[i].type == paperType){
									paper = papers[i];
									break;
								}
							}
							
							return paper?paper:papers[0];
						},
						getDefault:function (){
							return papers[0];	
						} 
					}
				
					var paper = Paper.getPaper(printModel.settings.paperType);
						
					//var layout ="portrait";
					if(printModel.settings.orientation==="Landscape"){
						var temp = paper.width;
						paper.width = paper.height;
						paper.height = temp;
					}
					
					//before change to pixel, all variable are in mm.
					var margin = 0; 
					var r_table_w = 40;
					var r_table_h = 240.5;//240.5
					var paper_width = (paper.width - (margin*2));
					var paper_height = (paper.height - (margin*2));
					var table_width= paper.width;
					var table_height = 5;
					
					var mmToPixel = 3.77;		//pixel per mm

					var font_family = "Times New Roman";
					var info_font_size = 80;	//top info and bottom info font size
					var list_font_size = 100;	//list font size
					
					
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
					var colorDivSize = 10;
					var col1Width = 25;
					var col2Width = 20;
					var col3Width = 20;
					var col4Width = 25;
					var col5Width = 20;
					
					var rightList="";
				
					//test part start here
					var rowHeight = 20;//15
					//calculate how many row needed
					var row_count = Math.floor(borderHeight/rowHeight)-2;
					//calculate how many col needed
					var needed_row = threadLists.length;
					var col_count = Math.ceil(needed_row/row_count);
					//calculate width for img div part
				
					var borderWidth = paper_w_pixel - r_table_w_pixel*col_count - error_pixel;
					borderWidth = paper_w_pixel - r_table_w_pixel*col_count - error_pixel;
					//calculate width for righthand list part
					var divWidth = paper_w_pixel - borderWidth + error_pixel3;
					//if there enough space to display the list?
					if(divWidth > (paper_w_pixel*0.54)){
							alert("Sorry, we can not display it!");
							return;
					}
					
					rightList = "<div style='height:"+ borderHeight + "px; border: 1px solid black; width:" + divWidth +"px;"
							  +"margin-top:" + -(paper_h_pixel - table_height_pixel - error_pixel2) + "px;text-align:center; border-left-style:none;"
							  +"margin-left:" + (borderWidth)  +"px; font-family:" + font_family + "; font-size:" + list_font_size +"%;'>"
							  +"<table style='border-collapse: collapse; width:" + divWidth + "px;'>";
					
					var tdDot = "";
					var tdEmpty="";
					
					if(printModel.settings.showStitchCount){
						var tdNeed = 5;
						display = "true";
					}
					else{
						var tdNeed = 4;
						display = "none";
					}
					
					for(var i=0;i<tdNeed;i++){
							tdDot += "<td style = 'border-bottom-style:dotted;border-bottom-width: 1px;'></td>";
							tdEmpty +="<td></td>";
					}
					
						
					for(var i = 0,t,dotRow; i < row_count; i++){
						rightList += "<tr>"
						dotRow="";
						for(var j = 0; j < col_count; j++){
							var count = j * row_count + i;
							if(count < needed_row){
								t = threadLists[count];
								
								rightList += "<td style='height:"+rowHeight+"px; width:" + col1Width + "px;text-align:right;padding:0px;'>" +(t.col0?(t.col0+"."):"") + "</td>";
								rightList += "<td style='width:" + col2Width + "px;text-align:right; display:"+ display + "'>"+ t.col1  +"</td>";
								
								rightList += "<td style='width: "+ col3Width  +"px;'>"
											+(t.col2?("<center><div style ='border:1px solid black; width:" + colorDivSize + "px; height:"  + colorDivSize +"px; background-color:" + t.col2+ "'></div></center>"):"")
											+"</td>";
								
								rightList += "<td style ='text-align:right;width:" + col4Width+ "px;'>"+ t.col3 +"</td>";
								
								if(count < row_count && col_count !=1){		  
									rightList += "<td style ='width:" + col5Width  + "px;text-align:right;border-right-style:solid; border-right-width: 1px;padding-right:5px;'>" + t.col4+ "</td>";
								}
								else{
									rightList += "<td style ='width:" + col5Width  + "px;text-align:right;padding-right:5px;'>" + t.col4+ "</td>";
								}
				
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
						
					var imageBorderWidth=0;	//10 added by jacob to add a border to image, background and border of the image have same color  
					
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
					if (ratio > 1)
						ratio = 1;

					newImageW = image_w_pixel * ratio-imageBorderWidth*2;	//-imageBorderWidth*2:added by jacob
					newImageH =image_h_pixel * ratio-imageBorderWidth*2;	//-imageBorderWidth*2:added by jacob
					
					imgHtml += "<img src='" + printModel.image +"' alt='pattern'" 
							 + "style='display:block; width:" + newImageW + "px;height:" 
							 + newImageH + "px;" + "margin-left:auto;margin-right:auto;margin-top:"
							 + (borderHeight*0.5 - newImageH/2-imageBorderWidth)+"px;"
							 + (bgColor?"border:"+imageBorderWidth+"px solid "+bgColor+";background-color:"+bgColor+";":"")+"'>";	

					imgHtml += "</div>";
					
					//---------------------------header table part--------------------------
					ratio = ratio.toFixed(2);
					var topInfo = "<div style='height:" + table_height_pixel + "px; width:" + paper_w_pixel +"px ;border: 1px solid black;line-height:" + table_height_pixel +"px; text-align:right; border-bottom-style:none;font-family:" + font_family + "; font-size:" + info_font_size +"%;'>";
					topInfo += "Z:" + ratio + '&nbsp'.repeat(5) + printModel.topLine +"</div>";
					
					//---------------------------bottom table part---------------------------
					var bottomInfo = "<div style='height:" + table_height_pixel + "px; width:" + paper_w_pixel +"px ;border: 1px solid black;line-height:" + table_height_pixel +"px; text-align:left; border-top-style:none;font-family:" + font_family + "; font-size:" + info_font_size +"%;'>" 
					bottomInfo +='&nbsp'.repeat(6) + printModel.bottomLine + "</div>";
					
					//---------------------------display------------------------------------
					var display = topInfo + imgHtml + bottomInfo + rightList;
					
					return display;
					
				}	
				

				scope.print=function(){
					
					var printSettings =[{
								type: "radio",
								name: "paperType",
								value: ["Letter", "Ledger"],
								question: "Paper Type: ",
								answer: "Letter"
							  }, {
								type: "radio",
								name: "orientation",
								value: ["Landscape", "Portrait"],
								question: "Orientation: ",
								answer: "Portrait"
							  }, {
								type: "checkbox",
								name: "bgColour",
								value: true,
								question: "Show background colour: ",
								answer: true
							  }, {
								type: "checkbox",
								name: "showStitchCount",
								value: false,
								question: "Show stitch count: ",
								answer: false
							  }, {
								type: "checkbox",
								name: "showThreadList",
								value: true,
								question: "Show Thread List: ",
								answer: true
							  }, {
								type: "checkbox",
								name: "purgeRepeat",
								value: false,
								question: "Purge repeat codes: ",
								answer: false
							  }];
							
					util.getSettingDialog(printSettings,1).then(function(settings){
						//parameters:embMatcher,showThreads--list of threads,purgeRepeatCode
						scope.printModel=scope.getPrintModel(scope.threadMatcher,settings);
						
						//parameters:printModel,paperType,isLandscape,bgColor,showStitchCount
						//paperTypess :[{type:"letter",width:191, height:255},{type:"ledger", width:260, height:416}]
						var html=scope.getDesignHtml(scope.printModel);
						
						util.print(html,true);
					});
				}				
				
				
				
				scope.loadDesignById=function(designId){
				    scope.dstDesign.loadDstById(designId);
				}

				scope.onClick=function(){
					scope.embStage.onClick();		//selct/deselect an object
					scope.threadMatcher.drawDesign();	//drag image of design with current colourway
				}
				
				
			}, //end of link function
			
			controller:["$scope","util","DstDesign","EmbCanvas","EmbStage",
			            	function($scope,util,DstDesign,EmbCanvas,EmbStage){
				//{code:"S0561",r:255,g:0,b:0},{code:"S1011",r:125,g:125,b:125},{code:"S1043",r:0,g:0,b:255}
				//var runningStepList=new kendo.data.ObservableArray([{code:"S1043",codeIndex:1}]);
				
				
				//expose this directive scope to parent directive
				if($scope.cName) 
					$scope.$parent[$scope.cName]=$scope;

					
			    $scope.dstDesign=new DstDesign();

			    $scope.embStage=new EmbStage({container:'stagecontainer',
			        width: 2000,
			        height:2000});
				
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
					$scope.embStage.select();		//deselect all objects
					
					if($scope.threadMatcher 
							&&  $scope.threadMatcher.embCanvas 
							&&  $scope.threadMatcher.embCanvas.embDesign===e){
						
						$scope.threadMatcher.initColourwayList();
					}
					$scope.embImage.setWidth($scope.embCanvas.getOriginalWidth());
					$scope.embImage.setHeight($scope.embCanvas.getOriginalHeight());
					$scope.embCanvas.drawDesign();
				}
				
				$scope.dstDesign.designChanged.addListener($scope.embCanvas,$scope.onDesignChanged);
				$scope.embCanvas.imageChanged.addListener($scope.embStage,$scope.onImageChanged);
				
				$scope.setColourway=function(threads,runningSteps){
					$scope.threadMatcher.setColourway(threads,runningSteps);
					
				}
				$scope.getColourway=function(){
					return $scope.threadMatcher.getColourway();
				}
				$scope.getThumbnail=function(){
					return $scope.threadMatcher.getThumbnail();
				}
				
				$scope.getBackgroundColour=function(){
					var bgColour=$scope.threadMatcher.backgroundColour;
					return bgColour?bgColour:"#FFFFFF";
				}
				
				$scope.setBackgroundColour=function(bgColour){
					$scope.threadMatcher.backgroundColour=bgColour?bgColour:"#FFFFFF";
				}
				
				$scope.clear=function(){
					$scope.threadMatcher.clearDesign();	//designchanged event will be fired 
				}
				
			    $scope.newColourway=function(){
			    	$scope.threadMatcher.embCanvas.setColourway("","");
			    	$scope.threadMatcher.initColourwayList();
			    	$scope.threadMatcher.embCanvas.drawDesign();
			    }				
				
			    $scope.normalizeColourway=function(){
			    	$scope.threadMatcher.embCanvas.normalizeColourway();
			    	$scope.threadMatcher.parseColourway();
			    }			    
			}],
	}
	
	return directive;
}]).

directive("dstEditor",["EmbMatcher","util","$http",function(EmbMatcher,util,$http){
	
	var templateUrl="../dm/dsteditor";
	
	var directive={
			restrict:'EA',
			replace:true,
			scope:{
				cName:'@dstEditor',
				cEmbDataSource:'=',
				cColourwayDataSource:'=',
			},
	
			templateUrl:templateUrl,
			
			link:function(scope,element,attrs){
			    var populate=function(data){
					scope.dataSet.info=data.info;
					var itemNames=["colourways","samples"];
					for(var i=0,scopeItems,dataItems,itemName;i<itemNames.length;i++){
						itemName=itemNames[i];
						dataItems=data[itemName];
						if(dataItems){
							scopeItems=scope.dataSet[itemName];
							for(var j=0;j<dataItems.length;j++){
								scopeItems.push(dataItems[j]);
							}
						}
					}
			    }

				var clearDataSet=function(){
			    	scope.dataSet.info={};
			    	scope.dataSet.colourways.splice(0,scope.dataSet.colourways.length);
			    	scope.dataSet.samples.splice(0,scope.dataSet.samples.length);
			    	scope.dataSet.deleteds=[];
				}
				
			    scope.clear=function(){
			    	scope.searchDesignNumber=null;
			    	clearDataSet();
			    	scope.myDstPaint.clear();
			    	scope.myDstPaint.setBackgroundColour("#FFFFFF");
			    	scope.$apply();
			    }
			    
			    scope.loadDesignById=function(id){
			    	scope.clear();
			    	
			    	var url="../lib/emb/get-embdesign?id="+id;
					$http.get(url).then(
						function(data, status, headers, config) {
							if(data.data){
					    		populate(data.data);
							}
						},function(data, status, headers, config) {
					});

			    	scope.myDstPaint.loadDesignById(id);

			    }
			    
			    scope.saveDesign=function(){
			    	//if(!validDesign()) return;
					var url="../lib/emb/save-embdesign";
					
					$http.post(url,scope.dataSet).then(
						  function(data, status, headers, config) {
								if(data.data){
									clearDataSet();
						    		populate(data.data);
								}else{
									alert("failed to save:"+JSON.stringify(data));
								}
						  },function(data, status, headers, config) {
							  alert( "failure message: " + JSON.stringify(data));
						  });		
			    }
			    
			    var getColorwayDiFromPaint=function(){
			    	var colourway=scope.myDstPaint.getColourway();
			    	var thumbnail=scope.myDstPaint.getThumbnail();
			    	var bgColour=scope.myDstPaint.getBackgroundColour();
			    	var pos=thumbnail.indexOf(",");
			    	thumbnail=pos>0?thumbnail.substr(pos+1):"";
			    	
			    	var di={
			    		threads:colourway.threads,
			    		runningSteps:colourway.runningSteps,
			    		backgroundColour:bgColour,
			    		thumbnail:thumbnail,
			    	}
			    	return di;
			    }
			    
			    scope.addColourway=function(){
			    	var di=getColorwayDiFromPaint();
			    	di.libEmbDesignId=scope.dataSet.info.id;
			    	scope.cgw.addRow(di);
			    }
			    
			    scope.newColourway=function(){
			    	scope.myDstPaint.threadMatcher.embCanvas.setColourway("","");
			    	scope.myDstPaint.threadMatcher.initColourwayList();
			    	scope.myDstPaint.threadMatcher.embCanvas.drawDesign();
			    }
			    
			    scope.removeColourway=function(){
					var dataItem=scope.cgw.getCurrentDataItem();
			    	var confirmed=true;
				    if (dataItem) {
				        if (dataItem.threads&&dataItem.runningSteps){
				        	confirmed=confirm('Please confirm to delete the selected row.');	
				        }
				        if(confirmed){
					    	if(dataItem.id){
					    		var item= {entity:"libEmbDesignColourway",id:dataItem.id};
								scope.dataSet.deleteds.push(item);				    	
					    	}
							scope.cgw.deleteRow(dataItem);
				        }
				    }else {
			        	alert('Please select a  colorway  to delete.');
			   		}
			    	
			    }
			    
			    scope.updateColourway=function(){
			    	var currentCell=scope.cgw.grid.current();
			    	if(currentCell){
				    	var diCurrent=scope.cgw.getCurrentDataItem();
				    	var diPaint=getColorwayDiFromPaint();
				    	if(diCurrent&&diPaint){
				    		diCurrent.threads=diPaint.threads;
				    		diCurrent.runningSteps=diPaint.runningSteps;
				    		diCurrent.backgroundColour=diPaint.backgroundColour;
				    		diCurrent.thumbnail=diPaint.thumbnail;
				    		diCurrent.isDirty=true;
				    	}
				    	scope.$apply();
				    	var columnIndex=scope.cgw.getColumnIndex("thumbnail");
		                var template = kendo.template(scope.cgw.gridColumns[columnIndex].template);
		            	var cell = currentCell.parent().children('td').eq(columnIndex);
		                cell.html(template(diCurrent));		                    
			    	}else{
			        	alert('Please select a  colorway  to update.');
			    	}
			    }
			    
			    scope.normalizeColourway=function(){
			    	scope.myDstPaint.threadMatcher.embCanvas.normalizeColourway();
			    	scope.myDstPaint.threadMatcher.parseColourway();
			    }
				

				
			},
			controller:["$scope","ColourwayGridWrapper",function($scope,ColourwayGridWrapper){
				
				$scope.cgw=new ColourwayGridWrapper("colourwayGrid");	
				$scope.cgw.setColumns();

				var onColourwayGridDoubleClicked=function(e){
					if(e.currentTarget){
						var di=$scope.colourwayGrid.dataItem(e.currentTarget);
						if(di&&di.threads&&di.runningSteps){
							$scope.myDstPaint.setColourway(di.threads,di.runningSteps);
							$scope.myDstPaint.setBackgroundColour(di.backgroundColour);
						}
					}
				}
				
				$scope.$on("kendoWidgetCreated", function(event, widget){
					if (widget ===$scope[$scope.cgw.name]) {
			        	$scope.cgw.wrapGrid(widget);
						widget.bind("dataBound",function(e){
							this.tbody.find("tr").dblclick(onColourwayGridDoubleClicked);
						});
			        }
			    });				
				
				$scope.colourwayGridOptions={
						autoSync: true,
				        columns: $scope.cgw.gridColumns,
				        dataSource: $scope.cColourwayDataSource,
				        pageable:false,
				        selectable: "row",
				        navigatable: true,
				        resizable: true,
				}
						
			}],
	}
	
	return directive;

}]);


</script>