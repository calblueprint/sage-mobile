package blueprint.com.sage.browse.fragments;

import blueprint.com.sage.shared.FormValidation;

/**
 * Created by charlesx on 11/16/15.
 */
public class CreateSchoolFragment extends SchoolFormAbstractFragment implements FormValidation {

    public static CreateSchoolFragment newInstance() { return new CreateSchoolFragment(); }

    public void initializeSchool() {
        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Create School");
    }
}
