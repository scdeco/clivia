<script>
angular.module("embdesign",	["kendo.directives","cliviagrid"]).

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
		
		
		
		getColorModel:function(colorway,stepCount){
			var colorModel;
			if(!colorway.threadCodes||!colorway.runningSteps||!stepCount){
				colorModel=this.getDefaultColorModel();
			}else{
				colorModel=[DictThread.defaultThreadColor];
				
				
				var threadColors=DictThread.getThreadColors(colorway.threadCodes);
				var runningSteps=colorway.runningSteps.split('-',stepCount);
				
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
		
		this.threadCodes="";
		this.runningSteps="";
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
			this.threadCodes=threadCodes,
			this.runningSteps=runningSteps;
		},
		
		drawDesign:function(){
	
			this.canvas.width=Math.round(this.dstDesign.pixelWidth*SCREEN_DESIGN_RATIO)+1;
			this.canvas.height=Math.round(this.dstDesign.pixelHeight*SCREEN_DESIGN_RATIO)+1;
			this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
			
			if(this.dstDesign)
				this.dstDesign.drawDesign(this.ctx,{threadCodes:this.threadCodes,runningSteps:this.runningSteps},SCREEN_DESIGN_RATIO);
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

	var paletteColours=[
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
			    width: 35,
			    template: "<span #if(colour){# class='colourCell' #}# style='background-color:#= colour #;'>&nbsp;</span>"
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
			    width: 40,
			    editor:function(container, options) {
			         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
			     },
			}, {			
				name:"colour",
			    title: " ",
			    width: 35,
			    template: "<span #if(colour){# class='colourCell' #}# style='background-color:#= colour #;'>&nbsp;</span>"
			}, {			
				name:"code",
			    field: "code",
			    title: "Thread",
			}, {			
				name:"threadIndex",
			    title: "#",
			    field:"threadIndex",
			    editor:function(container, options) {
			         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
			     },
			    width: 30
			}];
	
    var dstPaint=function(config){
			
    		this.gwThread=new GridWrapper("dstThreadGrid");
			this.gwThread.setColumns(threadGridColumns);
			
    		this.gwStep=new GridWrapper("dstStepGrid");
			this.gwStep.setColumns(stepGridColumns);

			this.threadList=new kendo.data.ObservableArray([]);
			this.runningStepList=new kendo.data.ObservableArray([]);
			
			this.dstCanvas={};
			this.dstStage=new DstStage({container:config.stage,
		          width: 1024,
		          height: 800});
	}
    
    dstPaint.prototype={

			clearThreads:function(){
				for(var i=0;i<this.threadList;i++){
					this.threadList[i].code="";
					this.threadList[i].colour="";
				}
				
			},
			
			clearRunningSteps:function(){
				for(var i=0;i<this.runningStepList.length;i++){
					this.runningStepList[i].code="";
					this.runningStepList[i].colour="";
					this.runningStepList[i].threadIndex="";
				}
			},
			
			initColorway:function(){
				this.threadList.splice(0,this.threadList.length)
				this.runningStepList.splice(0,this.runningStepList.length)
				if(this.dstCanvas.dstDesign){
					var design=this.dstCanvas.dstDesign,
						stepCount=design.stepCount,
						threadCount=stepCount<MAX_THREAD_COUNT?stepCount:MAX_THREAD_COUNT;
					for(var i=0;i<threadCount;i++)
						this.threadList.push({code:"",colour:""});
					for(var i=0;i<stepCount;i++)
						this.runningStepList.push({code:"",colour:"",threadIndex:""});
				}
			},
			
			parseThreads:function(){
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
			
			parseRunningSteps:function(){
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
			
			setDstCanvas:function(dstCanvas){
				this.dstCanvas=dstCanvas;
				this.initColorway();
			},
			
			wrapThreadGrid:function(){
				this.gwThread.wrapGrid();
			},

			wrapStepGrid:function(){
				this.gwStep.wrapGrid();
			},
			
			
			backgroundColorOptions:function(){
				return {
		        	columns: 1,
		        	tileSize: {width: 34,height: 12},
			        palette: paletteColours
		        }
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
					
					dataBound:function(e){
						self.gwThread.showLineNumber();
					},
					
					save:function(e){
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
						self.dstCanvas.drawDesign();
						self.dstStage.draw();

					},
				}
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

					dataBound:function(e){
						self.gwStep.showLineNumber();
					},
				
					save:function(e){
			       		if(typeof e.values.code!== 'undefined'){
			       			var code=e.values.code;
		  	        		e.preventDefault();
		  	        		if(code.trim()===";"){
		  	        			self.gwStep.copyPreviousRow();
		  	        		}else{
				          		e.model.set("code","");
				          		e.model.set("colour","");
				          		e.model.set("threadIndex","");
		  	        			
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
			  	        			e.model.set("code",thread.code);
			  	        			e.model.set("colour",thread.colour);
					          		e.model.set("threadIndex",(index+1).toString());
			  	        		}
		  	        		}
		 		       			
			          		var template = kendo.template(this.columns[2].template),
			                	cell = e.container.parent().children('td').eq(2);
		                    cell.html(template(e.model));
		                    
		                    self.parseRunningSteps();
							self.dstCanvas.drawDesign();
							self.dstStage.draw();
			          	}
						
					},
			

				}
			},
			
	}
	
    return dstPaint;
}]);


</script>