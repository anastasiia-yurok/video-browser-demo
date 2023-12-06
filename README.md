# video-browser-demo
# Video Browser Demo
## The demo app for video browsing

This is the sample app that allows to brows Vimeo videos from [Vimeo][vimeo] website of a certain category.
App also allows to play the selected video.

## Features

- Authenticates to [Vimeo][vimeo]
- Retrieves videos of a given category
- Nicely displays retrieved videos with focus based navigation
- Plays selected video

## Dependencies

No 3rd dependencies are used. App is build via native iOS frameworks: Foundation, UIKit, AVKit.

## Installation

- Open [workspace file][xcworkspace] in XCode
- Select target device
- Build & Run 

**! Known limitation:** running on real devices is not configured yet.

## Architecture

#### App flow
- `AppAssembly` - responsible for constructing the screens with proper dependencies.
- `AppRouter` - runs the initial flow and handle routing from screen to screen, uses `AppAssembly` to construct screens.
- `AppDelegate` - uses `AppRouter` to start the initial flow (screen).

#### Screen composition
- `ViewModel` - represents business logic on certain screen, prepares presentation data (sends it to `View`) and reacts on UI actions received from `View`.
- `View` - `UIViewController` + `View` defined in storyboard, presents the UI via data from `ViewModel` and delegates UI actions to `ViewModel`
- `Router` - closure that presents outer routes from the screen to be handles by the flow router. 

## Authentication

The authentication is performed by obtaining the auth token using the client credentials grant according to [Vimeo docs][vimeoAuth]. See the [AuthController.swift][AuthController] for implementation details.
Temporary `client id` and `secret` are used. To run the app with your own credentials see the [VimeoClient.swift][VimeoClient] and insert appropriate values in place.

## Vimeo API
The only api implemented is [CategoriesApi.swift]. It implements call to `categories/{category}/videos` to retrieve the list of videos for certain category.

**!Known issue**: For some reason this api does not returns `files` properties of the `video` that contains links to be used for a video player.

Future improvements here:
- implement pagination
- implement filtering

## Category Videos Browsing

See [Screens/VideoCollection][VideoCollection]

- This is initial screen of the app at this point.
- The screen downloads the list of retrieved videos on the start and presents it as a `UICollectionView`. 
- The predefined category is `sports`. You can change it by editing the `categoryName` constant of [VideoCollectionViewModel][VideoCollectionViewModel].
- Screen has the focus based navigation inside.
- When certain video is selected the app navigates to Video browser.

## Video Player

See [Screens/VideoPlayer][VideoPlayer]

Plays the video file with default controls.
**!Known issue**: Since api does not returns video play links the browser plays some mock video.


**Enjoy your video browsing!**

[//]:

   [vimeo]: <https://vimeo.com>
   [xcworkspace]: <https://github.com/anastasiia-yurok/video-browser-demo/tree/main/video-browser-demo/video-browser-demo.xcworkspace>
   [vimeoAuth]: <https://developer.vimeo.com/api/authentication>
   [VimeoClient]: <https://github.com/anastasiia-yurok/video-browser-demo/blob/main/video-browser-demo/video-browser-demo/Networking/Auth/VimeoClient.swift>
   [AuthController]: <https://github.com/anastasiia-yurok/video-browser-demo/blob/main/video-browser-demo/video-browser-demo/Networking/Auth/AuthController.swift>
   [CategoriesApi]: <https://github.com/anastasiia-yurok/video-browser-demo/blob/main/video-browser-demo/video-browser-demo/Networking/Categories%20Api/CategoriesApi.swift>
   [VideoCollection]: <https://github.com/anastasiia-yurok/video-browser-demo/tree/main/video-browser-demo/video-browser-demo/Screens/VideoCollection>
   [VideoPlayer]: <https://github.com/anastasiia-yurok/video-browser-demo/tree/main/video-browser-demo/video-browser-demo/Screens/VideoPlayer>
   [VideoCollectionViewModel]: <https://github.com/anastasiia-yurok/video-browser-demo/blob/main/video-browser-demo/video-browser-demo/Screens/VideoCollection/VideoCollectionViewModel.swift>

