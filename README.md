<!-- Heading -->
<img src='images/banner.png'>
<br />

<!-- Student Information -->
### 🐱&ensp;Student Information
- **Name:** Bianca Raianne L. Arce
- **Student Number:** 2020-10690
- **Section:** C-3L

- - -

<!-- App Description -->
### 📱&ensp;App Description
**Tomodachi 友達** is a task app that allows you to share your TODOs with your friends. It has the following features:

- 📝&ensp;Create, update, and/or delete your TODOs!
- 🔍&ensp;Search for users and **add** them as **friends!**
- 💖&ensp;**Share your TODOs** with **your friends** and be productive together!
- 🔔&ensp;Be **notified** of the latest updates about your TODOs.

This app was built using **Flutter.**

- - -

<!-- Screenshots -->
### ✨&ensp;App Preview
<img src='images/app_preview.png'>

- - -

<!-- Development -->
### 💻&ensp;Dev Process
- I utilized **[Dart packages](https://pub.dev/)** for most of my components, notifications, validators, and the splash screen.
- I used the system of having APIs, providers, and models for Firebase-related functions.
- To modularize and reuse components (e.g. text field), I created **components** and **utility** folders. I also utilized Flutter's **theme** feature to set my design system.
- I also included my own app icon and name.

- - -

<!-- Challenges -->
### 🪨&ensp;Challenges
- Alert dialogs used to have size overflow errors because the popup shrinks in size whenever a user tries to input something in a field.
- Integration of Firebase (e.g. API, Provider) in the UI was tricky because you have to know what kind of return value you are handling *(e.g. DocumentSnapshot, QuerySnapshot).* At the same time, you can't just cast a Future type into its real data type.
- Flutter testing can be a handlful in general because of the learning curve in handling a mock Firebase DB and authentication.

- - -

<!-- Test Cases -->
### 💖 Happy Paths
- The user *(owner)* can log in or sign up in the application.
- The user *(owner)* can create, view, edit, and delete their own task/s. They are also notified about the task **an hour before** its deadline.
- The user *(owner)* can search for users based on their **username.**
- The user *(owner)* can send and receive friend requests from other user/s *(mutual).*
- The user *(owner)* can accept or reject friend requests from other user/s *(mutual)* as well as unfriend them.
- The user *(owner)* can edit the details of a friend's *(mutual)* task except for changing the status.

- - -

### 😿 Unhappy Paths
- Notifications are **not proactive.** Even though a task was deleted, the notification for that task would still send. The same case holds for editing the task's deadline.
- In editing a task, the status and deadline does not reflect on the modal. The user has to set them again.
- An error message **does not display** in pages that uses Stream to load data from Firebase.
- In the signup screen, there is no validation for a **unique username.**

<br />

>> ❓&ensp;For more information about the code *(e.g. API, providers),* feel free to check out the documentation at **doc/index.html**.