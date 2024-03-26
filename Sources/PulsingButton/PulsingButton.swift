//
//  PulsingButton
//
//  Copyright (c) 2011-Present Lewis Halliday - https://github.com/lewishalliday/PulsingButton
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

/// A customizable UIControl that displays pulsing animation around a button image.
/// The button supports different images for its normal and selected states, customizable pulsing effects including color, radius, and animation timings.
open class PulsingButton: UIControl {
    private let buttonImageLayer = CALayer()
    private let backgroundLayer = CALayer()
    private var pulseLayers: [CALayer] = []

    /// The number of pulses to be displayed around the button.
    @IBInspectable open var pulseCount: Int = 2 {
        didSet {
            updatePulseLayers()
        }
    }

    /// The duration of each pulse animation cycle.
    @IBInspectable open var pulseDuration: Double = 2 {
        didSet {
            updatePulseAnimation()
        }
    }

    /// The time interval before the start of consecutive pulses.
    @IBInspectable open var intervalBetweenPulses: Double = 0.4 {
        didSet {
            updatePulseAnimation()
        }
    }

    /// The scale factor by which the pulse will expand.
    @IBInspectable open var pulseScaleFactor: CGFloat = 2.24 {
        didSet {
            updatePulseAnimation()
        }
    }

    /// The number of times the pulse animation will repeat.
    @IBInspectable open var pulseRepeatCount: Int = 100 {
        didSet {
            updatePulseAnimation()
        }
    }

    /// The color of the pulse effect.
    @IBInspectable open var pulseColor: UIColor = .gray {
        didSet {
            updatePulseColor()
        }
    }

    /// The image displayed on the button in its normal state.
    @IBInspectable open var image: UIImage? {
        didSet {
            updateButtonImage()
        }
    }

    /// The image displayed on the button in its selected state.
    @IBInspectable open var selectedImage: UIImage? {
        didSet {
            updateButtonImage()
        }
    }

    /// The background color of the button.
    public var buttonBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    /// Initializes a new `PulsingButton` with custom configurations.
    /// - Parameters:
    ///   - frame: The frame rectangle for the button, measured in points.
    ///   - pulseCount: The number of pulses to be displayed.
    ///   - pulseDuration: The duration of the pulse animation cycle.
    ///   - intervalBetweenPulses: The time interval before the start of consecutive pulses.
    ///   - pulseScaleFactor: The scale factor by which the pulse will expand.
    ///   - pulseRepeatCount: The number of times the pulse animation will repeat.
    ///   - pulseColor: The color of the pulse effect.
    ///   - image: The image for the button's normal state.
    ///   - selectedImage: The image for the button's selected state.
    ///   - backgroundColor: The background color of the button.
    public convenience init(frame: CGRect,
                            pulseCount: Int,
                            pulseDuration: Double,
                            intervalBetweenPulses: Double,
                            pulseScaleFactor: CGFloat,
                            pulseRepeatCount: Int,
                            pulseColor: UIColor,
                            image: UIImage?,
                            selectedImage: UIImage?,
                            backgroundColor: UIColor?)
    {
        self.init(frame: frame)
        self.pulseCount = pulseCount
        self.pulseDuration = pulseDuration
        self.intervalBetweenPulses = intervalBetweenPulses
        self.pulseScaleFactor = pulseScaleFactor
        self.pulseRepeatCount = pulseRepeatCount
        self.pulseColor = pulseColor
        self.image = image
        self.selectedImage = selectedImage
        buttonBackgroundColor = backgroundColor
        setupButton()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePulseRadius()
    }

    /// Sets up the initial configuration of the button and its layers.
    private func setupButton() {
        configureBackgroundLayer()
        configurePulseLayers()
        configureImageLayer()
        isUserInteractionEnabled = true
    }

    /// Configures the background layer of the button.
    private func configureBackgroundLayer() {
        layer.cornerRadius = frame.height / 2
        backgroundLayer.frame = bounds
        backgroundLayer.backgroundColor = buttonBackgroundColor?.cgColor
        backgroundLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(backgroundLayer, at: 0)
    }

    /// Initializes and configures pulse layers based on the current settings.
    private func configurePulseLayers() {
        pulseLayers.forEach { $0.removeFromSuperlayer() }
        pulseLayers.removeAll()
        
        for _ in 0 ..< pulseCount {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            layer.cornerRadius = CGFloat(frame.height / 2)
            layer.backgroundColor = pulseColor.cgColor
            layer.opacity = 0
            self.layer.insertSublayer(layer, below: backgroundLayer)
            pulseLayers.append(layer)
        }
    }

    /// Configures the image layer of the button.
    private func configureImageLayer() {
        let inset: CGFloat = 12
        let size = max(0, min(bounds.width, bounds.height) - inset * 2)
        buttonImageLayer.frame = CGRect(x: (bounds.width - size) / 2, y: (bounds.height - size) / 2, width: size, height: size)
        buttonImageLayer.contents = image?.cgImage
        buttonImageLayer.contentsGravity = .resizeAspect
        buttonImageLayer.masksToBounds = true
        layer.addSublayer(buttonImageLayer)
    }

    /// Starts the pulsing animation.
    open func startPulsing() {
        for (index, layer) in pulseLayers.enumerated() {
            let scaleAnimation = createScaleAnimation(index: index)
            let opacityAnimation = createOpacityAnimation(index: index)
            layer.add(scaleAnimation, forKey: "pulse")
            layer.add(opacityAnimation, forKey: "fade")
        }
    }

    /// Stops the pulsing animation and updates the button to its selected state.
    open func stopPulsing() {
        pulseLayers.forEach { $0.removeAllAnimations() }
        buttonImageLayer.contents = selectedImage?.cgImage
    }

    // MARK: - Update Methods

    /// Updates the radius of the pulse layers.
    private func updatePulseRadius() {
        configurePulseLayers()
        startPulsing()
    }

    /// Updates the number of pulse layers.
    private func updatePulseLayers() {
        configurePulseLayers()
        startPulsing()
    }

    /// Updates the color of the pulse layers.
    private func updatePulseColor() {
        for layer in pulseLayers {
            layer.backgroundColor = pulseColor.cgColor
        }
    }

    /// Updates the pulsing animation with the current settings.
    private func updatePulseAnimation() {
        stopPulsing()
        startPulsing()
    }

    /// Updates the background color of the button.
    private func updateBackgroundColor() {
        backgroundLayer.backgroundColor = buttonBackgroundColor?.cgColor
    }

    /// Updates the image displayed on the button.
    private func updateButtonImage() {
        configureImageLayer()
    }

    // MARK: - Animation Creation Methods

    /// Creates a scale animation for a pulse layer.
    /// - Parameter index: The index of the pulse layer.
    /// - Returns: A configured `CABasicAnimation` for scaling.
    private func createScaleAnimation(index: Int) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = pulseDuration
        animation.fromValue = 1.0
        animation.toValue = pulseScaleFactor
        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.beginTime = CACurrentMediaTime() + intervalBetweenPulses * Double(index)
        animation.repeatCount = Float(pulseRepeatCount)
        animation.isRemovedOnCompletion = false
        return animation
    }

    /// Creates an opacity animation for a pulse layer.
    /// - Parameter index: The index of the pulse layer.
    /// - Returns: A configured `CABasicAnimation` for fading.
    private func createOpacityAnimation(index: Int) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = pulseDuration
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.beginTime = CACurrentMediaTime() + intervalBetweenPulses * Double(index)
        animation.repeatCount = Float(pulseRepeatCount)
        animation.isRemovedOnCompletion = false
        return animation
    }
}
