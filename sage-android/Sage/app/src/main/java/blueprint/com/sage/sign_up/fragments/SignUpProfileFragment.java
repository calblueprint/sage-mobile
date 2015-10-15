package blueprint.com.sage.sign_up.fragments;


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
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.sign_up.SignUpActivity;
import blueprint.com.sage.sign_up.events.PhotoEvent;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/12/15.
 * Fragment for profile picture;
 */
public class SignUpProfileFragment extends Fragment {

    @Bind(R.id.sign_up_profile_picture) CircleImageView mProfile;

    private String mPhotoPath;

    private static final int CAMERA_REQUEST = 1337;
    private static final int PICK_PHOTO_REQUEST = 9001;
    private static final int DIALOG_CODE = 200;
    private static final String DIALOG_TAG = "SignUpProfileFragment";

    public static SignUpProfileFragment newInstance() { return new SignUpProfileFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_profile, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    public void onEvent(PhotoEvent event) {
        if (event == null) return;
        onPhotoEvent(event);
    }

    @OnClick(R.id.sign_up_profile_picture)
    public void openPhotoDialog() {
        PhotoOptionDialog dialog = PhotoOptionDialog.newInstance();
        dialog.setTargetFragment(this, DIALOG_CODE);
        dialog.show(getParentFragment().getFragmentManager(), DIALOG_TAG);
    }

    public void onSelectPhotoButtonPressed() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, PICK_PHOTO_REQUEST);
    }

    public void onTakePhotoButtonPressed() {
        Intent takePhotoIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePhotoIntent.resolveActivity(getActivity().getPackageManager()) != null) {
            File photoFile = createImageFile();
            if (photoFile != null) {
                takePhotoIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile));
                startActivityForResult(takePhotoIntent, CAMERA_REQUEST);
            }
        }
    }

    private File createImageFile() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        File image = null;

        try {
            image = File.createTempFile(imageFileName, ".jpg", storageDir);
            mPhotoPath = image.getAbsolutePath();
        } catch (IOException e) {
            Log.e(getClass().toString(), e.toString());
        }

        return image;
    }


    public void onPhotoEvent(PhotoEvent event)  {
        Log.e(getClass().toString(), "got here");

        if (event.getResultCode() != SignUpActivity.RESULT_OK) return;

        switch (event.getRequestCode()) {
            case PICK_PHOTO_REQUEST:
                pickPhotoResult(event.getData());
                break;
            case CAMERA_REQUEST:
                cameraResult(event.getData());
                break;
        }
    }

    private void pickPhotoResult(Intent data) {
        Bitmap photo = null;
        Uri targetUri = data.getData();

        try {
            photo = BitmapFactory.decodeStream(getActivity().getContentResolver().openInputStream(targetUri));
        } catch(FileNotFoundException e) {
            Log.e(getClass().toString(), e.toString());
        }

        insertPhoto(photo);
    }

    private void cameraResult(Intent intent) {
        Bitmap photo;

        int targetH = mProfile.getHeight();
        int targetW = mProfile.getWidth();

        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(mPhotoPath, options);

        int photoH = options.outHeight;
        int photoW = options.outWidth;

        int scaleFactor = 0;
        if (targetH > 0 && targetW > 0) scaleFactor = Math.min(photoH/targetH, photoW/targetW );

        options.inJustDecodeBounds = false;
        options.inSampleSize = scaleFactor;
        options.inPurgeable = true;

        photo = BitmapFactory.decodeFile(mPhotoPath, options);

        insertPhoto(photo);
    }

    private void insertPhoto(Bitmap photo) {
        if (photo == null)
            return;

        int height = photo.getHeight() / 2;
        int width = photo.getWidth() / 2;
        Bitmap scaledBitmap = Bitmap.createScaledBitmap(photo, width, height, false);

        mProfile.setImageBitmap(scaledBitmap);
    }



    public static class PhotoOptionDialog extends DialogFragment {

        private static String[] mOptions = { "Choose a photo", "Take a picture" };

        public static PhotoOptionDialog newInstance() { return new PhotoOptionDialog(); }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

            builder.setItems(mOptions, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (!(getTargetFragment() instanceof SignUpProfileFragment)) {
                        Log.e(getClass().toString(), "Can't even fragment");
                        return;
                    }

                    SignUpProfileFragment fragment = (SignUpProfileFragment) getTargetFragment();

                    if (which == 0) fragment.onSelectPhotoButtonPressed();
                    else fragment.onTakePhotoButtonPressed();
                }
            });

            return builder.create();
        }
    }
}
