#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include "BluetoothSerial.h"
BluetoothSerial SerialBT;

double xPos = 0, yPos = 0, zPos=0, headingVel = 0, yVel=0, zVel=0, netSpeed=0;
uint16_t BNO055_SAMPLERATE_DELAY_MS = 5; //how often to read data from the board
uint16_t PRINT_DELAY_MS = 50; // how often to print the data
uint16_t printCount = 0; //counter to avoid printing every 10MS sample

//velocity = accel*dt (dt in seconds)
//position = 0.5*accel*dt^2
//double ACCEL_VEL_TRANSITION =  (double)(BNO055_SAMPLERATE_DELAY_MS) / 1000.0;
double ACCEL_VEL_TRANSITION =  (double)((1/70)+(BNO055_SAMPLERATE_DELAY_MS) / 1000.0);

double ACCEL_POS_TRANSITION = 0.5 * ACCEL_VEL_TRANSITION * ACCEL_VEL_TRANSITION;
double DEG_2_RAD = 0.01745329251; //trig functions require radians, BNO055 outputs degrees
double netVelo = 0;

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
//                                   id, address
Adafruit_BNO055 bnoWrist = Adafruit_BNO055(55, 0x29);
Adafruit_BNO055 bnoBicep = Adafruit_BNO055(55, 0x28);

void setup(void)
{
  Wire.begin();
  Serial.begin(115200);
  SerialBT.begin("ESP32 Golf Analyzer"); //Start Bluetooth communication

  if (!bnoWrist.begin())
  {
    Serial.print("No wrist BNO055 detected");
    while (1);
  }
  
  if (!bnoBicep.begin())
  {
    Serial.print("No bicep BNO055 detected");
    while (1);
  }


  delay(1000);
}

void loop(void)
{
  //
  unsigned long tStart = micros();
  sensors_event_t orientationData , angVelData, linearAccelData;
  bnoWrist.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);
  bnoWrist.getEvent(&angVelData, Adafruit_BNO055::VECTOR_GYROSCOPE);
  bnoWrist.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL);

  xPos = xPos + ACCEL_POS_TRANSITION * linearAccelData.acceleration.x;
  yPos = yPos + ACCEL_POS_TRANSITION * linearAccelData.acceleration.y;
  zPos = zPos + ACCEL_POS_TRANSITION * linearAccelData.acceleration.z;

  if (printCount * BNO055_SAMPLERATE_DELAY_MS >= PRINT_DELAY_MS) {
    //enough iterations have passed that we can print the latest data

    SerialBT.print(orientationData.orientation.x);
    SerialBT.print(",");
    SerialBT.print(orientationData.orientation.y);
    SerialBT.print(",");
    SerialBT.print(orientationData.orientation.z);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.x);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.y);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.z);
    SerialBT.print(",");

    SerialBT.print(angVelData.gyro.x);
    SerialBT.print(",");
    SerialBT.print(angVelData.gyro.y);
    SerialBT.print(",");
    SerialBT.print(angVelData.gyro.z);
    SerialBT.print(",");
    
    SerialBT.print(xPos);
    SerialBT.print(",");
    SerialBT.print(yPos);
    SerialBT.print(",");
    SerialBT.print(zPos);

    bnoBicep.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);
    bnoBicep.getEvent(&angVelData, Adafruit_BNO055::VECTOR_GYROSCOPE);
    bnoBicep.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL);

    SerialBT.print(",");
    SerialBT.print(orientationData.orientation.x);
    SerialBT.print(",");
    SerialBT.print(orientationData.orientation.y);
    SerialBT.print(",");
    SerialBT.print(orientationData.orientation.z);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.x);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.y);
    SerialBT.print(",");
    SerialBT.print(linearAccelData.acceleration.z);
    SerialBT.print(",");

    SerialBT.print(angVelData.gyro.x);
    SerialBT.print(",");
    SerialBT.print(angVelData.gyro.y);
    SerialBT.print(",");
    SerialBT.print(angVelData.gyro.z);
    SerialBT.print(",");

    imu::Quaternion quat = bnoWrist.getQuat();           // Request quaternion data from wrist BNO055

    SerialBT.print(quat.w(),4);  // Print quaternion w
    SerialBT.print(","); 
    SerialBT.print(quat.x(),4);  // Print quaternion x
    SerialBT.print(","); 
    SerialBT.print(quat.y(),4);   // Print quaternion y
    SerialBT.print(","); 
    SerialBT.print(quat.z(),4);  // Print quaternion z
    SerialBT.print(",");

  imu::Quaternion quatBicep = bnoBicep.getQuat();           // Request quaternion data from bicep BNO055

    SerialBT.print(quatBicep.w(),4);  // Print quaternion w
    SerialBT.print(","); 
    SerialBT.print(quatBicep.x(),4);  // Print quaternion x
    SerialBT.print(","); 
    SerialBT.print(quatBicep.y(),4);   // Print quaternion y
    SerialBT.print(",");
    SerialBT.print(quatBicep.z(),4);  // Print quaternion z

    SerialBT.print("\n");


    printCount = 0;
  }
  else {
    printCount = printCount + 1;
  }


  while ((micros() - tStart) < (BNO055_SAMPLERATE_DELAY_MS * 1000)){
    //poll until the next sample is ready
  }
}

void printEvent(sensors_event_t* event) {
  Serial.println();
  Serial.print(event->type);
  double x = -1000000, y = -1000000 , z = -1000000; //dumb values, easy to spot problem
  if (event->type == SENSOR_TYPE_ACCELEROMETER) {
    x = event->acceleration.x;
    y = event->acceleration.y;
    z = event->acceleration.z;
  }
  else if (event->type == SENSOR_TYPE_ORIENTATION) {
    x = event->orientation.x;
    y = event->orientation.y;
    z = event->orientation.z;
  }
  else if (event->type == SENSOR_TYPE_MAGNETIC_FIELD) {
    x = event->magnetic.x;
    y = event->magnetic.y;
    z = event->magnetic.z;
  }
  else if ((event->type == SENSOR_TYPE_GYROSCOPE) || (event->type == SENSOR_TYPE_ROTATION_VECTOR)) {
    x = event->gyro.x;
    y = event->gyro.y;
    z = event->gyro.z;
  }

  Serial.print(": x= ");
  Serial.print(x);
  Serial.print(" | y= ");
  Serial.print(y);
  Serial.print(" | z= ");
  Serial.println(z);
}
