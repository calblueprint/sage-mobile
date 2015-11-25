package blueprint.com.sage.browse.fragments;

import android.view.View;

import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 11/25/15.
 */
public class EditUserFragment extends UserEditAbstractFragment {

    public static EditUserFragment newInstance(User user) {
        EditUserFragment fragment = new EditUserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    public void initializeViews() {
        mFirstName.setText(mUser.getFirstName());
        mLastName.setText(mUser.getLastName());
        mEmail.setText(mUser.getEmail());
        mUser.loadUserImage(getActivity(), mPhoto);

        mType.setVisibility(View.GONE);
        mRole.setVisibility(View.GONE);
    }
}
