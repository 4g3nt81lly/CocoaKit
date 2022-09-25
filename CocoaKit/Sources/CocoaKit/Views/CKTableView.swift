import Cocoa

/**
 A custom subclass of `NSTableView`.
 */
public class CKTableView : NSTableView {
    
    /// Invokes `tableView(_:didClick:)` if the user clicks on a row, otherwise deselects all selected rows.
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let point = self.convert(event.locationInWindow, from: nil)
        let rowNumber = self.row(at: point)
        if rowNumber == -1 {
            self.deselectAll(nil)
        } else {
            (self.delegate as? CKTableViewDelegate)?.tableView(self, didClick: rowNumber)
        }
    }
    
}

protocol CKTableViewDelegate : NSTableViewDelegate {
    
    /**
     Implement to specify custom behavior upon clicking a row.
     
     This protocol method is invoked whenever the user clicks any of the table view's row.
     
     - Parameters:
        - tableView: The table view.
        - row: The row number that is clicked.
     */
    func tableView(_ tableView: CKTableView, didClick row: Int)
    
}
