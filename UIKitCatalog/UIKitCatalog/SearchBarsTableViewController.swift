/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Table view controller for presenting various search bars.
*/

import UIKit

class SearchBarsTableViewController: BaseTableViewController {
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var storyboardSceneID = String()

        switch indexPath.row {
			case 0:
			// Default
			storyboardSceneID = "DefaultSearchBarViewController"
			case 1:
			// Custom
			storyboardSceneID = "CustomSearchBarViewController"
			default: break
        }

		let exampleViewController = storyboard?.instantiateViewController(withIdentifier: storyboardSceneID)
		pushOrPresentViewController(viewController: exampleViewController!, cellIndexPath: indexPath)
	}
}

