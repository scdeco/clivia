<script>
	orderApp.constant("consts",{
		
		maxTmpId:10000,
		
		baseUrl:"/miniataweb/",
		
		registeredItemTypes:[{
				name:"lineItem",
				hasDetail:false
			},{
				name:"imageItem",	
				hasDetail:false
			},{
				name:"designItem",	
				hasDetail:false
			},{
				name:"billItem",	
				hasDetail:false
			},{
				name:"fileItem",
				hasDetail:false
			},{
				name:"emailItem",	
				hasDetail:false
			}],
			
		registeredOrderItems:[{ 
				 text: "Bill", 
				 icon: "insert-n",
				 id:"billitem",
				 spec:"",
				 itemType: "billItem"
			},{
				 type: "separator" 
			},{
			   	 text: "Line Item", 
				 icon: "insert-n",
				 id: "lineitem",
				 spec: "1",
				 itemType: "lineItem"		//datatable
			},{
				 text: "Double Diamond", 
				 icon: "insert-n",
				 id:"lineitemdd",
				 snpId:14,
				 spec:"2",				//brandId
				 itemType:"lineItem"
			},{
				type: "separator" 
			},{
				text: "Design", 
				icon: "insert-m",
			   	id:"designitem",
				spec:"",
				itemType: "designItem"
			},{ 
				text: "Image", 
				icon: "insert-m",
			   	id:"imageitem",
				spec:"",
				itemType: "imageItem"
			},{ 
				text: "File", 
				icon: "insert-s",
			   	id:"fileitem",
				spec:"",
				itemType: "fileItem"
			},{ 
				text: "Email", 
				icon: "insert-s",
			   	id:"emailitem",
				spec:"",
				itemType: "emailItem"
			},{ 
				text: "Send&Receive",
				icon: "insert-s",
			   	id:"shipping",
				spec:"",
				itemType: "shippingItem"
			}],
	});
</script>