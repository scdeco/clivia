package com.scdeco.miniatarcp.cmd;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.handlers.HandlerUtil;

import com.scdeco.miniatarcp.editor.UserEditor;
import com.scdeco.miniatarcp.editor.UserEditorInput;

public class UserCommand extends AbstractHandler {
	
	public static final String ID="com.scdeco.miniatarcp.cmd.user";

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
        IWorkbenchWindow window = HandlerUtil.getActiveWorkbenchWindow(event);
        IWorkbenchPage page = window.getActivePage();
  
        UserEditorInput input = new UserEditorInput();
        try {
            page.openEditor(input, UserEditor.ID);
        } catch (PartInitException e) {
            System.out.println("Error:" + this.getClass().getName() + ":" + e);
            e.printStackTrace();
            throw new ExecutionException("Error open UserEditor");
        }
		return null;
	}

}
