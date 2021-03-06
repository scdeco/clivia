package com.scdeco.miniataweb.embdesign;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.IndexColorModel;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;


public class EMBDesign 
{
//	public enum FunctionCode { 9-STOP, STITCH, JUMP, BORERIN, END, CHANGECOLOR};
	final double SCREEN_DESIGN_RATIO=0.3765d;	//(1280/340)/10
	final class Stitch {
		public int stepIndex;
		public int funcCode;
		public int xCoord;
		public int yCoord;
		public int xImage;
		public int yImage;
		public int xChange;
		public int yChange;	
		
		public Stitch(){
		}
		
		public Stitch(int stepIndex,int funcCode,int xCoord,int yCoord,int xImage,int yImage,int xChange,int yChange){
			this.stepIndex=stepIndex;
			this.funcCode=funcCode;
			this.xCoord=xCoord;
			this.yCoord=yCoord;
			this.xImage=xImage;
			this.yImage=yImage;
			this.xChange=xChange;
			this.yChange=yChange;
		}
		
		//copy constructor
		public Stitch(Stitch anotherStitch){
			this.stepIndex=anotherStitch.stepIndex;
			this.funcCode=anotherStitch.funcCode;
			this.xCoord=anotherStitch.xCoord;
			this.yCoord=anotherStitch.yCoord;
			this.xImage=anotherStitch.xImage;
			this.yImage=anotherStitch.yImage;
			this.xChange=anotherStitch.xChange;
			this.yChange=anotherStitch.yChange;			
		}
		
	}
	
	final class Step{
		
		public int stepIndex;
		public int threadIndex;
		public int stitchCount;
		public int length;
		public int firstStitchIndex;
		public int lastStitchIndex;
	}
	
	
	public EMBDesign(){
		initializeEMBDesign();
	}
	
	public EMBDesign(String dstFile){
		initializeEMBDesign();
		setDstFile(dstFile);
	}
	
	private void initializeEMBDesign(){
		this.stepList=new ArrayList<Step>();

		this.ptTopLeft = new Point(0,0);
		this.ptBottomRight=new Point(0,0);
	}
	
	//generate in createStitchList()
	private ArrayList<Step> stepList;
	public ArrayList<Step> getStepList()	{
		return this.stepList;
	}

	private boolean showTrim=false;
	private int trimCount;

	private Stitch[] stitchList;
	public Stitch[] getStitchList(){
		return this.stitchList;
	}
	
	
	private String dstFile = "";
	public String getDstFile(){
		return this.dstFile;
	}
	public void setDstFile(String dstFile){
		if(this.dstFile != dstFile){
			clearDesign();
			this.dstFile = dstFile;
			createStitchList();
		}
	}
	
	private Stitch currPoint;
	private Point ptTopLeft;
	private Point ptBottomRight;
	private RandomAccessFile inFS;
	private BufferedImage rawDesignBufferedImage;
	
	public void clearDesign(){
		this.stitchList=null;
		this.stepList.clear();

		this.ptTopLeft.x = 0;
		this.ptTopLeft.y = 0;
		this.ptBottomRight.x = 0;
		this.ptBottomRight.y = 0;
		
		this.rawDesignBufferedImage = null;
		this.trimCount=0;
	}
	
	//FunctionCode { 1-STITCH, 2-JUMP,  3-STOP,4-BORERIN,  5-CHANGECOLOR,9-END} 
	private void getDSTToken(){
		byte x = 0,y = 0,z = 0;
		while ( x == 0 && y == 0 && z == 0)
		{
			try {
				x = this.inFS.readByte();
				y = this.inFS.readByte();
				z = this.inFS.readByte();
			} catch (IOException e) {
				e.printStackTrace();
				z = (byte) 0XF3;
			} 
		}
		
		if (z == (byte)0XF3){
			this.currPoint.funcCode = 9;	//FunctionCode.END;
			this.stepList.add(new Step());
			return;
		}
		
		int xChange = -9*((x>>3)&1)+9*((x>>2)&1)-((x>>1)&1)+(x&1)
				-27*((y>>3)&1)+27*((y>>2)&1)-3*((y>>1)&1)+3*(y&1)-81*((z>>3)&1)+81*((z>>2)&1);
		int yChange = -9*((x>>4)&1)+9*((x>>5)&1)-((x>>6)&1)+((x>>7)&1)
				-27*((y>>4)&1)+27*((y>>5)&1)-3*((y>>6)&1)+3*((y>>7)&1)-81*((z>>4)&1)+81*((z>>5)&1);
		
		this.currPoint.xChange = xChange;
		this.currPoint.yChange = yChange;
		this.currPoint.xCoord += xChange;
		this.currPoint.yCoord += yChange;
		
		this.currPoint.stepIndex = stepList.size();
		switch(z&0XC3){
			case 0X03:
				this.currPoint.funcCode = 1;		//FunctionCode.STITCH;
				break;
			case 0X83:
				this.currPoint.funcCode = 2;    	//FunctionCode.JUMP;
				break;
			case 0XC3:
				this.currPoint.funcCode =3;			//FunctionCode.STOP;
				this.stepList.add(new Step());
				break;
			case 0X43:
				this.currPoint.funcCode =4;			// FunctionCode.BORERIN;
				break;
			default:
				break;
		}
	}
	

	public void createStitchList(){
		if (this.dstFile.trim() == "") {return;}
		clearDesign();
		int stitchCount = 0;
		try{
			this.inFS = new RandomAccessFile(dstFile,"r");
			stitchList = new Stitch[(int)((this.inFS.length()-512-1)/3)+1];
			this.currPoint=new Stitch(); 
			this.inFS.seek(512);			
			for (getDSTToken(); currPoint.funcCode !=9 ; getDSTToken()){			//FunctionCode.END
				
				if (this.currPoint.xCoord < this.ptTopLeft.x) this.ptTopLeft.x = this.currPoint.xCoord;
				if (this.currPoint.yCoord > this.ptTopLeft.y) this.ptTopLeft.y = this.currPoint.yCoord;
				if (this.currPoint.xCoord > this.ptBottomRight.x) this.ptBottomRight.x = this.currPoint.xCoord;
				if (this.currPoint.yCoord < this.ptBottomRight.y) this.ptBottomRight.y = this.currPoint.yCoord;
				stitchList[stitchCount++] = new Stitch(currPoint);
			}
			
			int consecutiveJumpCount=0;
			int stepIndex = 0;
			stepList.get(stepIndex).firstStitchIndex = 0;
			for (int i = 0; i < stitchCount; i++){
				Stitch st=stitchList[i];
				st.xImage = st.xCoord - this.ptTopLeft.x;
				st.yImage = this.ptTopLeft.y - st.yCoord;
				if(st.stepIndex != stepIndex)
				{
					Step rs=stepList.get(stepIndex);
					rs.lastStitchIndex = i -1;
					rs.stitchCount = rs.lastStitchIndex -rs.firstStitchIndex+1;
					rs.stepIndex=stepIndex;
					
					stepIndex = st.stepIndex;
					stepList.get(stepIndex).firstStitchIndex = i;
				}
				
				if(st.funcCode==2)			//Jump
					consecutiveJumpCount++;
				else
				{
					if(consecutiveJumpCount>=5)
						trimCount++;
					consecutiveJumpCount=0;
				}
			}
			trimCount++;
			stepList.get(stepIndex).stepIndex=stepIndex;
			stepList.get(stepIndex).lastStitchIndex = stitchCount - 1;
			stepList.get(stepIndex).stitchCount = stepList.get(stepIndex).lastStitchIndex - stepList.get(stepIndex).firstStitchIndex;
			
			//if first Jump titches more than 5 , remove the count
			consecutiveJumpCount=0;
			for(int i=0;i<6;i++)
				if(stitchList[i].funcCode==2)
					consecutiveJumpCount++;
			if(consecutiveJumpCount>=5)
				trimCount--;
			trimCount=trimCount+stepList.size()-1;
				
		}
		catch(IOException e){
			System.out.println("Error file reading.");
			e.printStackTrace();
		}
		finally{
			if (this.inFS != null)
				try {
					this.inFS.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
	}
	
	//if provided colorway is null, generate a rawIndexColorModel 
	private IndexColorModel createIndexColorModel(Colorway colorway){

		int size=getStepCount()+1;

		byte[] r=new byte[size];
		byte[] g=new byte[size];
		byte[] b=new byte[size];
		
		if(colorway!=null){
			Color color=colorway.getThreadColor(0);
			int i=0;
			do{
				r[i]=(byte)color.getRed(); 
				g[i]=(byte)color.getGreen();
				b[i]=(byte)color.getBlue();
				if(++i<size)
					color=colorway.getStepColor(i-1);
				else
					break;
			} while (true);
		}
		else{
			for (byte i=0;i<size;i++){
				r[i]=i;g[i]=i;b[i]=i;
			}
		}
		
		return new IndexColorModel(8,size,r,g,b);
	}

	//if color==null, the g2d is colorindexmode, image is raw image data, otherwise image is real color
	public void drawStep(Step step,Graphics2D g2d,Color color){
		
		int stepIndex=step.stepIndex+1;
		Color threadColor=color==null?new Color(stepIndex,stepIndex,stepIndex):color;
		g2d.setColor(threadColor);
		
		Stitch currStitch;
		Stitch prevStitch=stitchList[step.firstStitchIndex];
		
//Draw dotted line for jump 		
//		float[] dash1 = {2f,0f,2f};		
//		BasicStroke bs1 = new BasicStroke(1,BasicStroke.CAP_BUTT,BasicStroke.JOIN_ROUND,1.0f,dash1,2f);
//		BasicStroke bs2 = new BasicStroke(1,BasicStroke.CAP_BUTT,BasicStroke.JOIN_ROUND);

//		g2d.setStroke(bs2);
		boolean prevStitchIsJump=true;
		Shape line=null;
		
		for(int i=step.firstStitchIndex+1;i<=step.lastStitchIndex;i++){
			currStitch=stitchList[i];
			
			//FunctionCode.JUMP||FunctionCode.STOP
			
			if(currStitch.funcCode==1){
				if(prevStitchIsJump){
					if (showTrim){
//						g2d.setStroke(bs1);
						line=new Line2D.Double(prevStitch.xImage*SCREEN_DESIGN_RATIO,prevStitch.yImage*SCREEN_DESIGN_RATIO,currStitch.xImage*SCREEN_DESIGN_RATIO,currStitch.yImage*SCREEN_DESIGN_RATIO);
						g2d.draw(line);
//						g2d.drawLine((int)(prevStitch.xImage*SCREEN_DESIGN_RATIO),(int)(prevStitch.yImage*SCREEN_DESIGN_RATIO),(int)(currStitch.xImage*SCREEN_DESIGN_RATIO),(int)(currStitch.yImage*SCREEN_DESIGN_RATIO));
//						g2d.setStroke(bs2);
					}
					prevStitchIsJump=false;
				}else{
//					g2d.drawLine((int) (prevStitch.xImage*SCREEN_DESIGN_RATIO),(int) (prevStitch.yImage*SCREEN_DESIGN_RATIO),(int) (currStitch.xImage*SCREEN_DESIGN_RATIO),(int) (currStitch.yImage*SCREEN_DESIGN_RATIO));
					line=new Line2D.Double(prevStitch.xImage*SCREEN_DESIGN_RATIO,prevStitch.yImage*SCREEN_DESIGN_RATIO,currStitch.xImage*SCREEN_DESIGN_RATIO,currStitch.yImage*SCREEN_DESIGN_RATIO);
					g2d.draw(line);
				}
			}else{
				prevStitchIsJump=true;
			}
			prevStitch=currStitch;
		}
	
	}
	
	//if colorway is null, draw BufferedImage.TYPE_BYTE_INDEXED to rawDesignBufferedImage, otherwaise draw design with provided colorway 
	public BufferedImage drawDesign(Colorway colorway){
		if (getStitchCount() == 0) return null;

		int width = getDesignWidthInPixel();
		int height = getDesignHeightInPixel();
		BufferedImage bi=null;
		Color bgColor=null;
		
		if(colorway==null){
			bi = new BufferedImage(width,height,BufferedImage.TYPE_BYTE_INDEXED,createIndexColorModel(null));
			bgColor=new Color(0,0,0);
		}else{
			bi= new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
			bgColor=new Color(255,255,255);
		}
		
		Graphics2D g2d =bi.createGraphics();
		g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,   RenderingHints.VALUE_ANTIALIAS_ON);
		g2d.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);

		g2d.setBackground(bgColor);
		g2d.clearRect(0, 0, width, height);
		
		if(colorway==null)
			for(Step step:stepList)
				drawStep(step,g2d,null);
		else{
			for(Step step:stepList){
				Color color=colorway.getStepColor(step.stepIndex);
				drawStep(step,g2d,color);
			}
		}
			
		return bi;
	}
	
	public byte[] getRawImageData(){
		if(rawDesignBufferedImage==null)
			rawDesignBufferedImage=drawDesign(null);
		 byte[] pixels = ((DataBufferByte) rawDesignBufferedImage.getRaster().getDataBuffer()).getData();
		 return pixels;
	}
	
	public BufferedImage getEMBDesignRawImage(){
		if(rawDesignBufferedImage==null)
			rawDesignBufferedImage=drawDesign(null);
		return rawDesignBufferedImage;
	}
	
	
	public EMBDesignM getEMBDesignM(){
		EMBDesignM emb=new EMBDesignM();
		emb.setPixelWidth(getDesignWidth());
		emb.setPixelHeight(getDesignHeight());
		emb.setWidth(getDesignWidthInMM());
		emb.setHeight(getDesignHeightInMM());
		emb.setStartX(getStartXInMM());
		emb.setStartY(getStartYInMM());
		emb.setLeft(getDesignLeftInMM());
		emb.setTop(getDesignTopInMM());
		emb.setRight(getDesignRightInMM());
		emb.setBottom(getDesignBottomInMM());
		
		emb.setStitchCount(getStitchCount());
		emb.setStepCount(getStepCount());
		emb.setTrimCount(getTrimCount());
		
		EMBDesignStitch[] embStitches=new EMBDesignStitch[getStitchCount()];
		
		for(int i=0;i<getStitchCount()-3;i++){
			EMBDesignStitch embStitch=new EMBDesignStitch();
			Stitch stitch=this.stitchList[i];
			if(stitch!=null){
				embStitch.setX(stitch.xImage);
				embStitch.setY(stitch.yImage);
				embStitch.setF(stitch.funcCode);
				embStitches[i]=embStitch;
			}
		}
		
		emb.setStitchList(embStitches);
		
		EMBDesignStep[] embSteps=new EMBDesignStep[getStepCount()];
		
		int i=0;
		for(Step step:stepList){
			EMBDesignStep embStep=new EMBDesignStep(); 
			embStep.setFirstStitch(step.firstStitchIndex);
			embStep.setLastStitch(step.lastStitchIndex);
			embStep.setIndex(i);
			embSteps[i]=embStep;
			i++;
		}
		emb.setStepList(embSteps); 
		return emb;
	}
		
	//get design image with provided colorway
	public BufferedImage getEMBDesignImage(boolean fromRawImage,Colorway colorway){
		BufferedImage bi=null;
		if(fromRawImage){
			IndexColorModel indexColorModel=createIndexColorModel(colorway);
			if(rawDesignBufferedImage==null)
				rawDesignBufferedImage=drawDesign(null);
			bi=new BufferedImage(indexColorModel,rawDesignBufferedImage.getRaster(),false,null);
		}else{
			if(colorway==null)
				colorway=new Colorway(getStepCount());
			bi=drawDesign(colorway);
		}
		return bi;
	}
	
	//get design image with default threads and runningstepList
	public BufferedImage getEMBDesignImage(boolean fromRawImage){
		return getEMBDesignImage(fromRawImage,new Colorway(getStepCount()));
	}
	
	//get design image with privided strings of threads and runnng steps
	public BufferedImage getEMBDesignImage(boolean fromRawImage,String threads,String runningsteps){
		return getEMBDesignImage(fromRawImage,new Colorway(threads,runningsteps));
	}

	
	public int getStitchCount(){
		return 	this.stitchList==null?0:this.stitchList.length;
	}
	
	public int getStepCount(){
		return this.stepList == null?0:stepList.size();
	}

	public int getTrimCount(){
		return this.trimCount;
	}
	
	public int getDesignHeight(){
		return getStitchCount()==0? 0 : ptTopLeft.y-ptBottomRight.y +1;
	}
	
	public int getDesignWidth(){
		return getStitchCount()==0 ? 0 : ptBottomRight.x-ptTopLeft.x+1;
	}
	
	public int getDesignWidthInPixel(){
		return (int) (getStitchCount()==0 ? 0 : getDesignWidth()*SCREEN_DESIGN_RATIO);
	}
	
	public int getDesignHeightInPixel(){
		return (int) (getStitchCount()==0? 0 : getDesignHeight()*SCREEN_DESIGN_RATIO);
	}
	
	public double getDesignHeightInMM(){
		return getStitchCount()==0? 0 : (double)getDesignHeight()/10.0d;
	}
	
	public double getDesignWidthInMM(){
		return getStitchCount()==0 ? 0 : (double)getDesignWidth()/10.0d;
	}
	
	public double getStartXInMM(){
		return getStitchCount() == 0 ? 0 : ((double)(stitchList[0].xImage) 
				- Math.abs((double)(ptBottomRight.x - ptTopLeft.x))/2.0d)/10.0d;
	}
	
	public double getStartYInMM(){
		return getStitchCount() == 0 ? 0 : ((double)(stitchList[0].yImage) 
				- Math.abs((double)(ptBottomRight.y - ptTopLeft.y))/2.0d)/10.0d;
	}
	
	public double getDesignLeftInMM(){
		return getStitchCount() == 0 ? 0 : Math.abs((double)ptTopLeft.x)/10.0d;
	}
	
	public double getDesignTopInMM()	{
		return getStitchCount() == 0 ? 0 : Math.abs((double)ptTopLeft.y)/10.0d;
	}
	
	public double getDesignRightInMM(){
		return getStitchCount() == 0 ? 0 : Math.abs((double)ptBottomRight.x)/10.0d;
	}
	
	public double getDesignBottomInMM(){
		return getStitchCount() == 0 ? 0 : Math.abs((double)ptBottomRight.y)/10.0d;
	}
	
	
}
