<script>
'user strict';
var queryApp = angular.module("queryApp",
		[ "ui.router", "kendo.directives","clivia"]);


queryApp.controller("queryCtrl",["$scope","cliviaDDS","util",function($scope,cliviaDDS,util){
	var scope=$scope;
	
	$scope.queryToolbarOptions={items: [{
		        type: "button",
		        text: "Export To Excel",
		        id: "btnExcel",
		        click: function(e){
		        	$scope.queryGridScope.queryGrid.saveAsExcel();
		            }
			}, {
        		type: "separator",
		    }, {
		        type: "button",
		        text: "Choose Columns",
		        id: "btnChooseColumns",
		        click: function(e){
		        	$scope.chooseColumn();
		            }
		    }, {
		        type: "button",
		        text: "Clear Filters",
		        id: "btnClearFilters",
		        click: function(e){
		        	 $("form.k-filter-menu button[type='reset']").trigger("click");
		            }
		    }, {
		        type: "separator",
		    }, {
		        type: "button",
		        text: "Summary",
		        id: "btnSummary",
		        click: function(e){
		        	$scope.getSummary();
		        	
		        	}
		    }, {
		        type: "button",
		        text: "Commission",
		        id: "btnCommission",
		        click: function(e){
		        	$scope.getCommission();
		        	
		        	}
		    }, {
		        type: "separator",
	        }, {
 	           	template:'Choose Theme:<theme-chooser></theme-chooser>'		    
		}]};
	
	scope.chooseAllColumns=function(chooseAll){
		scope.choosedColumns.splice(0,scope.choosedColumns.length);
		if(chooseAll){
			for(var i=0;i<scope.columns.length;i++)
				scope.choosedColumns.push(scope.columns[i]);
		}
	}
 	scope.chooseColumn=function(all){
		scope.columns=[];
		scope.choosedColumns=[];
		
		var columnItems=$scope.queryGridScope.dataSet.columnItems;
		var gridColumns=$scope.queryGridScope.queryGrid.columns;
		
		for(var i=0,col;i<columnItems.length;i++){
			if(columnItems[i].choosable){
				col={
					title:columnItems[i].title,
					field:columnItems[i].name,
				}
				scope.columns.push(col);
				for(var j=0;j<gridColumns.length;j++){
					
					if(gridColumns[j].field===col.field && !gridColumns[j].hidden){
						scope.choosedColumns.push(col);
						break;
					}
				}
			}
		}
		$scope.$apply();
		scope.chooseColumnWindow.center().open();
 	}
 	
 	scope.chooseColumnOk=function(){
 		var grid=$scope.queryGridScope.queryGrid;
 		var choosedColumns=this.choosedColumns;
 		var gridColumns=$scope.queryGridScope.queryGrid.columns;
		var options=$scope.queryGridScope.queryGrid.getOptions();
 		for(var i=0,choosed;i<gridColumns.length;i++){
 			choosed=false;
 			for(var j=0;j<choosedColumns.length;j++){
 				if(gridColumns[i].field===choosedColumns[j].field){
 					choosed=true;
 					break;
 				}
 			}
 			if(choosed){
	 	 		if(gridColumns[i].hidden)
	 	 			grid.showColumn(gridColumns[i].field);
 	 		}else{
	 	 		if(!gridColumns[i].hidden)
	 	 			grid.hideColumn(gridColumns[i].field);
 	 		}
 		}
 		
 	//	$scope.queryGridScope.queryGrid.
	// 		$scope.queryGridScope.query.rebind++;
 		scope.chooseColumnWindow.close();
 	}
 	
 	scope.chooseColumnCancel=function(){
 		scope.chooseColumnWindow.close();
 	}	
	
 	scope.getSummary=function(){
 		var options=$scope.queryGridScope.queryGrid.getOptions();
 		var filter=options.dataSource.filter;
 		var cond=scope.getSqlCondition(filter);
 		scope.summaryWindow.center().open();
 		scope.upcSummaryScope.load(cond);
 	}

 	scope.getCommission=function(){
 		var options=$scope.queryGridScope.queryGrid.getOptions();
 		var filter=options.dataSource.filter;
 		var cond=scope.getSqlCondition(filter); 		
 		scope.analysisWindow.center().open();
 		scope.garAnalysisScope.load(cond);
 	}
 	
 	
 	scope.getSqlExpression=function(filter){
 	 		var columnItems=$scope.queryGridScope.dataSet.columnItems;
 	 		var field=util.find(columnItems,"name",filter.field);
 	 		var value,likeValue;
 	 		
 	 		switch (field.dataType){
 	 			case "number":
 	 				value=String(filter.value);
 	 				break;
 	 			case "date":
 	 				value="'"+kendo.toString(filter.value,"yyyy-MM-dd")+"'";
 	 				
 	 				break;
 	 			case "boolean":
 	 				value=filter.value?"1":"0";
 	 				break;
 	 			default:
 	 				likeValue=filter.value.replace(/"/g,'\\"');
 	 				value="\""+likeValue+"\"";
 			}
 	 		
 	 		switch (filter.operator){
 	 			case "eq":
 	 				cond=field.name+"="+value;
 	 				break;
 	 			case "neq":
 	 				cond=field.name+"<>"+value;
 	 				break;
 	 			case "gt":
 	 				cond=field.name+">"+value;
 	 				break;
 	 			case "gte":
 	 				cond=field.name+">="+value;
 	 				break;
 	 			case "lt":
 	 				cond=field.name+"<"+value;
 	 				break;
 	 			case "lte":
 	 				cond=field.name+"<="+value;
 	 				break;
 	 			case "startswith":
 	 				cond=field.name+" like \""+likeValue+"%\"";
 	 				break;
 	 			case "endswith":
 	 				cond=field.name+" like \"%"+likeValue+"\"";
 	 				break;
 	 			case "contains":
 	 				cond=field.name+" like \"%"+likeValue+"%\"";
 	 				break;                
 	 			case "doesnotcontain":
 	 				cond=field.name+" not like \"%"+likeValue+"%\"";
 	 				break;
 	 				
 	 			case "isnull":
 	 				cond=field.name+" IS NULL";
 	 				break;
 	 			case "isnotnull":
 	 				cond=field.name+" IS NOT NULL";
 	 				break;
 	 			case "isempty":
 	 				cond=field.name+"=''";
 	 				break;
 	 			case "isnotempty":
 	 				cond=field.name+"<>=''";
 	 				break;
 	 		}
 	 		return "("+cond+")";
 	 		
 	 	} 	

 	
 	scope.getSqlCondition=function(filter) {
 		var cond="",exp,logic;

 		if (filter) {
 			if (filter.filters) {
 	 			logic=filter.logic?filter.logic:"and";
 				
 				for(var i=0,f;i<filter.filters.length;i++){
 					f=filter.filters[i];
 					exp=scope.getSqlCondition(f);
 					cond=cond+(!cond?"":(" "+logic+" "))+exp;
 				}
 				if(cond)
 					cond="("+cond+")";
 				
 			}else{
 				cond=scope.getSqlExpression(filter);
 			}
 		}
 		return cond;
 	}
 		
 	
	$scope.queryGridNo="802";
}]);


queryApp.directive("salesAnalysis",function(cliviaDDS,util){

	var directive={
			restrict:'EA',
			replace:false,	
			scope:{
				cName:'@salesAnalysis',
			},
			
			templateUrl:"salesanalysis",
			
		    link:function(scope,element,attrs){
		    	if(scope.cName)
		        	scope.$parent[scope.cName+"Scope"]=scope;
		    	
		    	scope.load=function(cond){
			    	var sql=" select rep,businessName, avg(discount) as avgDiscount,"+
			    				"avg(commissionRate) as avgCommissionRate,sum(orderQty) as sumOrderQty,sum(orderAmt) as sumOrderAmt,sum(orderCommission) as sumOrderCommission,"+
			    				"avg(getSMCommissionRate(discount)) as avgSMRate,"+
			    				"sum(getSMCommissionRate(discount)*orderAmt) as sumOrderSMCommission"+
	    					" from orderupcview"+
	    					" group by repid,customerId"+
	    					" order by rep,businessName";
			    	
		    		if (!!cond)
		    			sql=sql.replace("group by"," where "+cond+" group by");
	    					
			    	var url="../data/generic/sql?map=true&cmd=";

		    		util.getRemote(url+sql).then(
		    				function(data){
		    			 		var options=scope.analysisGrid.getOptions();
		    			 		var dataSource=options.dataSource;
		    			 		dataSource.data=data;
		    			 		scope.analysisGrid.setOptions({dataSource:dataSource});
		    				});
		    		
		    	}		
		    	
		    	scope.resizeGrid=function(grid,gridHeight){
				    var gridElement =grid.element;
				    if(gridElement){
				        var dataArea = gridElement.find(".k-grid-content"),
//				        gridHeight = gridElement.innerHeight()-37,
				        	otherElements = gridElement.children().not(".k-grid-content"),
				        	otherElementsHeight = 0;

				    	otherElements.each(function(){
					        otherElementsHeight += $(this).outerHeight();
						    });
				    	gridElement.innerHeight(gridHeight);
				   		dataArea.height(gridHeight - otherElementsHeight);
					}
		    	}
		    },
		    
		    controller:["$scope","cliviaDDS","util",function($scope,cliviaDDS,util){
				$scope.mainSplitterOptions={
						resize:function(e){
							var panes=e.sender.element.children(".k-pane");
							var gridHeight=$(panes[1]).innerHeight()-37;
							
	 	 			      	window.setTimeout(function () {
					            $scope.resizeGrid(upcGridHeight);
					      	},1); 
						}
				}
				
		    	$scope.analysisGridOptions={
	    			dataSource:{
	    				data:[],
                        schema:{
                            model: {
                                fields: {
                                	rep:{type:"string"},
                                    businessName: { type: "string" },
                                    avgDiscount: { type: "number" },
                                    avgCommissionRate:{type:"number"},
                                    sumOrderQty:{type:"number"},
                                    sumOrderAmt:{type:"number"},
                                    sumOrderCommission:{type:"number"},
                                }
                            }
                        },
                        group: {
                                 field: "rep" ,  aggregates: [
                                    { field: "avgDiscount", aggregate: "average"},
                                    { field: "avgCommissionRate", aggregate: "average" },
                                    { field: "sumOrderQty", aggregate: "sum" },
                                    { field: "sumOrderAmt", aggregate: "sum" },
                                    { field: "sumOrderCommission", aggregate: "sum" },
                                    { field: "avgSMRate", aggregate: "average" },
                                    { field: "sumOrderSMCommission", aggregate: "sum" },
                                 ]   
                               },
                        aggregate:[{ field: "avgDiscount", aggregate: "average"},
                                   { field: "avgCommissionRate", aggregate: "average" },
                                   { field: "sumOrderQty", aggregate: "sum" },
                                   { field: "sumOrderAmt", aggregate: "sum" },
        	                       { field: "sumOrderCommission", aggregate: "sum" },
                                   { field: "avgSMRate", aggregate: "average" },
                                   { field: "sumOrderSMCommission", aggregate: "sum" },
                            ]   
		   			},
		    			
                    sortable: true,
                    scrollable: true,
                    pageable: false,

					selectable: "multiple cell",
				    allowCopy: true,                    
                    
				    height:500,
				    
                    columns: [{ 
	                    	field: "businessName", 
	                    	title: "Customer",  
	                    	footerTemplate: "<div style='text-align: right'>Total:</div>",
	                    	width:250,
                    	},{ 
                    		field: "avgDiscount", 
                    		title: "Avg.Discount",
                    		aggregates: ["average"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		format:"{0:p2}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
   	                    	width:110,
                    	},{
                    		field: "sumOrderQty", 
                    		title: "Sum.Quantity",
                    		aggregates: ["sum"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= sum #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= sum #</div>",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
     	                    width:110,
                    	},{
                    		field: "sumOrderAmt", 
                    		title: "Sum.Amount",
                    		aggregates: ["sum"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		format:"{0:c}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
     	                    width:110,
                    	},{ 
                    		field: "avgCommissionRate", 
                    		title: "Avg.Commission Rate",
                    		aggregates: ["average"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		format:"{0:p2}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
   	                    	width:110,
                    	},{
                    		field: "sumOrderCommission", 
                    		title: "Sum.Commission",
                    		aggregates: ["sum"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		format:"{0:c}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
     	                    width:110,
                    	},{ 
                    		field: "avgSMRate", 
                    		title: "Avg.SM's Rate",
                    		aggregates: ["average"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(average,'p2') #</div>",
                    		format:"{0:p2}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
   	                    	width:110,
                    	},{
                    		field: "sumOrderSMCommission", 
                    		title: "SM's Commission",
                    		aggregates: ["sum"],
                    		groupFooterTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		footerTemplate:"<div style='text-align: right'>#= kendo.toString(sum,'c') #</div>",
                    		format:"{0:c}",
                    		headerAttributes:{style:"text-align:right;"},
                    		attributes:{style:"text-align:right;"},
     	                    width:110,
                    	},{
                    		title:"",
                    	}],
                    	
                    	//Align Footer Cells in exported excel
                    	excelExport: function(e) {
                            var rows = e.workbook.sheets[0].rows;

                            for (var ri = 0; ri < rows.length; ri++) {
                              var row = rows[ri];

                              if (row.type == "group-footer" || row.type == "footer") {
                                for (var ci = 0; ci < row.cells.length; ci++) {
                                  var cell = row.cells[ci];
                                  if (cell.value) {
                                    // Use jQuery.fn.text to remove the HTML and get only the text
                                    cell.value = $(cell.value).text();
                                    // Set the alignment
                                    cell.hAlign = "right";
                                  }
                                }
                              }
                            }
                    	}
		    	}
				
		    	$scope.analysisToolbarOptions={items: [{
		    				    	        type: "button",
		    				    	        text: "Export To Excel",
		    				    	        id: "btnExcel",
		    				    	        click: function(e){
		    				    	        	$scope.analysisGrid.saveAsExcel();
		    				    	            }
		    				    	    }, {
		    				    	        type: "separator",

		    				    		}]};	//end of $scope.queryToolbarOptions
		    	
		    }]	//end of controller
	}
	return directive;
	
});

queryApp.directive("upcSummary",function(cliviaDDS,util){
	
	var directive={
			restrict:'EA',
			replace:false,	
			scope:{
				cName:'@upcSummary',
			},
			
			template:'<div kendo-toolbar id="queryToolbar" k-options="queryToolbarOptions"></div>'+
		    		 '<div kendo-spreadsheet="spreadsheet" k-options="spreadsheetOptions" k-rebind="spreadsheetOptions" style="width:100%;height:800px;"></div>',
		    
		    link:function(scope,element,attrs){
		    	
		    	if(scope.cName)
		        	scope.$parent[scope.cName+"Scope"]=scope;
		    	
		    	scope.load=function(cond){
			    	var sql="select upcId,garmentId,category,styleNo,styleName,colour,size,upcNo,sum(orderQty) as 'sumOrderQty'"+
	    					"from orderupcview group by upcId order by category,styleNo,colour,upcNo";
	    			
			    	var url="../data/generic/sql?map=true&cmd=";


		    		if (!!cond)
		    			sql=sql.replace("group by"," where "+cond+" group by");
		    		
		    		url+=sql;
		    		
		    		util.getRemote(url).then(
		    				function(data){
		    					var sheets=createSheets(data);
		    					createSpreadsheet(sheets);
		    				});
		    		
		    	}
		    	
		    	var columnCount=12;
		    	
		    	
		    	var createSheets=function(data){
		    		var sheets=[],sheet;

		    		var season=scope.dds.season.getCurrentSeason(2);	//dd brand
		    		var categories=util.split(season.categories,";");
		    		
		    		var styleRowHeight=30,qtyRowHeight=25,sizeColWidth=50;
		    		var styleFontSize=16,detailFontSize=14;
		    		
		    		var summaryColumns=[{width:100},{width:90},{width:300},{width:80}];
		    		for(var i=summaryColumns.length;i<columnCount;i++){
		    			summaryColumns.push({width:0});
		    		}
		    		
		    		var summaryRows=[],summaryMergedCells=[];
		    		var summaryCategoryRow,summaryRowNo=1;

		    		
		    		var category,garment,sizes,colours;
		    		var rows,rowNo,styleRow,colorRow,headerRow;
		    		var mergedCells;

		    		var cells,qty=[],idx,sizeIdx;
		    		
		    		var addRow=function(row){
		    			rows.push(row);
		    			rowNo++;
		    		}
		    		
		    		var addSummaryRow=function(row){
		    			summaryRows.push(row);
		    			summaryRowNo++;
		    		}
		    		
		    		var total=0;
		    		var lineTotal=0;
		    		var styleTotal=0;
		    		var categoryTotal=0;

		    		var emptyRow={
		    				height:qtyRowHeight,
		    				cells:[{value:""}],
		    		}
		    		
		    		addSummaryRow({height:40,cells:[{
		    				value:"Double Diamond 2016--2017",
		    				fontSize: 22, 
		    				background: "rgb(96,181,255)",
		                	textAlign: "left", 
		                	color: "white"},{value:""},{value:""}]});
		    		summaryMergedCells.push("A1:C1");
		    		addSummaryRow(emptyRow);
		    		
		    		for(var c=0;c<categories.length;c++){
		    			
		    			r=util.findIndex(data,"category",categories[c]);
		    			if(r>=0){

		    				garment=scope.dds.garment.getGarmentById(data[r].garmentId);
		    				sizes=garment.sizeRange.split(",");
		    				categoryColumnCount=sizes.length+2;
		    				
		    				var columns=[{width:220},{width:90}];
		    				for(var i=columns.length;i<categoryColumnCount;i++){
		    					columns.push({width:sizeColWidth});
		    				}
		    				for(var i=columns.length;i<columnCount;i++){
		    					columns.push({width:0});
		    				}
		    				
		    				var lastColumnLetter="ABCDEFGHIJKLMNOPQ".charAt(categoryColumnCount-1);
		    				
		    				rows=[];
		    				rowNo=1;
		    				categoryTotal=0;
		    				category=data[r].category;
		    				mergedCells=[];
		    				summaryCategoryRow={height:30,cells:[{
		    					value:category,
		    					fontSize: 18, 
		    					background: "rgb(167,214,255)" 	},{value:""},{value:""}]};
		    				
		    				summaryMergedCells.push("A"+summaryRowNo+":"+"C"+summaryRowNo);
		    				addSummaryRow(summaryCategoryRow);
		    				
		    				while (r<data.length && category===data[r].category){
		    					
		    					garment=scope.dds.garment.getGarmentById(data[r].garmentId);
		    					mergedCells.push("A"+rowNo+":"+lastColumnLetter+rowNo);
		    				
		    					styleRow={
		    						height:styleRowHeight,
		    						cells:[{
		    							value:garment.styleNo+"   "+garment.styleName,
		    							fontSize: styleFontSize,
		    							background: "rgb(167,214,255)"
		    						}]
		    					}
		    					for(var i=1;i<columnCount;i++){
		    						styleRow.cells.push({value:"",fontSize:styleFontSize})
		    					}
		    					addRow(styleRow);
		    	
		    					sizes=garment.sizeRange.split(",");
		    				
		    					sizeIdx={};
		    					cells=[{value:""},{value:"Sum:",fontSize:detailFontSize,textAlign:"right"}];
		    					for(var i=0;i<sizes.length;i++){
		    						sizeIdx[sizes[i].trim()]=i;
		    						cells.push({value:sizes[i],fontSize:detailFontSize,textAlign:"right"});
		    					}
		    				
		    					headerRow={
		    							height:qtyRowHeight,
		    							cells:cells,
		    					}
		    					
		    					addRow(headerRow);
		    					
		    					styleTotal=0;
		    					
		    					while(r<data.length && data[r].garmentId===garment.id){
		    						
		    						colour=data[r].colour;
		    						for(var i=0;i<sizes.length;i++){
		    							qty[i]=0;
		    						}
		    						
		    						while(r<data.length && data[r].garmentId===garment.id && data[r].colour===colour){
		    							idx=sizeIdx[data[r].size];
		    							qty[idx]+=data[r].sumOrderQty;
		    							r++;
		    						}
		    						
		    						lineTotal=0;
		    						cells=[{value:colour,fontSize:detailFontSize},{value:0}];
		    						for(var i=0;i<sizes.length;i++){
		    							cells.push({value:qty[i],fontSize: detailFontSize});
		    							lineTotal+=qty[i];
		    						}
		    						cells[1].value=lineTotal;
		    						
		    						colorRow={
		    								height:qtyRowHeight,
		    								cells:cells,
		    						}
		    						addRow(colorRow);
		    						styleTotal+=lineTotal;
		    					}	//end of garmentId while
		    					
		    					headerRow.cells[1].value+=styleTotal;
		    					mergedCells.push("A"+rowNo+":"+lastColumnLetter+rowNo);
		    					addRow(emptyRow);
		    					
		    					categoryTotal+=styleTotal;
		    					
		    					addSummaryRow({
		    							cells:[{value:""},{value:garment.styleNo},{value:garment.styleName},{value:styleTotal}]
		    						});
		    					
		    				}	//end of category while
		    				
		    				total+=categoryTotal;
		    				
		    				summaryCategoryRow.cells.push({
		    					value:categoryTotal,
		    					fontSize: 18, 
		    					background: "rgb(167,214,255)" ,
		    					textAlign:"right" });
		    				
		    				addSummaryRow(emptyRow);
		    					
		    				sheet={
		    						name:category,
		    			            mergedCells:mergedCells,
		    			            rows:rows,
		    			            columns:columns,
		    					}
		    				sheets.push(sheet);
		    			}
		    			
		    		}	//end of sheet while
		    		
		    		
		    		summaryRows[0].cells.push({
		    			value:total,				
		    			fontSize: 22, 
		    			background: "rgb(96,181,255)",
		            	textAlign: "right", 
		            	color: "white"});
		    		
		    		sheets.unshift({
		    			name:"Summary",
		    			mergedCells:summaryMergedCells,
		    			rows:summaryRows,
		    			columns:summaryColumns
		    		});
		    		
		    		return sheets;
		    	}
		    	
		    	
		    	var createSpreadsheet=function(sheets){
		    		scope.spreadsheetOptions={
		    		        toolbar:false,
		    		        sheets:sheets,
		    		        columns:columnCount,
		    		        rows:100,
		    		        excel: { fileName: "Order.xlsx" },
		    			}
		    	};
		    },
		    
		    controller:["$scope","cliviaDDS","util",function($scope,cliviaDDS,util){
		    	$scope.dds={
		    			image:cliviaDDS.createDict("image","../data/libImage/","onDemand"),
		    			
		    			garment:cliviaDDS.getDict("garment"),
		    			brand:cliviaDDS.getDict("brand"),
		    			season:cliviaDDS.getDict("season"),
		    			upc:cliviaDDS.getDict("upc"),
		    			
		    			}	
		    	
		    	$scope.queryToolbarOptions={items: [{
/* 		    	        type: "button",
		    	        text: "Load",
		    	        id: "btnLoad",
		    	        click: function(e){
		    	        	$scope.load();
		    	            }
		    	    }, {
		    	        type: "separator",
 */		    	    }, {
		    	        type: "button",
		    	        text: "Export To Excel",
		    	        id: "btnExcel",
		    	        click: function(e){
		    	        	$scope.spreadsheet.saveAsExcel();
		    	            }
		    	    }, {
		    	        type: "separator",

		    		}]};	//end of $scope.queryToolbarOptions
		    	
		    	
		    	}]	//end of controller
		    }
	
		return directive;
});



</script>