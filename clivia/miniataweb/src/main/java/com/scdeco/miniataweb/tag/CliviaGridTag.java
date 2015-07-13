package com.scdeco.miniataweb.tag;

import java.io.IOException;
import java.util.ArrayList;
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
 
	@Override
	public void doTag() throws JspException, IOException {
		String prefix;
		List<String> editorList=new ArrayList<String>();
		String dataFilter="";
		
		PageContext pageContext = (PageContext) this.getJspContext(); 
		ServletContext servletContext = pageContext.getServletContext(); 
		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext); 
	
		gridInfoDao=(GridInfoDao)wac.getBean("gridInfoDao");
		gridColumnDao=(GridColumnDao)wac.getBean("gridColumnDao");
		
	    JspWriter out = getJspContext().getOut();
	    StringBuilder sb=new StringBuilder();
	    
	    if(gridno!=null){

	    	GridInfo gridInfo=gridInfoDao.findByGridNo(gridno);
			List<GridColumn> gridColumnList=gridColumnDao.findColumnListByGridId(gridInfo.getId());

			String crudServiceBaseUrl="*:{url:\"http://192.6.2.108:8080/miniataweb/cliviagrid/"+gridInfo.getGridDaoName()+
					"/*\",type:\"post\",dataType: \"json\",contentType:\"application/json\"},";
			
//			sb.append( "<script> $(document).ready(function() {");


			//create filter variable for javascript
			if(filter!=null && !filter.isEmpty()){
				dataFilter=createFilter(filter);
				sb.append("var "+name+"Filter="+dataFilter+";");
			}
			
sb.append("var "+name+"DataSource=new kendo.data.DataSource({");

sb.append("transport:{");

sb.append(crudServiceBaseUrl.replace("*", "read"));
sb.append(crudServiceBaseUrl.replace("*", "update"));		
sb.append(crudServiceBaseUrl.replace("*", "create"));
sb.append(crudServiceBaseUrl.replace("*", "destroy"));
//System.out.println("crudServiceBaseUrl:"+ crudServiceBaseUrl);

//System.out.println("crudServiceBaseUrl:"+ crudServiceBaseUrl.replace("*", "read"));

sb.append("parameterMap: function(options, operation) {"
				+"if (operation === \"read\"){"
				+ 	"return JSON.stringify(options);"
				+ 	"} else {"
				+ 	"return JSON.stringify(options.models);}}"
			+"},");
sb.append("error: function (e) {alert(\"Status:\" + e.status + \"; Error message: \" + e.errorThrown);},");

/*creat filter
 *  
 */
if(!dataFilter.isEmpty())
	sb.append("filter:" +dataFilter+",");

/*create sort descriptor
 * 
 */
String gridSortDescrptor=gridInfo.getGridSortDescriptor()==null?"":(gridInfo.getGridSortDescriptor());
if(!gridSortDescrptor.isEmpty()){
	String[] sorters=gridSortDescrptor.split(";");
	sb.append("sort:[");
	prefix="";
	for(String sorter:sorters){
		String[] items=sorter.split(",");
		sb.append(prefix+"{ field:\""+items[0]+"\",dir:\""+items[1]+"\" }");
		prefix=",";
	}
	sb.append("],");
}

sb.append("batch:true,");
sb.append("pageSize:"+gridInfo.getGridPageSize()+",");
sb.append("serverPaging: true,");
sb.append("serverFiltering: true,");
sb.append("serverSorting: true,");
sb.append("schema:{ data:\"data\", total:\"total\",model:{id:\"id\",fields:{");	
prefix="";
for(GridColumn gridColumn:gridColumnList){
	sb.append(prefix+gridColumn.getColumnName()+": { ");
	sb.append("type:\""+gridColumn.getColumnDataType()+"\",");
	sb.append("editable:"+gridColumn.isColumnEditable()+"}");
	prefix=",";
}
sb.append("}}}});");

//end of dataSource

//create kendogrid
sb.append("var "+name+"=$(\"#"+name+"\").kendoGrid({");
sb.append("dataSource:"+name+"DataSource,");
sb.append("selectable: true,");
sb.append("navigatable: true,");
sb.append("resizable: "+gridInfo.isColumnResizable()+",");
sb.append("reorderable: "+gridInfo.isColumnMovable()+",");
sb.append("pageable: "+(gridInfo.getGridPageSize()>0?"true":"false")+",");
sb.append("toolbar: [\"create\", \"save\", \"cancel\"],");
sb.append("columns:[");

for(GridColumn gridColumn:gridColumnList){
	sb.append("{");
	sb.append("field:\""+gridColumn.getColumnName()+"\",");
	sb.append("title:\""+gridColumn.getTitle()+"\",");
	if(!gridColumn.isColumnVisible())
		sb.append("hidden: true,");
	if(gridColumn.isColumnLocked())
		sb.append("locked: true,");
	if(gridColumn.isColumnLockable())
		sb.append("lockable: true,");
	if(gridColumn.getDisplayFormat()!=null&&!gridColumn.getDisplayFormat().isEmpty())
		sb.append("format: \""+gridColumn.getDisplayFormat()+"\",");
	if("boolean".equals(gridColumn.getColumnDataType())){
		
		String s="template:\"<input type='checkbox' disabled='disabled' value='#= "
				+gridColumn.getColumnName()+" #' #= "+gridColumn.getColumnName()+" ? 'checked=\\\\'checked\\\\'' : '' # />\",";
//		System.out.println(s);
		sb.append(s);
	}
	
	String editorDescription=gridColumn.getComboList();
	if(editorDescription!=null&&!editorDescription.isEmpty()){
//       	 System.out.println("test============"+editorDescription);

		String[] elements=editorDescription.split(":");
//      	 System.out.println("elements============"+elements[0]+"==="+elements[1]);
		if("dropdownlist".equalsIgnoreCase(elements[0])){
//	       	 System.out.println("elements============"+elements[1]);
			String editorName=gridColumn.getColumnName()+"ColumnEditor";
			sb.append("editor:"+editorName+",");
			StringBuilder eb=new StringBuilder();
			eb.append("function "+editorName+"(container, options) {");
            eb.append("$('<input class=\"grid-editor\" style=\"{height: 16px;font-size: 12px; padding: 1px;}\" required  data-bind=\"value:' + options.field + '\"/>')");  //data-text-field="CategoryName" data-value-field="CategoryID"
            eb.append(".appendTo(container).kendoDropDownList({");
            eb.append("autoBind: false,");
            eb.append("dataSource: { data:[\""+elements[1].replace(",","\",\"")+"\"]}});}");
            editorList.add(eb.toString());
            
 //           System.out.println(eb);
		}
		
	}
	sb.append("width:"+gridColumn.getWidth());
	sb.append("},");
}


sb.append("{ command:\"destroy\", title:\"&nbsp;\"}]," );
sb.append("editable:true");
sb.append("});");
//sb.append("});");

for(String editor:editorList)
	sb.append(editor);


//sb.append("</script>");

/*
sb.append("<style>");

//adjust height of grid's header and rows
sb.append("div.k-grid td,th{line-height: 25px;font-size: 12px; padding: 1px 5px; white-space: nowrap;}");
 
//adjust button size, such as buttons in grid toolbar
sb.append(".k-button{ font-size: 12px; padding: 1px 5px; }");

sb.append(".k-grid-pager{font-size:12px; height: 15px;}");
sb.append(".k-pager-nav, .k-pager-info {padding:1px;  vertical-align: text-top;}");
sb.append(".k-pager-numbers {transform:scale(0.7,0.7);}");
sb.append("</style>");
*/
System.out.println(sb.toString());
	    out.println(sb.toString());
	  }
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
		String prefix="";
		for(String entry:filters){
			String[] items=entry.split(",");
			sb.append(prefix+"{ field: \""+items[0]+"\", operator: \""+items[1]+"\",value: "+items[2]+"}");
			prefix=",";
		}
		sb.append("]");
		return sb.toString();
	}
	
} 