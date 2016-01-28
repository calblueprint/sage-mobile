package blueprint.com.sage.users.profile.fragments;

import android.annotation.TargetApi;
import android.content.Intent;
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
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.adapters.spinners.RoleSpinnerAdapter;
import blueprint.com.sage.shared.adapters.spinners.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.adapters.spinners.StringArraySpinnerAdapter;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.shared.validators.PhotoPicker;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.signUp.SignUpActivity;
import blueprint.com.sage.utility.PermissionsUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/25/15.
 */
public abstract class UserFormAbstractFragment extends Fragment implements FormValidation {
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
    protected FormValidator mValidator;

    private SchoolSpinnerAdapter mSchoolAdapter;
    private StringArraySpinnerAdapter mTypeAdapter;
    private RoleSpinnerAdapter mRoleAdapter;

    private static final int DIALOG_CODE = 200;
    private static final String DIALOG_TAG = "UserFormAbstractFragment";

    protected BaseInterface mBaseInterface;
    protected User mUser;

    List<School> mSchools;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mPhotoPicker = PhotoPicker.newInstance(getActivity(), this);
        mValidator = FormValidator.newInstance(getActivity());
        mBaseInterface = (BaseInterface) getActivity();
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

    @SuppressWarnings("deprecation")
    @TargetApi(16)
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode != SignUpActivity.RESULT_OK) return;

        switch (requestCode) {
            case PhotoPicker.CAMERA_REQUEST:
                mPhotoPicker.takePhotoResult(data, mPhoto);
                break;
            case PhotoPicker.PICK_PHOTO_REQUEST:
                mPhotoPicker.pickPhotoResult(data, mPhoto);
                break;
        }
    }

    private void initializeSpinners() {
        mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(),
                mSchools,
                R.layout.simple_spinner_header,
                R.layout.simple_spinner_item);
        mSchool.setAdapter(mSchoolAdapter);

        mTypeAdapter = new StringArraySpinnerAdapter(getActivity(),
                User.VOLUNTEER_SPINNER,
                R.layout.simple_spinner_header,
                R.layout.simple_spinner_item);

        mType.setAdapter(mTypeAdapter);

        mRoleAdapter = new RoleSpinnerAdapter(getActivity(),
                User.ROLE_SPINNER,
                R.layout.simple_spinner_header,
                R.layout.simple_spinner_item);

        mRole.setAdapter(mRoleAdapter);
    }

    public abstract void initializeViews();

    @OnClick(R.id.create_user_photo)
    public void onPhotoClick(CircleImageView imageView) {
        if (PermissionsUtils.hasIOPermissions(getActivity())) {
            PermissionsUtils.requestIOPermissions(getActivity());
            return;
        }

        PhotoPicker.PhotoOptionDialog dialog = PhotoPicker.PhotoOptionDialog.newInstance(mPhotoPicker);
        dialog.setTargetFragment(this, DIALOG_CODE);
        dialog.show(getFragmentManager(), DIALOG_TAG);
    }

    public abstract void validateAndSubmitRequest();

    public abstract boolean isValidUser();

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        mSchoolAdapter.setSchools(mSchools);

        if (mUser != null && mUser.getSchoolId() > 0)
            setSchool(mUser.getSchoolId());
    }

    public void setSchool(int id) {
        for (int i = 0; i < mSchools.size(); i++)
            if (mSchools.get(i).getId() == id)
                mSchool.setSelection(i);
    }
}
