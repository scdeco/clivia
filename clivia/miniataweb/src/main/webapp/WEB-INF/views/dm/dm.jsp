<!DOCTYPE html>
<html>
<head>
	<title>test</title>
	<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
	<shared:header/> 
	
	<%@include file="embdesign.jsp"%>
	<%@include file="../common/factories.jsp"%>
	<%@include file="../common/directives.jsp"%>
</head>
<body ng-app="embDesignApp" spellcheck="false">
	<div ng-controller="dmCtrl">
	   	<div kendo-toolbar id="dstToolbar" k-options="dstToolbarOptions"></div>
     	<div 	kendo-splitter="dmSplitter"  
      			k-orientation="'horizontal'" 
				k-panes="[{ collapsible: true, resizable: true,size:'700px'}
						 ,{ collapsible: true,resizable: true}]"
	   	 		style="height:800px;">
		    	 
		   	<div>
		   		<div kendo-grid="colourwayGrid" k-options="colourwayGridOptions">	</div>
		   	</div>
		   	
		   	<div>
				<div dst-paint="myDstPaint"></div>
			</div>
			
		</div>      		   	

		<div kendo-window="newUploadWindow" k-title="'Upload DST'"
		           k-width="600" k-height="500" k-visible="false" k-options="newUploadWindowOptions">
		           
		    <form name="infoForm" ng-submit="" novalidate class="simple-form" >
				<ul id="fieldlist">
		    		<li>
					    <label>Design Number:</label>
					    <input type="text"  name="designNumber" class="k-textbox" style="width:100px;"   ng-model="newUploadData.designNumber"/> 
					</li>
		    		<li>
					    <label>Design Name:</label>
					    <input type="text"  name="designName" class="k-textbox" style="width:100%;"   ng-model="newUploadData.description"/> 
					</li>
		    		<li>
					    <label>Customer:</label>
					    <map-combobox   style="width:300px;" c-options="newUploadCompanyOptions" ng-model="newUploadData.companyId"/>
				     </li>
		    		<li>
					    <label>Remark:</label>
					    <textarea  class="k-textbox" style="width:100%;height:100px;"  ng-model="newUploadData.remark"> </textarea>
					</li>
		    		<li>
					    <label>Stitches:</label>
					</li>
		    		<li>
					    <label>Steps:</label>
					</li>
		    		<li>
					    <label>Size:</label>
					</li>
				 </ul>
		    </form>
		    
			<input kendo-upload  name="file"  type="file" k-options="newUploadOptions" />
		</div>			

		<div kendo-window="queryWindow"			
				k-width="1000"
			 	k-height="680"
			 	k-position="{top: 45, left: 320 }"	
			 	k-resizable="true"
				k-draggable="true"
			 	k-title="'List'"
			 	k-visible="false" 
			 	k-actions="['Minimiz','Maximize','Close']"
			 	k-pinned="true"
			 	k-modal="false">
		
 			<div  query-grid="queryGrid"  c-grid-no="'401'" c-options="queryGridOptions"></div> 
		</div>
			
<pre>
<!-- printModel={{myDstPaint.printModel|json}} -->
 
 	dataSet:{{dataSet|json}} 
</pre>
 

	</div>
</body>
<script>
var designApp = angular.module("embDesignApp",
		["kendo.directives","embdesign"]);
		
designApp.controller("dmCtrl",
		["$scope","$http","ColourwayGridWrapper",function($scope,$http,ColourwayGridWrapper){

			$scope.dataSet={
					info:{},
					colourways:new kendo.data.ObservableArray([]), 
					samples:new kendo.data.ObservableArray([]), 
					deleteds:[]
				};
			
			
			var imgUrl="../resources/images/";

			var searchTemplate='<kendo-combobox name="searchDesignNumber" k-placeholder="\'Search Design#\'" ng-model="searchDesignNumber"  k-options="searchDesignNumberOptions" style="width: 140px;" />';
			
			$scope.dstToolbarOptions={items: [{
					template: "<span><label>Design:</label></span>",
				},{
			        type: "button",
			        text: "New",
			        id:"btnNew",
			        click: function(e) {
			        	$scope.clear();
			        	//$scope.myDstPaint.setDstDesign(--id)
			       		 }
			    }, {
			        type: "button",
			        text: "Open",
			        id:"btnOpen",
			        click: function(e) {
			        	$scope.newUploadWindow.open();
				        }
	            }, {	
	                template:searchTemplate,		                
	            }, {
	                type: "button",
	                text: "Find",
	                imageUrl:imgUrl+"i-find.ico",
	                id:"btnFind",
	                click: function(e) {
	                	$scope.openQueryWindow();
	                }	                
	            }, {
	                type: "separator",
			    }, {	
					template: "<span><label>Colourway:</label></span>",
			    }, {	
			    	
			        type: "button",
			        text: "Add",
			        id: "btnAddColourway",
			        click: function(e){
			        	$scope.addColourway();
			        	}  
			    }, {	
			        type: "button",
			        text: "Update",
			        id: "btnUpdateColourway",
			        click: function(e){
			        	$scope.updateColourway();
			        	}  
			    }, {	
			        type: "button",
			        text: "Remove",
			        id: "btnRemoveColourway",
			        click: function(e){
			        	$scope.removeColourway();
			        	}  
			    }, {	
			        type: "button",
			        text: "New",
			        id: "btnNewColourway",
			        click: function(e){
			        	$scope.newColourway();
			        	}  
			    }, {	
			        type: "button",
			        text: "Normalize",
			        id: "btnNormalizeColourway",
			        click: function(e){
			        	$scope.normalizeColourway();
			        	}  
			    }, {
			        type: "separator",
			    }, {	
			        type: "button",
			        text: "Save",
			        id: "btnSave",
			        click: function(e){
			        	$scope.saveDesign();
			        	}  
			    }, {
			        type: "button",
			        text: "Print",
			        id: "btnPrint",
			        click: function(e){
			        	$scope.myDstPaint.print();
			        	}  
  	            }, {
	                type: "separator",
 	            }, {
 	            	template:'Choose Theme:<theme-chooser></theme-chooser>'
			}]};
			
			
		    $scope.searchDesignNumberOptions={
		        	dataSource:{data:[]},	//recent orders
		        	//Fired when the value of the widget is changed by the user
		        	change:function(e){
		        		$scope.getDesign();
		        	}
		        }
		    
			$scope.newUploadWindowOptions={
					open:function(e){
//						$scope.imageItemToolbar.enable("#btnAdd",false);				
					},
					close:function(e){
//						$scope.imageItemToolbar.enable("#btnAdd");				
					}
			}
			 
		    $scope.newUploadData={
		    		designNumber:"",
		    		description:"",
		    		companyId:"",
		    		remark:"",
		    }
		    
		    $scope.newUploadCompanyOptions={
		    				name:"companyComboBox",
		    				dataTextField:"businessName",
		    				dataValueField:"id",
		    				minLength:1,
		    				url:'../datasource/companyInfoDao/read',
		    			}
		    
			$scope.newUploadOptions={
		    		
					multiple: false,
					async:{
						 saveUrl: '../lib/embdesign/upload',
						 autoUpload: false,
						 /* The selected files will be uploaded in separate requests */
					},
					
					localization:{
						uploadSelectedFiles: 'Upload',
						select:"select a DST file..."
					},
					
					//Triggered when a file(s) is selected. 
					//Note: Cancelling this event will prevent the selection from occurring.
					select:function(e){
						var files=e.files;
						if(files && files.length>0){
							var file=files[0];
							var ext=file.extension;
							if(ext)
								ext=ext.toLowerCase().trim();
							if(ext!==".dst"){
								e.preventDefault();
								alert("You must select a dst file.")
							}else{
								$scope.newUploadData.designNumber=file.name.substring(0,file.name.lastIndexOf(file.extension));
								if($scope.newUploadData.designNumber)
									$scope.newUploadData.designNumber.trim().toUpperCase();
								$scope.$apply();
							}
						}
				    },
					
					upload:function (e) {
						
						$scope.clear();
						
						var data=$scope.newUploadData;
						var error="";
						if(data.designNumber)
							data.designNumber=data.designNumber.trim().toUpperCase();
						if(!data.designNumber)
							error+="Design Number can not be empty. ";
						
						if(!data.companyId)
							error+="Please select a company for this design. "
							
						if(error)	{
							e.preventDefault();
							alert(error);
							
						}else{
						    e.data = {data:JSON.stringify(data)};
						}
					},
					 
					success: function (e) {
					    if(e.response.status==="success"){
					    	var data=e.response.data;
							if(data){
								$scope.loadDesign(data.id);
							}
				    	}
					},
					
					error:function(e){
			//	 		alert("failed:"+JSON.stringify(e.response.data));
					},
					
					//Fires when all active uploads have completed either successfully or with errors
					complete:function(e){
					}
			};
					
			$scope.queryGridOptions={
					doubleClickEvent:function(e){
							if(e.currentTarget){
								var di=this.dataItem(e.currentTarget);
								if(di&&di.id){
									$scope.loadDesign(di.id);
									if(e.target && e.target.cellIndex===0)
										$scope.queryWindow.close();
								}
								
							}
						}
			}
			
			$scope.openQueryWindow=function(){
				$scope.queryWindow.open();
			}
			
			
			var cgw=new ColourwayGridWrapper("colourwayGrid");	
			cgw.setColumns();

			$scope.$on("kendoWidgetCreated", function(event, widget){

				if (widget ===$scope["colourwayGrid"]) {
		        	cgw.wrapGrid(widget);
					widget.bind("dataBound",function(e){
						this.tbody.find("tr").dblclick(onDoubleClick);
					});

/* 		        			resize:function(gridHeight){
		        				bgw.resizeGrid(gridHeight);
		        				},
 */			        	
		        }
				
		    });				
			
			
		    $scope.colourwayGridDataSource=new kendo.data.DataSource({
		    	data:$scope.dataSet.colourways,	//$scope.dstDesign.info.colorway,
			    schema: {
			        model: {
			            id: "id"
			        }
			    },
			    serverFiltering:false,
			    pageSize: 0,
			    
 		       	save: function(e) {
 		       		
 		       	},
 		       	
		         //row or cloumn changed
		       	change:function(e){
		       		
		       	},


		    });
		    
			$scope.colourwayGridOptions={
					autoSync: true,
			        columns: cgw.gridColumns,
			        dataSource: $scope.colourwayGridDataSource,
			        pageable:false,
			        selectable: "row",
			        navigatable: true,
			        resizable: true,
			}
			
			var onDoubleClick=function(e){
				if(e.currentTarget){
					var di=$scope.colourwayGrid.dataItem(e.currentTarget);
					if(di&&di.threads&&di.runningSteps){
						$scope.myDstPaint.setColourway(di.threads,di.runningSteps);
						$scope.myDstPaint.setBackgroundColour(di.backgroundColour);
					}
				}
			}

		    var populate=function(data){
				$scope.dataSet.info=data.info;
				var itemNames=["colourways","samples"];
				for(var i=0,scopeItems,dataItems,itemName;i<itemNames.length;i++){
					itemName=itemNames[i];
					dataItems=data[itemName];
					if(dataItems){
						scopeItems=$scope.dataSet[itemName];
						for(var j=0;j<dataItems.length;j++){
							scopeItems.push(dataItems[j]);
						}
					}
				}
		    }
		    
			var clearDataSet=function(){
		    	$scope.dataSet.info={};
		    	$scope.dataSet.colourways.splice(0,$scope.dataSet.colourways.length);
		    	$scope.dataSet.samples.splice(0,$scope.dataSet.samples.length);
		    	$scope.dataSet.deleteds=[];
			}
			
		    $scope.clear=function(){
		    	$scope.searchDesignNumber=null;
		    	clearDataSet();
		    	$scope.myDstPaint.clear();
		    	$scope.myDstPaint.setBackgroundColour("#FFFFFF");
		    	$scope.$apply();
		    }
		    
		    $scope.loadDesign=function(id){
		    	$scope.clear();
		    	
		    	var url="../lib/emb/get-embdesign?id="+id;
				$http.get(url).then(
					function(data, status, headers, config) {
						if(data.data){
				    		populate(data.data);
						}
					},function(data, status, headers, config) {
				});

		    	$scope.myDstPaint.loadDesignById(id);

		    }
		    
		    $scope.saveDesign=function(){
		    	//if(!validDesign()) return;
				var url="../lib/emb/save-embdesign";
				
//				if(scope.companyForm.$dirty||scope.instructionsForm.$dirty)
//					scope.dataSet.info.isDirty=true;
				
				$http.post(url,$scope.dataSet).then(
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
		    	var colourway=$scope.myDstPaint.getColourway();
		    	var thumbnail=$scope.myDstPaint.getThumbnail();
		    	var bgColour=$scope.myDstPaint.getBackgroundColour();
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
		    
		    $scope.addColourway=function(){
		    	var di=getColorwayDiFromPaint();
		    	di.libEmbDesignId=$scope.dataSet.info.id;
		    	cgw.addRow(di);
		    }
		    
		    $scope.newColourway=function(){
		    	$scope.myDstPaint.threadMatcher.embCanvas.setColourway("","");
		    	$scope.myDstPaint.threadMatcher.initColourwayList();
		    	$scope.myDstPaint.threadMatcher.embCanvas.drawDesign();
		    }
		    
		    $scope.removeColourway=function(){
				var dataItem=cgw.getCurrentDataItem();
		    	var confirmed=true;
			    if (dataItem) {
			        if (dataItem.threads&&dataItem.runningSteps){
			        	confirmed=confirm('Please confirm to delete the selected row.');	
			        }
			        if(confirmed){
				    	if(dataItem.id){
				    		var item= {entity:"libEmbDesignColourway",id:dataItem.id};
							$scope.dataSet.deleteds.push(item);				    	
				    	}
						cgw.deleteRow(dataItem);
			        }
			    }else {
		        	alert('Please select a  colorway  to delete.');
		   		}
		    	
		    }
		    
		    $scope.updateColourway=function(){
		    	var currentCell=cgw.grid.current();
		    	if(currentCell){
			    	var diCurrent=cgw.getCurrentDataItem();
			    	var diPaint=getColorwayDiFromPaint();
			    	if(diCurrent&&diPaint){
			    		diCurrent.threads=diPaint.threads;
			    		diCurrent.runningSteps=diPaint.runningSteps;
			    		diCurrent.backgroundColour=diPaint.backgroundColour;
			    		diCurrent.thumbnail=diPaint.thumbnail;
			    		diCurrent.isDirty=true;
			    	}
			    	$scope.$apply();
			    	var columnIndex=cgw.getColumnIndex("thumbnail");
	                var template = kendo.template(cgw.gridColumns[columnIndex].template);
	            	var cell = currentCell.parent().children('td').eq(columnIndex);
	                cell.html(template(diCurrent));		                    
		    	}else{
		        	alert('Please select a  colorway  to update.');
		    	}
		    }
		    
		    $scope.normalizeColourway=function(){
		    	$scope.myDstPaint.threadMatcher.embCanvas.normalizeColourway();
		    	$scope.myDstPaint.threadMatcher.parseColourway();
		    }
		    
		}]);

</script>
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

     #fieldlist {
        margin: 10px;
        padding: 0;
     }
      
     #fieldlist li {
         list-style: none;
         padding-top: .7em;
         text-align: left;
     }
     
     #fieldlist label {
          display: block;
      }
      
     
      textarea { 
      	resize: vertical; 
      }
      


	
</style>

</html>