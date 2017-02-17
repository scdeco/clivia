<script>
	orderApp.constant("consts",{
		
		maxTmpId:10000,
		
		baseUrl:"/miniataweb/",
		
		registeredItemTypes:[{
				id:1,
				name:"billItem",
				model:"orderBillItem",
				hasDetail:true,
				directive:"bill-item",
			},{
				id:2,
				name:"lineItem",
				model:"orderLineItem",
				hasDetail:true,
			 	directive:"line-item",
			},{
				id:3,
				name:"designItem",	
				model:"orderDesign",
				hasDetail:false,
				directive:"design-item",
			},{
				id:4,
				name:"imageItem",
				model:"orderImage",
				hasDetail:false,
				directive:"image-item",
			},{
				id:5,
				name:"fileItem",
				model:"orderFile",
				hasDetail:false,
				directive:"file-item",
			},{
				id:6,
				name:"emailItem",
				model:"orderEmail",
				hasDetail:false,
				directive:"email-item",
			},{
				id:7,
				name:"contactItem",
				model:"orderContact",
				hasDetail:false,
				directive:"contact-item",
			},{
				id:8,
				name:"addressItem",
				model:"orderAddress",
				hasDetail:false,			
				directive:"address-item",
			}],
			
		registeredOrderItems:[{ 
				 text: "Pricing", 
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
				text: "Contact", 
				icon: "insert-s",
			   	id:"contactitem",
				spec:"",
				itemType: "contactItem",
				itemTypeId:7,
			},{ 
				text: "Address", 
				icon: "insert-s",
			   	id:"addressitem",
				spec:"",
				itemType: "addressItem",
				itemTypeId:8,
			},{ 
				text: "Send&Receive",
				icon: "insert-s",
			   	id:"shipping",
				spec:"",
				itemType: "shippingItem",
				directive:"send-receive",
			}],
			
			registeredServices:[{
				id:10,
				text: "Embroidery", 
				icon: "insert-n",
				model:"orderServiceEmb",
				name:"serviceEmb",
			},{
				id:11,
				text: "Screen Printing", 
				icon: "insert-n",
				model:"orderServiceSp",
				name:"serviceSp",
				
			},{
				id:12,
				text: "Heat Transfer", 
				icon: "insert-n",
				model:"orderServiceHt",
				name:"serviceHt",
			},{
				id:13,
				text: "Laser Etching", 
				icon: "insert-n",
				model:"orderServiceLaser",
				name:"serviceLaser",
			},{
				id:14,
				text: "Digitizing", 
				icon: "insert-n",
				model:"orderDigitizing",
				name:"serviceDigitizing",
			}],
			
	});
</script>