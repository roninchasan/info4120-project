# info4120-project
Web 3D visualization tool for our motion tracking wearable golf swing analyzer. Collaboration with Roger Liu (rgl72@cornell.edu) and Tyler Russano (tr333@cornell.edu).

Project uses Arduino to collect data from 2 BNO055 9-DOF IMU & absolute orientation sensors via Bluetooth. Calculations are made using Java Processing and loaded into CSV files for the webpage to read. 

Analytics include swing speed, angle of swing plane, impact angle, and swing tempo. Uses a trained KNN (n=3) ML algorithm to identify type of club used in swing. 3D path of motion calculated using quaternion data from sensors to calculate movement of intercepting vectors in 3 dimensions. Mapped using D3.js.
