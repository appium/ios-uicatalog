/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view controller that demonstrates how to use `UIPickerView`.
*/

import UIKit

class PickerViewController: UIViewController {
    // MARK: - Types

    enum ColorComponent: Int {
        case red = 0, green, blue
        
        static var count: Int {
            return ColorComponent.blue.rawValue + 1
        }
    }

    struct RGB {
        static let max: CGFloat = 255.0
        static let min: CGFloat = 0.0
        static let offset: CGFloat = 5.0
    }

    // MARK: - Properties

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var colorSwatchView: UIView!

    lazy var numberOfColorValuesPerComponent: Int = (Int(RGB.max) / Int(RGB.offset)) + 1

    var redColor: CGFloat = RGB.min {
        didSet {
            updateColorSwatchViewBackgroundColor()
        }
    }

    var greenColor: CGFloat = RGB.min {
        didSet {
            updateColorSwatchViewBackgroundColor()
        }
    }

    var blueColor: CGFloat = RGB.min {
        didSet {
            updateColorSwatchViewBackgroundColor()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePickerView()
    }
	
    func updateColorSwatchViewBackgroundColor() {
        colorSwatchView.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)
    }

    func configurePickerView() {
        // Set the default selected rows (the desired rows to initially select will vary from app to app).
        let selectedRows: [ColorComponent: Int] = [.red: 13, .green: 41, .blue: 24]

        for (colorComponent, selectedRow) in selectedRows {
            /** Note that the delegate method on `UIPickerViewDelegate` is not triggered
                when manually calling `selectRow(_:inComponent:animated:)`. To do
                this, we fire off delegate method manually.
            */
            pickerView.selectRow(selectedRow, inComponent: colorComponent.rawValue, animated: true)
            pickerView(pickerView, didSelectRow: selectedRow, inComponent: colorComponent.rawValue)
        }
    }

}

// MARK: - UIPickerViewDataSource

extension PickerViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return ColorComponent.count
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return numberOfColorValuesPerComponent
	}
}

// MARK: - UIPickerViewDelegate

extension PickerViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let colorValue = CGFloat(row) * RGB.offset
		
        // Set the initial colors for each picker segment.
		let value = CGFloat(colorValue) / RGB.max
		var redColorComponent = RGB.min
		var greenColorComponent = RGB.min
		var blueColorComponent = RGB.min
		
		switch ColorComponent(rawValue: component)! {
		case .red:
			redColorComponent = value
			
		case .green:
			greenColorComponent = value
			
		case .blue:
			blueColorComponent = value
		}
		
        if redColorComponent < 0.5 {
            redColorComponent = 0.5
        }
        if blueColorComponent < 0.5 {
            blueColorComponent = 0.5
        }
        if greenColorComponent < 0.5 {
            greenColorComponent = 0.5
        }
		let foregroundColor = UIColor(red: redColorComponent, green: greenColorComponent, blue: blueColorComponent, alpha: 1.0)
		
		// Set the foreground color for the entire attributed string.
		let attributes = [
			NSAttributedString.Key.foregroundColor: foregroundColor
		]
		
		let title = NSMutableAttributedString(string: "\(Int(colorValue))", attributes: attributes)
		
		return title
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let colorComponentValue = RGB.offset * CGFloat(row) / RGB.max
		
		switch ColorComponent(rawValue: component)! {
		case .red:
			redColor = colorComponentValue
			
		case .green:
			greenColor = colorComponentValue
			
		case .blue:
			blueColor = colorComponentValue
		}
	}

}

// MARK: - UIPickerViewAccessibilityDelegate

extension PickerViewController: UIPickerViewAccessibilityDelegate {

    func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
        
        switch ColorComponent(rawValue: component)! {
        case .red:
            return NSLocalizedString("Red color component value", comment: "")
			
        case .green:
            return NSLocalizedString("Green color component value", comment: "")
			
        case .blue:
            return NSLocalizedString("Blue color component value", comment: "")
        }
    }
}

