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
		<div dst-paint="myDstPaint"></div>

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
					    <map-combobox   style="width:300px;" c-options="newUploadCompanyOptions" ng-model="newUploadData.customerNumber"/>
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
			
<!-- <pre>
printModel={{myDstPaint.printModel|json}}
</pre>
 -->

	</div>
</body>
<script>
var designApp = angular.module("embDesignApp",
		["kendo.directives","embdesign"]);
		
designApp.controller("dmCtrl",
		["$scope",function($scope){
			var id=16;
			var imgUrl="../resources/images/";

			var searchTemplate='<kendo-combobox name="searchDesignNumber" k-placeholder="\'Search Design#\'" ng-model="searchDesignNumber"  k-options="searchDesignNumberOptions" style="width: 140px;" />';
			
			$scope.dstToolbarOptions={items: [{
		        type: "button",
		        text: "New",
		        id:"btnNew",
		        click: function(e) {
		        	$scope.myDstPaint.setDstDesign(--id)
		       		 }
		    }, {
		        type: "button",
		        text: "Open",
		        id:"btnOpen",
		        click: function(e) {
		        	$scope.newUploadWindow.open();
			        }
		    }, {
		        type: "separator",
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
		        type: "button",
		        text: "Print",
		        id: "btnPrint",
		        click: function(e){
		        	$scope.myDstPaint.print();
		        	}  
		    }, {
		        type: "separator",
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
		    		customerNumber:"",
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
						var data=$scope.newUploadData;
						var error="";
						if(data.designNumber)
							data.designNumber=data.designNumber.trim().toUpperCase();
						if(!data.designNumber)
							error+="Design Number can not be empty. ";
						
						if(!data.customerNumber)
							error+="Please select a company for this design. "
							
						if(error)	
							e.preventDefault();
						else
						    e.data = {data:JSON.stringify(data)};
					},
					 
					success: function (e) {
					    if(e.response.status==="success"){
					    	var data=e.response.data;
							if(data){
								$scope.myDstPaint.setDstDesign(data.id)
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
									$scope.myDstPaint.setDstDesign(di.id);
									if(e.target && e.target.cellIndex===0)
										$scope.queryWindow.close();
								}
								
							}
						}
			}
			
			$scope.openQueryWindow=function(){
				$scope.queryWindow.open();
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