package com.spozebra.flutter_zebra_device_ids

import androidx.annotation.NonNull
import com.symbol.emdk.EMDKResults
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "spozebra/identifiers"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            if (call.method!!.contentEquals("initEmdk")) {
                if(EmdkEngine.getInstance().initEmdk(applicationContext))
                    result.success("OK")
                else
                    result.error("KO", "Unable to initialize Emdk", "")
            }
            else if (call.method!!.contentEquals("setProfile")) {
                val xmlProfile = call.argument<String>("xmlProfile")
                val r = EmdkEngine.getInstance().setProfile(xmlProfile, null)

                if(r!!.statusCode == EMDKResults.STATUS_CODE.SUCCESS)
                    result.success("OK")
                else
                    result.error(r.statusString, r.extendedStatusMessage, "")

            }
        }
    }
}
