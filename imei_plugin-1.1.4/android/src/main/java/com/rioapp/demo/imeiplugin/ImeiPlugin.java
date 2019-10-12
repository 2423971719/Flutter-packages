package com.rioapp.demo.imeiplugin;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Build;
import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ImeiPlugin
 */
public class ImeiPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
    private final Activity activity;
    private static final int MY_PERMISSIONS_REQUEST_READ_PHONE_STATE = 1995;
    private Result mResult;
    private static boolean ssrpr = false;

    /**
     * Plugin registration.
     * add Listener Request permission
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "imei_plugin");
        ImeiPlugin imeiPlugin = new ImeiPlugin(registrar.activity());
        channel.setMethodCallHandler(imeiPlugin);
        registrar.addRequestPermissionsResultListener(imeiPlugin);
    }

    private ImeiPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void getImei(Activity activity, Result result) {
        try {

            if (ContextCompat.checkSelfPermission((activity), Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                TelephonyManager telephonyManager = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    result.success(telephonyManager.getImei());
                else
                    result.success(telephonyManager.getDeviceId());

            } else {

                if (ssrpr && ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_PHONE_STATE))
                    result.success("Permission Denied");
                else
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);

            }

        } catch (Exception ex) {
            result.success("unknown");
        }
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        mResult = result;

        try {
            ssrpr = call.<Boolean>argument("ssrpr");
        } catch (Exception e) {
            ssrpr = false;
        }

        if (call.method.equals("getImei")) {
            getImei(activity, mResult);
        } else if (call.method.equals("getSha1")) {
            getSha1(activity, mResult);
        } else if (call.method.equals("getMd5")) {
            getMd5(activity, mResult);
        } else {
            mResult.notImplemented();
        }

    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] results) {
        if (requestCode == MY_PERMISSIONS_REQUEST_READ_PHONE_STATE) {
            if (results[0] == PackageManager.PERMISSION_GRANTED) {
                getImei(activity, mResult);
            } else {
                mResult.success("Permission Denied");
            }
            return true;
        }

        return false;
    }

    /**
     * 获取sha1
     *
     * @return
     */
    public static void getSha1(Activity activity, Result result) {
        try {
            PackageInfo info = activity.getPackageManager().getPackageInfo(
                    activity.getPackageName(), PackageManager.GET_SIGNATURES);
            byte[] cert = info.signatures[0].toByteArray();
            MessageDigest md = MessageDigest.getInstance("SHA1");
            byte[] publicKey = md.digest(cert);
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < publicKey.length; i++) {
                String appendString = Integer.toHexString(0xFF & publicKey[i])
                        .toUpperCase(Locale.US);
                if (appendString.length() == 1)
                    hexString.append("0");
                hexString.append(appendString);
                hexString.append(":");
            }
            String results = hexString.toString();
            if (ContextCompat.checkSelfPermission((activity), Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                result.success(results.substring(0, results.length() - 1));
            } else {

                if (ssrpr && ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_PHONE_STATE))
                    result.success("Permission Denied");
                else
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);

            }
        } catch (Exception e) {
            result.success("unknown");
        }

    }

    /**
     * 获取md5
     *
     * @return
     */
    public static void getMd5(Activity activity, Result result) {
        try {
            PackageInfo packageInfo = activity.getPackageManager().getPackageInfo(
                    activity.getPackageName(), PackageManager.GET_SIGNATURES);
            Signature[] signs = packageInfo.signatures;
            Signature sign = signs[0];
            String signStr = encryptionMD5(sign.toByteArray());
            if (ContextCompat.checkSelfPermission((activity), Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                    result.success(signStr);

            } else {

                if (ssrpr && ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_PHONE_STATE))
                    result.success("Permission Denied");
                else
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);

            }
        } catch (Exception e) {
            result.success("unknown");
        }

    }

    public static String encryptionMD5(byte[] byteStr) {
        MessageDigest messageDigest = null;
        StringBuffer md5StrBuff = new StringBuffer();
        try {
            messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(byteStr);
            byte[] byteArray = messageDigest.digest();
//            return Base64.encodeToString(byteArray,Base64.NO_WRAP);
            for (int i = 0; i < byteArray.length; i++) {
                if (Integer.toHexString(0xFF & byteArray[i]).length() == 1) {
                    md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));
                } else {
                    md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));
                }
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return md5StrBuff.toString();
    }
}
