package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/22/15.
 * Shows a user
 */
public class UserFragment extends BrowseAbstractFragment {

    private User mUser;

    public static UserFragment newInstance(User user) {
        UserFragment fragment = new UserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Requests.Users.with(getActivity()).makeShowRequest(mUser);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user, parent, false);
        ButterKnife.bind(this, view);
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

    public void onEvent(UserEvent event) {
        mUser = event.getUser();
    }
}
