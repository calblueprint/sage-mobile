package blueprint.com.sage.shared.validators;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.widget.ImageView;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by charlesx on 11/18/15.
 */
public class PhotoPicker {

    private Activity mActivity;
    private Fragment mFragment;
    private String mPhotoPath;

    public static final int CAMERA_REQUEST = 1337;
    public static final int PICK_PHOTO_REQUEST = 9001;

    public PhotoPicker(Activity activity, Fragment fragment) {
        mActivity = activity;
        mFragment = fragment;
    }

    public static PhotoPicker newInstance(Activity activity, Fragment fragment) {
        return new PhotoPicker(activity, fragment);
    }

    public void onSelectPhotoButton() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        mFragment.startActivityForResult(intent, PICK_PHOTO_REQUEST);
    }

    public void onTakePhotoButton() {
        Intent takePhotoIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePhotoIntent.resolveActivity(mActivity.getPackageManager()) != null) {

            File photoFile = null;

            try {
                photoFile = createImageFile();
            } catch (IOException e) {
                Log.e(getClass().toString(), e.toString());
            }

            if (photoFile != null) {
                takePhotoIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile));
                mFragment.startActivityForResult(takePhotoIntent, CAMERA_REQUEST);
            }
        }
    }

    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(imageFileName, ".jpg", storageDir);
        mPhotoPath = image.getAbsolutePath();
        return image;
    }

    public Bitmap pickPhotoResult(Intent data, ImageView imageView) {
        Bitmap photo;
        Uri targetUri = data.getData();

        try {
            final int IMAGE_MAX_SIZE = 100000; // 1.2MP
            InputStream in = mActivity.getContentResolver().openInputStream(targetUri);

            // Decode image size
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeStream(in, null, options);
            in.close();

            int scale = 1;
            while ((options.outWidth * options.outHeight) * (1 / Math.pow(scale, 2)) >
                    IMAGE_MAX_SIZE) {
                scale++;
            }
            Log.e("size", "" + scale);
            Bitmap bitmap;
            in = mActivity.getContentResolver().openInputStream(targetUri);
            if (scale > 1) {
                options = new BitmapFactory.Options();
                options.inSampleSize = scale;
                bitmap = BitmapFactory.decodeStream(in, null, options);

                // resize to desired dimensions
                int height = bitmap.getHeight();
                int width = bitmap.getWidth();

                double y = Math.sqrt(IMAGE_MAX_SIZE
                        / (((double) width) / height));
                double x = (y / height) * width;
                Log.e("x & y", "x: " + x + " y: " + y);
                Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, (int) x,
                        (int) y, true);
                bitmap.recycle();
                photo = scaledBitmap;
                Log.e("bitmap size", photo.getByteCount() + "");
                in.close();
                return photo;

            } else {
                photo = BitmapFactory.decodeStream(in);
                Log.e("bitmap size", photo.getByteCount() + "");

                in.close();
                return photo;
            }



        } catch(Exception e) {
            Log.e(getClass().toString(), e.toString());
        }

        return null;
    }

    public Bitmap takePhotoResult(Intent data, ImageView imageView) {
        Bitmap photo;

        int targetH = imageView.getHeight();
        int targetW = imageView.getWidth();

        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(mPhotoPath, options);

        int photoH = options.outHeight;
        int photoW = options.outWidth;

        int scaleFactor = 0;
        if (targetH > 0 && targetW > 0)
            scaleFactor = Math.min(photoH/targetH, photoW/targetW );

        options.inJustDecodeBounds = false;
        options.inSampleSize = scaleFactor;
        options.inPurgeable = true;

        photo = BitmapFactory.decodeFile(mPhotoPath, options);

        return insertPhoto(photo);
    }

    private Bitmap insertPhoto(Bitmap photo) {
        if (photo == null)
            return null;

        int height = photo.getHeight() / 4;
        int width = photo.getWidth() / 4;
        Bitmap bitmap =Bitmap.createScaledBitmap(photo, width, height, false);
        Log.e("bitmap scaled size", bitmap.getByteCount() + "");
        return bitmap;
    }

    public static class PhotoOptionDialog extends DialogFragment {

//        private static String[] mOptions = { "Choose a photo", "Take a picture" };
        private static String[] mOptions = { "Choose a photo" };
        private PhotoPicker mPicker;

        public static PhotoOptionDialog newInstance(PhotoPicker picker) {
            PhotoOptionDialog dialog = new PhotoOptionDialog();
            dialog.setPicker(picker);
            return dialog;
        }

        public void setPicker(PhotoPicker picker) { mPicker = picker; }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

            builder.setItems(mOptions, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (which == 0) mPicker.onSelectPhotoButton();
                    else mPicker.onTakePhotoButton();
                }
            });

            return builder.create();
        }
    }
}
