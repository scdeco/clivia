package com.scdeco.miniataweb.tag;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.scdeco.miniataweb.dao.GridColumnDao;
import com.scdeco.miniataweb.dao.GridInfoDao;
import com.scdeco.miniataweb.model.GridColumn;
import com.scdeco.miniataweb.model.GridInfo;

public class CliviaGridTag extends SimpleTagSupport {

	GridInfoDao gridInfoDao;
	GridColumnDao gridColumnDao;
	
	GridInfo gridInfo;
	List<GridColumn> gridColumnList;

	private String gridno;
	public void setGridno(String gridno) {
		this.gridno = gridno;
	}
	
	private String name;
	public void setName(String name) {
		this.name = name;
	}
	
	private String filter;
	public void setFilter(String filter){
		this.filter=filter;
	}
	
	private boolean editable;
	public void setEditable(boolean editable){
		this.editable=editable;
	}
	
	private boolean inscript;
	public void setInscript(boolean inscript){
		this.inscript=inscript;
	}

	private boolean hidelineno;
	public void setHidelineno(boolean hidelineno){
		this.hidelineno=hidelineno;
	}
	
	
	private StringBuilder before;
    private StringBuilder main;
    private StringBuilder after;
	
	
	@Override
	public void doTag() throws JspException, IOException {
		
		PageContext pageContext = (PageContext) this.getJspContext(); 
		ServletContext servletContext = pageContext.getServletContext(); 
		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext); 
	
		gridInfoDao=(GridInfoDao)wac.getBean("gridInfoDao");
		gridColumnDao=(GridColumnDao)wac.getBean("gridColumnDao");
		
	    JspWriter out = getJspContext().getOut();

	    
	    if(gridno.isEmpty()) return;

    	gridInfo=gridInfoDao.findByGridNo(gridno);
		gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId());
		
		before=new StringBuilder();
	    main=new StringBuilder();
	    after=new StringBuilder();
	    
	    StringBuilder outScript=new StringBuilder();

	    createDataSource();
		createKendoGrid();
		
		if (!inscript){
			outScript.append( "<script>");
			outScript.append("$(document).ready(function() {");
		}
		
		outScript.append(before);
		outScript.append(main);
		outScript.append(after);
	
		if (!inscript){
			outScript.append("});");
			outScript.append("</script>");
		}
		
		System.out.println(outScript.toString());
	    out.println(outScript.toString());
	  
	}


	private void createKendoGrid(){
		
		
		main.append("var "+name+"KendoGrid=$(\"#"+name+"\").kendoGrid({");
		
		createToolbar();
		
		createGridColumns();
		
		if(!hidelineno)
			enableShowLineNo();
		
		main.append("dataSource:"+name+"DataSource,");
		main.append("selectable: true,");
		main.append("navigatable: true,");
		main.append("resizable: "+gridInfo.isColumnResizable()+",");
		main.append("reorderable: "+gridInfo.isColumnMovable()+",");
		
		if (gridInfo.getGridPageSize()>0)
			main.append("pageable: { refresh: true, pageSizes: true, buttonCount: 5 },");
		
		main.append("filterable: true,");
		main.append("editable: "+editable);
		
		main.append("}).data(\"kendoGrid\");");

		
	}	//end of createKendoGrid
	
	private void createGridColumns(){
		main.append("columns:[");			//begin of columns
		if(!hidelineno)
			main.append("{title: \"#\", template: \"#= ++"+name+"LineNo #\", locked: true, width: 30},");

		for(GridColumn gridColumn:gridColumnList){
			main.append("{");
			main.append("field:\""+gridColumn.getColumnName()+"\",");
			main.append("title:\""+gridColumn.getTitle()+"\",");
			
			if(!gridColumn.isColumnVisible())
				main.append("hidden: true,");
			if(gridColumn.isColumnLocked())
				main.append("locked: true,");
			if(gridColumn.isColumnLockable())
				main.append("lockable: true,");
			
			if(!gridColumn.isColumnFilterable())
				main.append("filterable: false,");		
			
			if(gridColumn.getDisplayFormat()!=null&&!gridColumn.getDisplayFormat().isEmpty())
				main.append("format: \""+gridColumn.getDisplayFormat()+"\",");
			
			if("boolean".equals(gridColumn.getColumnDataType())){
				
				String s=" template:\"<input type='checkbox' disabled='disabled' value='#= "
						+gridColumn.getColumnName()+" #' #= "+gridColumn.getColumnName()+" ? 'checked=\\\\'checked\\\\'' : '' # />\",";
				
//				System.out.println(s);
				main.append(s);
			}
			 
			String editor=gridColumn.getColumnEditor();
			if(editor!=null&&!editor.isEmpty()){

				//String[] elements=editorDescription.split(":");
				String editorName=gridColumn.getColumnName()+"ColumnEditor";
				String editorDescriptor=gridColumn.getEditorDescriptor();
				
				main.append("editor:"+editorName+",");
				
				after.append("function "+editorName+"(container, options) {");   //required before data-bind
				after.append("$('<input class=\"grid-editor\" style=\"{height: 16px;font-size: 12px; padding: 1px;}\"   data-bind=\"value:' + options.field + '\"/>')");  //data-text-field="CategoryName" data-value-field="CategoryID"
				after.append(".appendTo(container).kendo"+editor+"({");
				after.append("autoBind: false,");
				after.append("dataSource: { data:[\""+editorDescriptor.replace(",","\",\"")+"\"]}});}");
			}
			
			main.append("width:"+gridColumn.getWidth());
			main.append("},");
		}

		main.append("]," );  //end of columns
	}

	private void createDataSource(){
	
//		String crudServiceBaseUrl="*:{url:\"http://192.6.2.108:8080/miniataweb/cliviagrid/"+gridInfo.getGridDaoName()+
//				"/*\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},";

		String crudServiceBaseUrl="*:{url: 'http://'+window.location.host"+"+'/miniataweb/cliviagrid/"+gridInfo.getGridDaoName()+
				"/*',type:'post',dataType: 'json',contentType:'application/json'},";
			
		//create filter variable for javascript
		String dataFilter="";
		
		if(filter!=null && !filter.isEmpty()){
			dataFilter=createFilter(filter);
			main.append("var "+name+"Filter="+dataFilter+";");
		}
		
		main.append("var "+name+"DataSource=new kendo.data.DataSource({");

		main.append("transport:{");

		main.append(crudServiceBaseUrl.replace("*", "read"));
		main.append(crudServiceBaseUrl.replace("*", "update"));		
		main.append(crudServiceBaseUrl.replace("*", "create"));
		main.append(crudServiceBaseUrl.replace("*", "destroy"));

		//System.out.println("crudServiceBaseUrl:"+ crudServiceBaseUrl.replace("*", "read"));

		main.append("parameterMap: function(options, operation) {"
						+"if (operation === \"read\"){"
						+ 	"return JSON.stringify(options);"
						+ 	"} else {"
						+ 	"return JSON.stringify(options.models);}}"
					+"},");
		
		main.append("error: function (e) {alert(\"Status:\" + e.status + \"; Error message: \" + e.errorThrown);},");

		/*creat filter
		 *  
		 */
		if(!dataFilter.isEmpty())
			main.append("filter:" +dataFilter+",");

		/*create sort descriptor
		 * 
		 */
		String gridSortDescrptor=gridInfo.getGridSortDescriptor()==null?"":(gridInfo.getGridSortDescriptor());
		if(!gridSortDescrptor.isEmpty()){
			String[] sorters=gridSortDescrptor.split(";");
			main.append("sort:[");
			for(String sorter:sorters){
				String[] items=sorter.split(",");
				main.append("{ field:\""+items[0]+"\",dir:\""+items[1]+"\" },");
			}
			main.append("],");
		}

		main.append("batch:true,");
		main.append("pageSize:"+gridInfo.getGridPageSize()+",");
		main.append("serverPaging: true,");
		main.append("serverFiltering: true,");
		main.append("serverSorting: true,");

		main.append("schema:{ data:\"data\", total:\"total\",model:{id:\"id\",fields:{");	
		for(GridColumn gridColumn:gridColumnList){
			main.append(gridColumn.getColumnName()+": { ");
			main.append("type:\""+gridColumn.getColumnDataType()+"\",");
			main.append("editable:"+gridColumn.isColumnEditable()+"},");
		}
		main.append("}}}});");
		
	} //end of dataSource
	
	private void enableShowLineNo(){
		before.append(" "+name+"LineNo=0;");
		main.append("dataBinding: function() { "+name+"LineNo = (this.dataSource.page() -1) * this.dataSource.pageSize();},");	
	}
	
	private void createToolbar(){
		
		main.append("toolbar: [");

		main.append("{name:\"create\",text:\"Add\"},");
		main.append("{name:\"save\",text:\"Save\"},");
		main.append("{name:\"cancel\",text:\"Cancel\"},"); 
		
		main.append("{name:\"destroy\",text:\"Delete\"},");
		
		//e.preventDefault();
		after.append("$('#"+name+" .k-grid-toolbar a.k-grid-delete').click(function (e) {e.preventDefault();"+
							"var selectedItem="+name+"KendoGrid.dataItem("+name+"KendoGrid.select());"+
							"if (selectedItem!==null) { "+
								"if (confirm('Please confirm to delete the selected row.')){"
										+ name+"DataSource.remove(selectedItem);}"+
							"}else{"+
								"alert('Please select a  row to delete.');"+
							"}"+
							
							"});");	

		
		main.append("{template: '<a class=\"k-button\"  onclick=\"on"+name+"ClickChooseCommand()\">Choose Columns</a>'}");
		
		after.append("on"+name+"ClickChooseCommand=function () { "+
				"var selectedRow="+name+"KendoGrid.select();"+
				"var selected= "+name+"KendoGrid.dataItem(selectedRow);"+
				" if(selected!=null){"+			   
				"alert('Toolbar command is clicked!'+selected.id);"+
			  	"} else { "+
				"alert('Toolbar command is clicked!');}"+
				"};");

		main.append("],"); //end of creating toolbar
	}

/* create filter from tag's filter attribute:
 * format:
			filter: {  <---need append from outside of this function
			    logic: "and",
			    filters: [
			      { field: "category", operator: "eq", value: "Food" },
			      { field: "name", operator: "eq", value: "Tea" }
			    ]
			  }        <---need append from outside of this function
*/ 
	
	private String createFilter(String filter) {
		StringBuilder sb=new StringBuilder();
		String[] filters=filter.split(";");
		sb.append("[");
		for(String entry:filters){
			String[] items=entry.split(",");
			sb.append("{ field: \""+items[0]+"\", operator: \""+items[1]+"\",value: "+items[2]+"},");
		}
		sb.append("]");
		return sb.toString();
	}
	
} 