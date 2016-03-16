<script>
	orderApp.constant("consts",{
		
		maxTmpId:10000,
		
		baseUrl:"/miniataweb/",
		
		registeredItemTypes:[{
				id:1,
				name:"billItem",	
				hasDetail:false
			},{
				id:2,
				name:"lineItem",
				hasDetail:false
			},{
				id:3,
				name:"designItem",	
				hasDetail:false
			},{
				id:4,
				name:"imageItem",	
				hasDetail:false
			},{
				id:5,
				name:"fileItem",
				hasDetail:false
			},{
				id:6,
				name:"emailItem",	
				hasDetail:false
			}],
			
		registeredOrderItems:[{ 
				 text: "Bill", 
				 icon: "insert-n",
				 id:"billitem",
				 spec:"",
				 itemType: "billItem",
				 itemTypeId:1,
			},{
				 type: "separator" 
			},{
			   	 text: "Line Item", 
				 icon: "insert-n",
				 id: "lineitem",
				 spec: "1",
				 itemType: "lineItem",		//datatable
				 itemTypeId:2,
			},{
				 text: "Double Diamond", 
				 icon: "insert-n",
				 id:"lineitemdd",
				 snpId:14,
				 spec:"2",				//brandId
				 itemType:"lineItem",
				 itemTypeId:2,
			},{
				type: "separator" 
			},{
				text: "Design", 
				icon: "insert-m",
			   	id:"designitem",
				spec:"",
				itemType: "designItem",
				itemTypeId:3,
			},{ 
				text: "Image", 
				icon: "insert-m",
			   	id:"imageitem",
				spec:"",
				itemType: "imageItem",
				itemTypeId:4,

			},{ 
				text: "File", 
				icon: "insert-s",
			   	id:"fileitem",
				spec:"",
				itemType: "fileItem",
				itemTypeId:5,
			},{ 
				text: "Email", 
				icon: "insert-s",
			   	id:"emailitem",
				spec:"",
				itemType: "emailItem",
				itemTypeId:6,
			},{ 
				text: "Send&Receive",
				icon: "insert-s",
			   	id:"shipping",
				spec:"",
				itemType: "shippingItem"
			}],
	});
</script>