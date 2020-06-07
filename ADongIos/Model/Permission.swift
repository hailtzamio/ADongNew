

import Foundation

 class Permission : Codable {
	var id : Int?
	var authorityId : Int?
	var appEntityId : Int?
    var appEntityCode:String?
	var action : String?
}
