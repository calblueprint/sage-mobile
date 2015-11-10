package blueprint.com.sage.checkIn.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.checkIn.CheckInListActivity;

/**
 * Created by charlesx on 11/10/15.
 */
public class CheckInListAbstractFragment extends Fragment {
    public CheckInListActivity getParentActivity() { return (CheckInListActivity) getActivity(); }
}