# Video viewer application for iPhone

### About the project:
The project's objective - to implement a mobile application for viewing movies which are charged Lyudmila video in one of the available online video services.

### Business specification:
  1. The main application screen contains a tab bar and three pages: "Featured", "New" and "Feed". When the user opens the application, it displays "Featured".
  2. The user should be able to switch between all three tabs using the tab bar (at the bottom of the screen).
  3. The page "New" should show new videos selected from the video hosting service. On the "Favorites" page, a video must be selected.
  4. The first time you launch the application, the main login screen is displayed on the "Feed" page. After the user logs in with his credentials, this tab should show videos of other users that the user has subscribed to.
  
##### Requirements for all tabs with video:
1. Videos should be displayed as a list;
2. Show thumbnail image of video;
3. Each reduced image should occupy 100% of the screen width, the height should be calculated depending on the downloaded image;
4. The name of the video and the number of likes should be displayed at the bottom of each video;
5. When a user clicks on a video - play this video on a new screen;
6. Each tab with a video list must have a Pull-To-Refresh function to allow the user to update the current tab;
7. The application must continuously upload video to each page to achieve an endless scrolling effect (download the first ten videos and then upload the next ten when the user scrolls down the page).

##### Other Features:

- The application can only work in portrait orientation;
- Follow the latest Apple recommendations; Do not forget about the basic UX.
- The user logon state must be maintained between application sessions;
- Handle errors when the user tries to log in (wrong email address / password, too short;
Password, incorrect credentials, etc.). Show the correct message to the user.
- The application should show a user-friendly message when the device is not connected to the Internet;
- Add the "Log Out" button at the bottom of the "Feed" page if the user is logged on. Hide it if the user has not logged in;
- Execute the logout action when the user clicks the "Log Out" button;
- You can use third-party tools / libraries / frameworks.

##### Restrictions:
  - There is one week to complete the implementation of the application;
  - To perform the task, you must use the programming language Swift 3 and XCode 8.


### Implementation:

I used **Swift 3.1**, **XCode 8.3.2**.

##### Frameworks
To implement the requirements, I decided to use additional libraries:
1. [**'Gloss'**](https://github.com/hkellaway/Gloss) - i use it to build a data model and processing json, it is very convenient and looks nice.
2. [**'SwiftKeychainWrapper'**](https://github.com/jrendel/SwiftKeychainWrapper) - this is a simple and convenient library for working with "Keychain". In this project, its task is to keep the "token" in a safe place.
3. [**'Alamofire'**](https://github.com/Alamofire/Alamofire) -  a very powerful library, but in this project I do not use all its potential, I could replace it with the standard code for working with the network, but taking into account the short terms, 'Alamofire' will help to realize the task faster.

All libraries are downloaded via CocoaPods as frameworks.

##### Design pattern

For 'Alamofire' to download exactly the data that I need at the current time, I use the **"Builder" design pattern**, through which I build a query with the required parameters and send it through the single method of the **"BaseViewController"** superclass, quickly and conveniently.

To transform the data received from the server, use the  **"Factory Method" design pattern**, which, when creating a model in conjunction with 'Gloss', returns the required object to me.

To store the user state, I use the  **"State" design pattern**, it determines the state based on whether there is a custom "token" in the "Keychain", and provides it to me, if necessary. And also the  **"Singleton" design pattern**, to be sure that there will not be two different states.

To add thumbnails of video clips, I use **UITableView**, since the requirements for all videos are identical, I made one superclass **BaseViewController**, which will take care of all the work on loading and rendering tables. I drew the cell in a separate file **"VideoCell.xib"** file as it is identical for all tables.
When the data source is updated, I update the table with the insertion of new rows, this is much more efficient than updating the entire table every time.

In the technical assignment it is stated that the cell width should be 100% of the screan, and the height of the cell should be denamic, but not more than the width. 
I use the `tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat` method, in which I return the height of the uploaded image, this method will change the height of the row, and my **"UIImageView"** is tied to its edges, hence the image - to increase or decrease. Quickly and effectively.

To load thumbnails from the server, I use the **"ImgLoaderQueueManager"** class, which generates the required number of streams, in each of which an image is loaded.
After loading (successful or unsuccessful) images, the **"CollectionImgUpdaterDelegate"**  is called, which updates its image number to the image.
Transferring the loading of images on the shoulders of **OperationQueue** I will no longer think that the user will experience discomfort when procuring the table. Scrolling will go smoothly, and the user will be busy with the enthusiastic viewing of images, the lucky user is the best reward :)

When the boot loader works, the user sees the **activity indicators** on the cells of the table and in the status bar, if the loader could not load the image, the user will review the template image, all this is more loyal to the user, although not described in the technical assignment.

Most of the errors seen by the user come along with the data from the "API", however, there are those that need to be stored in the application, for this there is a separate file called **"Localization.swift"**. I try to store text that the user will see at once in **"NSLocalizedString"** to enable multilanguage.

_This project is published with a public repository with the permission of the customer._
_From the project, all text links indicating that the application is part of the video server are removed._
