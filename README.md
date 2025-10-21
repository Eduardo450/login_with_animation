# 🐻 Login_with_animation

This is a university practice demonstrating an interactive login screen built with Flutter and Rive. The character dynamically reacts to user input in the email and password fields.

---

## Features 🚀

* **Interactive Animation:** The character reacts to user input in real-time.
* **Email Tracking:** The character's eyes follow along as the user types their email (`isChecking` & `numLook` inputs).
* **Password "Privacy":** The character covers its eyes when the user focuses on the password field (`isHandsUp` input).
* **Validation Feedback:** The animation plays a 'success' (`trigSuccess`) or 'fail' (`trigFail`) animation based on the login validation result.
* **Client-Side Validation:** Includes checks for a valid email format and a strong password (minimum 8 characters, 1 uppercase, 1 lowercase, 1 number, and 1 special character).
* **Password Toggle:** A button to show/hide the password.

---

## What is Rive? 🐻

[**Rive**](https://rive.app/) is a powerful design and animation tool that allows you to create interactive vector animations that run in real-time. Unlike static GIFs or videos, Rive animations can be controlled by code, user input, or other events.

### What is a State Machine? 🧠

A **State Machine** is the logic behind a Rive animation. It's a visual way to define different states (e.g., `idle`, `checking`, `hands_up`) and the transitions between them. In this project, we use a State Machine to listen for inputs from our Flutter code and trigger the correct animation:

* `isChecking` (Boolean): Makes the character look at the email field.
* `isHandsUp` (Boolean): Makes the character cover its eyes.
* `trigSuccess` (Trigger): Plays the happy animation.
* `trigFail` (Trigger): Plays the sad animation.
* `numLook` (Number): Controls the eye movement based on the email's text length.

---

## Technologies Used 🛠️

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [Rive](https://rive.app/) (using the `rive` package)

---

## Project Structure 📂

The project's `lib` folder is organized simply:

```text
Login_with_animation/
├── assets/
│   └── animated_login_character.riv    # The Rive animation file
├── lib/
│   ├── main.dart                       # Main app entry point
│   └── screens/
│       └── login_screen.dart           # The login screen UI and logic
└── pubspec.yaml                        # Project dependencies and asset declarations
```

* **lib/main.dart:** The entry point of the application. It initializes Flutter and sets LoginScreen as the home widget.

* **lib/screens/login_screen.dart:** This is the heart of the project. It builds the UI and manages the StateMachineController to connect the UI to the Rive animation.

* **assets/:** This folder holds the Rive animation file.

* **pubspec.yaml:** This is the project's configuration file. It's crucial as it lists the dependencies (like flutter and rive) and, importantly, declares the path to the assets/ folder so Flutter can find the .riv animation file.

---

## Demo 🎬

Here is a quick demonstration of the app in action.

<p align="center">
<img src="https://github.com/user-attachments/assets/a5c7ef79-1720-4cd5-bde4-22a860017ffb" alt="App Demo GIF">
</p>

---

## How to Run 🚀

To get a local copy up and running, follow these simple steps.

1.  Clone the repo
    ```sh
    git clone https://github.com/Eduardo450/login_with_animation
    ```
2.  Navigate to the project directory
    ```sh
    cd login_with_animation
    ```
3.  Install dependencies
    ```sh
    flutter pub get
    ```
4.  Run the app
    ```sh
    flutter run
    ```

---

## Course Information 🎓

* **Course:** Computer Graphics
* **Professor:** Rodrigo Fidel Gaxiola Sosa

---

## Credits ✨

This project uses a remixed Rive animation.

* **Original Animation:** JcToon
* **Remix By:** Dexterc
* **Source:** [https://rive.app/marketplace/3645-7621-remix-of-login-machine/](https://rive.app/marketplace/3645-7621-remix-of-login-machine/)
