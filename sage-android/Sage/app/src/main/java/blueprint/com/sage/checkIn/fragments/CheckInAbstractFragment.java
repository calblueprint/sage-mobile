package blueprint.com.sage.checkIn.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.checkIn.CheckInActivity;

/**
 * Created by charlesx on 10/21/15.
 */
public abstract class CheckInAbstractFragment extends Fragment {
    public CheckInActivity getParentActivity() {
        return (CheckInActivity) getActivity();
    }
}
