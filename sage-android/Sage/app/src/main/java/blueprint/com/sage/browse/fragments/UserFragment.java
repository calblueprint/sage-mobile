package blueprint.com.sage.browse.fragments;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.EditUserEvent;
import blueprint.com.sage.events.users.PromoteUserEvent;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.shared.interfaces.PromoteInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/22/15.
 * Shows a user
 */
public class UserFragment extends Fragment implements PromoteInterface {

    @Bind(R.id.user_layout) View mLayout;
    @Bind(R.id.user_name) TextView mName;
    @Bind(R.id.user_school) TextView mSchool;
    @Bind(R.id.user_total_hours) TextView mHours;
    @Bind(R.id.user_photo) CircleImageView mPhoto;

    private User mUser;

    private BaseInterface mBaseInterface;
    private NavigationInterface mNavigationInterface;

    private static final int DIALOG_CODE = 200;
    private static final String DIALOG_TAG = "UserFragment";

    public static UserFragment newInstance(User user) {
        UserFragment fragment = new UserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mBaseInterface = (BaseInterface) getActivity();
        mNavigationInterface = (NavigationInterface) getActivity();
        Requests.Users.with(getActivity()).makeShowRequest(mUser);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user, parent, false);
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
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();

        int layoutId = 0;
        User currentUser = mBaseInterface.getUser();
        if (currentUser.getId() == mUser.getId()) {
            layoutId = R.menu.menu_edit_delete;
        } else if (currentUser.isAdmin()) {
            layoutId = R.menu.menu_user_promote;
        }

        if (layoutId != 0)
            inflater.inflate(layoutId, menu);

        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_edit:
                FragUtils.replaceBackStack(R.id.container,
                                           EditUserFragment.newInstance(mUser),
                                           getActivity());
                break;
            case R.id.menu_delete:
                break;
            case R.id.user_promote:
                openPromoteDialog();
                break;
        }

        return super.onOptionsItemSelected(item);
    }

    private void initializeViews() {
        mName.setText(mUser.getName());
        mHours.setText(String.valueOf(mUser.getTotalHours()));
        mUser.loadUserImage(getActivity(), mPhoto);

        if (mUser.getSchool() != null)
            mSchool.setText(mUser.getSchool().getName());

        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Profile");
    }

    private void openPromoteDialog() {
        PromoteDialog dialog = PromoteDialog.newInstance(this);
        dialog.setTargetFragment(this, DIALOG_CODE);
        dialog.show(getFragmentManager(), DIALOG_TAG);
    }

    public void onEvent(UserEvent event) {
        mUser = event.getUser();
        initializeViews();
    }

    public void onEvent(EditUserEvent event) {
        mUser = event.getUser();
        initializeViews();
    }

    public void onEvent(PromoteUserEvent event) {
        Snackbar.make(mLayout, "You've change this user's role!", Snackbar.LENGTH_SHORT).show();
    }

    public void selectedRole(String selection) {
        String role = "student";
        switch (selection) {
            case "Admin":
                role = "admin";
                break;
            case "Student":
                role = "student";
                break;
        }
        mUser.setRole(role);

        Requests.Users.with(getActivity()).makePromoteRequest(mUser);
    }

    public static class PromoteDialog extends DialogFragment {

        private PromoteInterface mPromoteInterface;

        public static PromoteDialog newInstance(PromoteInterface promoteInterface) {
            PromoteDialog dialog = new PromoteDialog();
            dialog.setInterface(promoteInterface);
            return dialog;
        }

        public void setInterface(PromoteInterface promoteInterface) {
            mPromoteInterface = promoteInterface;
        }

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

            final String[] roles = getResources().getStringArray(R.array.user_promote_options);

            builder.setTitle(getString(R.string.user_promote_dialog_title)).setItems(roles,
                    new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            mPromoteInterface.selectedRole(roles[i]);
                            dialogInterface.dismiss();
                        }
                    });

            return builder.show();
        }
    }
}
