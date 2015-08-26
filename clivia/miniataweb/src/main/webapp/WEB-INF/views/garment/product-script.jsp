<script>

angular.module("app", ["kendo.directives"])	.controller("MyCtrl",["$scope","$http",function($scope,$http) {

	var baseUrl="/miniataweb/garment/";
	
	$scope.currentStyleNumber="";
	$scope.searchStyleNumber="";

	$scope.mainSplitterOrientation="horizontal";
	$scope.pageModel={};
	
	$scope.dictColourway=[];
	$scope.dictSizeRange=[];
	
	$scope.newGarment=function(){
		$scope.pageModel.product={};
		$scope.pageModel.product.styleNumber="";
		$scope.pageModel.productUPCs=[{}];
		$scope.currentStyleNumber="";
		
	//	$scope.productForm.$setPristine();
			
	}

	$scope.newGarment();
	
	$scope.$watch("pageModel.product.colourway",function(){
    	$scope.dictColourway=String($scope.pageModel.product.colourway).split(',');
	});
	$scope.$watch("pageModel.product.sizeRange",function(){
    	$scope.dictSizeRange=String($scope.pageModel.product.sizeRange).split(',');
	});
	
	$scope.getGarment=function(){
		
		if(!!$scope.searchStyleNumber){
			$scope.newGarment();
			
			var url=baseUrl+"get-product?style="+$scope.searchStyleNumber;
			$http.get(url).
				success(function(data, status, headers, config) {
				    if(data){
				    	
				    	$scope.pageModel.product=data;
	
				    	$scope.upcGridOptions.dataSource.filter=[{
			    	        field: "garmentId",
			    	        operator: "eq",
			    	        value:	(!!$scope.pageModel.product.id)?$scope.pageModel.product.id:-1
			    	    }];
				    	$scope.currentStyleNumber=$scope.pageModel.product.styleNumber;
				    } else {
				    	alert("Can not found style:"+$scope.searchStyleNumber+".");
				    }
				    
			    	$scope.searchStyleNumber="";
				    
			   }).
  			   error(function(data, status, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			   });	

		}
		else{
			alert("Please input a style# first.");
		}
		
	}
	
	 
	$scope.saveGarment=function(){
 		if (validGarment()){
			var url=baseUrl+"save-product";
			$http.post(url,$scope.pageModel.product).
			  success(function(data, status, headers, config) {
			    	$scope.pageModel.product=data;
			  }).
			  error(function(data, status, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			  });		
		}
	}
	
	$scope.deleteGarment=function(){
		if(!!$scope.pageModel.product.id && confirm("Please confirm to delete this product.")){
			var url=baseUrl+"delete-product";
			$http.post(url,$scope.pageModel.product).
			  success(function(data, status, headers, config) {
				  $scope.newGarment();
			  }).
			  error(function(data, start, headers, config) {
				  alert( "failure message: " + JSON.stringify({data: data}));
			  });		
		}
	}
	
	
 	var validGarment=function(){
		var isValid=true;
		var errors="";

		if(!!!$scope.pageModel.product.styleNumber){
			errors+="Style# can not be empty.";
		}
		if(!!!$scope.pageModel.product.styleName){
			errors+="Style name can not be empty.";
		}
		if (errors!=""){
			alert(errors);
			isValid=false;
		}
		
		return isValid;
	}
	
	
 	$scope.priceSettings={
			min:"0",
			upArrowText:"Increment",
			downArrowText:"Decrement"
	};
 	
	$scope.brandOptions=["DD","VIE","Vestige"];

	$scope.$watch("pageModel.product.sizeRange",function(){
		if(!!$scope.pageModel.product.sizeRange){
			var str= String($scope.pageModel.product.sizeRange);
			$scope.dictSizeRange=str.split(",");
		}
		else{
			$scope.dictSizeRange=[];
		}
	});

	var upcGridToolbar=[{
	        name: "create",
	        text: "Add"
	    }, {
	        name: "save",
	        text: "Save"
	    }, {
	        name: "cancel",
	        text: "Cancel",
    }]; 
	
	var upcColourwayEditor=function(container, options) {
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>').appendTo(container).kendoDropDownList({
	        autoBind: false,
	        dataSource: {
	            data: $scope.dictColourway
	        }
	    })
	};	

	var upcSizeEditor=function(container, options) {
	    $('<input class="grid-editor"  data-bind="value:' + options.field + '"/>').appendTo(container).kendoDropDownList({
	        autoBind: false,
	        dataSource: {
	            data: $scope.dictSizeRange
	        }
	    })
	};	
	
	
	$scope.searchOptions={
			dataSource:{
 	    	    transport: {
	    	        read: {
	    	            url: '/miniataweb/dict/list?from=garment&textField=styleNumber',
	    	            type: 'get',
	    	            dataType: 'json',
 	    	            contentType: 'application/json'
	    	        }
			} }
	};
	
	upcGridLineNumber=0;
	var upcDataUrl="/miniataweb/data/garmentUpcDao/";
	$scope.upcGridOptions = {
			toolbar:upcGridToolbar,
	        dataSource: {
	    	    transport: {
	    	        read: {
	    	            url: upcDataUrl+'read',
	    	            type: 'post',
	    	            dataType: 'json',
	    	            contentType: 'application/json'
	    	        },
	    	        update: {
	    	            url: upcDataUrl+'update',
	    	            type: 'post',
	    	            dataType: 'json',
	    	            contentType: 'application/json'
	    	        },
	    	        create: {
	    	            url: upcDataUrl+'create',
	    	            type: 'post',
	    	            dataType: 'json',
	    	            contentType: 'application/json'
	    	        },
	    	        destroy: {
	    	            url: upcDataUrl+'destroy',
	    	            type: 'post',
	    	            dataType: 'json',
	    	            contentType: 'application/json'
	    	        },
	    	        parameterMap: function(options, operation) {
	    	            if (operation === "read") {
	    	                return JSON.stringify(options);
	    	            } else {
	    	                return JSON.stringify(options.models);
	    	            }
	    	        }
	    	    },
	    	    error: function(e) {
	    	        alert("Status:" + e.status + "; Error message: " + e.errorThrown);
	    	    },
	    	    filter: [{
	    	        field: "garmentId",
	    	        operator: "eq",
	    	        value:	(!!$scope.pageModel.product.id)?$scope.pageModel.product.id:-1
	    	    }],
	    	    sort: [{
	    	        field: "upcNumber",
	    	        dir: "asc"
	    	    }],
	    	    batch: true,
	    	    pageSize: 16,
	    	    serverPaging: true,
	    	    serverFiltering: true,
	    	    serverSorting: true,
	    	    schema: {
	    	        data: "data",
	    	        total: "total",
	    	        model: {
	    	            id: "id",
	    	            fields: {
	    	                id: {
	    	                    type: "number",
	    	                    editable: false
	    	                },
	    	                garmentId: {
	    	                    type: "number",
	    	                    editable: true
	    	                },
	    	                upcNumber: {
	    	                    type: "string",
	    	                    editable: true
	    	                },
	    	                colour: {
	    	                    type: "string",
	    	                    editable: true
	    	                },
	    	                size: {
	    	                    type: "string",
	    	                    editable: true
	    	                },
	    	                qtyInStock: {
	    	                    type: "number",
	    	                    editable: true
	    	                },
	    	                qtyInOrder: {
	    	                    type: "number",
	    	                    editable: true
	    	                },
	    	                remark: {
	    	                    type: "string",
	    	                    editable: true
	    	                }
	    	            }
	    	        }
	    	    }
	    	}, //end of dataSource,
	    	
	        columns: [{
	            title: " ",
	            template: "#= ++upcGridLineNumber #",
	            locked: true,
	            width: 30
				}, {
				    field: "id",
				    title: "Id",
				    hidden: true,
				    filterable: false,
				    width: 0
				}, {
				    field: "garmentId",
				    title: "Garment Id",
				    hidden: true,
				    filterable: false,
				    width: 0
				}, {
				    field: "upcNumber",
				    title: "UPC#",
				    locked: true,
				    width: 120
				}, {
				    field: "colour",
				    title: "Colour",
				    editor:upcColourwayEditor,
				    width: 100
				}, {
				    field: "size",
				    title: "Size",
				    editor:upcSizeEditor,
				    width: 80
				}, {
				    field: "qtyInStock",
				    title: "Qty In Stock",
				    width: 80
				}, {
				    field: "qtyInOrder",
				    title: "Qty In Order",
				    width: 80
				}, {
				    field: "remark",
				    title: "Remark",
				    width: 80
				}, {
					command: {
						name:"destroy",
						template: "<a class='k-grid-delete k-button'  style='width: 22px; height: 22px; vertical-align: middle; text-align: center;'><span style='margin: 2px;' class='k-icon k-i-close'></span></a>"
						},
					title: "&nbsp;",
					width:38,
 			}],  //end of columns
	        
	        selectable: true,
	        navigatable: true,
	        resizable: true,
	        reorderable: true,
	        pageable: {
	            refresh: true,
	            pageSizes: ["all",2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],
	            buttonCount: 5,
	           
	        },
	        filterable: false,
	        sortable:true,
	        editable: {confirmation:false},
	        edit:function(e) {
	    	    if (e.model.isNew()&&!e.model.dirty) {
	    	            e.model.set("garmentId", $scope.pageModel.product.id); 
	    	    }
	    	 },
	    	 dataBinding: function() {
	             upcGridLineNumber = (this.dataSource.page() - 1) * this.dataSource.pageSize();
	         }
	    }; //end of 

}]);  //end of controller


/* $('#garmentupcgrid .k-grid-toolbar a.k-grid-delete').click(function(e) {
    e.preventDefault();
    var selectedItem = garmentupcgridKendoGrid.dataItem(garmentupcgridKendoGrid.select());
    if (selectedItem !== null) {
        if (confirm('Please confirm to delete the selected row.')) {
            garmentupcgridDataSource.remove(selectedItem);
        }
    } else {
        alert('Please select a  row to delete.');
    }
}); */


</script>
