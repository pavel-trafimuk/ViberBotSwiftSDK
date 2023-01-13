//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 23/12/2022.
//

import Foundation

public enum Constants {
    
    /// The authentication token (also known as application key) is a unique
    /// and secret account identifier. It is used to authenticate request
    /// in the Viber API and to prevent unauthorized persons from
    /// sending requests on behalf of a bot. Each API request must
    /// include an HTTP Header called X-Viber-Auth-Token containing the account’s authentication token.
    static let authHeaderKey = "X-Viber-Auth-Token"
    
    /// Each callback will contain a signature on the JSON passed to the callback.
    /// The signature is HMAC with SHA256 that will use the authentication
    /// token as the key and the JSON as the value.
    /// The result will be passed as HTTP Header X-Viber-Content-Signature
    /// so the receiver can determine the origin of the message.
    static let signatureHeaderKey = "X-Viber-Content-Signature"
    
    static let callBacksPath = "bot_callbacks"
    
    // TODO: implement it everywhere
    /// you can use it in any text, it will be replaced on real participant name before sending
    public static let usernamePlaceholder = "replace_me_with_user_name"
    
    /// will be replaced by the URL encoded receiver ID
    public static let encodedReceiverIdPlaceholder = "replace_me_with_url_encoded_receiver_id"
    
    /// will be replaced by the receiver ID
    public static let receiverIdPlaceholder = "replace_me_with_receiver_id"
}
