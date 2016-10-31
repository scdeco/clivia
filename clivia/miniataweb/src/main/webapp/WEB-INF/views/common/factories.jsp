<script>
'user strict';

clivia=angular.module("clivia",["kendo.directives" ]);

clivia.factory("util",["$http","$q",function($http,$q){
	var tmpId=1000;
	return {
		
		getTmpId:function(){
			return tmpId++;
		},
		
		createIndexOnId:function(dis,idName){
			if(!idName) idName="id";
			var result={};
			for(var i=0,di;i<dis.length;i++){
				di=dis[i];
				result[String(di[idName])]=di;
			}
			return result;
		},
		
		createIndexOnKey:function(dis,key){
			var result={};
			for(var i=0,di;i<dis.length;i++){
				di=dis[i];
				if(!!di[key]){
					result[di[key]]=di;
				}
			}
			return result;
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
		
		duplicateObject:function(o){
			var newO={};
			for(var p in o)
			    if(o.hasOwnProperty(p))
			        newO[p]=o[p];
			return newO;
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
		},
		
		createAddress:function(companyInfo,orderAddresses,companyAddresses,isBilling,isText){
	 		var address,a;
	 		var addresses=orderAddresses;
	 		for(var i=0,f;i<addresses.length;i++){
	 			a=addresses[i];
	 			f=isBilling?a.billing:a.shipping;
	 			if(f){
	 				address=a;
	 				break;
	 			}
	 		}
	 		
	 		if(!address){
		 		addresses=companyAddresses;
		 		for(var i=0,f;i<addresses.length;i++){
		 			a=addresses[i];
		 			f=isBilling?a.billing:a.shipping;
		 			if(f){
		 				address=a;
		 				break;
		 			}
		 		}
	 		}
	 		
	 		if(address){
				address={
					receiver:address.receiver,
					addr1:address.addr1,
					addr2:address.addr2,
					city:address.city,
					province:address.province,
					country:address.country,
					postalCode:address.postalCode,
					attn:address.attn,
				};
	 		}else{
				address={
						receiver:"",
						addr1:"",
						addr2:"",
						city:"",
						province:"",
						country:"",
						postalCode:"",
						attn:"",
					};
	 		}
	 		if(!address.receiver){
	 			address.receiver="";
	 			if(isBilling||(a.billing && a.shipping))	
	 	 			address.receiver=companyInfo.businessName;
	 		}
	 		
	 		if(isText){
	 			a=address;
	 			address="";
	 			if(a.receiver)
	 				address+=a.receiver+"\n";
	 			if(a.addr1)
	 				address+=a.addr1+"\n";
	 			if(a.addr2)
	 				address+=a.addr2+"\n";
	 			if(a.city)
	 				address+=a.city+", ";
	 			if(a.province)
	 				address+=a.province+" ";
	 			if(a.postalCode)
	 				address+=a.postalCode+"\n";
	 			if(a.country)
	 				address+=a.country+"\n";
	 			if(a.attn)
	 				address+=a.attn;
	 				
	 		}
	 		
			return address;
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


</script>