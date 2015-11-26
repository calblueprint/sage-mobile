package blueprint.com.sage.browse.fragments;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.events.users.CreateAdminEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.adapters.RoleSpinnerAdapter;
import blueprint.com.sage.shared.adapters.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.adapters.TypeSpinnerAdapter;
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.shared.validators.PhotoPicker;
import blueprint.com.sage.shared.validators.UserValidators;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/25/15.
 */
public abstract class UserEditAbstractFragment extends Fragment implements FormValidation {
    @Bind(R.id.create_user_layout) LinearLayout mLayout;

    @Bind(R.id.create_user_first_name) EditText mFirstName;
    @Bind(R.id.create_user_last_name) EditText mLastName;
    @Bind(R.id.create_user_email) EditText mEmail;
    @Bind(R.id.create_user_password) EditText mPassword;
    @Bind(R.id.create_user_confirm_password) EditText mConfirmPassword;
    @Bind(R.id.create_user_current_password) EditText mCurrentPassword;

    @Bind(R.id.user_role_layout) View mRoleLayout;
    @Bind(R.id.user_school_layout) View mSchoolLayout;
    @Bind(R.id.user_current_password_layout) View mCurrentPasswordLayout;
    @Bind(R.id.user_type_layout) View mTypeLayout;

    @Bind(R.id.create_user_school) Spinner mSchool;
    @Bind(R.id.create_user_type) Spinner mType;
    @Bind(R.id.create_user_role) Spinner mRole;
    @Bind(R.id.create_user_photo) CircleImageView mPhoto;

    private PhotoPicker mPhotoPicker;
    private UserValidators mValidator;
    private SchoolSpinnerAdapter mSchoolAdapter;
    private TypeSpinnerAdapter mTypeAdapter;
    private RoleSpinnerAdapter mRoleAdapter;

    private static final int DIALOG_CODE = 200;
    private static final String DIALOG_TAG = "UserEditAbstractFragment";

    protected NavigationInterface mNavigationInterface;
    protected User mUser;

    List<School> mSchools;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mPhotoPicker = PhotoPicker.newInstance(getActivity(), this);
        mValidator = UserValidators.newInstance(getActivity());
        mNavigationInterface = (NavigationInterface) getActivity();
        mSchools = new ArrayList<>();
        Requests.Schools.with(getActivity()).makeListRequest(null);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_user, parent, false);
        ButterKnife.bind(this, view);
        initializeSpinners();
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

    private void initializeSpinners() {
        mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(),
                mSchools,
                R.layout.user_spinner_item, R.layout.user_spinner_item);
        mSchool.setAdapter(mSchoolAdapter);

        mTypeAdapter = new TypeSpinnerAdapter(getActivity(),
                getResources().getStringArray(R.array.volunteer_types),
                R.layout.user_spinner_item, R.layout.user_spinner_item);

        mType.setAdapter(mTypeAdapter);

        mRoleAdapter = new RoleSpinnerAdapter(getActivity(),
                getResources().getStringArray(R.array.role_types),
                R.layout.user_spinner_item, R.layout.user_spinner_item);

        mRole.setAdapter(mRoleAdapter);
    }

    public abstract void initializeViews();

    @OnClick(R.id.create_user_photo)
    public void onPhotoClick(CircleImageView imageView) {
        PhotoPicker.PhotoOptionDialog dialog = PhotoPicker.PhotoOptionDialog.newInstance(mPhotoPicker);
        dialog.setTargetFragment(this, DIALOG_CODE);
        dialog.show(getFragmentManager(), DIALOG_TAG);
    }

    public void validateAndSubmitRequest() {
        if (!isValidUser())
            return;

        if (this instanceof CreateAdminFragment)
            mUser = new User();

        mUser.setFirstName(mFirstName.getText().toString());
        mUser.setLastName(mLastName.getText().toString());
        mUser.setEmail(mEmail.getText().toString());
        mUser.setPassword(mPassword.getText().toString());
        mUser.setConfirmPassword(mPassword.getText().toString());

        int schoolId = ((School) mSchool.getSelectedItem()).getId();
        Bitmap profile = mPhoto.getImageBitmap();

        if (mRoleLayout.getVisibility() == View.VISIBLE) {
            int role = mRole.getSelectedItemPosition();
            mUser.setRoleInt(role);
        }

        if (mTypeLayout.getVisibility() == View.VISIBLE) {
            int volunteer = mType.getSelectedItemPosition();
            mUser.setVolunteerTypeInt(volunteer);
        }

        if (mCurrentPasswordLayout.getVisibility() == View.VISIBLE) {
            mUser.setCurrentPassword(mCurrentPassword.getText().toString());
        }

        mUser.setSchoolId(schoolId);
        mUser.setProfile(profile);

        if (this instanceof CreateAdminFragment) {
            Requests.Users.with(getActivity()).makeCreateAdminRequest(mUser);
        } else if (this instanceof EditUserFragment) {
            Requests.Users.with(getActivity()).makeEditRequest(mUser);
        }
    }

    private boolean isValidUser() {
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

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        mSchoolAdapter.setSchools(mSchools);
    }
}
