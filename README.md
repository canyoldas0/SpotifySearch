# Spotify Search Project.

This project is developed by Can Yoldas.

- Note: Xcode 14 Beta is used during the development.
- It is tested on real device iOS 15.6.1

## Get Started

The purpose of the project is to use Spotify APIs for login and search for some further data. Spotify iOS SDK isn't used for this project. UIKit for the UIs and URLSession for networking are preferred.

I know that TicketSwap uses Combine and SwiftUI in tech stack, I also wanted to use those technologies, I believe those would make my life easier, however one week wouldn't be enough to make this project as comprehensive as it is.

### API References

<a href="https://developer.spotify.com/documentation/web-api/reference/#/operations/search" target="_blank" rel="noopener">Search</a>
<a href="https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile" target="_blank" rel="noopener">Profile</a>
<a href="https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist" target="_blank" rel="noopener">Artists</a>
<a href="https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums" target="_blank" rel="noopener">Artists' Albums</a>

### Authorization

For authorization in Spotify API, I choose manuel authentication method which might not be the practical way, but I didn't want to use the SDK, because I have experience using the old method.

Authentication returns access token, refresh token and expiration time.
There is a control mechanism in Auth Manager which controls if the access token is valid, if token is about to expire, it refreshes to token and continues to calls.

In each app launch, Auth manager controls whether tokens should be reset.

All the private keys are stored in Keychain.

### Architecture

MVVM-C pattern is used in this project. Focused on component based development with the protocol oriented programming to make the code cleaner and scalable.

- Factory pattern is used to initializing in proper way.
- Protocol oriented programming and dependency injections are used to make testing easier.
- Prevented using singletons as possible to make testing easier again.
- View classes are abstracted from the view controllers to make it cleaner and reusable.

### Network Layer

Spotify APIs requires access token to make successful calls. If user is signed in, auth manager provides valid token for service calls.

I wanted to keep my network flow as linear as it's possible to make it suitable for SOLID's dependency inversion. High level objects shouldn't rely on the lower level objects.

![Network Flow](/Resources/networkFlow.jpg)

### What are my thoughts about the project?

- This project includes unit testing in coordinator and view model level. Though, test coverage can be improved.
- Coordinator pattern is a great way to handle navigations and flows, when the app is scaling, it helps you a lot. However, for this scale of project, it wasn't necessary to do it, The reason why I chose is that case studies are never scalable kind of projects, but I wanted it to approach this project as it is a real life project.
- UIs can be more abstracted, more customizable for reusability.
- Spotify SDK could be used, if somehow this project required some playback from Spotify, I would have gone for it for sure.
- Mock Service Requests could be added and some kind of a local resource manager could be added to make testing more reliable. Instead, I chose to go with dummies (stub).
- All the strings or constants can be stored in structs to make it smoother. Since I don't have localization in the app, I didn't want to spend my limited resources on it.

### Summary

Overall, it was a great experience for me. There isn't a complex UI in this case study because I wanted to focus on concepts rather than UIs.

This kind of an authorization layer wasn't something I have done before. I believe that combining it with the observation layer and dependency injections was great income of this project.

I believe that SwiftUI and Combine would be a best practice stack for this project, zipping service requests and making the UI responsive to updates would be much easier.

I need to mention that after completing the project, I set myself a new goal, learning the SwiftUI and Combine.

### Fun fact

The UISheetPresentationController that comes in iOS 15 causes a memory leak.

```
let viewController = ViewController()

if let sheetVC = viewController.sheetPresentationController {
    // If you set this true view controller doesn't deinitialize.
    sheet.prefersGrabberVisible = true
}
```
