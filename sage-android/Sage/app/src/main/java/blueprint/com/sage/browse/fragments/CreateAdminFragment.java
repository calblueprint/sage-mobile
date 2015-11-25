package blueprint.com.sage.browse.fragments;

/**
 * Created by charlesx on 11/18/15.
 */
public class CreateAdminFragment extends UserEditAbstractFragment {

    public static CreateAdminFragment newInstance() { return new CreateAdminFragment(); }

    public void initializeViews() {
        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Create User");
    }
}
