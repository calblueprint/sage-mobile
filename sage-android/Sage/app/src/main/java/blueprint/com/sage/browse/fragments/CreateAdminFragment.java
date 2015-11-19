package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Spinner;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.validators.PhotoPicker;
import blueprint.com.sage.shared.validators.UserValidators;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends BrowseAbstractFragment implements FormValidation {

    @Bind(R.id.create_user_first_name) EditText mFirstName;
    @Bind(R.id.create_user_last_name) EditText mLastName;
    @Bind(R.id.create_user_email) EditText mEmail;
    @Bind(R.id.create_user_password) EditText mPassword;
    @Bind(R.id.create_user_confirm_password) EditText mConfirmPassword;

    @Bind(R.id.create_user_school) Spinner mSchool;
    @Bind(R.id.create_user_type) Spinner mType;
    @Bind(R.id.create_user_role) Spinner mRole;
    @Bind(R.id.create_user_photo) CircleImageView mPhoto;

    private PhotoPicker mPhotoPicker;
    private UserValidators mValidator;

    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mPhotoPicker = PhotoPicker.newInstance(getParentActivity(), this);
        mValidator = UserValidators.newInstance(getParentActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_user, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStart();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater menuInflater) {
        menu.clear();
        menuInflater.inflate(R.menu.menu_save, menu);
        super.onCreateOptionsMenu(menu, menuInflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }

    }

    private void initializeViews() {

    }

    public void validateAndSubmitRequest() {
        if (!isValidUser())
            return;

        String firstName = mFirstName.getText().toString();
        String lastName = mLastName.getText().toString();
        String email = mEmail.getText().toString();
        String password = mPassword.getText().toString();
        String confirmPassword = mConfirmPassword.getText().toString();
        User user = new User(firstName, lastName, email, password, )
    }

    private boolean isValidUser() {
        return mValidator.hasNonBlankField(mFirstName, "First Name") &
                mValidator.hasNonBlankField(mLastName, "Last Name") &
                ((mValidator.hasNonBlankField(mPassword, "Password") &
                  mValidator.hasNonBlankField(mConfirmPassword, "Confirm Password")) &&
                  mValidator.hasMatchingPassword(mPassword, mConfirmPassword)) &
                hasSelectedSpinnerOptions();


    }

    private boolean hasSelectedSpinnerOptions() {

    }
}
