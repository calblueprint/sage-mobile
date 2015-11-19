package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Spinner;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.validators.PhotoPicker;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends BrowseAbstractFragment implements FormValidation {

    @Bind(R.id.create_user_first_name) TextView mFirstName;
    @Bind(R.id.create_user_last_name) TextView mLastName;
    @Bind(R.id.create_user_email) TextView mEmail;
    @Bind(R.id.create_user_password) TextView mPassword;
    @Bind(R.id.create_user_confirm_password) TextView mConfirmPassword;

    @Bind(R.id.create_user_school) Spinner mSchool;
    @Bind(R.id.create_user_type) Spinner mType;
    @Bind(R.id.create_user_role) Spinner mRole;
    @Bind(R.id.create_user_photo) CircleImageView mPhoto;

    private PhotoPicker mPhotoPicker;



    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mPhotoPicker = PhotoPicker.newInstance(getParentActivity(), this);
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
        boolean hasErrors = false;

        String firstName = mFirstName.getText().toString();
        String lastName = mLastName.getText().toString();
        String email = mEmail.getText().toString();
        String password = mPassword.getText().toString();
        String confirmPassword = mConfirmPassword.getText().toString();

        if (firstName.isEmpty()) {
            mFirstName.setText(getString(R.string.cannot_be_blank, "First Name"));
            hasErrors = true;
        }

        if (lastName.isEmpty()) {
            mLastName.setText(getString(R.string.cannot_be_blank, "Last Name"));
            hasErrors = true;
        }

        if (email.isEmpty()) {
            mEmail.setText(getString(R.string.cannot_be_blank, "Email"));
            hasErrors = true;
        }

        if (password.isEmpty()) {
            mPassword.setText(getString(R.string.cannot_be_blank, "Password"));
            hasErrors = true;
        }

        if (confirmPassword.isEmpty()) {
            mConfirmPassword.setText(getString(R.string.cannot_be_blank, "Confirm Password"));
            hasErrors = true;
        }

        if (!password.equals(confirmPassword)) {
            mFirstName.setText("");
            hasErrors = true;
        }
    }
}
