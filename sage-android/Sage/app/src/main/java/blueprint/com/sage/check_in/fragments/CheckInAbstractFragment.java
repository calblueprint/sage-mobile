package blueprint.com.sage.check_in.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.check_in.CheckInActivity;

/**
 * Created by charlesx on 10/21/15.
 */
public abstract class CheckInAbstractFragment extends Fragment {
    public CheckInActivity getParentActivity() {
        return (CheckInActivity) getActivity();
    }
}
