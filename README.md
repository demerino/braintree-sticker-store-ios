# Braintree Sandbox Example

Example of a mock checkout screen that shows Braintree's Drop-in, collects payment information, updates the UI and sends the payment information to a server.

[Watch the Screencast](https://www.youtube.com/watch?v=Dbu2um4J1qg)

## Try it
- Requires Xcode 8+ and Cocoapods 1.1.1+
- Clone this repo
- Run `pod install`
- Open the `workspace` 
- Replace `YOUR_AUTHORIZATION_KEY_HERE` in `ViewController.swift` with your authorization string
- Run the application

_Note that you'll need to setup a server running on localhost:3000 to transact with the resulting nonce_
