package blueprint.com.sage.browse.fragments;

import android.graphics.Bitmap;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends UserEditAbstractFragment {

    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    public void initializeViews() {
        mCurrentPasswordLayout.setVisibility(View.GONE);
        mPassword.setText(getString(R.string.sign_up_password));
        mConfirmPassword.setText(getString(R.string.sign_up_password_confirm));

        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Create User");
    }

    public void validateAndSubmitRequest() {
        if (!isValidUser())
            return;

        mUser = new User();

        mUser.setFirstName(mFirstName.getText().toString());
        mUser.setLastName(mLastName.getText().toString());
        mUser.setEmail(mEmail.getText().toString());
        mUser.setPassword(mPassword.getText().toString());
        mUser.setConfirmPassword(mPassword.getText().toString());

        int schoolId = ((School) mSchool.getSelectedItem()).getId();
        Bitmap profile = mPhoto.getImageBitmap();

        int role = mRole.getSelectedItemPosition();
        mUser.setRoleInt(role);

        int volunteer = mType.getSelectedItemPosition();
        mUser.setVolunteerTypeInt(volunteer);

        mUser.setSchoolId(schoolId);
        mUser.setProfile(profile);

        Requests.Users.with(getActivity()).makeCreateAdminRequest(mUser);
    }

    public boolean isValidUser() {
        return mValidator.hasNonBlankField(mFirstName, "First Name") &
                mValidator.hasNonBlankField(mLastName, "Last Name") &
                (mValidator.hasNonBlankField(mEmail, "Email") &&
                        mValidator.hasValidEmail(mEmail)) &
                ((mValidator.hasNonBlankField(mPassword, "Password") &
                        mValidator.hasNonBlankField(mConfirmPassword, "Confirm Password")) &&
                        mValidator.hasMatchingPassword(mPassword, mConfirmPassword)) &
                mValidator.mustBePicked(mSchool, "School", mLayout);
    }
}
