package com.spozebra.flutter_zebra_device_ids

import android.annotation.SuppressLint
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.symbol.emdk.EMDKResults
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "spozebra/identifiers"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method!!.contentEquals("initEmdk")) {
                if (EmdkEngine.getInstance().initEmdk(applicationContext))
                    result.success("OK")
                else
                    result.error("KO", "Unable to initialize Emdk", "")
            } else if (call.method!!.contentEquals("setProfile")) {
                val xml = call.argument<String>("xml")
                val r = EmdkEngine.getInstance().setProfile(xml)

                if (r!!.statusCode == EMDKResults.STATUS_CODE.SUCCESS)
                    result.success("OK")
                else
                    result.error(r.statusString, r.extendedStatusMessage, "")

            } else if (call.method!!.contentEquals("getSerialNumber")) {
                val serialNumber = retrieveSerialNumber()
                if (!serialNumber.isNullOrEmpty())
                    result.success(serialNumber)
                else
                    result.error("Unable to find serial number", "", "")
            }
        }
    }

    @SuppressLint("NewApi")
    private fun retrieveSerialNumber(): String {
        val uri = "content://oem_info/oem.zebra.secure/build_serial"
        var column = "build_serial"
        contentResolver.query(
            Uri.parse(uri),
            arrayOf(column),
            null,
            null
        ).use {
            if (it != null) {
                val columnIndexDisplayName = it.getColumnIndexOrThrow(column)

                while (it.moveToNext()) {
                    Log.i("MainActivity", "Column Data: ${uri}")
                    val value = it.getString(columnIndexDisplayName)
                    return value
                }
            }
        }
        return ""
    }
}
