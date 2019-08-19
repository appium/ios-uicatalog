/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The primary table view controller displaying all the UIKit examples.
*/

import UIKit

class MasterViewController: BaseTableViewController {
   
	struct Example {
		var title: String
		var subTitle: String
		var twoLevel: Bool
	}

    var exampleList = [
		// This is a list of examples offered by this sample.
        Example(title: "Activity Indicators", subTitle: "ActivityIndicatorViewController", twoLevel: false),
		Example(title: "Alert Controller", subTitle: "AlertControllerViewController", twoLevel: false),
		Example(title: "Buttons", subTitle: "ButtonViewController", twoLevel: false),
		Example(title: "Date Picker", subTitle: "DatePickerController", twoLevel: false),
		Example(title: "Image View", subTitle: "ImageViewController", twoLevel: false),
		Example(title: "Page Control", subTitle: "PageControlViewController", twoLevel: false),
		Example(title: "Picker View", subTitle: "PickerViewController", twoLevel: false),
		Example(title: "Progress Views", subTitle: "ProgressViewController", twoLevel: false),
		Example(title: "Search", subTitle: "SearchViewControllers", twoLevel: true),
		Example(title: "Segmented Controls", subTitle: "SegmentedControlViewController", twoLevel: false),
		Example(title: "Sliders", subTitle: "SliderViewController", twoLevel: false),
		Example(title: "Stack Views", subTitle: "StackViewController", twoLevel: false),
		Example(title: "Steppers", subTitle: "StepperViewController", twoLevel: false),
		Example(title: "Switches", subTitle: "SwitchViewController", twoLevel: false),
		Example(title: "Text Fields", subTitle: "TextFieldViewController", twoLevel: false),
		Example(title: "Text View", subTitle: "TextViewController", twoLevel: false),
		Example(title: "Toolbars", subTitle: "ToolbarViewControllers", twoLevel: true),
		Example(title: "Web View", subTitle: "WebViewController", twoLevel: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //..
    }

    override func isTwoLevelCell(indexPath: IndexPath) -> Bool {
	 	var twoLevelCell = false
		twoLevelCell = exampleList[indexPath.row].twoLevel
		return twoLevelCell
	}
	
	override func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
		let splitViewWantsToShowDetail = splitViewController?.traitCollection.horizontalSizeClass == .regular
		if splitViewWantsToShowDetail {
			if isTwoLevelCell(indexPath: indexPath) {
				cell.accessoryType = .disclosureIndicator
			}
		} else {
			// For two level table views in split view master/detail mode we don't navigate but just present.
			if isTwoLevelCell(indexPath: indexPath) {
				cell.accessoryType = isTwoLevelCell(indexPath: indexPath) ? .disclosureIndicator : .none
			}
		}
	}
	
}

// MARK: - UITableViewDataSource

extension MasterViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exampleList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let example = exampleList[indexPath.row]
		cell.textLabel?.text = example.title
		cell.detailTextLabel?.text = example.subTitle
		return cell
	}
}

// MARK: - UITableViewDelegate

extension MasterViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let example = exampleList[indexPath.row]
		pushOrPresentStoryboard(storyboardName: example.subTitle, cellIndexPath: indexPath)
	}
	
}

