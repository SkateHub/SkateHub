
# Product Spec Design: SkateHub
## Overview
### Description
Allows other skaters to socialize and share their progress.

### App Evaluation
- **Category:** Social Networking
- **Mobile:** This app would be optimized for mobile use
- **Story:** Allows users to connect with each other and view their specific posts to support the skateboarding scene in the user's area.
- **Market:** Any one will be able to use the app as much as they want. It is marketed towards skateboarders.
- **Habit:** This app could be used as often or unoften as the user wanted depending on how deep their skating social life is, and what they're looking for.
- **Scope:** We allow users to connect with other users. They will be allowed to create posts such as images and have others see them. These posts will be related to skateboarding.



## 1. User Stories (Required and Optional)

**Required Must-have Stories**

 - [x] User can login using a LogIn Page
 - [x] User can create an account using a SignUp Page
 - [x] User can stay logged in
 - [x] User can log out
 - [X] User can view a feed of photos/posts
 - [X] User can create a photo/post
 - [ ] User can comment/like a post
 

**Optional Nice-to-have Stories**

 - [ ] User can pin skate spots on a map
 - [x] User can edit their profile
 - [ ] User can follow/unfollow users
 - [ ] User can see a tab of whom they follow
 - [ ] User will get notifications when their photo is commented or liked
 

## 2. Screen Archetypes

 * Login Screen
   * User can login
 * Register screen
   * User can register a new account
 * Stream
   * User can view a feed of photos/posts
   * User can comment/like a post
 * Map View
   * User can view a map of skate spots
 * Creation 
   * User can create a photo/post 
   * User can pin skate spots on a map
 * Profile
   * User can edit their profile 
   * User can logout

## 3. Navigation

**Tab Navigation** (Tab to Screen)

 * Main Feed
 * Creating a post/photo
 * View map of skate spots
 * Edit profile

**Flow Navigation** (Screen to Screen)

 * Login Screen
   => Main Feed
 * Sign up Screen
   => Main Feed
 * Stream Screen
   => Profile Screen
 * Creation Screen
   => Main Feed after creating post/photo
 * Profile Screen
   => Main Feed
 * Map View
   => Main Feed
   
 ## 3. Wireframe
 <img width="944" alt="Screen Shot 2020-03-22 at 11 43 45 AM" src="https://user-images.githubusercontent.com/44143466/77253776-061e4380-6c33-11ea-9139-36a15ff50e67.png">

## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | image         | File     | image that user posts |
   | caption       | String   | image caption by author |
   | commentsCount | Number   | number of comments that has been posted to an image |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   
### Networking
#### List of network requests by screen
   - Login Screen
       - (GET) Login to account
         ```swift
         func myMethod() {
         var user = PFUser()
         user.username = "myUsername"
         user.password = "myPassword"
         user.email = "email@example.com"
         // other fields can be set just like with PFObject
         user["phone"] = "415-392-0202"

         user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
              let errorString = error.userInfo["error"] as? NSString
              // Show the errorString somewhere and let the user try again.
            } else {
              // Hooray! Let them use the app now.
            }
          }
         }
         ```
   - Sign up Screen
       - (Create) Sign-up a new account
       ```swift
         PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
      (user: PFUser?, error: NSError?) -> Void in
      if user != nil {
        // Do stuff after successful login.
      } else {
        // The login failed. Check error to see why.
          }
     }
     ```
   - Home Feed Screen
      - (Read/GET) Query all posts where user is author
         ```swift
         let query = PFQuery(className:"Post")
         query.whereKey("author", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
        ```swift
        PFObject.deleteAll(inBackground: objectArray){(succeeded, error) in
            if (succeeded) {
        // The array of objects was successfully deleted.
            } else {
        // There was an error. Check the errors localizedDescription.
            }
        }
         ``` 
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user profile image
         ```swift
         let query = PFQuery(className:"GameScore")
         query.getObjectInBackground(withId: "xWMyZEGZ") { (gameScore: 
         PFObject?, error: Error?) in
            if let error = error {
            print(error.localizedDescription)
            } else if let gameScore = gameScore {
            // code to change
            }
        }
         ```
      - (Delete) Delete account
         ```swift
        PFObject.deleteAll(inBackground: objectArray){(succeeded, error) in
            if (succeeded) {
        // The array of objects was successfully deleted.
            } else {
        // There was an error. Check the errors localizedDescription.
            }
        }
         ``` 
## Demo of current progress
![HUBO](https://user-images.githubusercontent.com/44143466/78502052-03d8e080-772d-11ea-9edc-89292c7fd561.gif)

## Demo of second sprint
<img src=http://g.recordit.co/vNQ3ORYP1V.gif width=400><br>
