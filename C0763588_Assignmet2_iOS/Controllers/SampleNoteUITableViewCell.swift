

import UIKit

class SampleNoteUITableViewCell : UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
    private(set) var totaldays  : String = ""
    private(set) var dayworked  : String = ""
    private(set) var status  : String = ""
 
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet var totaldayslabel: UILabel!
    @IBOutlet var dayworkedlabel: UILabel!
    @IBOutlet var statuslabel: UILabel!
}
