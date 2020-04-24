PlayPal README

PennKey: smlee18

App instructions: 
	
	Create an account by signing up, filling in all of the text fields, and uploading a profile picture for your dog. To test the location tracking function, you can log out and sign up again with a different email. I suggest moving slightly so that the annotations won't show up on top of each other. When you sign in with a new user, you should see the first user on your map. Because I used CoreLocation, the app only works when run on an iOS device (not the simulator), because it grabs the location of the device. 

Project Description: 
	
	PlayPal is an app that connects dog owners with other dog owners and shows them fun places to take their dog to explore. Users can see the locations of potential play pals within a 30 km radius of their current location. They also have their own profile page which displays their profile image, bio, and various other information.

Goals: 
	In the future, I will be implementing the PalsViewController to display potential play pals in a table view. I will also be adding locations of hiking trails and dog parks to the database so that they show up on the map as well. Finally, I would also like to implement a "friend" system so that users can send and accept friend requests to each other. 


Notes:
	I used GeoFire to read and write updated user locations to the Firebase database. There weren't very many tutorials on how to use GeoFire, so I spent most of my time implementing this feature and connecting it to the database. Right now, users can only see the name of other dogs, but when I implement the table view, I will allow users to see other dog's full profiles. I hope to implement the other features over the summer (I'll definitely have the time!)

GitHub repo: https://github.com/18smlee/PlayPal