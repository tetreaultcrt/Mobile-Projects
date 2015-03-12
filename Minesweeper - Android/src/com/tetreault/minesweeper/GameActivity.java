package com.tetreault.minesweeper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.Stack;

import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.Point;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.os.Build;

public class GameActivity extends ActionBarActivity {
	
	private static final String TAG = "Minesweeper";
	private int mines[] = new int[50];
	private FrameLayout mainView;
	private int viewWidth;
	private int viewHeight;
	//private ArrayList<CellView> gameGrid;
	private CellView gameGrid[][] = new CellView[16][16];


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_game);
		mainView = (FrameLayout)findViewById(R.id.container);
		
		
		getScreenDimensions();
		getMines();
		createGame();
		markNumberOfAdjacentMines();
		

	}
	
	
	private void getScreenDimensions(){
		
		Display display = getWindowManager().getDefaultDisplay();
		Point size = new Point();
		display.getSize(size);
		viewWidth = size.x;
		Log.v(TAG, String.format("size.x %d", size.x));
		viewHeight = size.y;
		Log.v(TAG, String.format("size.y %d", size.y));

	}
	
	private void getMines(){
		Random rand = new Random();

		for(int i = 0; i < 50; i++){
	        int random = rand.nextInt(256);
	        mines[i] = random;
	    }
		
		
		
	}
	
	private void createGame(){
		int i, j;
		
		for (i=0; i < 16; i++){
			for (j=0;j < 16; j++){
				
				CellView cell = new CellView(this, i * (viewWidth/16), j * ((viewHeight - 73) /16), this);
				cell.setLayoutParams(new FrameLayout.LayoutParams(viewWidth/16, (viewHeight - 73)/16));
				((FrameLayout) mainView).addView(cell);;
				
				cell.setiIndex(i);
				cell.setjIndex(j);
				cell.setIsDiscovered(false);
				cell.setIsFlag(false);
				cell.setText(" ");
				cell.setTextSize(24);
				cell.setGravity(Gravity.CENTER);
				
				if (contains(mines, i*j +1)){
					cell.setIsMine(true);
				} else {
					cell.setIsMine(false);
				}
				
				gameGrid[i][j] = cell;
			}
		}
		
	}
	
	private boolean contains(int[] array, int value){
		
		for (int i = 0; i < array.length; i++){
			if (array[i] == value){
				return true;
			}
		}
		
		return false;	
	}
	
	public void showAllMines(){
	    
		int i, j;
	    
	    for (i = 0; i < 16; i++){
	        for (j = 0; j < 16; j++){
	            
	            CellView cell = gameGrid[i][j];
	            if (cell.getIsMine()){
	                cell.setText("M");
	            }
	            
	        }
	    }
	
	    AlertDialog alertDialog = new AlertDialog.Builder(this).create();
	    alertDialog.setTitle("You Lost!");
	    alertDialog.setMessage("Would You Like to start a new game?");
	    alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
	    public void onClick(DialogInterface dialog, int which) {
	    	
	    	resetGame();
	    	
	    }
	    });
	    alertDialog.show();
	
	
	}
	
	public void checkIfWinner(){
	    
	    int i, j;
	    
	    for (i = 0; i < 16; i++){
	        for (j = 0; j < 16; j++){
	            CellView cell = gameGrid[i][j];
	            if (!cell.getIsDiscovered()){
	                return;
	            }
	        }
	    }
	    
	    AlertDialog alertDialog = new AlertDialog.Builder(this).create();
	    alertDialog.setTitle("You Won!");
	    alertDialog.setMessage("Would You Like to start a new game?");
	    alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
	    public void onClick(DialogInterface dialog, int which) {
	    	
	    	resetGame();
	    	
	    }
	    });
	    alertDialog.show();	    
	    
	}
	
	public void resetGame(){
		
		this.mines = new int[50];
		
		getMines();
		createGame();
		markNumberOfAdjacentMines();
	}
	
	
	public void DFSFromCell(CellView Cell){
		
		
		Stack<CellView> stack = new Stack<CellView>();
		stack.push(Cell);
		
		while(!stack.isEmpty()){
			
			CellView v = (CellView)stack.pop();
			if (!v.getIsDiscovered() && v.getNumberOfMinesNear() == 0){
				v.setIsDiscovered(true);
	        	v.setText(" ");
	        	v.setBackgroundColor(Color.LTGRAY);	
	        	
	        	for (CellView aCell : v.getAdjacentCells()){
	        		stack.push(aCell);
	        	}
			} else {
				
				if (v.getIsMine()){
	            	v.setText(" ");	            	
                	v.setBackgroundColor(Color.GRAY);
	                v.setIsDiscovered(true);
	            } else if (v.getNumberOfMinesNear() > 0){
	                
	                v.setText((String.valueOf(v.getNumberOfMinesNear())));
	                
	    	        switch (v.getNumberOfMinesNear()) {
	                case 1:
	                	v.setTextColor(Color.BLUE);
	                    break;
	                case 2:
	                	v.setTextColor(Color.GREEN);
	                    break;
	                case 3:
	                	v.setTextColor(Color.GRAY);
	                    break;
	                case 4:
	                	v.setTextColor(Color.MAGENTA);
	                    break;
	                case 5:
	                	v.setTextColor(Color.YELLOW);
	                    break;
	                case 6:
	                	v.setTextColor(Color.CYAN);
	                    break;
	                default:
	                	v.setTextColor(Color.BLACK);
	                    break;
	    	        }
	                
                	v.setBackgroundColor(Color.GRAY);
	                v.setIsDiscovered(true);
	            }
			}

		}
		
	}
	
	private void markNumberOfAdjacentMines(){

		int i, j;
		
		for (i = 0; i < 16; i++){
			for (j = 0; j < 16; j++){
				
				CellView cell = gameGrid[i][j];
				
				if (cell.getiIndex() == 0 && cell.getjIndex() == 0){

					CellView adjCell1 = gameGrid[i][j+1];
					CellView adjCell2 = gameGrid[i+1][j+1];
					CellView adjCell3 = gameGrid[i+1][j];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					cell.setAdjacentCells(temp);


				} else if (cell.getiIndex() == 0 && cell.getjIndex() == 15){

					CellView adjCell1 = gameGrid[i][j-1];
					CellView adjCell2 = gameGrid[i+1][j];
					CellView adjCell3 = gameGrid[i+1][j-1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if(adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					cell.setAdjacentCells(temp);

				} else if (cell.getiIndex() == 15 && cell.getjIndex() == 0){

					CellView adjCell1 = gameGrid[i-1][j];
					CellView adjCell2 = gameGrid[i-1][j+1];
					CellView adjCell3 = gameGrid[i][j+1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					cell.setAdjacentCells(temp);

				} else if (cell.getiIndex() == 15 && cell.getjIndex() == 15){


					CellView adjCell1 = gameGrid[i-1][j];
					CellView adjCell2 = gameGrid[i-1][j-1];
					CellView adjCell3 = gameGrid[i][j-1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					cell.setAdjacentCells(temp);

				} else if (cell.getiIndex() == 0){


					CellView adjCell1 = gameGrid[i][j-1];
					CellView adjCell2 = gameGrid[i+1][j-1];
					CellView adjCell3 = gameGrid[i+1][j];
					CellView adjCell4 = gameGrid[i+1][j+1];
					CellView adjCell5 = gameGrid[i][j+1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell4.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell5.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					temp.add(adjCell4);
					temp.add(adjCell5);
					cell.setAdjacentCells(temp);

				} else if (cell.getiIndex() == 15){

					CellView adjCell1 = gameGrid[i][j-1];
					CellView adjCell2 = gameGrid[i-1][j-1];
					CellView adjCell3 = gameGrid[i-1][j];
					CellView adjCell4 = gameGrid[i-1][j+1];
					CellView adjCell5 = gameGrid[i][j+1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell4.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell5.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					temp.add(adjCell4);
					temp.add(adjCell5);
					cell.setAdjacentCells(temp);

				} else if (cell.getjIndex() == 0){


					CellView adjCell1 = gameGrid[i-1][j];
					CellView adjCell2 = gameGrid[i-1][j+1];
					CellView adjCell3 = gameGrid[i][j+1];
					CellView adjCell4 = gameGrid[i+1][j+1];
					CellView adjCell5 = gameGrid[i+1][j];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell4.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell5.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					temp.add(adjCell4);
					temp.add(adjCell5);
					cell.setAdjacentCells(temp);


				} else if (cell.getjIndex() == 15){

					CellView adjCell1 = gameGrid[i-1][j];
					CellView adjCell2 = gameGrid[i-1][j-1];
					CellView adjCell3 = gameGrid[i][j-1];
					CellView adjCell4 = gameGrid[i+1][j-1];
					CellView adjCell5 = gameGrid[i+1][j];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell4.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell5.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					temp.add(adjCell4);
					temp.add(adjCell5);
					cell.setAdjacentCells(temp);

				} else{

					CellView adjCell1 = gameGrid[i-1][j-1];
					CellView adjCell2 = gameGrid[i-1][j];
					CellView adjCell3 = gameGrid[i-1][j+1];
					CellView adjCell4 = gameGrid[i][j-1];
					CellView adjCell5 = gameGrid[i][j+1];
					CellView adjCell6 = gameGrid[i+1][j-1];
					CellView adjCell7 = gameGrid[i+1][j];
					CellView adjCell8 = gameGrid[i+1][j+1];

					if (adjCell1.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell2.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell3.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell4.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell5.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell6.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell7.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}
					if (adjCell8.getIsMine()){
						cell.setNumberOfMinesNear(cell.getNumberOfMinesNear() + 1);
					}

					ArrayList<CellView> temp = new ArrayList<CellView>();
					temp.add(adjCell1);
					temp.add(adjCell2);
					temp.add(adjCell3);
					temp.add(adjCell4);
					temp.add(adjCell5);
					temp.add(adjCell6);
					temp.add(adjCell7);
					temp.add(adjCell8);
					cell.setAdjacentCells(temp);

				}


			}
		}

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.game, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
	

}
