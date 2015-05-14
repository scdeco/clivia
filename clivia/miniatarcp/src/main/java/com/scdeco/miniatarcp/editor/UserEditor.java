package com.scdeco.miniatarcp.editor;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.part.EditorPart;
 
public class UserEditor extends EditorPart {
 
  public static final String ID = "com.scdeco.miniatarcp.editor.user";
  private Text txtUserName;
  private Text txtEmail;
 
  public UserEditor() {
 
  }
 
  @Override
  public void doSave(IProgressMonitor monitor) {
 
  }
 
  @Override
  public void doSaveAs() {
 
  }
 
  /**
   * Important!!!
   */
  @Override
  public void init(IEditorSite site, IEditorInput input)
          throws PartInitException {
      if (!(input instanceof UserEditorInput)) {
          throw new PartInitException("Invalid Input: Must be "
                  + UserEditorInput.class.getName());
      }
      setSite(site);
      setInput(input);
  }
 
  @Override
  public boolean isDirty() {
      return false;
  }
 
  @Override
  public boolean isSaveAsAllowed() {
      return false;
  }
 
  @Override
  public void createPartControl(Composite parent) {
      parent.setLayout(new FillLayout());
      Composite body = new Composite(parent, SWT.NONE);
      
      Label lblUserName = new Label(body, SWT.NONE);
      lblUserName.setBounds(26, 10, 70, 15);
      lblUserName.setText("User Name:");
      
      Label lblEmail = new Label(body, SWT.NONE);
      lblEmail.setBounds(26, 31, 55, 15);
      lblEmail.setText("Email:");
      
      txtUserName = new Text(body, SWT.BORDER);
      txtUserName.setBounds(112, 7, 174, 21);
      
      txtEmail = new Text(body, SWT.BORDER);
      txtEmail.setBounds(112, 31, 174, 21);
  	
  }
 
  @Override
  public void setFocus(){
	  
  }
}
