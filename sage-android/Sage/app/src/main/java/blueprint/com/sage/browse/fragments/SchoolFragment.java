package blueprint.com.sage.browse.fragments;

import android.os.Bundle;

import blueprint.com.sage.models.School;

/**
 * Created by charlesx on 11/20/15.
 */
public class SchoolFragment extends BrowseAbstractFragment {

    private School mSchool;

    public static SchoolFragment newInstance(School school) {
        SchoolFragment fragment = new SchoolFragment();
        fragment.setSchool(school);
        return fragment;
    }

    public void setSchool(School school) { mSchool = school; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
//        super.onCreateView(inflater, parent, savedInstanceState);
//        View view = inflater.inflate()
//    }


}

