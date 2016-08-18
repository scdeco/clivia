<script>
'user strict';

clivia=angular.module("clivia",["kendo.directives" ]);

clivia.factory("util",["$http","$q",function($http,$q){
	var tmpId=1000;
	return {
		
		getTmpId:function(){
			return tmpId++;
		},
		
		//find index of item in items by key value or by keys and values
		//property=id,propertyValue=2  
		//or propertyName=['garmentId','colour','size'] and  propertyVlaue=[12,"Red","XL"]
		findIndex:function(items,propertyName,propertyValue){
			var result=-1;
			
			if(Array.isArray(propertyName) || Array.isArray(propertyValue)) {
				if(Array.isArray(propertyName) 
						&& Array.isArray(propertyValue) 
						&&	propertyName.length===propertyValue.length){
					
					var ns=propertyName,vs=propertyValue;
					for (var i = 0,item; i <items.length; i++) {
						item=items[i];
						j=0;
						while (j<propertyName.length){
						    if (item[ns[j]] !== vs[j]) {
						    	break; 
						    }
						    j++
						}
						if(j===propertyName.length){
							result=i;
							break;
						}
					}
				}
			}else{
				for (var i = 0; i <items.length; i++) {
				    if (items[i][propertyName] === propertyValue) {
				    	result=i;
				    	break; 
				    }
				}
			}
			return result;
		},
		
		find:function(items,propertyName,propertyValue){
			var index=this.findIndex(items,propertyName,propertyValue);
			return index<0?null:items[index];
		},
		
		getRemote:function(url,data){
			var processSuccess=function(data, status, headers, config) {
				if(data){
					deferred.resolve(data)
				}else{
					deferred.reject("error:1");
				}
			}
			var processError=function(data, status, headers, config) {
				deferred.reject("error:2");
			}
			
			var deferred = $q.defer();
			
			if(!data){
				$http.get(url).
					success(processSuccess).
					error(processError);			
			}else{
				$http.post(url,data).
					success(processSuccess).
					error(processError);			
			}
			
			return deferred.promise;
		},
		
		split:function(originalStr,seperator){
			if(!seperator)
				seperator=",";
			var strs=[];
			if(originalStr){
				strs=originalStr.split(seperator);
				for(var i=0;i<strs.length;i++){
					if(strs)
						strs[i]=strs[i].trim();
				}
			}
			return strs;
		},
		
		clearProperties:function(o){
			for(var p in o)
			    if(o.hasOwnProperty(p))
			        o[p] = null;
		},
		
		printUrl:function(url,data,preview){
	 		this.getRemote(url,data).then(
	 				function(html){
	 				    var printWin = window.open('','');
	 	 			    printWin.document.open();
	 	 			    printWin.document.write(html);
	 				    printWin.document.close();
	 				    printWin.focus();
	 				    if(!preview){
	 				    	//if do not settimeout, the content will be blank, print before they are rendered
	 				    	setTimeout(function(){		
		 					    printWin.print();
		 					    printWin.close(); 
	 				    	},50);
	 				    }
	 				});
		},
		
		print:function(html,preview){
			    var windowContent = '<!DOCTYPE html>';
			    windowContent += '<html>'
			    windowContent += '<head><title></title></head>';
			    windowContent += '<body>'
			    windowContent += html;
			    windowContent += '</body>';
			    windowContent+='<style>	html {font-family: Arial, Helvetica, sans-serif; font-size: 9pt;}';
			    windowContent+='</style>';
			    windowContent += '</html>';
			    var printWin = window.open('','');
 			    printWin.document.open();
 			    printWin.document.write(windowContent);
			    printWin.document.close();
			    printWin.focus();
			    if(!preview){
				    printWin.print();
				    printWin.close(); 
			    }
			},
		uploadImage:function(file,url){
				var deferred = $q.defer();

	            var fd = new FormData();
	               fd.append('file', file,"pasteimage.jpg"); 
	            
	               $http.post(url, fd, {
	                  transformRequest: angular.identity,
	                  headers: {'Content-Type': undefined}
	            	   })
	            
	               .success(function(e){
	            	   deferred.resolve(e);
	              		 })
	               .error(function(){
	               	});
	            return deferred.promise;
			},
		getTerms:function(){
			return ["Prepaid","Net Before Jan.10","Net Before Feb.10","Net 15 Days","Net 30 Days","Net 45 Days","Net 60 Days","2%/10/N30","2%/10/N45","2%/10/N60",""];
		},
			
		getThumbnail:function(source,thumbnailSize){
				var tempCanName = "tempCan";
				
				function getImage(s){	
					var strDataURI = s.toDataURL();
					var img = new Image;
					img.src = strDataURI;
					return img;
				}
			
				function createTemporaryCan(img,w,h){
					var canvas = document.createElement('canvas');
					
					canvas.id = tempCanName;
					canvas.width = w;
					canvas.height = h;
					
					document.body.appendChild(canvas);
				
					return  document.getElementById(tempCanName);
				}
				
				
				var img = getImage(source);
				var f= ((img.width>=img.height)?img.width:img.height)/thumbnailSize;
				var w=Math.round(img.width/f),
					h=Math.round(img.height/f);
				
				var tempCan = createTemporaryCan(img,w,h);
				var ctxTemp = tempCan.getContext("2d");
				ctxTemp.drawImage(img, 0, 0, w, h);
				
				var iData=tempCan.toDataURL("image/png");
				$('#'+tempCanName).remove();
				return iData;
			},
		
			//
		getSettingDialog:function(settings,destroyDelayTime){
			var dfd;
			var win;
			var dialogId="settingDialog"+this.getTmpId();
			var okId=dialogId+"Ok";
			var cancelId=dialogId+"Cancel";
			var result
			var buttonClicked=false;
			var getButton=function(caption,id){
				return "<a id='"+id+"' class='k-button' style='margin: 10px;'><span class='k-icon k-i-"+(caption==="Ok"?"tick":"close")+"'></span>"+caption+"</a>";
			}
			
			var onButtonClick=function(button){
				var result;
				buttonClicked=true;
				if(button.id==okId)
					result=getResult();
				
				win.close();
				
				if(result)
					dfd.resolve(result);
				else
					dfd.reject();
			}
			
			var getResult=function(){
				var answer = {};
				for(var i=0, r; i<settings.length; i++){
					r = settings[i];
					
					switch(r.type){
						case "checkbox":
							r.answer = document.getElementById(r.id).checked;
							break;
						case "radio":
							r.answer = $("input[name='"+r.id+"']:checked").val(); 
							break;
					}	
					
					answer[r.name]=r.answer;

					
				}
				return answer;
			}
			
			var createDialog=function(settings){
				
				var b= "<div id='"+dialogId+"' style='width: auto; height: auto;'>" + "<div style='width: 350px; margin:20px;'>";
			    for (var i = 0, r; i < settings.length; i++) {
			      r = settings[i];
			      r.id=dialogId+r.name;
			      
				  switch(r.type){
					case "checkbox":
						b += "<input type=" + r.type + " id=" +r.id +  (r.value?" checked":"") + ">" +  r.question +"<br><br>";
						break;
					case "radio":
						b +=  "<div id=" +r.id+">"+r.question +"&nbsp;"; 
						for(var j=0; j<r.value.length; j++){
							b +=  "<input type=" + r.type +  " name="+r.id+ " value=" + r.value[j] + (r.answer===r.value[j]?" checked":"") + ">" +r.value[j] + "&nbsp;&nbsp;";
						}
						b += "</div><br>";
						break;
				  }	
			      
			    }
			    b += "<p style='width: 180px; margin: auto;'>" +getButton("Ok",okId)+getButton("Cancel",cancelId)+ "</p>";  
			    b += "</div>";
			    
			    var div=document.createElement("div");
			    div.Id=dialogId;
			    div.innerHTML=b;
			    document.body.appendChild(div);
			    
			    win=$("#"+dialogId).kendoWindow({
				        title: "Print Settings",
				        visible: false,
				        modal: true,
				        actions: ["Close"],
			  	  		close: function () {
				  	  				if(destroyDelayTime){
		 	  			 				var self=this;
			  			 		       	setTimeout(function() {
		  				 		       		self.destroy();
		  				 		       		}, destroyDelayTime);
				  	  				}else
				  	  					this.destroy();		
	  			 		  
	 								if(!buttonClicked)
			  			 				dfd.reject("cancel");
			  					},
		  				activate:function(){
		  					$("#"+okId).click(function(){onButtonClick(this)});
		  					$("#"+cancelId).click(function(){onButtonClick(this)});
		  				}
			      }).data("kendoWindow").center().open();
			}
			
			dfd= $q.defer();
			createDialog(settings);
			return dfd.promise;
		}
		
	}	
}]).

factory("Event",function(){

	var event=function(){
		this.listeners=[];
	};
	

	event.prototype={
		getListenerIdx:function(owner,handler){
				var idx=-1;
				if(owner && handler)
					for(var i=0,listener;i<this.listeners.length;i++){
						listener=this.listeners[i];
						if(listener.owner===owner && listener.handler===handler){
							idx=i;
							break;
						}
					}
				return idx;
		},
			
		addListener:function(owner,handler){
			if(owner && handler && this.getListenerIdx(owner,handler)==-1)
				this.listeners.push({
						owner:owner,
						handler:handler
					});
		},
		
		removeListener:function(owner,handler){
			var idx=this.getListenerIdx(owner,handler);
			if(idx>=0){
				this.listeners.splice(idx,1);
			}
		},
		
		fireEvent:function(args){
			for(var i=0,listener;i<this.listeners.length;i++){
				listener=this.listeners[i];
				listener.handler.apply(listener.owner,args);
			}
		}
	}
	
	return event;
}).

factory("DataDict",["$q","util",function($q,util){
	
	var DataDict=function(name,url,mode,data){
		if(name.name){
			this.name=name.name;
			this.url=name.url;
			this.loadMode=!!name.mode?name.mode:"lazy";		//lazy,onDemand,eager
			this.data=name.data;
		}else{
			this.name=name;
			this.url=url;
			this.loadMode=!!mode?mode:"lazy";		//lazy,onDemand,eager
			this.data=data;
		}
		this.items=[];
		this.isLoading=false;
		this.isLoaded=false;
		this.waitingDeferred=[];
		if(this.loadMode==="eager")
			this.load();
	}
	
	DataDict.prototype={
		createDefer:function(){
			return $q.defer();
		},
		
		clear:function(){
			this.isLoaded=false;
			this.items.splice(0,this.items.length);
			while(this.waitingDeferred.length>0){
				var deferred=this.waitingDeferred.pop();
				deferred.reject("error");
			}
			this.isLoading=false;
		},
		
		addItem:function(item){
			this.items.push(item);
		},
		
		waitForLoaded:function(deferred){
			this.waitingDeferred.unshift(deferred);
			if(this.waitingDeferred.length===1){
				var self=this;
				
				util.getRemote(this.url,this.data)
					.then(function(loaded){
						self.finishLoading(true,loaded);
					},function(error){
						self.finishLoading(false,error);
					});
			}
		},
		
		startLoading:function(deferred){
			this.isLoading=true;	
			this.isLoaded=false;
			this.items.splice(0,this.items.length);
			this.waitForLoaded(deferred);
		},
		
		finishLoading:function(succeed,response){
			this.isLoading=false;
			if(succeed){
				if(response){
					this.isLoaded=true;
					this.items=response;
				}else{
					this.isLoaded=false
				}
			}else{
				this.isLoaded=false;
			}
			while(this.waitingDeferred.length>0){
				var deferred=this.waitingDeferred.pop();
				if(this.isLoaded)
					deferred.resolve(this.items);
				else
					deferred.reject("error");
			}
		},
		
		load:function(){
			var deferred = $q.defer();
			
			if(this.isLoading){
				this.waitForLoaded(deferred);
			}else{
				this.startLoading(deferred);
			}
			return deferred.promise;
		},
		
		
		loadItem:function(name,value){
			var deferred = $q.defer();
			var	self=this;
			var	url=this.url+"getitem?name="+name+"&value="+value;
			
			util.getRemote(url)
				.then(function(gotItem){
					if(gotItem){
			    		self.addItem(gotItem);
					}
					deferred.resolve(gotItem);
			},function(error){
				deferred.reject(error);
			});
			
			return deferred.promise;
		},
		
		loadItems:function(name,strValues){
			var deferred = $q.defer();

			var self=this,
			url=this.url+"getitems?name="+name+"&value="+strValues;
		
			util.getRemote(url)
				.then(function(gotItems){
					if(gotItems){
						for(var i=0,item;i<gotItems.length;i++){
							item=gotItems[i];
				    		self.addItem(item);
						}
					}
					deferred.resolve(gotItems);
				},function(error){
					deferred.reject(error);
				});
			
			return deferred.promise;
		},
		
		
		
		//find the item in local item list only. 
		getLocalItem:function(name,value){
			return util.find(this.items,name,value);
		},
		
		getLocalItems:function(name,values){
			var valueList=values.split(",");
			var items=[]
			for(var i=0,item,value;i<valueList;i++){
				value=valueList[i];
				item=this.getLocalItem(name,value)
				if(item){
					items.push(item);
				}
			}
			return items;
		},
		
		//To get an arrry of {text:textFieldValue,value:valueFieldValue} for the named dict
		//textFieldValue comes from textFieldName and value comes from valueFieldName
		//used for kendo grid map column,
		//			name:"snpId",
		//		    field: "snpId",
		//		    title: "Item",
		//		    values:cliviaDDS.getMap("snp","id","name"),
		getMap:function(valueFieldName,textFieldName){
			var maps=[],items=this.items;
			
			for(var i=0,item,map;i<items.length;i++){
				item=items[i];
				map={value:item[valueFieldName],text:item[textFieldName]};
				maps.push(map);
			}
			return maps;
		},
		
		//Return a promise.If resolved,data is the none null item;otherwise rejected with error info
		//If item is not catched, load it
		getItem:function(name,value){
			var deferred = $q.defer();
			var foundItem=null,self=this;
			
			if(this.loadMode==="onDemand"){
				foundItem=this.getLocalItem(name,value);
				if(foundItem){
					deferred.resolve(foundItem);
				}else{
					this.loadItem(name,value)
						.then(function(foundItem){
							if(foundItem)	//succeed
								deferred.resolve(foundItem);
							else
								deferred.reject("error:can not find");
						},function(error){
							deferred.reject(error);
						});
				}
		}else{	//lazy or eager
			if(this.isLoaded){
				foundItem=this.getLocalItem(name,value);
				if(foundItem)
					deferred.resolve(foundItem);
				else
					deferred.reject(foundItem);
			}else{
				this.load()
					.then(function(loaded){
						var foundItem=self.getLocalItem(name,value);
						if(foundItem)
							deferred.resolve(item);
						else
							deferred.reject("error:can not find");
					},function(error){
						deferred.reject(error);
					});
			}
		}
			return deferred.promise;
		},
		
		getItems:function(name,values){
			var deferred = $q.defer();
			var	self=this;
			
			//get all items if name is not provided (call by getItems())
			if(!name){
				if(this.isLoaded){
					deferred.resolve(this.items);
				}else{
					this.load()
						.then(function(){
							deferred.resolve(self.items)
						},function(){
							deferred.reject("error");
						});
				}
			}else{

				var items=[];
				if(this.loadMode==="onDemand"){
					var valueList=values.split(",");
					var getValues=[];
					for(var i=0,item,value;i<valueList.length;i++){
						value=valueList[i];
						item=this.getLocalItem(name,value)
						if(item){
							items.push(item);
						}else{
							getValues.push(value);
						}
					}
				
					if(getValues.length>0){
						this.loadItems(name,getValues.join())
							.then(function(loadedItems){
								if(loadedItems){
									for(var i=0;i<loadedItems.length;i++){
										items.push(loadedItems[i]);
									}
									deferred.resolve(items)
								}else{
									deferred.reject("error");
								}
								
							},function(error){
								deferred.reject(error)
							});
					}else{
						deferred.resolve(items);
					}
					
				}else{
					if(this.isLoaded){
						items=this.getLocalItems(name,values);
						if(items.length>0){
							deferred.resolve(items);
						}else{
							deferred.reject("error");
						}
					}else{
						this.load()
							.then(function(){
								items=self.getLocalItems(name,values);
								if(items.length>0){
									deferred.resolve(items);
								}else{
									deferred.reject("error");
								}
							},function(){
								deferred.reject("error");
							});
					}
				}
			}
			
			return deferred.promise;
		}
			
	};
	
	return DataDict;
}]);


clivia.factory("DataDictSet",["DataDict","util", function(DataDict,util){
	var dds=function(dicts){
		this.dicts=[];
		this.addDicts(dicts);
	}
	
	dds.prototype={
			
		createDict:function(name,url,mode,data){
			return new DataDict(name,url,mode,data);		
		},
		
		//To get an arrry of {text:textFieldValue,value:valueFieldValue} for the named dict
		//textFieldValue comes from textFieldName and value comes from valueFieldName
		//used for kendo grid map column,
		//			name:"snpId",
		//		    field: "snpId",
		//		    title: "Item",
		//		    values:cliviaDDS.getMap("snp","id","name"),
		getMap:function(name,valueFieldName,textFieldName){
			return this.getDict(name).getMap(valueFieldName,textFieldName);
		},
		
		getDict:function(name){
			return util.find(this.dicts,"name",name);
		},

		
		getDicts:function(strNames){
			var result=[];
			var names=strNames.split(",");
			for(var i=0,dict;i<names.length;i++){
				dict=this.getDict(names[i].trim());
				if(dict)
					result.push[dict];
			}
			return result;
		},

		addDict:function(dict){
			if(dict) {
				this.dicts.push(dict);
			}
		},
		
		//dicts is a array of {name,url,mode}
		addDicts:function(dicts){
			if(dicts){
				for(var i=0,dict;i<dicts.length;i++){
					dict=this.createDict(dicts[i]);
					this.addDict(dict);
				}
			}
		},
		
		//load eager dict only
		load:function(){
			for(var i=0,dict;i<this.dicts.length;i++){
				dict=this.dicts[i];
				if(dict.loadMode==="eager")
					dict.load();
			}
		},
		
		refresh:function(){
			
		}
				
	};
	
	return dds;
}]);
//data dictionary set
clivia.factory("cliviaDDS",["DataDictSet",function(DataDictSet){
	var baseUrl="../";
	var dicts=[{
			name:"grid",
			url:baseUrl+"data/gridInfo/sql",
			mode:"eager",
			data:{orderby:"gridNo"},
		},{
			name:"column",
			url:baseUrl+"data/gridColumn/sql",
			mode:"eager",
			data:{orderby:"gridId,lineNo"},
		},{
			name:"snp",
			url:baseUrl+"data/dictSnp/sql",
			mode:"eager",
			data:{orderby:"lineNo"},
		},{
			name:"city",
			url:baseUrl+"dict/get?from=dictCity&textField=name&orderBy=name",
			mode:"eager"
		},{
			name:"province",
			url:baseUrl+"dict/get?from=dictProvince&textField=name&orderBy=name",
			mode:"eager"
		},{
			name:"customerInput",
			url:baseUrl+"data/companyInfo/",
			mode:"onDemand"
		},{
			name:"employeeInput",
			url:baseUrl+"data/employeeInfo/",  
			mode:"onDemand",
			
// 			url:baseUrl+"data/employeeInfo/get",
//			mode:"eager"
 		},{
			name:"garment",
			url:baseUrl+"data/generic/sql",
			data:{select:"id,brandId,seasonId,styleNo,styleName,colourway,sizeRange,rrp,wsp,rrpCad,wspCad,imageId",from:"garmentInfo",orderby:"seasonId,styleNo"},
			mode:"eager"
		},{
			name:"upc",
			url:baseUrl+"data/generic/sql",
			data:{select:"garmentId,colour,size,upcId",from:"garmentWithDetail",orderby:"garmentId,colour,size"},
			mode:"eager"
		},{
			name:"brand",
			url:baseUrl+"data/dictGarmentBrand/get",
			mode:"eager"
		},{
			name:"season",
			url:baseUrl+"data/dictGarmentSeason/get",
			mode:"eager"
		}];
	
	
	
	var cliviaDDS=new DataDictSet(dicts);
	
	var dictUpc=cliviaDDS.getDict("upc");
	dictUpc.fields=dictUpc.data.select.split(",");
	dictUpc.getUpcId=function(garmentId,colour,size){
		var items=this.items;
		var result;
		var idxGarmentId=0;
			idxColour=1;
			idxSize=2;
			idxUpcId=3;
		
		for(var i=0,item;i<items.length;i++){
			item=items[i];
			
			if(item[idxGarmentId]===garmentId && item[idxColour]===colour&&item[idxSize]===size){
				result=item[idxUpcId];
				break;
			}
		}
		return result;
	}
	
	var dictGarment=cliviaDDS.getDict("garment");
	dictGarment.fields=dictGarment.data.select.split(",");

	dictGarment.getGarment=function(seasonId,styleNo){
		var items=this.items;
		var result;
		var idxSeasonId=2;//this.fields.indexOf["seasonId"],
			idxStyleNo=3;//this.fields.indexOf["styleNo"];
		
		for(var i=0,item;i<items.length;i++){
			item=items[i];
			if(item[idxSeasonId]===seasonId && item[idxStyleNo]===styleNo){
				result={}
				for(var j=0;j<this.fields.length;j++)
				result[this.fields[j]]=item[j];
				break;
			}
		}
		return result;
	}

	dictGarment.getGarmentById=function(garmentId){
		var items=this.items;
		var result;
		var idxGarmentId=0
		
		for(var i=0,item;i<items.length;i++){
			item=items[i];
			if(item[idxGarmentId]===garmentId){
				result={}
				for(var j=0;j<this.fields.length;j++)
				result[this.fields[j]]=item[j];
				break;
			}
		}
		return result;
	}
	
	var dictBrand=cliviaDDS.getDict("brand");
	dictBrand.getBrandNameL=function(brandId){
		var item=this.getLocalItem("id",brandId);
		return item?item.name:"";
	}
	
	var dictSeason=cliviaDDS.getDict("season");
	dictSeason.getCurrentSeason=function(brandId){
		var items=this.items;
		var season=null;
		for(var i=0;i<items.length;i++){
			if(items[i].brandId===brandId && items[i].isCurrent){
				season=items[i];
				break;
			}
		}
		return season;
	}
	
	dictSeason.getCurrentSeasonId=function(brandId){
		var season=this.getCurrentSeason(brandId);
		return season?season.id:2;
	}
	
	return cliviaDDS
}]);

//dataSource set
clivia.factory("cliviaDSS",["cliviaDDS",function(cliviaDDS){
	var customerInput=new kendo.data.DataSource({
		 transport: {
 	        read: {
 	            url: '/miniataweb/dict/map?from=company&textField=businessName&valueField=id&orderBy=businessName',
 	            type: 'get',
 	            dataType: 'json',
  	            contentType: 'application/json'
 	        	}
			} 		
	});

	return{
		customerInput:customerInput,
	}	
}]);

clivia.factory("GridWrapper",function(){
			//constructor, need a kendoGrid's name
			var GridWrapper=function(gridName,gridColumns){
				this.gridName=gridName;
				this.grid=null;
				this.gridColumns=!!gridColumns?gridColumns:[];
				this.editingRowUid="";
				this.reorderRowEnabled=false;
				this.isEditing=true;
				this.enterKeyDown=false;
				this.enterMoveDown=false;
				this.hasDateColumnEditor=false;
				this.doubleClickEvent=null;
				this.currentRowUid="";
				this.recordLineNo=true;
				this.hasDirtyFlag=true;
			}
			
			GridWrapper.prototype.setConfig=function(config){
				if(config){
					if(typeof config.columns!=='undefined')
						this.gridColumns=config.columns;
				}
			}
			
			GridWrapper.prototype.setColumns=function(columns){
				this.gridColumns=columns;
			}
			
			GridWrapper.prototype.enableEnterMoveDown=function(){
				this.enterMoveDown=true;
			}
			
			GridWrapper.prototype.getGridColumn=function(fieldName){
				var columns=this.gridColumns;
				var result="";
				for(var i=0;i<columns.length;i++){
					if(columns[i].field===fieldName){
						result=columns[i];
						break;
					}
				}
				return result;
			}
			
			//call this method in kendoWidgetCreated event
			GridWrapper.prototype.wrapGrid=function(grid){
				this.grid=grid;					//$("#"+this.gridName).data("kendoGrid");
				var self=this;
				
				if(this.doubleClickEvent){
					this.grid.bind("dataBound",function(e){
						self.grid.tbody.find("tr").dblclick(self.doubleClickEvent);
					});
				}
				
				var showLineNumber=function(grid){
		   	   		 var pageSkip = (grid.dataSource.page() - 1) * grid.dataSource.pageSize();
	   	   		 
		   	   		 pageSkip=!pageSkip? 1:++pageSkip;
	   	   		 
	   	   		 	//index starts from 0
		   	   		 grid.tbody.find('td.gridLineNumber').text(function(index){
	   	   				return pageSkip+index;
	   	   				});	
				}
				
				//if name of the first column is "lineNumbershow, show lineNumber 
				if(this.gridColumns[0].name==="lineNumber"){
					this.grid.bind("dataBound",function(e){
						//e.sender is this.grid
			   	   		 showLineNumber(e.sender);
					});
				}
				//dataBound event triggered before wrapped
				showLineNumber(this.grid);
				
				//if this grid has dataPickerEditor column, convert value of date type to string
				if(this.hasDateColumnEditor){
					this.grid.bind('save',function(e){
						var gridColumns=self.gridColumns;
						for(var i=0,gridColumn;i<gridColumns.length;i++){
							gridColumn=gridColumns[i];
							if(gridColumn.editor===self.dateColumnEditor && e.values[gridColumn.field]){
								e.preventDefault();
								var format=gridColumn.format?gridColumn.format:'{0:yyyy-MM-dd}';
								format=format.slice(3,format.length-1); //remove {0:} from format
								e.values[gridColumn.field]=kendo.toString(e.values[gridColumn.field],format);
								e.model[gridColumn.field]=e.values[gridColumn.field];
								break;
							}
						}
					});
				}
				
				if(this.hasDirtyFlag){
					this.grid.bind('save',function(e){
						e.model.isDirty=true;	
					});
				}
				
				if(this.enterMoveDown){
					this.grid.tbody.bind('keydown', function (e) {
						if(self.enterMoveDown && e.keyCode === 13 ){
							self.enterKeyDown=true;
							console.log("keydown in wrapper:");
							// stop bubbling up of this event
					        e.stopPropagation();
						}
	                });
					this.grid.bind('save',function(e){
						
						if(self.enterMoveDown)
							if(self.enterKeyDown){
								self.enterKeyDown=false;
								console.log(self.gridName+" save in wrapper:");
								var row=self.getEditingRow();
								var cell=self.getEditingCell();
								if(row && cell){
							        var cellToEdit = $(row).next().find('td:eq('+cell.cellIndex+')');
				                    self.grid.editCell(cellToEdit);
								}
							}
						
					});
					
	            }			
			}
			
			GridWrapper.prototype.getDataItemIndexByRowIndex=function (rowIndex){
				if(!this.grid) return null;
				var row=this.getRow(rowIndex);
				var dataItem=this.getDataItemByRow(row);
				return this.getDataItemIndex(dataItem);
			}

			GridWrapper.prototype.getDataItemByRow=function (row){
				if(!this.grid) return null;
				return (!!row)?this.grid.dataItem(row):null;
			}
				
			GridWrapper.prototype.getDataItemByIndex=function (index){
				if(!this.grid) return null;
				var data=this.grid.dataSource.data();
				return (index>=0 && index<data.length)?data[index]:null;
			}
			GridWrapper.prototype.getDataItemIndex=function (dataItem){
				if(!this.grid) return null;
				var index = (!!dataItem)?this.grid.dataSource.indexOf(dataItem):null;
				console.log("dataItem index:"+index);
				return index;
			}
				
			GridWrapper.prototype.getCurrentDataItem=function (){
				var result=null;
				
				if(!this.grid) return result;
				var row=this.getCurrentRow();
				
				if(row){
					result=this.getDataItemByRow(row);
				}else{
					result=this.grid.dataItem(this.grid.select());
				}
				return result;
			}
				
			GridWrapper.prototype.getCurrentDataItemIndex=function (){
				if(!this.grid) return null;
				var dataItem= this.getCurrentDataItem();
				var idx = this.getDataItemIndex(dataItem);
				return idx;
			}

			GridWrapper.prototype.getRow = function(arg){
				if(!this.grid) return null;
				if(Number.isInteger(arg))
					return this.grid.tbody.children().eq(arg);
				else
					return  arg.closest("tr");
			}

			//index starts from 0
			GridWrapper.prototype.getRowIndex=function (row){
				if(!this.grid) return null;
				 var index=(!!row)?($("tr", this.grid.tbody).index(row)):null;
					console.log("getRowIndex:"+index);
				 return index;
			}
				
			GridWrapper.prototype.getEditingCell=function (){
				if(!this.grid) return null;
				var cells=$("td.k-edit-cell",this.grid.tbody.children()).first();
				return cells.length>0?cells[0]:null;
			}
			
			GridWrapper.prototype.getCurrentCell=function(){
				if(!this.grid) return null;
				
				var cell=this.grid.current();
				return cell?cell[0]:null;
			}
				
			GridWrapper.prototype.getEditingRow=function (){
				if(!this.grid) return null;
				var cell=this.getEditingCell();
				var row=(!!cell)?$(cell).closest("tr"):null;
				return row?row[0]:null; 
			}
			
			GridWrapper.prototype.getCurrentRow=function(){
				if(!this.grid) return null;
				var cell=this.getCurrentCell();
				var row=(!!cell)?$(cell).closest("tr"):null;

				return row?row[0]:null; 
			}
			
			GridWrapper.prototype.getCurrentRowIndex=function (){
				if(!this.grid) return null;
				var index=this.getRowIndex(this.getCurrentRow());
				return index;
			}

			//lineNo starts from 1
			GridWrapper.prototype.setLineNo=function (){
				if(!this.recordLineNo) return;
				var ds=this.grid.dataSource;
				var dataItems=ds.view();
				var skip = !!ds.skip()?ds.skip():0;
				for(var i=0,lineNo;i<dataItems.length;i++){
					lineNo=i+skip+1;
					if(dataItems[i].lineNo!==lineNo){
						dataItems[i].lineNo=lineNo;
						dataItems[i].isDirty=true;
					}
				}
			}
			
			GridWrapper.prototype.getRowCount=function (){
				var count=0;
				if(this.grid){
					var ds=this.grid.dataSource;
					var dataItems=ds.view();
					count=dataItems.length;
				}
				return count;
			}
				
			GridWrapper.prototype.addRow=function (dataItem,isInsert){
		        var dataSource =this.grid.dataSource;

		        if(!isInsert){ //append to last row
				    dataSource.add(dataItem);
				    this.setLineNo();
				    if(dataSource.totalPages()>1)		//without the line will casue problem when add row  
				    	dataSource.page(dataSource.totalPages());
			    	this.grid.editRow(this.grid.tbody.children().last());
			    }else{		//insert before current row
						var rowIdx =this.getCurrentRowIndex();
			    	var idx = this.getCurrentDataItemIndex();
				    dataSource.insert((!!idx)?idx:0,dataItem);
				    this.setLineNo();
			    	this.grid.editRow(this.getRow(rowIdx));
			    }
		        var cell=this.getEditingCell();
		        if(cell) this.grid.current(cell);
			}		
			
			GridWrapper.prototype.deleteRow=function (dataItem){
			    if (dataItem) {
		        	this.grid.dataSource.remove(dataItem);
		        	this.currentRow=-1;
		        	this.setLineNo();
		        	this.grid.table.focus();
			    }					
			}		
			
			GridWrapper.prototype.rowChanged=function(){
	       		var row=this.getCurrentRow();
	       		var	newRowUid=row?row.dataset["uid"]:"";
	       		var changed=false;
        		if((typeof newRowUid!=="undefined") && (this.currentRowUid!==newRowUid)){		//row changed
        			this.currentRowUid=newRowUid;
        			changed=true;
        		}
        		return changed;
			}
			
			GridWrapper.prototype.getColumnIndex=function(columnName){
				var columns=this.gridColumns;
				var index=-1;
				for(var i=0;i<columns.length;i++){
					if(columns[i].name===columnName){
						index=i;
						break;
					}
				}
				return index;
			}
			//used in grid save event, e is parameter of save(e); columnIndex is the index of column intend to update
			//The grid will not update templte column automatically when change data value in save event
			//column can be column index or name, used in billGrid,setpGrid,threadGrid,garmentInput grid... 
			GridWrapper.prototype.updateTemplateColumn=function(e,column){
				if(!Number.isInteger(column))
					column=this.getColumnIndex(column);
                var template = kendo.template(this.gridColumns[column].template),
            	cell = e.container.parent().children('td').eq(column);
                cell.html(template(e.model));		                    
			}

			
			GridWrapper.prototype.updateTemplateColumns=function(e){
				for(var i=0;i<this.gridColumns.length;i++){
					if(this.gridColumns[i].template)
						this.updateTemplateColumn(e,i);
				}
			}
			
			
			
			GridWrapper.prototype.copyPreviousRow=function(){
				var idx=this.getCurrentRowIndex();
				if(idx>0){
					dis=this.grid.dataSource.view();
					diFrom=dis[idx-1];
					diTo=dis[idx];
		 			for(var i=1;i<this.gridColumns.length;i++){
		 				var field=this.gridColumns[i].field;
		 				if(typeof diFrom[field] !=='undefined')
		     		 		diTo[field]=diFrom[field];
		 			}
				}
//		 		var dataItem=this.getCurrentDataItem();
//		  		var dataItemIndex=this.getCurrentDataItemIndex();
//		 		var copiedDataItem=this.getDataItemByIndex(dataItemIndex-1);
//		  		if(!!copiedDataItem){
//		  			for(var i=1;i<this.gridColumns.length;i++){
//		  				if(typeof copiedDataItem[this.gridColumns[i].field] !=='undefined')
//		      		 			dataItem[this.gridColumns[i].field]=copiedDataItem[this.gridColumns[i].field];
//		  			}
//		  		}
			}

			
			GridWrapper.prototype.getSortableOptions=function (){
				var self=this;		
				return 	{
					 filter: ".k-grid tr[data-uid]:not(.k-grid-edit-row)",			
		             hint: $.noop,
		             cursor: "move",
		             placeholder: function(element) {
		                 return element.clone().addClass("k-state-hover").css("opacity", 0.65);
		             },
		             container:"#"+this.gridName+ " tbody",
		             change: function(e) {
		             	 var ds=self.grid.dataSource,
		                 	 idx=self.getDataItemIndexByRowIndex(e.newIndex),
		                 	 di= ds.getByUid(e.item.data("uid"));
		                 ds.remove(di);
		                 ds.insert(idx, di);
		 				 self.setLineNo();
		                 ds.sync();
		                 
		                 if(typeof self.dragSorted!='undefined')
		                	 self.dragSorted();
		                }
		            };
			}
			
			
			GridWrapper.prototype.enableEditing=function(editing){
				this.isEditing=editing;
				this.grid.setOptions({
					editable:editing,
					selectable: editing?"cell":"row",
				});
			}
			
			//called from parenet resize event
			GridWrapper.prototype.resizeGrid=function(gridHeight){
			    var gridElement =this.grid.element;
			    if(gridElement){
			        var dataArea = gridElement.find(".k-grid-content"),
//			        gridHeight = gridElement.innerHeight()-37,
			        	otherElements = gridElement.children().not(".k-grid-content"),
			        	otherElementsHeight = 0;

			    	otherElements.each(function(){
				        otherElementsHeight += $(this).outerHeight();
					    });
			    	gridElement.innerHeight(gridHeight);
			   		dataArea.height(gridHeight - otherElementsHeight);
				}
			};	
			
		    
		    GridWrapper.prototype.numberColumnEditor=function(container, options) {
		        $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
		            .appendTo(container)
		            .kendoNumericTextBox({
		                spinners : false
		            });
		    };
		    
		    GridWrapper.prototype.dateColumnEditor=function (container, options) {
		        $('<input  class="grid-editor" data-type="text" data-bind="value:' + options.field  + '"/>')
	            .appendTo(container)
	            .kendoDatePicker({
	            	format:options.format
	            });
			}

		    GridWrapper.prototype.readOnlyColumnEditor=function(container, options) {
		         $("<span>" + options.model.get(options.field)+ "</span>").appendTo(container);
		     };
			
		    GridWrapper.prototype.kendoComboBoxEditor=function(container,options,items){
				if(items){
				    $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
				    	.appendTo(container)
				    	.kendoComboBox({
					        autoBind: true,
					        dataSource: {data:items}
				    		});
				}
			};

		    GridWrapper.prototype.kendoDropDownListEditor=function(container,options,items){
				if(items){
				    $('<input class="grid-editor" data-bind="value:' + options.field + '"/>')
				    	.appendTo(container)
				    	.kendoDropDownList({
					        autoBind: true,
					        dataSource: {data:items}
				    		});
				}
			};
			
			return GridWrapper;
			
}); /* end of GridWrapper */	

//GarmentGridWrapper inherited from GridWrapper
clivia.factory("GarmentGridWrapper",["GridWrapper","cliviaDDS","DataDict","$q",function(GridWrapper,cliviaDDS,DataDict,$q){

	 var thisGGW;
	 var getColumns=function(){
		 
		    var sizeRangeFields=thisGGW.season.sizeFields.split(",");
		    var sizeRangeTitles=thisGGW.season.sizeTitles.split(",");
			var sizeQtyWidth=40;
			var sizeQtyEditor=thisGGW.sizeQtyEditor;

			var sizeQtyAttr={style:"text-align:right;"};
			
			var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
			
				}, {			
					name:"garmentId",
				    field: "garmentId",
				    title: "Garment Id",
				    hidden:true,
				    width: 0
				}, {			
					name:"styleNo",
				    field: "styleNo",
				    title: "Style",
				    width: 70
				}, {
					name:"description",
				    field: "description",
				    title: "Name",
				    editor:thisGGW.brand.hasInventory?thisGGW.readOnlyColumnEditor:null,
				    width: 240
				}, {
					name:"colour",
				    field: "colour",
				    title: "Colour",
				    editor:thisGGW.brand.hasInventory?thisGGW.colourColumnEditor:null,
				    width: 150
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//extend last column if do not set its width 
			}];
			
			if(sizeRangeFields.length>0){		
				var j=5;
				for(var i=0;i<sizeRangeFields.length;i++){
					var field="qty"+("00"+i).slice(-2);
					gridColumns.splice(j++,0,{
						name:sizeRangeFields[i],
						field:field,
						title:sizeRangeTitles[i],
					    editor:sizeQtyEditor,
					    width: sizeQtyWidth,
					    attributes:sizeQtyAttr
					});			
				}
				gridColumns.splice(j,0,{
					name:"quantity",
				    field: "quantity",
				    title: "Total",
				    editor: thisGGW.readOnlyColumnEditor,
				    width: 80,
				    attributes:sizeQtyAttr
					});
			}else{
				gridColumns.splice(4,0,{
						name:"size",
					    field: "size",
					    title: "Size",
					    editor:thisGGW.sizeColumnEditor,
					    width: 80
					}, {
						name:"quantity",
					    field: "quantity",
					    title: "Quantity",
					    editor: thisGGW.numberColumnEditor,
					    width: 80,
					    attributes:{style:"text-align:right;"}
					})
			}
			
			return gridColumns;
		}
		
	 var GarmentGridWrapper=function(gridName){
		 
		GridWrapper.call(this,gridName);
		
		this.currentGarment=null;
		this.dict={colourway:[],sizeRange:[]};
		this.dictGarment=cliviaDDS.getDict("garment");
		this.total=0;
		
		thisGGW=this;
	}
	 
	GarmentGridWrapper.prototype=new GridWrapper();
	
	//must set before calling wrapegrid
	GarmentGridWrapper.prototype.setBrandSeason=function(brand,season){
		this.season=season;
		this.brand=brand;
		this.setColumns(getColumns());
	}

	
	GarmentGridWrapper.prototype.setRowDict=function(){
  		var colourway=[],sizeRange=[];
  		if(this.currentGarment){
			colourway=String(this.currentGarment.colourway).split(',');
			sizeRange=String(this.currentGarment.sizeRange).split(',');
			for(var i=0;i<colourway.length;i++)
				colourway[i]=colourway[i].trim();
			
			for(var i=0;i<sizeRange.length;i++)
				sizeRange[i]=sizeRange[i].trim();
  		}
  		this.dict.colourway=colourway;
  		this.dict.sizeRange=sizeRange;
	}
	
	GarmentGridWrapper.prototype.setCurrentGarment=function(model){
   	if (!model) return;
   	if(!model.styleNo) return;
   	
		var styleNo=model.styleNo;
		if(!styleNo){
			this.currentGarment=null;
			model.set("garmentId",null);
			this.setRowDict();
		}else{
			if(this.currentGarment && this.currentGarment.styleNo===styleNo){
		    	model.set("description",this.currentGarment.styleName);
		    	model.set("garmentId",this.currentGarment.id);
			}else{
				garment=this.dictGarment.getGarment(this.season.id,styleNo);
				if(garment){
					this.currentGarment=garment;
			    	model.set("description",thisGGW.currentGarment.styleName);
			    	model.set("garmentId",this.currentGarment.id);
					this.setRowDict();
				}
			}
		}
	}

	var getDictUpc=function(dictUpc){
    	var deferred = $q.defer();
		
		dictUpc.load()
			.then(function(loaded){
				deferred.resolve(loaded);
			},function(error){
				deferred.reject(error);
			});

		return deferred.promise;
    }

	var getUpcItem=function(dict,styleNo,colour,size){
    	var len=dict.items.length;
    	var result=null;
    	for(var i=0,item;i<len;i++){
    		item=dict.items[i];
    		if(styleNo===item.styleNo && colour===item.colour && size===item.size){
    			result=item;
    			break;
    		}
    	}
    	return result;
    }
    
	GarmentGridWrapper.prototype.parseFromLineItems=function(){
		
    	var deferred = $q.defer();
    	
    	var dictUpc=new DataDict("upc","","onDemand");
	   	var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:styleNo;s:s;s:";

    	var dataItems=thisGGW.grid.dataItems();

		var styleNos="";
		
		for(var i=0;i<dataItems.length;i++){
			if(styleNos.indexOf(dataItems[i].styleNo)<0)
				styleNos+=","+dataItems[i].styleNo;
		}
		
		dictUpc.url=dictUpcUrl+styleNos.substring(1);

		getDictUpc(dictUpc)
			.then(function(){
				var items=[];

				var noError=true;
				for(var r=0,di,item;r<dataItems.length;r++){
					di=dataItems[r];		//dataItem
					for(var i=0;i<thisGGW.season.sizeFields.length;i++){  //exclude colour,total,remark
						var field="qty"+("00"+i).slice(-2); 	//right(2)
						var quantity=parseInt(di[field]);
						if(quantity){
						    item={}; 
						    upcItem=getUpcItem(dictUpc,di.styleNo,di.colour,thisGGW.season.SizeFields[i])
						    if(upcItem){
						    	item.upcId=upcItem.upcId;
						    	item.rowNumber=r;
							    item.quantity=quantity;
							    item.remark=di.remark;
							    items.push(item);
						    }else{			//error can not find 
						    	noError=false;
						    	deferred.reject("error:failed to UPC item.");
						    	break;
						    }
						}
					}
				    if(!noError)
				    	break;
				}
				if(noError)
					deferred.resolve(items);
			},function(){
				deferred.reject("error:failed to get UPC")
			});
		return deferred.promise;
	}
	
	GarmentGridWrapper.prototype.parseToLineItems=function(items){
		
		if(!items) return;
		
    	var dictUpc=new DataDict("upc","","onDemand");
	   	var dictUpcUrl="../data/garmentWithDetail/call/findListIn?param=s:upcId;s:i;s:";

	   	var upcIds="";
	   	
		for(var i=0;i<items.length;i++){
			upcIds+=","+items[i].upcId;
		}
		
		dictUpc.url=dictUpcUrl+upcIds.substring(1);;
	   	
	   	getDictUpc(dictUpc)
			.then(function(){
					
					for (var i=0,rowNumber=-1,lineItem,item,index,field;i<items.length;i++){
						item=items[i];
						upcItem=dictUpc.getLocalItem("upcId",item.upcId);
						if(upcItem){
							if(rowNumber!==item.rowNumber){
								lineItem={
										styleNo:upcItem.styleNo,
										colour:upcItem.colour,
										description:upcItem.styleName,
										remark:item.remark
										};
								lineItem=thisGGW.grid.dataSource.add(lineItem);
								rowNumber=item.rowNumber;
							}
							index=thisGGW.season.sizeFields.indexOf(upcItem.size);
							field="qty"+("00"+index).slice(-2); 
							lineItem[field]=item.quantity;
						}else{		//error:can not find upc item
							
						}
					}
					thisGGW.calculateTotal();
			},function(){
				var error="error:failed to get UPC";
			});
	}
	
	GarmentGridWrapper.prototype.calculateLineTotal=function(dataItem) {
		var result=0;
		var sizeFields=this.season.sizeFields.split(",");
		for(var i=0;i<sizeFields.length;i++){  //exclude colour,total,remark
			var field="qty"+("00"+i).slice(-2); 	//right(2)
			var quantity=parseInt(dataItem[field]);
			if(quantity){
				result+=quantity;	
			}
		}
		return result;
	}
	
	
	GarmentGridWrapper.prototype.calculateTotal=function(calculate) {
		if(!this.grid) return;
		var dataItems=this.grid.dataItems();
		var total=0;
		for(var r=0,di,t;r<dataItems.length;r++){
			di=dataItems[r];		//dataItem
			if(calculate){					//(currentDataItem && di.uid===currentDataItem.uid){
				di.quantity=this.calculateLineTotal(di);
			}
			total+=di.quantity?di.quantity:0;
		}
		
		this.total=total;
		return total;
	}
	
	//in column editor function,"this" is the window.
	GarmentGridWrapper.prototype.colourColumnEditor=function(container, options) {
 		var items=thisGGW.dict.colourway;
 		thisGGW.kendoDropDownListEditor(container,options,items);
 	}

	GarmentGridWrapper.prototype.sizeColumnEditor=function(container, options) {
		var items=thisGGW.dict.sizeRange;
		thisGGW.kendoDropDownListEditor(container,options,items);
	}				    

	GarmentGridWrapper.prototype.sizeQtyEditor=function(container, options) {
		if(thisGGW.reorderRowEnabled) return;
		var column=thisGGW.getGridColumn(options.field);
		if(column)
			if(thisGGW.brand.hasInventory && thisGGW.dict.sizeRange.indexOf(column.name)<0)
		        $("<span>-</span>").appendTo(container);
			else
				thisGGW.numberColumnEditor(container,options);
		else
	        thisGGW.readOnlyEditor(container,options);
	}				    
	
	return GarmentGridWrapper;
}]); /* end of GarmentGridWrapper */

//BillGridWrapper inherited from GridWrapper
clivia.factory("BillGridWrapper",["GridWrapper","cliviaDDS","DataDict",function(GridWrapper,cliviaDDS,DataDict){
	
	 var thisGGW;

	 var getColumns=function(){

		 var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
				}, {			
					name:"snpId",
				    field: "snpId",
				    title: "Item",
				    values:thisGGW.dictSnp.getMap("id","name"),
				    width: 150
				}, {
					name:"itemNumber",
				    field: "itemNumber",
				    title: "Item Number",
				    width: 100,
				    attributes:{style:"text-align:center;"}
				}, {
					name:"description",
				    field: "description",
				    title: "Description",
				    width: 400
				}, {
					name:"orderQty",
				    field: "orderQty",
				    title: "Quantity",
				    width: 80,
				    attributes:{style:"text-align:right;"}
				}, {
					name:"unit",
				    field: "unit",
				    title: "Unit",
				    width: 60,
				    attributes:{style:"text-align:center;"}
				    
				}, {
					name:"listPrice",
				    field: "listPrice",
				    title: "List Price",
				    format: "{0:n2}",
				    width: 80,
				    attributes:{style:"text-align:right;"}
				}, {
					name:"discount",
					field:"discount",
					title:"% Off",
					format: "{0:p2}",					
				    editor: thisGGW.percentageColumnEditor,
				    width: 60,
				    attributes:{style:"text-align:right;"}
				}, {
					name:"orderPrice",
				    field: "orderPrice",
				    title: "Price",
				    format: "{0:n2}",
				    width: 80,
				    attributes:{style:"text-align:right;"}
				}, {
					name:"orderAmt",
				    title: "Amount",
				    template: '#=kendo.format("{0:c}", orderAmt)#',
				    width: 80,
				    attributes:{style:"text-align:right;"}
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//the column is extended if its width is not set   
			}];
			
			return gridColumns;
		}
		
	 var BillGridWrapper=function(gridName){
		 
		GridWrapper.call(this,gridName);

		thisGGW=this;
		this.dictSnp=cliviaDDS.getDict("snp");
		this.total=0;
		this.setColumns=function(){this.gridColumns=getColumns()};		
	}
	 
	BillGridWrapper.prototype=new GridWrapper();
	
	BillGridWrapper.prototype.percentageColumnEditor=function(container, options) {
		if(thisGGW.reorderRowEnabled) return;
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>')
	    	.appendTo(container)
	    	.kendoNumericTextBox({
				min: 0,
             	max: 1,
	            step: 0.01,
	            decimals:2
	    	})
	}					
	
/* 	BillGridWrapper.prototype.snpColumnEditor=function(container, options) {
			//if(thisGGW.reorderRowEnabled) return;
		    $('<input class="grid-editor" data-value-primitive="true"  data-bind="value:' + options.field + '"/>')
		    	.appendTo(container)
		    	.kendoDropDownList({
			        dataSource: { data:cliviaDDS.getDict("snp").items},
		            dataTextField:"text",
		            dataValueField:"value"
		    })
		}				     
 */	 
	BillGridWrapper.prototype.calculateTotal=function(calculate) {
		if(!this.grid) return;
		var dataItems=this.grid.dataItems();
		var total=0;
		for(var i=0,di,amt;i<dataItems.length;i++){
			di=dataItems[i];
			
			if(calculate){
				di.orderAmt=(di.orderQty?di.orderQty:0)*(di.orderPrice?di.orderPrice:0);
			}
	 		
			total+=di.orderAmt?di.orderAmt:0;
		}
		
		this.total=total;
		return total;
	}
 
	BillGridWrapper.prototype.setDiscount=function(discount){
		if(!this.grid) return;
		var dataItems=this.grid.dataItems();

		for(var i=0,di,p;i<dataItems.length;i++){
			di=dataItems[i];
			di.discount=discount;
			p=(discount>0 && discount<1)?di.listPrice*(1-discount):di.listPrice;
			di.orderPrice=p.toFixed(2);
			di.isDirty=true;
		}
		
		this.calculateTotal(true);
	}
	
	 BillGridWrapper.prototype.getSnpItem=function(snpId){
		 return thisGGW.dictSnp.getLocalItem("id",snpId);
	 }


	return BillGridWrapper;
	
}]); /* end of BillGridWrapper */


clivia.factory("ImageGridWrapper",["GridWrapper","cliviaDDS","DataDict",function(GridWrapper,cliviaDDS,DataDict){
	
	 var thisGGW;

	 var getColumns=function(){

		 var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
				}, {			
					name:"imageId",
				    title: "image",
				    template:'<img ng-src="data:image/JPEG;base64,{{getImage(#:imageId#).thumbnail}}" alt="{{#:imageId#}} image">',
				    width: 150
				}, {
					name:"originalFileName",
				    field: "originalFileName",
				    title: "File Name",
				    width: 120
				}, {
					name:"description",
				    field: "description",
				    title: "Description",
				    width: 250
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//the column is extended if its width is not set   
			}];
			
			return gridColumns;
		}
		
	 var ImageGridWrapper=function(gridName){
		 
		GridWrapper.call(this,gridName);
		thisGGW=this;
		this.setColumns=function(){this.gridColumns=getColumns()};		
	}
	 
	ImageGridWrapper.prototype=new GridWrapper();
	
	return ImageGridWrapper;
	
}]); /* end of ImageGridWrapper */

//used in order and company
clivia.factory("ContactGridWrapper",["GridWrapper","cliviaDDS",function(GridWrapper,cliviaDDS){
	
	var thisGW;

	var getColumns=function(){
		return [{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "title",
		         field: "title",
		         title: "Title",
		         editor:thisGW.titleColumnEditor,
		         width: 60
		     }, {
		         name: "firstName",
		         field: "firstName",
		         title: "First Name",
		         width: 80,
		     }, {
		         name: "lastName",
		         field: "lastName",
		         title: "Last Name",
		         width: 80,
		     }, {
		         name: "position",
		         field: "position",
		         title: "Position",
		         editor:thisGW.positionColumnEditor,
		         width: 80,
		     }, {
		         name: "phone",
		         field: "phone",
		         title: "Phone",
		         width: 120,
		     }, {
		         name: "email",
		         field: "email",
		         title: "Email",
		         width:150,
		     }, {
		         name: "isBuyer",
		         field: "isBuyer",
		         title: "Is Buyer",
		         template: '<input type="checkbox" #= isBuyer ? checked="checked" : "" # disabled="disabled" />',
		         width: 65,
		     }, {
		         name: "isActive",
		         field: "isActive",
		         title: "Active",
		         template: '<input type="checkbox" #= isActive ? checked="checked" : "" # disabled="disabled" />',
		         width: 65,
		     }, {
		    	 name:"remark",
		         field: "remark",
		         title: "Remark",
		}];
	}
	
	var gw=function(gridName){
		
		GridWrapper.call(this,gridName);
		thisGW=this;
	}
	
	gw.prototype=new GridWrapper();	//implement inheritance
	
	gw.prototype.setColumns=function(){
	 	this.gridColumns=getColumns();
	}
	
	gw.prototype.titleColumnEditor=function(container, options) {
		var items=['Mr.','Mrs.','Ms.','Miss'];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	gw.prototype.positionColumnEditor=function(container, options) {
		var items=['Owner','Buyer','Accountant'];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	return gw;
}]); //end of ContactGridWrapper

//used in order and company
clivia.factory("AddressGridWrapper",["GridWrapper","cliviaDDS",function(GridWrapper,cliviaDDS){

	var thisGW;
	
	var dictProvince=cliviaDDS.getDict('province');
	var dictCity=cliviaDDS.getDict('city');

	var getColumns=function(){

		return [{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "receiver",
		         field: "receiver",
		         title: "Receiver",
		         width: 200
			}, {
		         name: "addr1",
		         field: "addr1",
		         title: "Addr. Line 1",
		         width: 200
			}, {
		         name: "addr2",
		         field: "addr2",
		         title: "Addr. Line 2",
		         width: 120
		     }, {
		         name: "country",
		         field: "country",
		         title: "Country",
		         editor:thisGW.countryColumnEditor,
		         width: 80,
		     }, {
		         name: "province",
		         field: "province",
		         title: "Province",
		         editor: thisGW.provinceColumnEditor,
		         width: 75,
		     }, {
		         name: "city",
		         field: "city",
		         title: "City",
		         editor: thisGW.cityColumnEditor,
		         width: 90,
		     }, {
		         name: "postalCode",
		         field: "postalCode",
		         title: "Postal Code",
		         width: 80,

		     }, {
		         name: "attn",
		         field: "attn",
		         title: "Attn.",
		         width: 60,
		     }, {
		         name: "billing",
		         field: "billing",
		         title: "Billing",
		         template: '<input type="checkbox" #= billing ? checked="checked" : "" # disabled="disabled" />',
		         width: 50,
		     }, {
		         name: "shipping",
		         field: "shipping",
		         title: "Shipping",
		         template:'<input type="checkbox" #= shipping ? checked="checked" : "" # disabled="disabled" />',
		         width:65,
		     }, {
		    	 name:"remark",
		         field: "remark",
		         title: "Remark",
		}];
	}
	
	var gw=function(gridName){
		GridWrapper.call(this,gridName);
		thisGW=this;
	}
	
	gw.prototype=new GridWrapper();	//implement inheritance

	gw.prototype.setColumns=function(){
	 	this.gridColumns=getColumns();
	}
	
	gw.prototype.countryColumnEditor=function(container, options) {
		var items=['Canada','USA'];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	gw.prototype.provinceColumnEditor=function(container, options) {
		var items=dictProvince.items;
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	gw.prototype.cityColumnEditor=function(container, options) {
		var items= dictCity.items;
		thisGW.kendoComboBoxEditor(container, options,items);
	}

	return gw;
}]); //end of AddressGridWrapper


//used in company
clivia.factory("JournalGridWrapper",["GridWrapper","cliviaDDS",function(GridWrapper,cliviaDDS){

	var thisGW;
	
	var getColumns=function(){

		return [{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "event",
		         field: "event",
		         title: "Event",
		         editor: thisGW.actionColumnEditor,
		         width: 90
		     }, {
		         name: "date",
		         field: "date",
		         title: "Date",
		         format:"{0:yyyy-MM-dd}",
		         width: 100,
		         editor: thisGW.dateColumnEditor,
		     }, {
		         name: "postedBy",
		         field: "postedBy",
		         title: "Posted By",
		         editor: thisGW.personColumnEditor,
		         width: 75,
		     }, {
		         name: "content",
		         field: "content",
		         title: "Content",
		}];
	}
	
	var gw=function(gridName){
		
		GridWrapper.call(this,gridName);
	 	this.hasDateColumnEditor=true;
		thisGW=this;
	}
	
	gw.prototype=new GridWrapper();	//implement inheritance

	gw.prototype.setColumns=function(){
	 	this.gridColumns=getColumns();
	}	

	gw.prototype.actionColumnEditor=function(container, options) {
		var items=['Call','Letter','Visit','Email'];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	gw.prototype.personColumnEditor=function(container, options) {
		var items=[];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	
	return gw;
}]); //end of JournalGridWrapper

clivia.factory("ColumnGridWrapper",["GridWrapper","cliviaDDS",function(GridWrapper,cliviaDDS){

	var thisGW;
	
	var getColumns=function(){

		return [{
		        name:"lineNumber",
		        title: "#",
		        attributes:{class:"gridLineNumber"},
		        headerAttributes:{class:"gridLineNumberHeader"},
		        width: 25,
			}, {
		         name: "name",
		         field: "name",
		         title: "Name",
		         width: 120
		     }, {
		         name: "title",
		         field: "title",
		         title: "Title",
		         width: 120,
		     }, {
		         name: "width",
		         field: "width",
		         title: "Width",
		         width: 60,
		         attributes:{style:"text-align:right;"},
			}, {
		         name: "template",
		         field: "template",
		         title: "Template",
		         width: 120
		     }, {
		         name: "dataType",
		         field: "dataType",
		         title: "Data Type",
		         editor:thisGW.dataTypeEditor,
		         width: 90,
		     }, {
		         name: "textAlignFixed",
		         field: "textAlignFixed",
		         title: "Header Align.",
		         editor:thisGW.textAlignmentEditor,
		         width: 90,
		     }, {
		         name: "textAlign",
		         field: "textAlign",
		         title: "Text Align.",
		         editor:thisGW.textAlignmentEditor,
		         width: 80,
		     }, {
		         name: "displayFormat",
		         field: "displayFormat",
		         title: "Format",
		         width: 75,
		     }, {
		         name: "filterable",
		         field: "filterable",
		         title: "Filterable",
		         width: 75,		     
		     }, {
		         name: "sortable",
		         field: "sortable",
		         title: "Sortable",
		         template:'<input type="checkbox" #= sortable ? checked="checked" : "" # disabled="disabled" />',
		         width: 75,
		     }, {
		         name: "choosable",
		         field: "choosable",
		         title: "Choosable",
		         template:'<input type="checkbox" #= choosable ? checked="checked" : "" # disabled="disabled" />',
		         width: 75,
		     }, {
		         name: "lockable",
		         field: "lockable",
		         title: "Lockable",
		         template:'<input type="checkbox" #= lockable ? checked="checked" : "" # disabled="disabled" />',
		         width: 75,
		     }, {
		         name: "locked",
		         field: "locked",
		         title: "Locked",
		         template:'<input type="checkbox" #= locked ? checked="checked" : "" # disabled="disabled" />',
		         width: 75,
		     }, {
		         name: "hidden",
		         field: "hidden",
		         title: "Hidden",
		         template:'<input type="checkbox" #= hidden ? checked="checked" : "" # disabled="disabled" />',
		         width: 75,
		     }, {
		         name: "remark",
		         field: "remark",
		         title: "Remark",
		}];
	}
	
	var gw=function(gridName){
		
		GridWrapper.call(this,gridName);
		thisGW=this;
	}
	
	gw.prototype=new GridWrapper();	//implement inheritance

	gw.prototype.setColumns=function(){
	 	this.gridColumns=getColumns();
	}	
	
	gw.prototype.textAlignmentEditor=function(container, options) {
 		var items=["left","center","right",""];
 		thisGW.kendoDropDownListEditor(container,options,items);
 	}

	gw.prototype.dataTypeEditor=function(container, options) {
 		var items=["string","number","date",""];
 		thisGW.kendoDropDownListEditor(container,options,items);
 	}
	return gw;
}]); //end of JournalGridWrapper



clivia.factory("DesignGridWrapper",["GridWrapper","cliviaDDS","DataDict",function(GridWrapper,cliviaDDS,DataDict){
	
	 var thisGGW;

	 var getColumns=function(){

		 var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
				}, {			
					name:"thumbnail",
				    title: "Thumbnail",
 				  //  template:'<img src="data:image/JPEG;base64,#:thumbnail#" alt="image #:id#" style="background-color:#:backgroundColour#;">', 
				    width: 150
				}, {
					name:"designNumber",
				    field: "designNumber",
				    title: "Design#",
				    width: 120
				}, {
					name:"designName",
				    field: "designName",
				    title: "Design Name",
				    width: 200
				}, {
					name:"stitchCount",
				    field: "stitchCount",
				    title: "Stitches",
				    width: 80
				}, {
					name:"colourCount",
				    field: "colourCount",
				    title: "Colours",
				    width: 80
				}, {
					name:"threads",
				    field: "threads",
				    title: "Threads",
				    width: 200
				}, {
					name:"runningSteps",
				    field: "runningSteps",
				    title: "Running Steps",
				    width: 200
				    
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//the column is extended if its width is not set   
			}];
			
			return gridColumns;
		}
		
	 var gw=function(gridName){
		 
		GridWrapper.call(this,gridName);
		thisGGW=this;
		this.setColumns=function(){this.gridColumns=getColumns()};		
	}
	 
	gw.prototype=new GridWrapper();
	
	return gw;
	
}]); /* end of ColourGridWrapper */


clivia.factory("ColourwayGridWrapper",["GridWrapper","cliviaDDS","DataDict",function(GridWrapper,cliviaDDS,DataDict){
	
	 var thisGGW;

	 var getColumns=function(){

		 var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
				}, {			
					name:"thumbnail",
				    title: "Thumbnail",
 				    template:'<img src="data:image/JPEG;base64,#:thumbnail#" alt="image #:id#" style="background-color:#:backgroundColour#;">', 
				    width: 150
				}, {
					name:"threads",
				    field: "threads",
				    title: "Threads",
			        attributes: {style:"white-space:normal;"},
				    width: 120
				}, {
					name:"runningSteps",
				    field: "runningSteps",
				    title: "Running Steps",
			        attributes: {style:"white-space:normal;"},
				    width: 120
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//the column is extended if its width is not set   
			}];
			
			return gridColumns;
		}
		
	 var gw=function(gridName){
		 
		GridWrapper.call(this,gridName);
		thisGGW=this;
		this.setColumns=function(){this.gridColumns=getColumns()};		
	}
	 
	gw.prototype=new GridWrapper();
	
	return gw;
	
}]); /* end of ColourGridWrapper */

clivia.factory("EmbServiceGridWrapper",["GridWrapper","cliviaDDS","DataDict",function(GridWrapper,cliviaDDS,DataDict){
	
	 var thisGW;

	 var getColumns=function(){

		 var gridColumns=[{
			        name:"lineNumber",
			        title: "#",
			        //locked: true, if true will cause the wrong cell get focus when add new row
			        attributes:{class:"gridLineNumber"},
			        headerAttributes:{class:"gridLineNumberHeader"},
			        width: 25,
				}, {			
					name:"location",
				    field: "location",
				    title: "Location",
				    editor: thisGW.locationEditor,
				    width: 120
				}, {
					name:"designNo",
				    field: "designNo",
				    title: "Design#",
				    width: 120
				}, {
					name:"designName",
				    field: "designName",
				    title: "Design Name",
				    width: 150
				}, {
					name:"stitchCount",
				    field: "stitchCount",
				    title: "Stitches",
				    width: 90
				}, {
					name:"colourCount",
				    field: "colourCount",
				    title: "Colours",
				    width: 150
				}, {
					name:"threads",
				    field: "threads",
				    title: "Threads",
			        attributes: {style:"white-space:normal;"},
				    width: 150
				}, {
					name:"runningSteps",
				    field: "runningSteps",
				    title: "Running Steps",
			        attributes: {style:"white-space:normal;"},
				    width: 200
				}, {
					name:"remark",
				    field: "remark",
				    title: "Remark"
					//the column is extended if its width is not set   
			}];
			
			return gridColumns;
		}
		
	 var gw=function(gridName){
		 
		GridWrapper.call(this,gridName);
		thisGW=this;
		this.setColumns=function(){this.gridColumns=getColumns()};		
	}
	 
	gw.prototype=new GridWrapper();
	
	gw.prototype.locationEditor=function(container, options) {
		var items=['Cap Back','Cap Front','Center','Full Back','L./Chest','L./Sleeve','L.Collar'];
		thisGW.kendoComboBoxEditor(container, options,items);
	}
	return gw;
	
}]); /* end of ColourGridWrapper */

//service
clivia.factory("cliviaGridWrapperFactory",["ContactGridWrapper","AddressGridWrapper","JournalGridWrapper","ColumnGridWrapper","ColourwayGridWrapper","EmbServiceGridWrapper",
              function(ContactGridWrapper,AddressGridWrapper,JournalGridWrapper,ColumnGridWrapper,ColourwayGridWrapper,EmbServiceGridWrapper){
	return {
		getGridWrapper:function(wrapperName,gridName,callFrom){
			var gw=null;			
			switch(wrapperName){
			case "ContactGridWrapper":
				gw=new ContactGridWrapper(gridName);
				gw.setColumns();
				if(callFrom==="order"){
					gw.gridColumns.splice(8,1);//remove isActive column from grid
				}
				break;
			case "AddressGridWrapper":
				gw=new AddressGridWrapper(gridName);
				gw.setColumns();
				break;
			case "JournalGridWrapper":
				gw=new JournalGridWrapper(gridName);
				gw.setColumns();
				break;
				//column grid wrapper is used in grid management
			case "ColumnGridWrapper":
				gw=new ColumnGridWrapper(gridName);
				gw.setColumns();
				break;
			case "DesignGridWrapper":
				gw=new ColourwayGridWrapper(gridName);
				gw.setColumns();
				break;
			case "ColourwayGridWrapper":
				gw=new ColourwayGridWrapper(gridName);
				gw.setColumns();
				break;
			case "EmbServiceGridWrapper":
				gw=new EmbServiceGridWrapper(gridName);
				gw.setColumns();
				break;
			}
			
				
			return gw;
		}
	}
}]);

//seems not being used
/* clivia.factory("gridColumnFactory",["cliviaDDS","utils",function(cliviaDDS,util){
	var dictGrid=cliviaDDS.getDict("grid");
	var dictColumns=cliviaDDS.getDict("columns");
	var factory={
			getColumns:function(gridNo){
				var columns=[],dictColumns=dictColumn.items,column,item;
				var grid=dictGrid.getLocalItem("gridNo",gridNo);
				var idx=util.findIndex(dictColumns,"gridId",grid.id);
				var column;
				while( dictColumns[idx]===grid.id){
					item=dictColumns[idx++];					
					column={
						name:item.name,
						field:item.name,
						title:item.title,
					}
					columns.push(column);
				}
				return columns;
			}
	}
}]); */
</script>