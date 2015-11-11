package blueprint.com.sage.schools.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.schools.SchoolsActivity;

/**
 * Created by charlesx on 11/4/15.
 */
public class SchoolAbstractFragment extends Fragment {
    public SchoolsActivity getParentActivity() { return (SchoolsActivity) getActivity(); }
}
