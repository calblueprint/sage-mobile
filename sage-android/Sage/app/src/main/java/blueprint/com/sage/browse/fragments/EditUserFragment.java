package blueprint.com.sage.browse.fragments;

import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;

import blueprint.com.sage.events.users.CreateAdminEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/25/15.
 */
public class EditUserFragment extends UserEditAbstractFragment {

    public static EditUserFragment newInstance(User user) {
        EditUserFragment fragment = new EditUserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    public void initializeViews() {
        mFirstName.setText(mUser.getFirstName());
        mLastName.setText(mUser.getLastName());
        mEmail.setText(mUser.getEmail());
        mUser.loadUserImage(getActivity(), mPhoto);
        setSchool(mUser.getSchoolId());

        mTypeLayout.setVisibility(View.GONE);
        mRoleLayout.setVisibility(View.GONE);
    }

    public void validateAndSubmitRequest() {
        if (!isValidUser())
            return;

        mUser.setFirstName(mFirstName.getText().toString());
        mUser.setLastName(mLastName.getText().toString());
        mUser.setEmail(mEmail.getText().toString());
        mUser.setCurrentPassword(mCurrentPassword.getText().toString());

        if (!mPassword.getText().toString().isEmpty()) {
            mUser.setPassword(mPassword.getText().toString());
            mUser.setConfirmPassword(mPassword.getText().toString());
        }

        int schoolId = ((School) mSchool.getSelectedItem()).getId();
        Bitmap profile = mPhoto.getImageBitmap();

        mUser.setSchoolId(schoolId);
        mUser.setProfile(profile);

        Requests.Users.with(getActivity()).makeEditRequest(mUser);
    }

    public boolean isValidUser() {
        return mValidator.hasNonBlankField(mFirstName, "First Name") &
                mValidator.hasNonBlankField(mLastName, "Last Name") &
                hasValidEmail() &
                (hasEmptyPasswords() || hasMatchingPasswords()) &
                mValidator.mustBePicked(mSchool, "School", mLayout) &
                mValidator.hasNonBlankField(mCurrentPassword, "Current Password");
    }

    private boolean hasValidEmail() {
        return mValidator.hasNonBlankField(mEmail, "Email") &&
                mValidator.hasValidEmail(mEmail);
    }

    private boolean hasEmptyPasswords() {
        return mPassword.getText().toString().isEmpty() &&
                mConfirmPassword.getText().toString().isEmpty();
    }

    private boolean hasMatchingPasswords() {
        return (mValidator.hasNonBlankField(mPassword, "Password") &
                mValidator.hasNonBlankField(mConfirmPassword, "Confirm Password")) &&
                mValidator.hasMatchingPassword(mPassword, mConfirmPassword);
    }

    public void onEvent(CreateAdminEvent event) {
        try {
            NetworkUtils.setUser(getActivity(), event.getUser());
            mBaseInterface.setUser(event.getUser());
        } catch(Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
        FragUtils.popBackStack(this);
    }
}
