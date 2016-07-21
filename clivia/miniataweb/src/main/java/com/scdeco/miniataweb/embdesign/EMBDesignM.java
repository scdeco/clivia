package com.scdeco.miniataweb.embdesign;

public class EMBDesignM {
	private int pixelWidth;
	private int pixelHeight;
	private double width;
	private double height;
	private double startX;
	private double startY;
	private double left;
	private double top;
	private double right;
	private double bottom;
	private int stitchCount;
	private int stepCount;
	private int trimCount;
	private EMBDesignStitch[] stitchList;
	private EMBDesignStep[] stepList;
	
	public int getPixelWidth() {
		return pixelWidth;
	}
	public void setPixelWidth(int pixelWidth) {
		this.pixelWidth = pixelWidth;
	}
	public int getPixelHeight() {
		return pixelHeight;
	}
	public void setPixelHeight(int pixelHeight) {
		this.pixelHeight = pixelHeight;
	}


	public double getWidth() {
		return width;
	}
	public void setWidth(double width) {
		this.width = width;
	}
	public double getHeight() {
		return height;
	}
	public void setHeight(double height) {
		this.height = height;
	}
	public double getStartX() {
		return startX;
	}
	public void setStartX(double startX) {
		this.startX = startX;
	}
	public double getStartY() {
		return startY;
	}
	public void setStartY(double startY) {
		this.startY = startY;
	}
	public double getLeft() {
		return left;
	}
	public void setLeft(double left) {
		this.left = left;
	}
	public double getTop() {
		return top;
	}
	public void setTop(double top) {
		this.top = top;
	}
	public double getRight() {
		return right;
	}
	public void setRight(double right) {
		this.right = right;
	}
	public double getBottom() {
		return bottom;
	}
	public void setBottom(double bottom) {
		this.bottom = bottom;
	}
	public int getStitchCount() {
		return stitchCount;
	}
	public void setStitchCount(int stitchCount) {
		this.stitchCount = stitchCount;
	}
	public int getStepCount() {
		return stepCount;
	}
	public void setStepCount(int stepCount) {
		this.stepCount = stepCount;
	}
	public int getTrimCount() {
		return trimCount;
	}
	public void setTrimCount(int trimCount) {
		this.trimCount = trimCount;
	}
	public EMBDesignStitch[] getStitchList() {
		return stitchList;
	}
	public void setStitchList(EMBDesignStitch[] stitchList) {
		this.stitchList = stitchList;
	}
	public EMBDesignStep[] getStepList() {
		return stepList;
	}
	public void setStepList(EMBDesignStep[] stepList) {
		this.stepList = stepList;
	}

}
