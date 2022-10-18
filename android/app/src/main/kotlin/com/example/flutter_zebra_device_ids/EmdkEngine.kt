package com.spozebra.flutter_zebra_device_ids

import android.content.Context
import com.symbol.emdk.EMDKManager
import com.symbol.emdk.EMDKResults
import com.symbol.emdk.ProfileManager
import io.flutter.Log


class EmdkEngine : EMDKManager.EMDKListener {

    private var emdkManager: EMDKManager? = null
    private var profileManager: ProfileManager? = null

    fun initEmdk(context : Context) : Boolean {

        if(emdkManager != null)
            throw ExceptionInInitializerError("Emdk already initialized")

        val results = EMDKManager.getEMDKManager(context, this)

        return results.statusCode == EMDKResults.STATUS_CODE.SUCCESS
    }

    override fun onClosed() {
        if (emdkManager != null) {
            emdkManager!!.release()
            emdkManager = null
        }
        Log.d(TAG, "EMDK closed unexpectedly! Please close and restart the application.")
    }

    override fun onOpened(emdkManager: EMDKManager) {

        Log.d(TAG, "EMDK open success.")
        this.emdkManager = emdkManager

        //Get the ProfileManager object to process the profiles
        profileManager = emdkManager.getInstance(EMDKManager.FEATURE_TYPE.PROFILE) as ProfileManager
    }


    fun setProfile(xml: String?): EMDKResults? {
        return try {
            val params = arrayOfNulls<String>(1)
            // Append default profile
            params[0] = """<wap-provisioningdoc>
            <characteristic type="ProfileInfo">
            <parm name="created_wizard_version" value="11.0.1" />
            </characteristic>
            <characteristic type="Profile">
            <parm name="ProfileName" value="OEMService" />
            <parm name="ModifiedDate" value="2022-08-17 10:20:36" />
            <parm name="TargetSystemVersion" value="10.4" />$xml
            </characteristic>
            </wap-provisioningdoc>"""
            profileManager!!.processProfile(
                "MyProfile",
                ProfileManager.PROFILE_FLAG.SET,
                params
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