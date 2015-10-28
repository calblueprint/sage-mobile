package blueprint.com.sage.checkIn.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/27/15.
 * Fragment to make a checkin request.
 */
public class CheckInRequestFragment extends CheckInAbstractFragment {

    public static CheckInRequestFragment newInstance() { return new CheckInRequestFragment(); }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_request, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
