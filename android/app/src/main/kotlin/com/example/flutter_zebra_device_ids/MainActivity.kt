package com.spozebra.flutter_zebra_device_ids

import android.annotation.SuppressLint
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.example.flutter_zebra_device_ids.IEmdkStatusListener
import com.symbol.emdk.EMDKResults
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class MainActivity: FlutterActivity(), IEmdkStatusListener {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->

            when {
                call.method!!.contentEquals("initEmdk") -> {
                    initEmdk(result)
                }
                call.method!!.contentEquals("setProfile") -> {
                    val profileName = call.argument<String>("profileName")
                    setProfile(result, profileName!!)
                }
                call.method!!.contentEquals("getSerialNumber") -> {
                    val uri = "content://oem_info/oem.zebra.secure/build_serial"
                    val info = "build_serial"
                    retrieveIdentifier(result, uri, info)
                }
            }
        }
    }
    private fun initEmdk(result : MethodChannel.Result){
        if (EmdkEngine.getInstance().initEmdk(applicationContext, this))
            result.success("OK")
        else
            result.error("KO", "Unable to initialize Emdk", "")
    }
    private fun setProfile(result : MethodChannel.Result, profileName : String){
        val r = EmdkEngine.getInstance().setProfile(profileName)

        if (r!!.statusCode == EMDKResults.STATUS_CODE.SUCCESS || r!!.statusCode == EMDKResults.STATUS_CODE.CHECK_XML)
            result.success("OK")
        else
            result.error(r.statusString, r.extendedStatusMessage, "")
    }

    @SuppressLint("NewApi")
    private fun retrieveIdentifier(result : MethodChannel.Result, uri : String, info : String) {
        try {
            contentResolver.query(
                Uri.parse(uri),
                arrayOf(info),
                null,
                null
            ).use {
                if (it != null) {
                    val columnIndexDisplayName = it.getColumnIndexOrThrow(info)

                    while (it.moveToNext()) {
                        Log.i("MainActivity", "Column Data: $uri")
                        val value = it.getString(columnIndexDisplayName)
                        result.success(value)
                    }
                } else {
                    throw Exception("Content provider is null")
                }
            }
        }
        catch (ex: Exception){
            result.error("Unable to find serial number", ex.message, "")
        }
    }

    // Emdk Events
    override fun emdkOpened() {
        methodChannel!!.invokeMethod("emdkOpened", null)
    }

    override fun emdkClosed() {
        methodChannel!!.invokeMethod("emdkClosed", null)
    }

    companion object {
        private const val CHANNEL = "spozebra/identifiers"
        private var methodChannel : MethodChannel? = null
    }
}
