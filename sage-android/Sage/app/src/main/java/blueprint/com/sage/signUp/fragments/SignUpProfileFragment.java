package blueprint.com.sage.signUp.fragments;


import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.interfaces.PhotoPickerInterface;
import blueprint.com.sage.shared.validators.PhotoPicker;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.PermissionsUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/12/15.
 * Fragment for profile picture;
 */
public class SignUpProfileFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_profile_picture) CircleImageView mProfile;

    private static final int DIALOG_CODE = 200;
    private static final String DIALOG_TAG = "SignUpProfileFragment";

    private Bitmap mProfileBitmap;
    private PhotoPicker mPhotoPicker;

    public static SignUpProfileFragment newInstance() { return new SignUpProfileFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mPhotoPicker = PhotoPicker.newInstance(getActivity(), (PhotoPickerInterface) getParentFragment());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_profile, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {
        Bitmap bitmap = mSignUpInterface.getUser().getProfile();
        if (bitmap != null)
            mProfile.setImageBitmap(bitmap);
    }

    @OnClick(R.id.sign_up_profile_picture)
    public void openPhotoDialog() {
        if (!PermissionsUtils.hasIOPermissions(getActivity())) {
            PermissionsUtils.requestIOPermissions(getActivity());
            return;
        }

        PhotoPicker.PhotoOptionDialog dialog = PhotoPicker.PhotoOptionDialog.newInstance(mPhotoPicker);
        dialog.setTargetFragment(this, DIALOG_CODE);
        dialog.show(getParentFragment().getFragmentManager(), DIALOG_TAG);
    }

    public void pickPhotoResult(Intent data) {
        mProfileBitmap = mPhotoPicker.pickPhotoResult(data, mProfile);
        setProfileImage();
    }

    public void takePhotoResult(Intent data) {
        mProfileBitmap = mPhotoPicker.takePhotoResult(data, mProfile);
        setProfileImage();
    }

    public void removePhotoResult() {
        mProfileBitmap = null;
        setProfileImage();
    }

    private void setProfileImage() {
        Bitmap bitmap = mProfileBitmap == null ?
                BitmapFactory.decodeResource(getResources(), R.drawable.default_profile) :
                mProfileBitmap;

        mProfile.setImageBitmap(bitmap);
    }

    public boolean hasValidFields() { return true; }

    public void setUserFields() {
        User user = mSignUpInterface.getUser();
        user.setProfile(mProfileBitmap);
    }

    public void onEvent(APIErrorEvent event) {
        if (mLayout != null)
            mLayout.stopSpinning();
    }
}
