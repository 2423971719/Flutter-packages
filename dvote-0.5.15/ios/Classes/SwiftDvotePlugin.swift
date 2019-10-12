import Flutter

import Dvotemobile

public class SwiftDvotePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dvote", binaryMessenger: registrar.messenger())
    let instance = SwiftDvotePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var error: NSError?

    switch call.method {
      // HD wallets
      case "generateMnemonic": 
        if let arg = call.arguments as? Int {
          let mnemonic = Dvotemobile.DvotemobileGenerateMnemonic(arg, &error)
          if error != nil {
            result(FlutterError(code: "GENERATION_ERROR", 
              message: "Unable to generate a mnemonic",
              details: nil))
            break
          }
          result(mnemonic)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "Size should be an integer",
            details: nil))
        }
        break
        
      case "mnemonicToPrivateKey": 
        let args = call.arguments as? [String]
        let mnemonic = args?[0], hdPath = args?[1]
        if mnemonic != nil && hdPath != nil {
          let privKey = Dvotemobile.DvotemobileMnemonicToPrivateKey(mnemonic, hdPath, &error)
          if error != nil {
            result(FlutterError(code: "CONVERT_ERROR", 
              message: "Unable to convert the mnemonic",
              details: nil))
            break
          }
          result(privKey)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      case "mnemonicToPublicKey":
        let args = call.arguments as? [String]
        let mnemonic = args?[0], hdPath = args?[1]
        if mnemonic != nil && hdPath != nil {
          let pubKey = Dvotemobile.DvotemobileMnemonicToPublicKey(mnemonic, hdPath, &error)
          if error != nil {
            result(FlutterError(code: "CONVERT_ERROR", 
              message: "Unable to convert the mnemonic",
              details: nil))
            break
          }
          result(pubKey)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      case "mnemonicToAddress":
        let args = call.arguments as? [String]
        let mnemonic = args?[0], hdPath = args?[1]
        if mnemonic != nil && hdPath != nil {
          let address = Dvotemobile.DvotemobileMnemonicToAddress(mnemonic, hdPath, &error)
          if error != nil {
            result(FlutterError(code: "CONVERT_ERROR", 
              message: "Unable to convert the mnemonic",
              details: nil))
            break
          }
          result(address)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      // Signing
      case "signString":
        let args = call.arguments as? [String]
        let text = args?[0], privateKey = args?[1]
        if text != nil && privateKey != nil {
          let signature = Dvotemobile.DvotemobileSignString(text, privateKey, &error)
          if error != nil {
            result(FlutterError(code: "SIGN_ERROR", 
              message: "Unable to sign the text",
              details: nil))
            break
          }
          result(signature)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      case "verifySignature":
        let args = call.arguments as? [String]
        let hexSignature = args?[0], payload = args?[1], hexPublicKey = args?[2]
        var isValid = ObjCBool(false)

        if hexSignature != nil && payload != nil && hexPublicKey != nil {
          Dvotemobile.DvotemobileVerifySignature(hexSignature, payload, hexPublicKey, &isValid, &error)
          if error != nil {
            result(FlutterError(code: "VERIFY_ERROR", 
              message: "Unable to verify the signature",
              details: nil))
            break
          }
          result(isValid.boolValue)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 3 elements",
            details: nil))
        }
        break
        
      // Encryption
      case "encryptString":
        let args = call.arguments as? [String]
        let text = args?[0], passphrase = args?[1]
        if text != nil && passphrase != nil {
          let encryptedText = Dvotemobile.DvotemobileEncryptString(text, passphrase, &error)
          if error != nil {
            result(FlutterError(code: "ENCRYPT_ERROR", 
              message: "Unable to encrypt the text",
              details: nil))
            break
          }
          result(encryptedText)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      case "decryptString":
        let args = call.arguments as? [String]
        let cipherText = args?[0], passphrase = args?[1]
        if cipherText != nil && passphrase != nil {
          let decryptedText = Dvotemobile.DvotemobileDecryptString(cipherText, passphrase, &error)
          if error != nil {
            result(FlutterError(code: "DECRYPT_ERROR", 
              message: "Unable to decrypt the payload",
              details: nil))
            break
          }
          result(decryptedText)
        }
        else {
          result(FlutterError(code: "INVALID_PARAMS", 
            message: "The argument must be a string array with 2 elements",
            details: nil))
        }
        break
        
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
