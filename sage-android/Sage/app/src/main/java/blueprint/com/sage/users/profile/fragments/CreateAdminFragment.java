package blueprint.com.sage.users.profile.fragments;

import android.graphics.Bitmap;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.CreateAdminEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends UserFormAbstractFragment {

    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    public void initializeViews() {
        mCurrentPasswordLayout.setVisibility(View.GONE);
        mPassword.setHint(getString(R.string.sign_up_password));
        mConfirmPassword.setHint(getString(R.string.sign_up_password_confirm));
        mPhoto.setImageDrawable(ViewUtils.getDrawable(getActivity(), R.drawable.ic_account_circle_black_48dp));

        mToolbarInterface.setTitle("Create User");
    }

    public void validateAndSubmitRequest() {
        if (!isValidUser())
            return;

        mUser = new User();

        mUser.setFirstName(mFirstName.getText().toString());
        mUser.setLastName(mLastName.getText().toString());
        mUser.setEmail(mEmail.getText().toString());
        mUser.setPassword(mPassword.getText().toString());
        mUser.setPasswordConfirmation(mPassword.getText().toString());
        mUser.setVerified(true);

        int schoolId = ((School) mSchool.getSelectedItem()).getId();
        Bitmap profile = mPhoto.getImageBitmap();

        mUser.setRole(mRole.getSelectedItemPosition());
        mUser.setVolunteerType(mType.getSelectedItemPosition());

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

    public void onEvent(CreateAdminEvent event) {
        FragUtils.popBackStack(this);
    }
}
