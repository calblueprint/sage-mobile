package blueprint.com.sage.main.fragments;

import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.EditUserEvent;
import blueprint.com.sage.events.users.PromoteUserEvent;
import blueprint.com.sage.events.users.StatusUserEvent;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.fragments.ListDialog;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.ListDialogInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.users.EditUserActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/22/15.
 * Shows a user
 */
public class UserFragment extends Fragment implements ListDialogInterface {

    @Bind(R.id.user_layout) View mLayout;
    @Bind(R.id.user_name) TextView mName;
    @Bind(R.id.user_school) TextView mSchool;
    @Bind(R.id.user_volunteer) TextView mVolunteer;

    @Bind(R.id.user_total_time) TextView mTotalHours;
    @Bind(R.id.user_total_semester) TextView mTotalSemester;
    @Bind(R.id.user_hours_week) TextView mTotalWeek;

    @Bind(R.id.user_photo) CircleImageView mPhoto;

    @Bind(R.id.user_settings_layout) LinearLayout mUserSettingsLayout;
    @Bind(R.id.admin_settings_layout) LinearLayout mAdminSettingsLayout;

    private User mUser;

    private BaseInterface mBaseInterface;
    private ToolbarInterface mToolbarInterface;

    private static final int PROMOTE_DIALOG_CODE = 200;
    private static final int STATUS_DIALOG_CODE = 300;
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
        mBaseInterface = (BaseInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
        Requests.Users.with(getActivity()).makeShowRequest(mUser);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user, parent, false);
        ButterKnife.bind(this, view);
        initializeUser();
        initializeSettings();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
        mToolbarInterface.setToolbarElevation(0);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        mToolbarInterface.setToolbarElevation(getResources().getDimensionPixelSize(R.dimen.tab_layout_elevation));
    }

    private void initializeUser() {
        mUser.loadUserImage(getActivity(), mPhoto);
        mName.setText(mUser.getName());

        mVolunteer.setText(User.VOLUNTEER_SPINNER[mUser.getVolunteerType()]);
        mTotalHours.setText(mUser.getTimeString());
        mTotalSemester.setText(String.valueOf(60));
        mTotalWeek.setText(String.valueOf(mUser.getVolunteerType() + 1));

        if (mUser.getSchool() != null)
            mSchool.setText(mUser.getSchool().getName());
    }

    private void initializeSettings() {
        if (mBaseInterface.getUser().getId() == mUser.getId()) {
            mAdminSettingsLayout.setVisibility(View.GONE);
            mUserSettingsLayout.setVisibility(View.VISIBLE);
        } else if (mBaseInterface.getUser().isAdmin()) {
            mAdminSettingsLayout.setVisibility(View.VISIBLE);
            mUserSettingsLayout.setVisibility(View.GONE);
        }
    }

    @OnClick(R.id.user_check_ins)
    public void onCheckInClick(View view) {
        // TODO: add check in fragment
    }

    @OnClick(R.id.user_edit_profile)
    public void onEditProfileClick(View view) {
        FragUtils.startActivityBackStack(getActivity(), EditUserActivity.class);
    }

    @OnClick(R.id.user_about)
    public void onAboutClick(View view) {
        // TODO: add about fragment
    }

    @OnClick(R.id.user_log_out)
    public void onLogOutClick(View view) {
        NetworkUtils.logoutCurrentUser(getActivity());
    }

    @OnClick(R.id.admin_user_change_role)
    public void onPromoteClick(View view) {
        ListDialog dialog = ListDialog.newInstance(this,
                R.string.user_promote_dialog_title,
                User.ROLE_SPINNER);
        dialog.setTargetFragment(this, PROMOTE_DIALOG_CODE);
        dialog.show(getFragmentManager(), DIALOG_TAG);
    }

    @OnClick(R.id.admin_user_change_status)
    public void onStatusClick(View view) {
        ListDialog dialog = ListDialog.newInstance(this,
                R.string.user_status_dialog_title,
                User.STATUS_SPINNER);
        dialog.setTargetFragment(this, STATUS_DIALOG_CODE);
        dialog.show(getFragmentManager(), DIALOG_TAG);
    }

    @OnClick(R.id.admin_user_delete)
    public void onDeleteClick(View view) {
        NetworkUtils.logoutCurrentUser(getActivity());
    }

    public void onEvent(UserEvent event) {
        mUser = event.getUser();
        initializeUser();
    }

    public void onEvent(EditUserEvent event) {
        mUser = event.getUser();
        initializeUser();
    }

    public void onEvent(PromoteUserEvent event) {
        Snackbar.make(mLayout, "You've change this user's role!", Snackbar.LENGTH_SHORT).show();
    }

    public void onEvent(StatusUserEvent event) {
        Snackbar.make(mLayout, "You've change this user's status!", Snackbar.LENGTH_SHORT).show();
    }

    public void selectedItem(int selection, int requestCode) {
        switch (requestCode) {
            case PROMOTE_DIALOG_CODE:
                mUser.setRole(selection);
                Requests.Users.with(getActivity()).makePromoteRequest(mUser);
                break;
            case STATUS_DIALOG_CODE:
                mUser.setStatus(selection);
                Requests.Users.with(getActivity()).makeStatusRequest(mUser);
                break;
        }
    }
}
