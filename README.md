# MotionCap
 Motion Capture System – concept and implementation.
<br>
This project involves the development of a DIY Motion Capture system from scratch, divided into the following stages:

1. System concept design – defined the architecture, camera setup, and marker configuration.

2. Calibration and triangulation algorithms – implemented custom functions written in MATLAB for multi-camera calibration and 3D point triangulation using the Direct Linear Transformation (DLT) method, without relying on built-in MATLAB functions.

3. Marker tracking – developed original image processing algorithms for detecting and tracking markers in camera images, based on a Kalman filter and Hungarian Algorithm for assignment problem, without using MATLAB's built-in tracking tools.

4. Results and system accuracy verification – evaluated the system's precision using a custom-designed calibration device.


<h3>1. Concept of system.</h3>

| ![Fig. 2: 3D model of calibration wand](https://github.com/user-attachments/assets/d359184a-88d3-422c-8730-fea453e1cc41) | ![Fig. 3: Printed calibration wand](https://github.com/user-attachments/assets/aa4084a1-24ea-4fef-8d8b-1f02173eca97) |
|:--:|:--:|
| *Fig. 2: 3D model of calibration wand* | *Fig. 3: Printed calibration wand* |

| ![Fig. 4: Custom designed and printed handle for phone](https://github.com/user-attachments/assets/2cc40943-2196-47f5-9a95-8ec00815457c) | ![Fig. 5: Three cameras setup](https://github.com/user-attachments/assets/54c69dca-c4a7-4ad0-9d4a-957d35c97671) |
|:--:|:--:|
| *Fig. 4: Custom designed and printed handle for phone* | *Fig. 5: Three cameras setup* |

<h3>2. Calibration and triangulation algorithms.</h3>
Calibration procedure involves adopting 3D coordinates that will be assigned to the markers of the calibration wand. A matrix is created with three columns corresponding to the x, y, and z axes, and six rows corresponding to the markers. The position of the origin of the coordinate system depends on the coordinates chosen in this step. Triangulation is then used to determine the spatial positions of the markers by analyzing their projections from multiple viewpoints. By calculating the intersection of the rays from each viewpoint, the 3D positions of the markers are obtained, allowing for precise calibration and alignment of the coordinate system.
<p align="center">
  <img src="https://github.com/user-attachments/assets/d359184a-88d3-422c-8730-fea453e1cc41" alt="Rys 1 Printed calibration wand" width="500"/>
  <br>
  <em>Rys. 6: 3D model of calibration wand</em>

<h3>3. Marker tracking</h3>
Kalman filter and Hungarian Algorithm have been implemented to improve the accuracy of the system by estimating the state of a dynamic system from noisy measurements.
<p align="center">
  <a href="https://youtu.be/Vj2q1zKzQ9E" target="_blank">
    <img src="https://img.youtube.com/vi/Vj2q1zKzQ9E/0.jpg" alt="Video Thumbnail" width="500">
  </a>
  <br>
  <em>Demonstration of the Kalman filter on one marker</em>
</p>
<p align="center">
  <a href="https://youtu.be/S2EUguyW2uo" target="_blank">
    <img src="https://img.youtube.com/vi/S2EUguyW2uo/0.jpg" alt="Video Thumbnail" width="500">
  </a>
  <br>
  <em>Demonstration of the Kalman filter on three markers but without Hungarian Algorithm</em>
</p>
<p align="center">
  <a href="https://youtu.be/giraAuK3giA" target="_blank">
    <img src="https://img.youtube.com/vi/giraAuK3giA/0.jpg" alt="Video Thumbnail" width="500">
  </a>
  <br>
  <em>Combined Kalman filter and Hungarian Algorithm on three markers</em>
</p>

<h3>4. Results</h3>
In the video below you can watch a short results of DIY motion capture systems. Additionaly there have been created a device for verification of desgined system.
<p align="center">
  <a href="https://youtu.be/Ns-yqAmoosk" target="_blank">
    <img src="https://img.youtube.com/vi/Ns-yqAmoosk/0.jpg" alt="Video Thumbnail" width="500">
  </a>
  <br>
  <em>Combined Kalman filter and Hungarian Algorithm on three markers</em>
</p>

| ![Fig. 7: Custom designed vertification device](https://github.com/user-attachments/assets/675b493b-9f80-43b4-92d4-abc43ccb43f5) | ![Fig. 8: Connected electronics components to control the device](https://github.com/user-attachments/assets/54c69dca-c4a7-4ad0-9d4a-957d35c97671) |
|:--:|:--:|
| *Fig. 7: Custom designed vertification device* | *Fig. 8: Connected electronics components to control the device* |


