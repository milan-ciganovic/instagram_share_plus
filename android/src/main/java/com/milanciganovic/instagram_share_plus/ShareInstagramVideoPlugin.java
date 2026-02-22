package com.milanciganovic.instagram_share_plus;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * InstagramsharePlugin
 */
public class ShareInstagramVideoPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String INSTAGRAM_PACKAGE_NAME = "com.instagram.android";

    private MethodChannel mChannel;
    private Context mContext;
    private Activity mActivity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        mChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "instagram_share_plus");
        mChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mChannel.setMethodCallHandler(null);
        mChannel = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("shareVideoToInstagram")) {
            String path = call.argument("path");
            String type = call.argument("type");
            shareToInstagram(path, type);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private boolean instagramInstalled() {
        try {
            PackageManager pm = mContext.getPackageManager();
            pm.getPackageInfo(INSTAGRAM_PACKAGE_NAME, PackageManager.GET_ACTIVITIES);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private void openInstagramInPlayStore() {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setData(Uri.parse("market://details?id=" + INSTAGRAM_PACKAGE_NAME));
        mContext.startActivity(intent);
    }

    private void shareToInstagram(String path, String type) {
        String mediaType = "image".equals(type) ? "image/jpeg" : "video/*";

        File f = new File(path);
        Uri uri = ShareUtils.getUriForFile(mContext, f);

        if (instagramInstalled()) {
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setPackage(INSTAGRAM_PACKAGE_NAME);
            shareIntent.setType(mediaType);
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
            shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            try {
                mContext.startActivity(shareIntent);
            } catch (ActivityNotFoundException ex) {
                openInstagramInPlayStore();
            }
        } else {
            openInstagramInPlayStore();
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
