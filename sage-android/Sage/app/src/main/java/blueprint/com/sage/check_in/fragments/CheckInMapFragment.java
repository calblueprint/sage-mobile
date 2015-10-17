package blueprint.com.sage.check_in.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;

import blueprint.com.sage.R;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/16/15.
 * Fragment for check in map.
 */
public class CheckInMapFragment extends Fragment implements OnMapReadyCallback {

//    @Bind(R.id.check_in_check_fab) FloatingActionButton mCheckButton;
    @Bind(R.id.check_in_location_fab) FloatingActionButton mLocationButton;
    @Bind(R.id.check_in_map) MapView mMapView;

    private GoogleMap mMap;

    public static CheckInMapFragment newInstance() { return new CheckInMapFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MapsInitializer.initialize(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_map, parent, false);
        ButterKnife.bind(this, view);
        initializeViews(savedInstanceState);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        mMapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mMapView.onPause();
    }

    @Override
    public void onMapReady(GoogleMap map) {
        map.getUiSettings().setCompassEnabled(false);
        mMap = map;
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);
    }
}
