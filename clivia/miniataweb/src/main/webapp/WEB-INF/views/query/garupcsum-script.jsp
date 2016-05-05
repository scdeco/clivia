<script>
'user strict';
var queryApp = angular.module("queryApp",
		[ "ui.router", "kendo.directives","clivia"]);


queryApp.controller("queryCtrl",["$scope","cliviaDDS","util",function($scope,cliviaDDS,util){
	
	var dds={
			image:cliviaDDS.createDict("image","../data/libImage/","onDemand"),
			
			garment:cliviaDDS.getDict("garment"),
			brand:cliviaDDS.getDict("brand"),
			season:cliviaDDS.getDict("season"),
			upc:cliviaDDS.getDict("upc"),
			
			}	
	
	$scope.queryToolbarOptions={items: [{
	        type: "button",
	        text: "Load",
	        id: "btnLoad",
	        click: function(e){
	        	$scope.load();
	            }
	    }, {
	        type: "separator",
	    }, {
	        type: "button",
	        text: "Export To Excel",
	        id: "btnExcel",
	        click: function(e){
	        	$scope.spreadsheet.saveAsExcel();
	            }
	    }, {
	        type: "separator",

		}]};
	var sql="select upcId,garmentId,category,styleNo,styleName,colour,size,upcNo,sum(orderQty) as 'sumOrderQty'"+
			"from orderupcview group by upcId order by category,styleNo,colour,upcNo";
			
	var url="../data/generic/sql?map=true&cmd=";
	
	
	$scope.load=function(cond){
		if (!!cond)
			sql.replace("order by"," where "+cond+" order by");
		
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

		var season=dds.season.getCurrentSeason(2);	//dd brand
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

				garment=dds.garment.getGarmentById(data[r].garmentId);
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
					
					garment=dds.garment.getGarmentById(data[r].garmentId);
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
		$scope.spreadsheetOptions={
		        toolbar:false,
		        sheets:sheets,
		        columns:columnCount,
		        rows:100,
		        excel: {
		            fileName: "Order.xlsx"
		        }
		    }
		
	}
	
}]);






</script>