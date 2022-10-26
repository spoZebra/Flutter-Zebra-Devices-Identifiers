package com.spozebra.flutter_zebra_device_ids

import android.content.Context
import com.example.flutter_zebra_device_ids.IEmdkStatusListener
import com.symbol.emdk.EMDKManager
import com.symbol.emdk.EMDKResults
import com.symbol.emdk.ProfileManager
import io.flutter.Log


class EmdkEngine : EMDKManager.EMDKListener {

    private lateinit var listener : IEmdkStatusListener
    private var emdkManager: EMDKManager? = null
    private var profileManager: ProfileManager? = null

    fun initEmdk(context : Context, listener : IEmdkStatusListener) : Boolean {

        if(emdkManager != null)
            throw ExceptionInInitializerError("Emdk already initialized")

        this.listener = listener

        val results = EMDKManager.getEMDKManager(context, this)

        return results.statusCode == EMDKResults.STATUS_CODE.SUCCESS
    }

    override fun onClosed() {
        if (emdkManager != null) {
            emdkManager!!.release()
            emdkManager = null
        }
        // notify closed
        listener.emdkClosed()
        Log.d(TAG, "EMDK closed unexpectedly! Please close and restart the application.")
    }

    override fun onOpened(emdkManager: EMDKManager) {

        Log.d(TAG, "EMDK open success.")
        this.emdkManager = emdkManager

        //Get the ProfileManager object to process the profiles
        profileManager = emdkManager.getInstance(EMDKManager.FEATURE_TYPE.PROFILE) as ProfileManager

        // notify successful initialization
        listener.emdkOpened()
    }


    fun setProfile(profileName: String?): EMDKResults? {
        return try {
            val params = arrayOfNulls<String>(0)

            val test :Array<String>? = null
            profileManager!!.processProfile(
                profileName,
                ProfileManager.PROFILE_FLAG.SET,
                test
            )
        } catch (ex: Exception) {
            Log.e(TAG, ex.toString())
            null
        }
    }

    protected fun releaseResources() {
        //Clean up the objects created by EMDK manager
        if (profileManager != null)
            profileManager = null

        if (emdkManager != null) {
            emdkManager!!.release()
            emdkManager = null
        }
    }

    init {
        INSTANCE = this
    }

    companion object {
        const val TAG = "EmdkEngine"

        @Volatile
        private var INSTANCE: EmdkEngine? = null

        fun getInstance(): EmdkEngine {
            synchronized(this) {
                var instance = INSTANCE

                if (instance == null) {
                    instance = EmdkEngine()
                    INSTANCE = instance
                }
                return instance
            }
        }
    }
}