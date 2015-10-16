package blueprint.com.sage.check_in.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/16/15.
 * Fragment for check in map.
 */
public class CheckInMapFragment extends Fragment {

    public static CheckInMapFragment newInstance() { return new CheckInMapFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_map, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
