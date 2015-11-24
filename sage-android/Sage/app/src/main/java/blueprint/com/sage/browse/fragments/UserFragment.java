package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/22/15.
 * Shows a user
 */
public class UserFragment extends Fragment {

    @Bind(R.id.user_name) TextView mName;
    @Bind(R.id.user_school) TextView mSchool;
    @Bind(R.id.user_total_hours) TextView mHours;
    @Bind(R.id.user_photo) CircleImageView mPhoto;

    private User mUser;
    private NavigationInterface mNavigationInterface;

    public static UserFragment newInstance(User user) {
        UserFragment fragment = new UserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
        inflater.inflate(R.menu.menu_edit_delete, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_edit:
                break;
            case R.id.menu_save:
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

    public void onEvent(UserEvent event) {
        mUser = event.getUser();
        initializeViews();
    }
}
