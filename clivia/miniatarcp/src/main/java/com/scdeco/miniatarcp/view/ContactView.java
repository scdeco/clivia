package com.scdeco.miniatarcp.view;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;

public class ContactView extends ViewPart {

	public ContactView() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void createPartControl(Composite parent) {
		
		SashForm sashForm = new SashForm(parent, SWT.BORDER | SWT.SMOOTH);
		
		TabFolder tabFolder = new TabFolder(sashForm, SWT.NONE);
		
		TabItem tabItem_1 = new TabItem(tabFolder, SWT.NONE);
		tabItem_1.setText("New Item");
		
		Label lblNewLabel = new Label(tabFolder, SWT.NONE);
		tabItem_1.setControl(lblNewLabel);
		lblNewLabel.setText("New Label");
		
		TabItem tabItem = new TabItem(tabFolder, SWT.NONE);
		tabItem.setText("New Item");
		sashForm.setWeights(new int[] {1});
		// TODO Auto-generated method stub

	}

	@Override
	public void setFocus() {
		// TODO Auto-generated method stub

	}

}
