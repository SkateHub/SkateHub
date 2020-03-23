
# Product Spec Design: SkateHub

## 1. User Stories (Required and Optional)

**Required Must-have Stories**

 * User can login using a LogIn Page
 * User can create an account using a SignUp Page
 * User can stay logged in
 * User can log out
 * User can view a feed of photos/posts
 * User can create a photo/post
 * User can comment/like a post

**Optional Nice-to-have Stories**

 * User can pin skate spots on a map
 * User can edit their profile
 * User can follow/unfollow users
 * User can see a tab of whom they follow
 * User will get notifications when their photo is commented or liked
 

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
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user profile image
#### [OPTIONAL:] Existing API Endpoints
##### An API Of Ice And Fire
- Base URL - [http://www.anapioficeandfire.com/api](http://www.anapioficeandfire.com/api)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /characters | get all characters
    `GET`    | /characters/?name=name | return specific character by name
    `GET`    | /houses   | get all houses
    `GET`    | /houses/?name=name | return specific house by name

##### Game of Thrones API
- Base URL - [https://api.got.show/api](https://api.got.show/api)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /cities | gets all cities
    `GET`    | /cities/byId/:id | gets specific city by :id
    `GET`    | /continents | gets all continents
    `GET`    | /continents/byId/:id | gets specific continent by :id
    `GET`    | /regions | gets all regions
    `GET`    | /regions/byId/:id | gets specific region by :id
    `GET`    | /characters/paths/:name | gets a character's path with a given name
