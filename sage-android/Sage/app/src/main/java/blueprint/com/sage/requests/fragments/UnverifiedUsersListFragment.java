package blueprint.com.sage.requests.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public class UnverifiedUsersListFragment extends RequestsAbstractFragment {

    public static UnverifiedUsersListFragment newInstance() { return new UnverifiedUsersListFragment(); }
    
    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_list, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
