package blueprint.com.sage.browse.fragments;

import android.view.View;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends UserEditAbstractFragment {

    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    public void initializeViews() {
        mCurrentPasswordLayout.setVisibility(View.GONE);

        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Create User");
    }
}
