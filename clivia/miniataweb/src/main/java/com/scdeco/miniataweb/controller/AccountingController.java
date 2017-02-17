/*package com.scdeco.miniataweb.controller;

import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scdeco.miniataweb.dao.EmployeeInfoDao;
import com.scdeco.miniataweb.dao.InvoiceDao;
import com.scdeco.miniataweb.model.EmployeeInfo;
import com.scdeco.miniataweb.model.Invoice;
import com.scdeco.miniataweb.model.InvoiceInfo;

@Controller
@RequestMapping("/ac/*")
public class AccountingController {
	
	@Autowired
	private EmployeeInfoDao employeeInfoDao;
	
	@Autowired
	private InvoiceDao invoiceDao;

	@RequestMapping(value="/",method=RequestMethod.GET)
	public String getAccuntingPage(Model model,HttpServletRequest request){
		
		model.addAttribute("theme", employeeInfoDao.getTheme(principal.getName()));
		
		return "ac/ac";
	}
	
	@RequestMapping(value="invoice",method=RequestMethod.GET)
	public String getInvoicePage(Model model,Principal principal){
		model.addAttribute("theme", employeeInfoDao.getTheme(principal.getName()));
		
		return "ac/invoice";
	}
	
	
	@RequestMapping(value="get-invoice",method=RequestMethod.GET)
	public @ResponseBody  Invoice getInvoice(@RequestParam("number") String invoiceNumber)
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		System.out.println("Invoice#:"+invoiceNumber);
		return invoiceDao.getByInvoiceNumber(invoiceNumber);
	}

	@RequestMapping(value="save-invoice",method=RequestMethod.POST)
	public @ResponseBody  Invoice saveInvoice(@RequestBody Invoice invoice,Principal principal) 
			throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		String username=principal.getName();
		EmployeeInfo employeeInfo=employeeInfoDao.findByUsername(username);
		InvoiceInfo invoiceInfo=invoice.getInfo();
		invoiceInfo.setCreateBy(employeeInfo.getId());
		
		invoiceDao.save(invoice);
		return invoice;
	}
	
	@RequestMapping(value="delete-invoice",method=RequestMethod.GET)
	public @ResponseBody String deleteInvoice(@RequestParam("id") int id) 
				throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, InstantiationException{
		
		invoiceDao.delete(id);
		
		return "";
	}

	@RequestMapping(value="print-invoice",method=RequestMethod.POST)
	public String printConfirm(@RequestBody Map<String,String> data,Model model,@RequestParam("file") String file){
		
		System.out.println(data);
		model.addAttribute("data",data);
		return "/om/"+file;
	}



}
*/