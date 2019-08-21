/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages how to handle the detail view controller for our split view controller.
*/

import UIKit

class DetailViewManager: NSObject, UISplitViewControllerDelegate {
	var splitViewController: UISplitViewController? = nil {
		didSet {
			splitViewController?.delegate = self
			splitViewController?.preferredDisplayMode = .allVisible
		}
	}

	/// Swaps out the detail for view controller for the Split View Controller this instance is managing.
 	func setDetailViewController(detailViewController: UIViewController) {
		var viewControllers: [UIViewController] = (splitViewController?.viewControllers)!
		if viewControllers.count > 1 {
			viewControllers[1] = detailViewController
		}
		splitViewController?.viewControllers = viewControllers
	}
	
	/** Set the default plain detail view controller (called by PageOneViewController,
		that is, in case a selected item is deleted in a split view controller)
	*/
	func setDefaultDetailViewController() {
		let initialDetailViewController = splitViewController?.storyboard?.instantiateViewController(withIdentifier: "navInitialDetail")
		setDetailViewController(detailViewController: initialDetailViewController!)
	}
	
	// MARK: - UISplitViewControllerDelegate
	
	func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewController.DisplayMode {
		return .allVisible
	}
	
 	func splitViewController(_ splitViewController: UISplitViewController,
 	                         collapseSecondary secondaryViewController: UIViewController,
 	                         onto primaryViewController: UIViewController) -> Bool {
		return true
	}
	
	func splitViewController(_ splitViewController: UISplitViewController,
	                         separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
		var returnSecondaryVC: UIViewController? = nil
		
		if let primaryVC = primaryViewController as? UINavigationController {
			let selectedVC = primaryVC.topViewController
			if selectedVC is UINavigationController {
				if let navVC = selectedVC as? UINavigationController {
					let currentVC = navVC.visibleViewController
				
					if currentVC?.popDueToSizeChange != nil {
						currentVC?.popDueToSizeChange()
					}
					
					// The currentVC has popped, now obtain it's ancestor vc in the table.
					let currentVC2 = navVC.visibleViewController
					if currentVC2 is BaseTableViewController {
						let baseTableViewVC = currentVC2 as? BaseTableViewController
						if baseTableViewVC?.tableView.indexPathForSelectedRow == nil {
							// The table has no selection, make the detail empty.
							returnSecondaryVC = splitViewController.storyboard?.instantiateViewController(withIdentifier: "navInitialDetail")
						}
					}
				}
			}
		}
		
		return returnSecondaryVC
	}
}
