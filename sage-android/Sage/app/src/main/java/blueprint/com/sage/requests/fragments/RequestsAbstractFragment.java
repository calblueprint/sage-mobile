package blueprint.com.sage.requests.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.requests.RequestsActivity;

/**
 * Created by charlesx on 11/10/15.
 */
public class RequestsAbstractFragment extends Fragment {
    public RequestsActivity getParentActivity() { return (RequestsActivity) getActivity(); }
}