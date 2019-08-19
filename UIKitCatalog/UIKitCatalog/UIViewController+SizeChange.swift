/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extension for any view controller that wants to pop itself from the nav stack, if transitioned
 to compact mode on the iPhone.
*/

import UIKit

extension UIViewController {
	func popDueToSizeChange() {
		/** This view controller was pushed in a table view while in the split view controller's
			master table, upon rotation to expand, we want to pop this view controller (to avoid
			master and detail being the same view controller).
		*/
		if navigationController != nil {
			navigationController?.popViewController(animated: true)
		}
	}
}
