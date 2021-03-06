package blueprint.com.sage.users.profile.fragments;

import android.util.Log;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.EditUserEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by charlesx on 11/25/15.
 */
public class EditUserFragment extends UserFormAbstractFragment {

    public static EditUserFragment newInstance(User user) {
        EditUserFragment fragment = new EditUserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    public void initializeViews() {
        mToolbarInterface.setTitle("Edit User");
        mFirstName.setText(mUser.getFirstName());
        mLastName.setText(mUser.getLastName());
        mEmail.setText(mUser.getEmail());
        mUser.loadUserImage(getActivity(), mPhoto);
        setSchool(mUser.getSchoolId());

        mTypeLayout.setVisibility(View.GONE);
        mRoleLayout.setVisibility(View.GONE);

        mPassword.setHint(getString(R.string.optional));
        mConfirmPassword.setHint(getString(R.string.optional));
    }

    public void validateAndSubmitRequest() {
        if (!mValidator.hasNonBlankField(mCurrentPassword, "Current Password")) {
            mScrollView.scrollTo(0, mScrollView.getBottom());
            return;
        }

        if (!isValidUser())
            return;

        mUser.setFirstName(mFirstName.getText().toString());
        mUser.setLastName(mLastName.getText().toString());
        mUser.setEmail(mEmail.getText().toString());
        mUser.setCurrentPassword(mCurrentPassword.getText().toString());

        if (!mPassword.getText().toString().isEmpty()) {
            mUser.setPassword(mPassword.getText().toString());
            mUser.setPasswordConfirmation(mPassword.getText().toString());
        }

        int schoolId = ((School) mSchool.getSelectedItem()).getId();

        mUser.setSchoolId(schoolId);
        mUser.setProfile(mProfileBitmap);

        mItem.setActionView(R.layout.actionbar_indeterminate_progress);
        Requests.Users.with(getActivity()).makeStickyEditRequest(mUser);
    }

    public boolean isValidUser() {
        return mValidator.hasNonBlankField(mFirstName, "First Name") &
                mValidator.hasNonBlankField(mLastName, "Last Name") &
                hasValidEmail() &
                (hasEmptyPasswords() || hasMatchingPasswords()) &
                mValidator.mustBePicked(mSchool, "School", mLayout);
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

    public void onEvent(EditUserEvent event) {
        try {
            NetworkUtils.setUser(getActivity(), event.getUser());
            NetworkUtils.setSchool(getActivity(), event.getUser().getSchool());

            mBaseInterface.setUser(event.getUser());
            mBaseInterface.setSchool(event.getUser().getSchool());
        } catch(Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
        getActivity().onBackPressed();
    }
}
