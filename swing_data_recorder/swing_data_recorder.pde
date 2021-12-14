import org.apache.commons.math3.ml.neuralnet.*;
import org.apache.commons.math3.ml.neuralnet.twod.*;
import org.apache.commons.math3.ml.neuralnet.twod.util.*;
import org.apache.commons.math3.ml.neuralnet.oned.*;
import org.apache.commons.math3.ml.neuralnet.sofm.*;
import org.apache.commons.math3.ml.neuralnet.sofm.util.*;
import org.apache.commons.math3.ml.clustering.*;
import org.apache.commons.math3.ml.clustering.evaluation.*;
import org.apache.commons.math3.ml.distance.*;
import org.apache.commons.math3.analysis.*;
import org.apache.commons.math3.analysis.differentiation.*;
import org.apache.commons.math3.analysis.integration.*;
import org.apache.commons.math3.analysis.integration.gauss.*;
import org.apache.commons.math3.analysis.function.*;
import org.apache.commons.math3.analysis.polynomials.*;
import org.apache.commons.math3.analysis.solvers.*;
import org.apache.commons.math3.analysis.interpolation.*;
import org.apache.commons.math3.stat.interval.*;
import org.apache.commons.math3.stat.ranking.*;
import org.apache.commons.math3.stat.clustering.*;
import org.apache.commons.math3.stat.*;
import org.apache.commons.math3.stat.inference.*;
import org.apache.commons.math3.stat.correlation.*;
import org.apache.commons.math3.stat.descriptive.*;
import org.apache.commons.math3.stat.descriptive.rank.*;
import org.apache.commons.math3.stat.descriptive.summary.*;
import org.apache.commons.math3.stat.descriptive.moment.*;
import org.apache.commons.math3.stat.regression.*;
import org.apache.commons.math3.linear.*;
import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;
import org.apache.commons.math3.distribution.fitting.*;
import org.apache.commons.math3.complex.*;
import org.apache.commons.math3.ode.*;
import org.apache.commons.math3.ode.nonstiff.*;
import org.apache.commons.math3.ode.events.*;
import org.apache.commons.math3.ode.sampling.*;
import org.apache.commons.math3.random.*;
import org.apache.commons.math3.primes.*;
import org.apache.commons.math3.optim.*;
import org.apache.commons.math3.optim.linear.*;
import org.apache.commons.math3.optim.nonlinear.vector.*;
import org.apache.commons.math3.optim.nonlinear.vector.jacobian.*;
import org.apache.commons.math3.optim.nonlinear.scalar.*;
import org.apache.commons.math3.optim.nonlinear.scalar.gradient.*;
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.*;
import org.apache.commons.math3.optim.univariate.*;
import org.apache.commons.math3.exception.*;
import org.apache.commons.math3.exception.util.*;
import org.apache.commons.math3.fitting.leastsquares.*;
import org.apache.commons.math3.fitting.*;
import org.apache.commons.math3.dfp.*;
import org.apache.commons.math3.fraction.*;
import org.apache.commons.math3.special.*;
import org.apache.commons.math3.geometry.*;
import org.apache.commons.math3.geometry.hull.*;
import org.apache.commons.math3.geometry.enclosing.*;
import org.apache.commons.math3.geometry.spherical.twod.*;
import org.apache.commons.math3.geometry.spherical.oned.*;
import org.apache.commons.math3.geometry.euclidean.threed.*;
import org.apache.commons.math3.geometry.euclidean.twod.*;
import org.apache.commons.math3.geometry.euclidean.twod.hull.*;
import org.apache.commons.math3.geometry.euclidean.oned.*;
import org.apache.commons.math3.geometry.partitioning.*;
import org.apache.commons.math3.geometry.partitioning.utilities.*;
import org.apache.commons.math3.optimization.*;
import org.apache.commons.math3.optimization.linear.*;
import org.apache.commons.math3.optimization.direct.*;
import org.apache.commons.math3.optimization.fitting.*;
import org.apache.commons.math3.optimization.univariate.*;
import org.apache.commons.math3.optimization.general.*;
import org.apache.commons.math3.util.*;
import org.apache.commons.math3.genetics.*;
import org.apache.commons.math3.transform.*;
import org.apache.commons.math3.filter.*;

import weka.classifiers.Classifier;
import weka.core.Attribute;
import weka.core.DenseInstance;
import weka.core.FastVector;
import weka.core.Instances;
import weka.core.converters.ArffSaver;
import weka.core.converters.Saver;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.BufferedWriter;
import java.io.FileWriter;
import weka.classifiers.lazy.IBk;
import weka.classifiers.functions.SMO;
import weka.classifiers.trees.J48;
import processing.serial.*;
import java.util.Collections;
import com.github.psambit9791.jdsp.filter.Butterworth;
import java.util.Arrays;

import com.github.psambit9791.jdsp.filter.*;
import com.github.psambit9791.jdsp.io.*;
import com.github.psambit9791.jdsp.signal.*;
import com.github.psambit9791.jdsp.signal.peaks.*;
import com.github.psambit9791.jdsp.misc.*;
import com.github.psambit9791.jdsp.transform.*;
import com.github.psambit9791.jdsp.windows.*;
import com.github.psambit9791.jdsp.splines.*;

import uk.me.berndporr.iirj.*;

Serial myPort;  // Create object from Serial class
String myString = null;
int datadimension = 29; // acceleration, gyroscope, position in 3 dimensions (xyz)
PrintWriter output; // write data into files
long starttime =0;
int timeduration = 3; //time duration of the recording in seconds
int restduration = 2; // The pause length between each repeat
String[] classLabels= {"putt","iron","drive"}; // The names of the class 
String trainingFile = "/Users/rchasan/Documents/info4120/info4120-project/datasets/Golf_Swing_Training_Data_All_Attr.arff";
int counter = 0;
boolean done = false;
int samplerate = 70;
int cutoff = 1;
ArrayList alldata[] = new ArrayList[datadimension];
static public FastVector atts;
public static FastVector attsResult;
public Classifier myclassifier ;
BufferedWriter trainingfileWriter = null;
static Instances mInstances;


//data output: (wrist): orientationx, oy, oz ax, ay, az, gx, gy, gz, positionx, positiony, positionz, (bicep): orientationx, oy, oz ax, ay, az, gx, gy, gz
//LAST 4: wrist w, x, y, z quaternion, bicep w, x, y, z
void setup() {
  //size(640, 360);
  //background(color(255,255,255));
  printArray(Serial.list());
  String portName = Serial.list()[2];// change to your port 
  myPort = new Serial(this, portName, 115200);
  setupARFF(trainingFile,classLabels);
  
  for(int i=0; i<datadimension; ++i){
   alldata[i] = new ArrayList(); 
  }

  output = createWriter("swingPosition.csv");
  output.println("wrist-orientation, wrist-ax, wrist-ay, wrist-az, wrist-gx, wrist-gy, wrist-gz, wrist-positionx, wrist-positiony, wrist-positionz, bicep-orientation, bicep-ax, bicep-ay, bicep-az, bicep-gx, bicep-gy, bicep-gz");
  println("Start recording swing");
}
void draw() {
  while((myPort.available() > 0)&&!(done)){
    if(starttime ==0) starttime = millis();// record the starting time of the recording
    myString = myPort.readStringUntil('\n');    // '\n'(ASCII=10) every number end flag
    if(myString!= null){
      //System.out.println(myString);
      //System.out.println(myString.length());
      String[] list = split(myString.substring(0, myString.length()-2), ',');// remove the newline symbol 
      if(list.length == datadimension){
        output.print(myString);// Output the line (string) to the local file
        System.out.println(myString);
        for(int i = 0; i<datadimension; i++){
          float num = Float.parseFloat(list[i]);
          alldata[i].add(num);
        }
      
      } 
    
    //If the recording time is longer than the timeduration, close the file and stop the program
    if(millis()-starttime > timeduration*1000){
        starttime =0;
        output.flush(); // Push the data from buffer to the file
        output.close();
        println("Finish collecting swing data");
        delay(restduration*1000);
        done = true;
        
        calculateStats(alldata);
        System.out.println("Analysis complete, refresh GUI to see stats!");
      }
   
    }
  }
}

void calculateStats(ArrayList[] data){    
    HashMap<String, String> stats = new HashMap<String, String>();
    
    ArrayList magnitudes = magnitudeAccl(data);
    int maxAcclIndex = magnitudes.indexOf(getMax(magnitudes));
    
    float initialClubAngle = (float)data[2].get(0);
    float impactClubAngle = (float)data[2].get(maxAcclIndex);
    float impactAngle = initialClubAngle - impactClubAngle;
    
    int topSwingIndex = findTopSwingIndex(magnitudes, maxAcclIndex);
    
    ArrayList downSwingMags = new ArrayList(magnitudes.subList(topSwingIndex+2, maxAcclIndex-1));
    float downSpeed = integrateSpeed(downSwingMags);
    
    ArrayList backSwingMags = new ArrayList(magnitudes.subList(0, topSwingIndex+5));
    float backSpeed = integrateSpeed(backSwingMags);
    
    ArrayList endSwingMags = new ArrayList(magnitudes.subList(maxAcclIndex, magnitudes.size()));
    int endSwingIndex = magnitudes.indexOf(getMin(endSwingMags));

    float backTime = (float)((float)1/(float)70)*(float)((float)topSwingIndex-0);
    float forwardTime = (float)((float)1/(float)70)*(float)((float)endSwingIndex-(float)topSwingIndex);
    
    float swingRatio = forwardTime/backTime;
    
    stats.put("swingSpeed", String.format("%.1f", (downSpeed/2.23694)));
    stats.put("swingRatio", String.format("%.2f", swingRatio));
    stats.put("impactAngle", String.format("%.1f", impactAngle));

    float swingPlane = (float)data[1].get(maxAcclIndex) + 90;

    stats.put("swingPlane", String.format("%.1f", swingPlane));
    
    String swingType = swingRecognition(data);
    stats.put("swingType", swingType);
    
    HashMap<String, Float> clubWeights = new HashMap<String, Float>();
    clubWeights.put("putt",0.18);
    clubWeights.put("iron",0.55);
    clubWeights.put("drive",0.34);
    
    Float weight = clubWeights.get(swingType);
    Float force = weight * getMax(magnitudes);
    
    stats.put("force", String.format("%.1f", force));
    
    ArrayList coordinates[] = matrixToPosition(data);

    writePositionsToCSV(coordinates);

    writeStats(stats);
}

void writePositionsToCSV(ArrayList[] coordinates){
    PrintWriter coordinatesOutput = createWriter("coordinates.csv");
    
    int count = 0;
    
    coordinatesOutput.print("x,y,z"); 
    coordinatesOutput.println();

    for (int j=0; j<coordinates[0].size(); j++){
      for (int i=0; i<3; i++) { 
        if (i == 2){
          coordinatesOutput.print(coordinates[i].get(j));
         coordinatesOutput.println();
        } else {
          coordinatesOutput.print(coordinates[i].get(j) + ",");
        }
      count++;
      }
    }
    
    coordinatesOutput.flush(); // Push the data from buffer to the file
    coordinatesOutput.close();

}

void writeStats(HashMap<String, String> stats){
    PrintWriter statsOutput = createWriter("swingStats.csv");
    
    int count = 0;
    for (String i : stats.keySet()) {
      if (count == stats.size()-1){
        statsOutput.print(i);
      } else {
        statsOutput.print(i + ",");
      }
      count++;
    }
    
    statsOutput.println();

    count = 0;
    for (String i : stats.values()) {
       if (count == stats.size()-1){
        statsOutput.print(i);
      } else {
        statsOutput.print(i + ",");
      }
      
      count++;
    }
    
    statsOutput.flush(); // Push the data from buffer to the file
    statsOutput.close();

}

String swingRecognition(ArrayList[] data){
  
    double[] featurelist = new double[72+1]; // The last feature is the label of the data 
    featurelist[0] = getMax(data[3]);  
    featurelist[1] = getMax(data[4]);  
    featurelist[2] = getMax(data[5]);  
    featurelist[3] = getMax(data[6]);  
    featurelist[4] = getMax(data[7]);  
    featurelist[5] = getMax(data[8]);  
    
    featurelist[6] = getMin(data[3]);  
    featurelist[7] = getMin(data[4]);  
    featurelist[8] = getMin(data[5]);  
    featurelist[9] = getMin(data[6]);  
    featurelist[10] = getMin(data[7]);  
    featurelist[11] = getMin(data[8]);  
    
    featurelist[12] = getMean(data[3]);  
    featurelist[13] = getMean(data[4]);  
    featurelist[14] = getMean(data[5]);  
    featurelist[15] = getMean(data[6]);  
    featurelist[16] = getMean(data[7]);  
    featurelist[17] = getMean(data[8]);  
    
    featurelist[18] = getVariance(data[3]);  
    featurelist[19] = getVariance(data[4]);  
    featurelist[20] = getVariance(data[5]);  
    featurelist[21] = getVariance(data[6]);  
    featurelist[22] = getVariance(data[7]);  
    featurelist[23] = getVariance(data[8]);  
    
    featurelist[24] = getZeroCross(data[3]);  
    featurelist[25] = getZeroCross(data[4]);  
    featurelist[26] = getZeroCross(data[5]);  
    featurelist[27] = getZeroCross(data[6]);  
    featurelist[28] = getZeroCross(data[7]);  
    featurelist[29] = getZeroCross(data[8]);  
    
    featurelist[30] = getMedian(data[3]);  
    featurelist[31] = getMedian(data[4]);  
    featurelist[32] = getMedian(data[5]);  
    featurelist[33] = getMedian(data[6]);  
    featurelist[34] = getMedian(data[7]);  
    featurelist[35] = getMedian(data[8]);
    
    featurelist[36] = getMax(data[15]);  
    featurelist[37] = getMax(data[16]);  
    featurelist[38] = getMax(data[17]);  
    featurelist[39] = getMax(data[18]);  
    featurelist[40] = getMax(data[19]);  
    featurelist[41] = getMax(data[20]);  
    
    featurelist[42] = getMin(data[15]);  
    featurelist[43] = getMin(data[16]);  
    featurelist[44] = getMin(data[17]);  
    featurelist[45] = getMin(data[18]);  
    featurelist[46] = getMin(data[19]);  
    featurelist[47] = getMin(data[20]);  
    
    featurelist[48] = getMean(data[15]);  
    featurelist[49] = getMean(data[16]);  
    featurelist[50] = getMean(data[17]);  
    featurelist[51] = getMean(data[18]);  
    featurelist[52] = getMean(data[19]);  
    featurelist[53] = getMean(data[20]);  
    
    featurelist[54] = getVariance(data[15]);  
    featurelist[55] = getVariance(data[16]);  
    featurelist[56] = getVariance(data[17]);  
    featurelist[57] = getVariance(data[18]);  
    featurelist[58] = getVariance(data[19]);  
    featurelist[59] = getVariance(data[20]);  
    
    featurelist[60] = getZeroCross(data[15]);  
    featurelist[61] = getZeroCross(data[16]);  
    featurelist[62] = getZeroCross(data[17]);  
    featurelist[63] = getZeroCross(data[18]);  
    featurelist[64] = getZeroCross(data[19]);  
    featurelist[65] = getZeroCross(data[20]);  
    
    featurelist[66] = getMedian(data[15]);  
    featurelist[67] = getMedian(data[16]);  
    featurelist[68] = getMedian(data[17]);  
    featurelist[69] = getMedian(data[18]);  
    featurelist[70] = getMedian(data[19]);  
    featurelist[71] = getMedian(data[20]);
    
    featurelist[72] = 0.0;  // assigned a random class label

    try{
        DenseInstance addinstance = new DenseInstance(1.0, featurelist);
        addinstance.setDataset(mInstances); // Specify the instance family this instance belongs to
        int resultindex = (int)myclassifier.classifyInstance(addinstance);
        return classLabels[resultindex];
    } catch (Exception e){
      return "Unknown";
    }
 
}

  private void setupARFF(String folder, String[] mylabels) {
    atts = new FastVector(); // Save the feature namse
    attsResult = new FastVector(); // Save the label names
    
    //Set up the folder , in case the folder dose not exist
    File writeFolder = new File(folder);
      if (!writeFolder.exists()) {
        writeFolder.mkdirs();
      }
    
    for (int i=0; i<mylabels.length;++i) {
      attsResult.addElement(mylabels[i]);
    }
    
   //Add the name of the features
    atts.add(new Attribute("Max_AcclX_wrist"));
    atts.add(new Attribute("Max_AcclY_wrist"));
    atts.add(new Attribute("Max_AcclZ_wrist"));
    atts.add(new Attribute("Max_GyroX_wrist"));
    atts.add(new Attribute("Max_GyroY_wrist"));
    atts.add(new Attribute("Max_GyroZ_wrist"));
    
    atts.add(new Attribute("Min_AcclX_wrist"));
    atts.add(new Attribute("Min_AcclY_wrist"));
    atts.add(new Attribute("Min_AcclZ_wrist"));
    atts.add(new Attribute("Min_GyroX_wrist"));
    atts.add(new Attribute("Min_GyroY_wrist"));
    atts.add(new Attribute("Min_GyroZ_wrist"));
    
    atts.add(new Attribute("Mean_AcclX_wrist"));
    atts.add(new Attribute("Mean_AcclY_wrist"));
    atts.add(new Attribute("Mean_AcclZ_wrist"));
    atts.add(new Attribute("Mean_GyroX_wrist"));
    atts.add(new Attribute("Mean_GyroY_wrist"));
    atts.add(new Attribute("Mean_GyroZ_wrist"));
    
    atts.add(new Attribute("Var_AcclX_wrist"));
    atts.add(new Attribute("Var_AcclY_wrist"));
    atts.add(new Attribute("Var_AcclZ_wrist"));
    atts.add(new Attribute("Var_GyroX_wrist"));
    atts.add(new Attribute("Var_GyroY_wrist"));
    atts.add(new Attribute("Var_GyroZ_wrist"));
    
    atts.add(new Attribute("ZeroCrossCount_AcclX_wrist"));
    atts.add(new Attribute("ZeroCrossCount_AcclY_wrist"));
    atts.add(new Attribute("ZeroCrossCount_AcclZ_wrist"));
    atts.add(new Attribute("ZeroCrossCount_GyroX_wrist"));
    atts.add(new Attribute("ZeroCrossCount_GyroY_wrist"));
    atts.add(new Attribute("ZeroCrossCount_GyroZ_wrist"));
    
    atts.add(new Attribute("Median_AcclX_wrist"));
    atts.add(new Attribute("Median_AcclY_wrist"));
    atts.add(new Attribute("Median_AcclZ_wrist"));
    atts.add(new Attribute("Median_GyroX_wrist"));
    atts.add(new Attribute("Median_GyroY_wrist"));
    atts.add(new Attribute("Median_GyroZ_wrist"));
    
    atts.add(new Attribute("Max_AcclX_bicep"));
    atts.add(new Attribute("Max_AcclY_bicep"));
    atts.add(new Attribute("Max_AcclZ_bicep"));
    atts.add(new Attribute("Max_GyroX_bicep"));
    atts.add(new Attribute("Max_GyroY_bicep"));
    atts.add(new Attribute("Max_GyroZ_bicep"));
    
    atts.add(new Attribute("Min_AcclX_bicep"));
    atts.add(new Attribute("Min_AcclY_bicep"));
    atts.add(new Attribute("Min_AcclZ_bicep"));
    atts.add(new Attribute("Min_GyroX_bicep"));
    atts.add(new Attribute("Min_GyroY_bicep"));
    atts.add(new Attribute("Min_GyroZ_bicep"));
    
    atts.add(new Attribute("Mean_AcclX_bicep"));
    atts.add(new Attribute("Mean_AcclY_bicep"));
    atts.add(new Attribute("Mean_AcclZ_bicep"));
    atts.add(new Attribute("Mean_GyroX_bicep"));
    atts.add(new Attribute("Mean_GyroY_bicep"));
    atts.add(new Attribute("Mean_GyroZ_bicep"));
    
    atts.add(new Attribute("Var_AcclX_bicep"));
    atts.add(new Attribute("Var_AcclY_bicep"));
    atts.add(new Attribute("Var_AcclZ_bicep"));
    atts.add(new Attribute("Var_GyroX_bicep"));
    atts.add(new Attribute("Var_Gyro_bicep"));
    atts.add(new Attribute("Var_GyroZ_bicep"));
    
    atts.add(new Attribute("ZeroCrossCount_AcclX_bicep"));
    atts.add(new Attribute("ZeroCrossCount_AcclY_bicep"));
    atts.add(new Attribute("ZeroCrossCount_AcclZ_bicep"));
    atts.add(new Attribute("ZeroCrossCount_GyroX_bicep"));
    atts.add(new Attribute("ZeroCrossCount_GyroY_bicep"));
    atts.add(new Attribute("ZeroCrossCount_GyroZ_bicep"));
    
    atts.add(new Attribute("Median_AcclX_bicep"));
    atts.add(new Attribute("Median_AcclY_bicep"));
    atts.add(new Attribute("Median_AcclZ_bicep"));
    atts.add(new Attribute("Median_GyroX_bicep"));
    atts.add(new Attribute("Median_GyroY_bicep"));
    atts.add(new Attribute("Median_GyroZ_bicep"));
    
    atts.add(new Attribute("result", attsResult));
    mInstances = new Instances("Swings", atts, 0);

    try {
      //Load training file and train classifier     
      BufferedReader reader = new BufferedReader(new FileReader(trainingFile));
      mInstances  = new Instances(reader);
      reader.close();
      mInstances.setClassIndex(mInstances.numAttributes() - 1);
      // Use KNN with a K = 3 
      myclassifier = new IBk(3);
      myclassifier.buildClassifier(mInstances);
      
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }


//6 Features: Maximum, minimum, variance, mean, zero-crossing rate, median
float getMax(ArrayList data){
  float max = (float)data.get(0);
  for(int i=1;i<data.size(); ++i){
    if(max< (float)data.get(i)) max = (float)data.get(i);
  }
  return max; 
}

float getMin(ArrayList data){
  float min = (float)data.get(0);
  for(int i=1;i<data.size(); ++i){
    if(min > (float)data.get(i)) min = (float)data.get(i);
  }
  return min; 
}

float getVariance(ArrayList data){
  float mean = getMean(data);
  float sum = 0;
  for(int i=1;i<data.size(); ++i){
    sum+= Math.pow(((float)data.get(i)-mean),2);
  }
  
  return (sum/(data.size()-1)); 
}

float getZeroCross(ArrayList data){
  int count = 0;
  boolean positive = true;
  if ((float)data.get(0)<0){
    positive = false;
  }

  for(int i=1;i<data.size(); ++i){
    if (((float)data.get(i)<0)&&positive){
      positive = false;
      count +=1;
    }
    else if (((float)data.get(i)>0)&&!positive){
      positive = true;
      count +=1;
    }
  }
  return count; 
}

float getSum(ArrayList data){
  float sum = (float)data.get(0);
  for(int i=1;i<data.size(); ++i){
    sum+=(float)data.get(i);
  }
  return sum; 
}

float getMean(ArrayList data){
  return (getSum(data)/data.size()); 
}

float getMedian(ArrayList data){
  Collections.sort(data);

  if(data.size()%2==1){
   return (float)data.get((data.size()+1)/2-1);
  }
  else{
    float lower = (float)data.get(data.size()+1/2-1);
    float upper = (float)data.get(data.size()/2);
    return (float)((lower+upper)/2.0);
  }
}

ArrayList magnitudeAccl(ArrayList[] data){
  ArrayList magnitudeArray = new ArrayList();
  
  for(int i=0; i<data[0].size();i++){
    float magnitude = sqrt( pow(((float)data[3].get(i)),2) + pow((float)data[4].get(i),2) + pow((float)data[5].get(i),2));
    
    magnitudeArray.add(magnitude);
    //println(magnitude);
  }
   return magnitudeArray;
}

int findTopSwingIndex(ArrayList magAccls, int maxIndex){
  ArrayList beforeImpactAccls = new ArrayList(magAccls.subList(2, maxIndex));
  
  return (beforeImpactAccls.indexOf(getMin(beforeImpactAccls))+2);
}

float integrateSpeed(ArrayList data){
  float sum = 0.0;
  
  sum = getSum(data);
  return sum;
}
ArrayList getquaternion(ArrayList[] data){

  ArrayList rotations = new ArrayList();

  for (int i =0; i<data[0].size(); i++){
    
    Quaternion X = new Quaternion((float)data[25].get(i),(float)data[26].get(i),(float)data[27].get(i),(float)data[28].get(i));
    Quaternion invertedX = X.getInverse();
    
    Quaternion Z = new Quaternion((float)data[21].get(i),(float)data[22].get(i),(float)data[23].get(i),(float)data[24].get(i));

    Quaternion product = Quaternion.multiply(invertedX, Z);
        
    rotations.add(product);
  }
  return rotations;
}

ArrayList[] matrixToPosition(ArrayList[] data){
  ArrayList coordinates[] = new ArrayList[3];
  
  for(int i=0; i<3; ++i){
   coordinates[i] = new ArrayList(); 
  }
  
  ArrayList quatData = new ArrayList();
   quatData = getquaternion(data);
   
   double yawOC = 0;
    double rollOC = 0;
   double pitchOC = 0;

   
    for(int i = 0; i<quatData.size(); i++){
     double[][] rm = new double[3][3];
      Quaternion thisRotation = (Quaternion)quatData.get(i);
      
      double w = thisRotation.getQ0();
      double x = thisRotation.getQ1();
      double y = thisRotation.getQ2();
      double z = thisRotation.getQ3();
      
      rm[0][0] = (w*w)+(x*x)+(y*y)+(z*z);
      rm[0][1] = 2*((x*y)-(w*z));
      rm[0][2] = 2*((w*y)-(x*z));
      
      rm[1][0] = 2*((x*y)+(w*z));
      rm[1][1] = (w*w)-(x*x)+(y*y)-(z*z);
      rm[1][2] = 2*((-w*y)+(x*z));
      
      rm[2][0] = 2*((-w*y)+(x*z));
      rm[2][1] = 2*((w*x)+(y*z));
      rm[2][2] = (w*w)-(x*x)-(y*y)+(z*z);
      
      double yy = y * y; 

      double roll = Math.atan2(2 * (w * x + y * z), 1 - 2*(x * x + yy));
      double pitch = Math.asin(2 * w * y - x * z);
      double yaw = Math.atan2(2 * (w * z + x * y), 1 - 2*(yy+z * z));
      
      /*  Convert Radians to Degrees */
      double rollDeg  = 57.2958 * roll;
      double pitchDeg = 57.2958 * pitch;
      double yawDeg   = 57.2958 * yaw;
      
      double yawRange = 45;
      
      if (i==0){
        yawOC = yawDeg;
      }
      
      double pitchRange = 45;
      
      if (i==0){
         pitchOC = pitchDeg;
      }
      
      double rollRange = 45;
      if (i==0){
         rollOC = rollDeg;
      }

      double xCoord = ((yawDeg-yawOC)/(yawRange/2.0));
      double yCoord = ((pitchDeg-pitchOC)/(pitchRange/2.0));
      double zCoord = ((rollDeg-rollOC)/(rollRange/2.0));

      coordinates[0].add(xCoord);
      coordinates[1].add(yCoord);
      coordinates[2].add(zCoord);

      }
      return coordinates;
    }
