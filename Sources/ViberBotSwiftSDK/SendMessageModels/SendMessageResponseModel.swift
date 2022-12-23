//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

public struct SendMessageResponseModel: Codable {
    /// Action result.
    /// 0 for success. In case of failure - appropriate failure status number. See error codes table for additional information
    public let status: ResponseStatus
    
    /// ok or failure reason.
    public let statusMessage: String
    
    public let messageToken: Int64?
    
    public let billingStatus: BillingStatus?
    
    public enum BillingStatus: Int, Codable {
        /// Default for all cases other than the ones listed below: chat extension, reply to open conversation, etc.
        case free = 0
        
        /// 1:1 message/keyboard sent in a session from a non-billable bot
        case inSessionNonBillableBot = 1
        
        /// 1:1 message/keyboard sent in a session from a billable bot
        case inSessionForBillableBot = 2
        
        /// Free out of session 1:1 message/keyboard sent by a non-billable bot
        case outOfSessionFreeMessageNonBillableBot = 3
        
        /// Free out of session 1:1 message/keyboard sent by a billable bot
        case outOfSessionFreeMessageForBillableBot = 4
        
        /// Charged out of session 1:1 message/keyboard sent by a billable bot
        case outOfSessionBilledMessage = 5
    }
    
    public enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case messageToken = "message_token"
        case billingStatus = "billing_status"
    }
}
