import java.util.ArrayList;
import processing.serial.*;
import grafica.*;
import java.awt.*;

String myString = null;
int numAxis = 12; 
BufferedReader reader;
String line= "";
int linecounter =0;
int locationPlotIMU_X = 20;// The position of the plot in the window
int locationPlotIMU_Y = 20;
int widthPlotIMU = 1000;// size of the plot 
int heightPlotIMU = 700;

ArrayList rawData[] = new ArrayList[numAxis];// each arraylist saves the data for one axis in IMU

void setup() {
  size(1500, 900);// dimension of the window
  background(color(255,255,255));
  
  String datafile = "drive_9_65590.csv";
  //Load data from the datafile to rawData[];
  loadData(datafile);
  
  drawdata(rawData[0], color(0,255,0));// Visualize Acclerometer X-axis  
  drawdata(rawData[1], color(255,0,0));// Visualize Acclerometer Y-axis 
  drawdata(rawData[2], color(0,0,255));// Visualize Acclerometer Z-axis 
  
  drawdata(rawData[6], color(255,255,0));// Visualize Acclerometer X-axis  
  drawdata(rawData[7], color(255,0,255));// Visualize Acclerometer Y-axis 
  drawdata(rawData[8], color(0,255,255));// Visualize Acclerometer Z-axis 
  
  //ArrayList magArray = magnitudeAccl(rawData); //calculate the magnitude/energy of the acclerometer 
  //ArrayList diffArray = absdiffArray(magArray);// calculate the absolute difference of the magnitude/energy of the acclerometer
  //ArrayList avgArray =  movingAverage(diffArray,10); // apply moving average filter on the data 

  
}
void draw() {
}

//Load data from the file into arraylists
void loadData(String filepath){
//Initialize the arraylists for saving the raw IMU data   
   for(int i=0; i<numAxis;i++) {
      rawData[i]= new ArrayList();
   }
   reader = createReader(filepath);// reader is an instance of BufferedReader
   
   //read Data from the files until the end of the file
   while(line!=null){
     try {
      line = reader.readLine();
      if(line==null) break;      
      String[] list = split(line.substring(0, line.length()-2), ',');
      
      //Save data into arrayList
      if(list.length == numAxis){
        float[] imuValue = new float[numAxis]; // imuValue 0-6 : acclx, y, z, gyro x, y, z;
        for(int i = 0; i<numAxis; i++){
          imuValue[i] = Float.parseFloat(list[i]);
          rawData[i].add(imuValue[i]);
        }
        linecounter++;
      }
      println(linecounter+","+line);
     } catch (IOException e) {
      e.printStackTrace();
      line = null;
     } 
   }
}

//Draw the data using the specified color  
void drawdata(ArrayList data, color linecolor){
   GPointsArray gpoints = new GPointsArray();
   //add data to Gpoints for visualization, The first parameter is the index of the data (x axis).
   for(int i=0; i<data.size();++i){
     gpoints.add(i, (float)data.get(i));
   }
    
    GPlot plotIMU= new GPlot(this);
    //Set the position of the plot in the window (top left corner)
    plotIMU.setPos(locationPlotIMU_X, locationPlotIMU_Y);
    //Set the dimension of the plot 
    plotIMU.setDim(widthPlotIMU, heightPlotIMU);
    //Set the data to be visualized
    plotIMU.setPoints(gpoints);
    
    //Set the title 
    plotIMU.setTitleText("IMU Data");
    plotIMU.getXAxis().setAxisLabelText("Time (t)");
    plotIMU.getYAxis().setAxisLabelText("y axis");
    //Set the range of data to be visualized
    plotIMU.setXLim(0, linecounter-2);
 
    // plot background and axis 
    println("draw");
    plotIMU.beginDraw();
    plotIMU.drawXAxis();
    plotIMU.drawYAxis();
    plotIMU.drawTitle();
    plotIMU.setLineColor(linecolor);
    plotIMU.drawLines();// Draw lines to connect data
    plotIMU.endDraw();
  
}

//Calculate the magnitude of Accelerometer = X^2+y^2+z^2, return as an arraylist
ArrayList magnitudeAccl(ArrayList[] data){
  
  ArrayList magnitudeArray = new ArrayList();
  //Implement your function  


  return magnitudeArray;
}


//Applying the moving average filter on the data 
ArrayList movingAverage(ArrayList data, int winsize){
  ArrayList avgArray = new ArrayList();
  //Implement your function  

  return avgArray;
}



//Calculate the difference of the array, y[n] = x[n]-x[n-1];  y is the returned data, x is the rawdata
ArrayList diffArray(ArrayList data){
  ArrayList diffarray = new ArrayList();
   //Implement your function 
   
   return diffarray;
}

//Calculate the absolute difference of the array, y[n] = abs(x[n]-x[n-1]);  y is the returned data, x is the rawdata. 
ArrayList absdiffArray(ArrayList data){
  
   ArrayList diffarray = new ArrayList();
    //Implement your function  

  
   return diffarray;
}
