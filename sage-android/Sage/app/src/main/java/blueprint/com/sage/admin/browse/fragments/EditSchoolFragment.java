package blueprint.com.sage.admin.browse.fragments;

import android.os.Bundle;

import blueprint.com.sage.events.schools.EditSchoolEvent;
import blueprint.com.sage.events.schools.SchoolEvent;
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

    @Override
    public void initializeViews(Bundle savedInstanceState) {
        super.initializeViews(savedInstanceState);
        mToolbarInterface.setTitle("Edit School");
        Requests.Schools.with(getActivity()).makeShowRequest(mSchool, null);

    }
    public void initializeSchool() {
        mSchoolName.setText(mSchool.getName());
        mSchoolAddress.setText(mSchool.getAddress());
        setUserSpinner();
    }

    public void makeRequest() {
        Requests.Schools.with(getActivity()).makeEditRequest(mSchool);
    }

    public void onEvent(SchoolEvent event) {
        mSchool = event.getSchool();
        initializeSchool();
    }

    public void onEvent(EditSchoolEvent event) {
        mItem.setActionView(null);
        FragUtils.popBackStack(this);
    }
}
