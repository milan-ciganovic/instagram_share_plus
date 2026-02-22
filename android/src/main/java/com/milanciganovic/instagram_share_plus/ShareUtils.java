package com.milanciganovic.instagram_share_plus;

import android.content.Context;
import android.net.Uri;
import android.os.Build;

import java.io.File;

class ShareUtils {

    static Uri getUriForFile(Context context, File file) {
        String authorities = context.getPackageName() + ".instagramshare.fileprovider";

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            return Uri.fromFile(file);
        } else {
            return InstagramShareProvider.getUriForPath(authorities, file.getAbsolutePath());
        }
    }
}
