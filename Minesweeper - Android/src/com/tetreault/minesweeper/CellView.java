package com.tetreault.minesweeper;

import java.util.ArrayList;

import android.view.GestureDetector;
import android.view.MotionEvent;
import android.content.Context;
import android.graphics.Color;
import android.support.v4.view.GestureDetectorCompat;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

public class CellView extends TextView implements GestureDetector.OnGestureListener, GestureDetector.OnDoubleTapListener {
	
	private static final String TAG = "Minesweeper";
	private Boolean isMine;
	private Boolean isFlag;
	private Boolean isDiscovered;
	private int numberOfMinesNear;
	private int iIndex;
	private int jIndex;
	private ArrayList<CellView> adjacentCells;
    GestureDetector gestureDetector;
	GameActivity mainInstance;

	public CellView(Context context, int x, int y, GameActivity instance) {
		super(context);
		// TODO Auto-generated constructor stub
		this.setX(x);
		this.setY(y);
		this.setBackgroundResource(R.drawable.border);
		this.gestureDetector = new GestureDetector(context, this);		
		this.mainInstance = instance;
		//Log.v(TAG, "CellView created");
	}


	public Boolean getIsMine() {
		return isMine;
	}


	public void setIsMine(Boolean isMine) {
		this.isMine = isMine;
	}


	public Boolean getIsFlag() {
		return isFlag;
	}


	public void setIsFlag(Boolean isFlag) {
		this.isFlag = isFlag;
	}


	public Boolean getIsDiscovered() {
		return isDiscovered;
	}


	public void setIsDiscovered(Boolean isDiscovered) {
		this.isDiscovered = isDiscovered;
	}


	public int getNumberOfMinesNear() {
		return numberOfMinesNear;
	}


	public void setNumberOfMinesNear(int numberOfMinesNear) {
		this.numberOfMinesNear = numberOfMinesNear;
	}


	public ArrayList<CellView> getAdjacentCells() {
		return adjacentCells;
	}


	public void setAdjacentCells(ArrayList<CellView> adjacentCells) {
		this.adjacentCells = adjacentCells;
	}


	public int getiIndex() {
		return iIndex;
	}


	public void setiIndex(int iIndex) {
		this.iIndex = iIndex;
	}


	public int getjIndex() {
		return jIndex;
	}


	public void setjIndex(int jIndex) {
		this.jIndex = jIndex;
	}
	
    @Override 
    public boolean onTouchEvent(MotionEvent event){ 
        
    	return this.gestureDetector.onTouchEvent(event);
        // Be sure to call the superclass implementation
		//Log.v(TAG, "OnTouchEvent called");

        //return super.onTouchEvent(event);
    }

	@Override
	public boolean onSingleTapConfirmed(MotionEvent e) {
		// TODO Auto-generated method stub
		
		if (this.getText().equals(" ")){
			this.setText("F");
		} else if (this.getText().equals("F")){
			this.setText(" ");
		}
		return true;
	}


	@Override
	public boolean onDoubleTap(MotionEvent e) {
		
		if (this.getIsMine()){
			this.mainInstance.showAllMines();
			this.setBackgroundColor(Color.RED);
			
		} else if (this.numberOfMinesNear > 0){
			
            this.setText((String.valueOf(this.numberOfMinesNear)));
			
	        switch (this.numberOfMinesNear) {
            case 1:
            	this.setTextColor(Color.BLUE);
                break;
            case 2:
            	this.setTextColor(Color.GREEN);
                break;
            case 3:
            	this.setTextColor(Color.RED);
                break;
            case 4:
            	this.setTextColor(Color.MAGENTA);
                break;
            case 5:
            	this.setTextColor(Color.YELLOW);
                break;
            case 6:
            	this.setTextColor(Color.CYAN);
                break;
            default:
            	this.setTextColor(Color.BLACK);
                break;
	        }
	        this.setBackgroundColor(Color.GRAY);
	        this.setIsDiscovered(true);
			
		} else {
			this.mainInstance.DFSFromCell(this);
		}
		
		this.mainInstance.checkIfWinner();
		
		Log.v(TAG, "OnDoubleTap");
		
		return true;
	}


	@Override
	public boolean onDoubleTapEvent(MotionEvent e) {
		// TODO Auto-generated method stub
		return true;
	}


	@Override
	public boolean onDown(MotionEvent e) {
		// TODO Auto-generated method stub
		return true;
	}


	@Override
	public void onShowPress(MotionEvent e) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public boolean onSingleTapUp(MotionEvent e) {		
		return true;
	}


	@Override
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
			float distanceY) {
		// TODO Auto-generated method stub
		return true;
	}


	@Override
	public void onLongPress(MotionEvent e) {
		// TODO Auto-generated method stub
	}


	@Override
	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY) {
		// TODO Auto-generated method stub
		return true;
	}




}
