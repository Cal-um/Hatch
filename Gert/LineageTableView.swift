//
//  LineageTableView.swift
//  Gert
//
//  Created by Calum Harris on 09/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData


class LineageTableView: UITableViewController {
  
  // Load properties and sort profiles.

  var managedObjectContext: NSManagedObjectContext!
  var selectedProfile: Profile!
  var profileSelectedForParent: Profile?
  var oppositeGender : Profile?
  var damTrueSireFalse: Bool! {
    didSet {
      if damTrueSireFalse == true {
          navigationItem.title = "Choose Dam"
          profileSelectedForParent = selectedProfile.mother
          oppositeGender = selectedProfile.father
      } else {
          navigationItem.title = "Choose Sire"
          profileSelectedForParent = selectedProfile.father
          oppositeGender = selectedProfile.mother
        }
      }
    
    }
  
  var allProfiles: [Profile]!
  
  var allProfilesPreSortToRemoveSelf: [Profile]!{
    didSet {
      if oppositeGender == nil {
          allProfiles = allProfilesPreSortToRemoveSelf.filter {
            i in i != selectedProfile
        }
      } else {
          allProfiles = allProfilesPreSortToRemoveSelf.filter {
            i in (i != selectedProfile) && (i != oppositeGender)
          }
        }
      }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //fetch all profiles from TabBarController
    let tbvc = self.tabBarController as! TabBarViewController
    allProfilesPreSortToRemoveSelf = tbvc.allProfiles!
    
  }

}




extension LineageTableView {
  
  // tableView Data Source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allProfiles.count
  }
    
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    cell = tableView.dequeueReusableCellWithIdentifier("liniageCell", forIndexPath: indexPath)
    
    let profile = allProfiles[indexPath.row]
    let profileName = profile.name
    
    if let _ = profileSelectedForParent where profileSelectedForParent == profile {
        cell.accessoryType = .Checkmark
    } else {
        cell.accessoryType = .None
    }
    
    cell.textLabel?.text = profileName
    
    return cell
  }
    
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let profile = allProfiles[indexPath.row]
    
    if let _ = profileSelectedForParent where profileSelectedForParent == profile {
        profileSelectedForParent = nil
    } else {
        profileSelectedForParent = profile
      }
   
    tableView.reloadData()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
}



extension LineageTableView {
  
  // Prepare and save
  
  override func viewWillDisappear(animated: Bool) {
    
    if let _ = profileSelectedForParent {
      if damTrueSireFalse == true {
          selectedProfile.mother = profileSelectedForParent
      } else {
          selectedProfile.father = profileSelectedForParent
        }
    } else {
        if damTrueSireFalse == true {
          selectedProfile.mother = nil
      } else {
          selectedProfile.father = nil
        }
    }
    
    saveContext()
    print(selectedProfile.father)
    print(selectedProfile.mother)
  }
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
          try managedObjectContext.save()
      } catch {
          let nserror = error as NSError
          NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
          abort()
      }
    }
  }

}
