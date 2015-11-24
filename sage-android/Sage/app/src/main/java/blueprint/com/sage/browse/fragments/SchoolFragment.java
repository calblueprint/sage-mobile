package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.adapters.UserListAdapter;
import blueprint.com.sage.events.schools.SchoolEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.view.MapUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/20/15.
 */
public class SchoolFragment extends Fragment
                            implements OnMapReadyCallback {

    @Bind(R.id.user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.user_list_refresh) SwipeRefreshLayout mRefreshUsers;

    @Bind(R.id.school_map) MapView mMapView;
    @Bind(R.id.school_name) TextView mName;
    @Bind(R.id.school_address) TextView mAddress;

    private School mSchool;
    private UserListAdapter mAdapter;
    private GoogleMap mMap;

    private NavigationInterface mNavigationInterface;

    public static SchoolFragment newInstance(School school) {
        SchoolFragment fragment = new SchoolFragment();
        fragment.setSchool(school);
        return fragment;
    }

    public void setSchool(School school) { mSchool = school; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNavigationInterface = (NavigationInterface) getActivity();
        MapsInitializer.initialize(getActivity());
        Requests.Schools.with(getActivity()).makeShowRequest(mSchool);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_school, parent, false);
        ButterKnife.bind(this, view);
        initializeViews(savedInstanceState);
        return view;
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);

        mName.setText(mSchool.getName());
        mAddress.setText(mSchool.getAddress());

        mAdapter = new UserListAdapter(getActivity(), new ArrayList<User>());

        mUserList.setEmptyView(mEmptyView);
        mUserList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mUserList.setAdapter(mAdapter);

        mNavigationInterface.toggleDrawerUse(false);
        getActivity().setTitle("School");
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
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
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onMapReady(GoogleMap map) {
        mMap = map;
        mMap.getUiSettings().setCompassEnabled(false);
        mMap.setMyLocationEnabled(true);
        mMap.getUiSettings().setMyLocationButtonEnabled(false);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(MapUtils.ZOOM));

        LatLng latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
        mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));

        setMapCenter();
    }

    private void setMapCenter() {
        if (mMap == null || !mSchool.hasLatLng())
            return;

        LatLng latLng = new LatLng(mSchool.getLat(), mSchool.getLng());
        mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));

        MarkerOptions options = new MarkerOptions();
        options.position(latLng);
        mMap.addMarker(options);
    }

    public void onEvent(SchoolEvent event) {
        mSchool = event.getSchool();
        mAdapter.setUsers(mSchool.getUsers());
        setMapCenter();
    }
}

