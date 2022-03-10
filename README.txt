Evan Sinasac - 1081418
INFO6028 Graphics (Project 2)

Program can be run in Visual Studio 2019 in Debug and Release modes for x64, it will not run in x86.

Program Instructions:
WASD			- Move Camera around the scene
Q/E			- Raise and lower the Camera in the scene
Mouse			- Aim Camera
M			- Switch between Wire-Frame and Solid fill
Esc			- Close the program
O/P (Midterm Only)	- Open/CLose the bay doors
Shift + Arrow Keys	- Raise and Lower blue spotlight
Ctrl + Arrow Keys	- Move blue spotlight around

PLY Models:
Using most updated version of our shaders and VAO manager, so PLY models require XYZ vertex coordinates, XYZ normal coordinates, RGBA (Colour) values, and UV (texture coordinates) values.

WorldFile.txt is used to place models in the scene, as well as their texture maps, values, and which operator the fragment shader should use for the textures.  lights.txt is used to place and modify lights in the scene.

The models I used are from Runemark Studio's Dark Fantasy Kit (https://assetstore.unity.com/packages/3d/environments/fantasy/dark-fantasy-kit-123894) and the models we were given for the midterm, and the ship pack we've been using in class.

TEXTURES
I am using the textures we've been using in class (such as the ship pack textures and the lisse mobile shipyard), the textures we were given for the midterm, and the textures from the Dark Fantasy Kit.
For the cube map (sky box), I am using a combination of the textures we were given in class, and modulating them with time (as we did in class), and for fun, I overlaid the city and some Skyrim screen shots.
When I recorded the demo video, I forgot to show the Skyrim textures on the cube map, I have un commented the lines for the submission, but if it's too annoying to look at, comment lines 353-360 in main, or change howMuch_cubeMap_03 to 0.0f in DrawObject_function.cpp

For the DFK models, I wasn't sure what the SmMetAO files are for, so I am just adding them to the models, which adds a greenish tint to the models.  They are affected by the Ratio3 value, so just change that to 0 for the easiest way to put the colour back to a more realistic colour.  (I changed the floor to 0 for one line of it to see the difference)

To switch which models are being loaded, switch which function is being called on line 207/208.
To be able to open/close the Bay doors (for the midterm scene), uncomment lines 494-501.
Comment lines 494-501 for the project 2 scene so you don't send models off into some interesting places lol.

LIGHTS
Lights are loaded from lights.txt  
To change the main light that affects the whole scene, change which directional light is first in the file, I find the directional lights along the z-axis make the Project scene easier to see, but the directional light in the -y-axis is more realistic.

VIDEO
https://youtu.be/Gq3tbFiwTeU	(short)
https://youtu.be/ri2v6_3Bqf4	(long)