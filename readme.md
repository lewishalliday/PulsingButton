# PulsingButton

`PulsingButton` is a customizable `UIControl` designed for iOS applications, providing an eye-catching pulsing effect around a button image. It supports customization for pulse effects, including color, radius, duration, and much more, making it highly versatile for various UI designs.

## Features

- Customizable pulsing animations
- Easy to integrate with Interface Builder or programmatically
- Supports dynamic changes to animation properties
- Allows different images for normal and selected states

## Installation

### Swift Package Manager

You can install `PulsingButton` using the Swift Package Manager by adding the package to your project's dependencies:

1. Open your project in Xcode.
2. Navigate to `File` > `Add Packages...`.
3. Enter `YOUR_GIT_URL` into the package repository URL text field.
4. Specify the version rules or choose a specific branch or commit as needed.
5. Click `Add Package`.

## Usage

### Importing the Package

To use `PulsingButton`, first import the package into your file:

```swift
import PulsingButton
``` 

### Adding the Button Programmatically

```swift
let pulsingButton = PulsingButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100),
                                  pulseRadius: 60,
                                  pulseCount: 3,
                                  pulseDuration: 1.5,
                                  intervalBetweenPulses: 0.5,
                                  pulseScaleFactor: 2.0,
                                  pulseRepeatCount: Float.infinity,
                                  pulseColor: .blue,
                                  normalImage: UIImage(named: "YourNormalImage"),
                                  selectedImage: UIImage(named: "YourSelectedImage"),
                                  backgroundColor: .lightGray)

view.addSubview(pulsingButton)
``` 

### Configuring with Interface Builder
Drag a UIView to your storyboard and set its class to PulsingButton in the Identity Inspector. You can customize the button's properties using the Attributes Inspector or programmatically in your view controller.

Starting and Stopping the Animation
To start the pulsing animation, call:

```swift
pulsingButton.startPulsing()
``` 
To stop the animation and display the selected image, call:

```swift
pulsingButton.stopPulsing()
``` 
### Customization
PulsingButton allows customization of the following properties:

- `pulseRadius`: The radius of the pulse effect.
- `pulseCount`: The number of pulses.
- `pulseDuration`: The duration of each pulse animation cycle.
- `intervalBetweenPulses`: The interval before the start of consecutive pulses.
- `pulseScaleFactor`: The scale factor by which the pulse will expand.
- `pulseRepeatCount`: The number of times the pulse animation will repeat.
- `pulseColor`: The color of the pulse effect.
- `normalImage`: The image for the button's normal state.
- `selectedImage`: The image for the button's selected state.
- `buttonBackgroundColor`: The background color of the button.
