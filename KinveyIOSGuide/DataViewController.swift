//
//  DataViewController.swift
//  KinveyIOSGuide
//
//  Created by Richard Trevivian on 3/1/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    let eventsStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Events",
        KCSStoreKeyCollectionTemplateClass : Event.self
        ])
    
    let invitationsStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Invitations",
        KCSStoreKeyCollectionTemplateClass : Invitation.self
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KCSUser.loginWithUsername("test", password: "password") { (user, error, result) -> Void in
            guard error == nil else {
                print("error:", error)
                return
            }
            print("user:", user)
        }
    }
    
    @IBAction func didTapSaveUser(sender: UIButton) {
        let invitation = Invitation()
        invitation.name = "Invitation_" + NSDate().description
        
        let event = Event()
        event.name = "Event_" + NSDate().description
        event.invitation = invitation
        
        saveEvent(event)
    }
    
    @IBAction func didTapSaveUsers(sender: UIButton) {
        let invitation = Invitation()
        invitation.name = "Invitation_" + NSDate().description
        
        let event = Event()
        event.name = "Event_" + NSDate().description
        event.invitations = [invitation]
        
        saveEvent(event)
    }
    
    @IBAction func didTaoSaveUsersSet(sender: UIButton) {
        let invitation = Invitation()
        invitation.name = "Invitation_" + NSDate().description
        
        let event = Event()
        event.name = "Event_" + NSDate().description
        event.invitationsSet = [invitation]
        
        saveEvent(event)
    }
    
    func saveEvent(event: Event) {
        guard KCSUser.activeUser() != nil else {
            print("KCSUser.activeUser == nil")
            return
        }
        eventsStore.saveObject(event, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("error:", error)
                return
            }
            print("objects:", objects)
            }, withProgressBlock: nil)
    }
    
}

class Event : NSObject {
    
    var entityId: String?
    var name: String?
    var metadata: KCSMetadata?
    
    var invitation: Invitation?
    var invitations: [Invitation]?
    var invitationsSet: NSMutableSet?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "metadata" : KCSEntityKeyMetadata,
            "name" : "name",
            "invitation" : "invitation",
            "invitations" : "invitations",
            "invitationsSet" : "invitationsSet"
        ]
    }
    
    static override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "invitation" : "Invitations",
            "invitations" : "Invitations",
            "invitationsSet" : "InvitationsSet"
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "invitation" : Invitation.self,
                "invitations" : Invitation.self,
                "invitationsSet" : Invitation.self,
            ]
        ]
    }
    
    override func referenceKinveyPropertiesOfObjectsToSave() -> [AnyObject]! {
        return [
            "invitation",
            "invitations",
            "invitationsSet"
        ]
    }
    
}

class Invitation : NSObject {
    
    var entityID: String?
    var name: String?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityID" : KCSEntityKeyId,
            "name" : "name"
        ]
    }
    
}
