package blueprint.com.sage.browse.fragments;

import blueprint.com.sage.R;
import blueprint.com.sage.events.schools.CreateSchoolEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/16/15.
 */
public class CreateSchoolFragment extends SchoolFormAbstractFragment implements FormValidation {

    public static CreateSchoolFragment newInstance() { return new CreateSchoolFragment(); }

    public void initializeSchool() {
        getActivity().setTitle("Create School");
    }

    public void makeRequest() {
        Requests.Schools.with(getActivity()).makeCreateRequest(mSchool);
    }

    public void onEvent(CreateSchoolEvent event) {
        mSchoolsInterface.setNewSchool(event.getSchool());
        FragUtils.popBackStack(this);
        FragUtils.replaceBackStack(R.id.container,
                SchoolFragment.newInstance(event.getSchool()),
                getActivity());
    }
}
