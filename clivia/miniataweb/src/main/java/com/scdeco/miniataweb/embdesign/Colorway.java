package com.scdeco.miniataweb.embdesign;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

import com.scdeco.miniataweb.util.CliviaUtils;

public class Colorway {
	
	public static final String Colourway_Seperator = "[+\\-*/.:;,]";	//+-*/.:;,
	public static final int Max_Thread_Number = 15;
	public static Color backgroundColor=Color.WHITE;
	
	public Colorway(String threads,String runningSteps){
		setThreads(threads);
		setRunningSteps(runningSteps);
	}
	
	public Colorway(int stepCount){
		if (stepCount>0){
			setThreads(""); 
			setRunningSteps(getDefaultRunningSteps(stepCount));
		}

	}
	
	private String getDefaultRunningSteps(int stepCount){
		String runningSteps = "";
		for(int step=0;step<stepCount;step++)
			runningSteps+= "-"+(step%Max_Thread_Number+1);
		runningSteps=runningSteps.substring(1);
		return runningSteps;
	}
	
	String runningSteps;
	//value of runningStepList is colorIndex of threadList
	int[] runningStepList;

	//comma seperated threads code string: S1043,S1026
	String threads;
	List<EmbroideryThread> threadList;
	
	public String getRunningSteps(){
		return this.runningSteps;
	}

	public void setRunningSteps(String runningSteps){
		this.runningSteps=normalizeRunningSteps(runningSteps);
		setRunningStepList();
	}

	private void setRunningStepList() {
		if (!runningSteps.isEmpty()){
			String[] stepList = this.runningSteps.split(Colourway_Seperator);
			runningStepList=new int[stepList.length];
			for(int i=0;i<stepList.length;i++){
				runningStepList[i]=Integer.parseInt(stepList[i]);
			}
		}
		else
			runningStepList=null;
	}
	
	public int getRunningStepCount(){
		return runningStepList==null?0:runningStepList.length;
	}

	public String getThreads(){
		return this.threads;
	}
	
	public void setThreads(String threads){
		this.threads=normalizThreads(threads);
		setThreadList();
	}
	
	private void setThreadList(){
		
		threadList=threads.isEmpty()?getDefaultThreadList():EMBThreadChart.getEmbroideryThreadList(threads);
	}
	
	public int getThreadCount(){
		return threadList==null?0:threadList.size();
	}
	
	//get thread color of the designated step
	public Color getStepColor(int stepIndex){
		return getThreadColor(runningStepList[stepIndex]);
	}
	
	//get thread color from threadList
	public Color getThreadColor(int colorIndex){
		return threadList.get(colorIndex).getColor();
	}
	
	public static List<EmbroideryThread> getDefaultThreadList(){
		List<EmbroideryThread> defaultThreadList=new ArrayList<EmbroideryThread>();
		defaultThreadList.add(new EmbroideryThread("", backgroundColor));
		defaultThreadList.add(new EmbroideryThread("", new Color(0,255,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(0,0,255)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,0,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,255,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(0,255,255)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,0,255)));
		defaultThreadList.add(new EmbroideryThread("", new Color(0,153,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(0,0,153)));
		defaultThreadList.add(new EmbroideryThread("", new Color(153,0,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,153,51)));
		defaultThreadList.add(new EmbroideryThread("", new Color(153,0,0)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,153,51)));
		defaultThreadList.add(new EmbroideryThread("", new Color(153,0,204)));
		defaultThreadList.add(new EmbroideryThread("", new Color(153,102,51)));
		defaultThreadList.add(new EmbroideryThread("", new Color(255,126,204)));
		defaultThreadList.add(new EmbroideryThread("", new Color(28,176,193)));
		defaultThreadList.add(new EmbroideryThread("", new Color(112,56,56)));
		return defaultThreadList;
	};
	
	public static String normalizThread(String thread){
		String result="";
		if(!CliviaUtils.isBlank(thread)){
			thread=thread.trim().toUpperCase();
			String firstLetter=thread.substring(0, 1);
			if("MS6".contains(firstLetter))
				thread=thread.substring(1);
			else
				firstLetter="S";
			int i=CliviaUtils.parseInt(thread);
			if(i>0)
				result=firstLetter+CliviaUtils.right("0000"+i,4);
		}
		return result;
	}
	
	
	public static String normalizThreads(String strThreads){
		String result="";
		if(!CliviaUtils.isBlank(strThreads)){
			String[] threads=strThreads.split(",");
			for(String thread:threads)
				result+=","+thread;
		}
		
		if(result!="")
			result=result.substring(1);
		return result;
	}
	
	public static String normalizeRunningSteps(String runningSteps){
		String result="";
		if(runningSteps.trim()!= ""){
			String[] steps = runningSteps.split(Colourway_Seperator);
			for(String step : steps)
				result += "-" + CliviaUtils.parseInt(step);		//Ints.tryParse(s);
			result= (result=="")? "":result.substring(1);
		}
		return runningSteps;
	}
	
	public static Colorway getDefaultColorway(){
		return new Colorway("",""); 
	}
	
	
}
