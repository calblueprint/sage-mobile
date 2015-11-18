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


    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        super.onCreate(savedInstanceState);
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


    }
}
