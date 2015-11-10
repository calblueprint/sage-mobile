package blueprint.com.sage.checkIn.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/10/15.
 */
public class CheckInListFragment extends CheckInListAbstractFragment {

    public static CheckInListFragment newInstance() { return new CheckInListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_list, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
