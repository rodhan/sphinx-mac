//
//  MockData.swift
//  Sphinx
//
//  Created by Rodhan Hickey on 20/02/2024.
//  Copyright © 2024 Sphinx. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MockData {
    static var Contacts: [JSON] = {
        return loadMockData(resource: "mock_contacts.json")
    }()
    
    static var Chats: [JSON] = {
        return loadMockData(resource: "mock_chats.json")
    }()
    
    static var Messages100HeyTheres: [JSON] = {
        return loadMockData(resource: "mock_messages_100_hey_theres.json")
    }()
    
    static func SingleAttachmentMessageWithID(_ id: Int, chatId: Int, senderId: Int) -> [JSON] {
        var messages = loadMockData(resource: "mock_message_attachment_template.json")
        
        messages[0]["id"].intValue = id
        messages[0]["chat_id"].intValue = chatId
        messages[0]["sender"].intValue = senderId
        
        return messages
    }
    
    static func MultipleAttachmentMessagesStartingWithID(_ id: Int, chatId: Int, senderId: Int, count: Int) -> [JSON] {
        
        var messages = SingleAttachmentMessageWithID(id, chatId: chatId, senderId: senderId)
        
        for i in 1..<count {
            let nextMessages = SingleAttachmentMessageWithID(id + i, chatId: chatId, senderId: senderId)
            
            messages.append(contentsOf: nextMessages)
        }
        
        return messages
    }

    static func SingleTextMessageWithID(_ id: Int, chatId: Int, senderId: Int) -> [JSON] {
        var messages = loadMockData(resource: "mock_message_template.json")
        
        messages[0]["id"].intValue = id
        messages[0]["chat_id"].intValue = chatId
        messages[0]["sender"].intValue = senderId
        
        return messages
    }
    
    static func MultipleTextMessagesStartingWithID(_ id: Int, chatId: Int, senderId: Int, count: Int) -> [JSON] {
        
        var messages = SingleTextMessageWithID(id, chatId: chatId, senderId: senderId)
        
        for i in 1..<count {
            let nextMessages = SingleTextMessageWithID(id + i, chatId: chatId, senderId: senderId)
            
            messages.append(contentsOf: nextMessages)
        }
        
        return messages
    }
    
    private static func loadMockData(resource: String) -> [JSON] {
        guard let url = Bundle.main.url(forResource: resource, withExtension: nil) else {
            print("🐞 Unable to load resource. File not found: \(resource)")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            return json.arrayValue
        } catch {
            print("🐞 Error while reading mock data: \(error)")
            return []
        }
    }
}
