package blueprint.com.sage.browse.fragments;

import blueprint.com.sage.events.schools.EditSchoolEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/29/15.
 */
public class EditSchoolFragment extends SchoolFormAbstractFragment {

    public static EditSchoolFragment newInstance(School school) {
        EditSchoolFragment fragment = new EditSchoolFragment();
        fragment.setSchool(school);
        return fragment;
    }

    public void setSchool(School school) { mSchool = school; }

    public void initializeSchool() {
        mSchoolName.setText(mSchool.getName());
        mSchoolAddress.setText(mSchool.getAddress());
        setUserSpinner();

        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("Edit School");
    }

    public void makeRequest() {
        Requests.Schools.with(getActivity()).makeEditRequest(mSchool);
    }

    public void onEvent(EditSchoolEvent event) {
        FragUtils.popBackStack(this);
    }
}
