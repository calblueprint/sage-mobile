package blueprint.com.sage.browse.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.browse.BrowseActivity;

/**
 * Created by charlesx on 11/4/15.
 */
public class BrowseAbstractFragment extends Fragment {
    public BrowseActivity getParentActivity() { return (BrowseActivity) getActivity(); }
}
