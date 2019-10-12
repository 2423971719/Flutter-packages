package com.dvote.dvote

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import dvotemobile.Dvotemobile

class DvotePlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "dvote")
      channel.setMethodCallHandler(DvotePlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      // HD WALLETS + BIP 39
      "generateMnemonic" -> {
        val size = call.arguments
        if (size is Int) {
          try {
            result.success(Dvotemobile.generateMnemonic(size.toLong()))
          } catch (e: IllegalArgumentException) {
            result.error("BAD_ARGS", e.message!!, null)
          } catch (e: Exception) {
            result.error("NATIVE_ERR", e.message!!, null)
          }
        }
        else {
          result.error("BAD_ARGS", "Size must be an integer", null)
        }
      }
      "mnemonicToPrivateKey" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val mnemonic = readArgument<String>(args, 0)
          val hdPath = readArgument<String>(args, 1)
          result.success(Dvotemobile.mnemonicToPrivateKey(mnemonic, hdPath))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      "mnemonicToPublicKey" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val mnemonic = readArgument<String>(args, 0)
          val hdPath = readArgument<String>(args, 1)
          result.success(Dvotemobile.mnemonicToPublicKey(mnemonic, hdPath))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      "mnemonicToAddress" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val mnemonic = readArgument<String>(args, 0)
          val hdPath = readArgument<String>(args, 1)
          result.success(Dvotemobile.mnemonicToAddress(mnemonic, hdPath))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      // SIGNATURE
      "signString" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val payload = readArgument<String>(args, 0)
          val privateKey = readArgument<String>(args, 1)
          result.success(Dvotemobile.signString(payload, privateKey))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      "verifySignature" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 3) {
          result.error("BAD_ARGS", "The parameter must be a string array with 3 elements", null)
          return
        }
        try {
          val hexSignature = readArgument<String>(args, 0)
          val payload = readArgument<String>(args, 1)
          val hexPublicKey = readArgument<String>(args, 2)
          result.success(Dvotemobile.verifySignature(hexSignature, payload, hexPublicKey))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      // ENCRYPTION
      "encryptString" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val text = readArgument<String>(args, 0)
          val passphrase = readArgument<String>(args, 1)
          result.success(Dvotemobile.encryptString(text, passphrase))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      "decryptString" -> {
        val args = call.arguments
        if (!(args is List<*>) || args.size != 2) {
          result.error("BAD_ARGS", "The parameter must be a string array with 2 elements", null)
          return
        }
        try {
          val payload = readArgument<String>(args, 0)
          val passphrase = readArgument<String>(args, 1)
          result.success(Dvotemobile.decryptString(payload, passphrase))
        } catch (e: IllegalArgumentException) {
          result.error("BAD_ARGS", e.message!!, null)
        } catch (e: Exception) {
          result.error("NATIVE_ERR", e.message!!, null)
        }
      }
      else -> result.notImplemented()
    }
  }

  // Helper function to extract typed argument lists
  private inline fun <reified T> readArgument(args: List<*>, index: Int): T {
    if (index >= args.size) {
      throw IllegalArgumentException("No argument available at index $index")
    }
    
    val argument = args[index]
    if (argument is T) {
      return argument
    }
    else {
      throw IllegalArgumentException("Argument at index $index " +
              "has unexpected type: ${argument?.javaClass?.name}")
    }
  }
}
