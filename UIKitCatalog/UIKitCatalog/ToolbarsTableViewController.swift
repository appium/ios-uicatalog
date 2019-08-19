/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Table view controller for presenting various `UIToolbars`.
*/

import UIKit

class ToolbarsTableViewController: BaseTableViewController {
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var storyboardSceneID = String()
		switch indexPath.row {
		case 0:
			// Default
			storyboardSceneID = "DefaultToolbarViewController"
		case 1:
			// Tinted
			storyboardSceneID = "TintedToolbarViewController"
		case 2:
			// Custom
			storyboardSceneID = "CustomToolbarViewController"
		default: break
		}
		
		let exampleViewController = storyboard?.instantiateViewController(withIdentifier: storyboardSceneID)
		pushOrPresentViewController(viewController: exampleViewController!, cellIndexPath: indexPath)
	}
}
