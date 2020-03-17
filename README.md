
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

