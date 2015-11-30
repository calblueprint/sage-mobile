package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.Spinner;

import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.adapters.PlacePredictionAdapter;
import blueprint.com.sage.browse.adapters.UserSpinnerAdapter;
import blueprint.com.sage.events.schools.CreateSchoolEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.NavigationInterface;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.MapUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/29/15.
 */
public abstract class SchoolFormAbstractFragment extends Fragment
          implements FormValidation, OnMapReadyCallback {

    private final int SW_LAT = 37;
    private final int SW_LNG = -123;
    private final int NE_LAT = 38;
    private final int NE_LNG = -122;
    private final int THRESHOLD = 3;

    private List<AutocompletePrediction> mPredictions;

    @Bind(R.id.create_school_name) EditText mSchoolName;
    @Bind(R.id.create_school_address) AutoCompleteTextView mSchoolAddress;
    @Bind(R.id.create_school_map) MapView mMapView;
    @Bind(R.id.create_school_director) Spinner mDirector;

    private List<User> mUsers;
    private UserSpinnerAdapter mUserAdapter;

    private GoogleMap mMap;
    protected School mSchool;
    protected NavigationInterface mNavigationInterface;
    private BaseInterface mBaseInterface;
    private PlacePredictionAdapter mPlaceAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        MapsInitializer.initialize(getActivity());
        mPredictions = new ArrayList<>();
        mBaseInterface = (BaseInterface) getActivity();
        mNavigationInterface = (NavigationInterface) getActivity();
        makeUserListRequest();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_school, parent, false);
        ButterKnife.bind(this, view);
        initializeViews(savedInstanceState);
        initializeSchool();
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_save, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
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
        super.onStop();
        mMapView.onPause();
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    private void makeUserListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("admin", "true");
        queryParams.put("director_id", null);

        Requests.Schools.with(getActivity()).makeListRequest(queryParams);
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);

        mPlaceAdapter = new PlacePredictionAdapter(getActivity(),
                R.layout.place_prediction_list_item, getPredictions());
        mSchoolAddress.setAdapter(mPlaceAdapter);
        mSchoolAddress.setThreshold(THRESHOLD);
        mSchoolAddress.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.length() > 2) getPredictions(charSequence.toString());
            }

            @Override
            public void afterTextChanged(Editable editable) {
            }
        });

        mSchoolAddress.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                AutocompletePrediction prediction = mPlaceAdapter.getItem(i);
                mSchoolAddress.setText(prediction.getDescription());
                LatLng bounds = MapUtils.getLatLngFromAddress(getActivity(), prediction.getDescription());
                if (bounds != null)
                    moveMapToLatLng(bounds);
            }
        });

        mUserAdapter = new UserSpinnerAdapter(getActivity(), mUsers, R.layout.simple_spinner_item, R.layout.simple_spinner_item);
    }

    public abstract void initializeSchool();

    @Override
    public void onMapReady(GoogleMap map) {
        mMap = map;
        mMap.getUiSettings().setCompassEnabled(false);
        mMap.setMyLocationEnabled(true);
        mMap.getUiSettings().setMyLocationButtonEnabled(false);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(MapUtils.ZOOM));
        mMap.getUiSettings().setAllGesturesEnabled(false);

        LatLng latLng;
        if (mSchool == null) {
            latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
        } else {
            latLng = new LatLng(mSchool.getLat(), mSchool.getLng());
        }
        moveMapToLatLng(latLng);
    }

    private void moveMapToLatLng(LatLng latLng) {
        mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
    }

    private void getPredictions(String address) {
        PendingResult<AutocompletePredictionBuffer> result =
                Places.GeoDataApi.getAutocompletePredictions(mBaseInterface.getGoogleApiClient(), address,
                        MapUtils.createBounds(SW_LAT, SW_LNG, NE_LAT, NE_LNG), null);

        if (result == null)
            return;

        result.setResultCallback(new ResultCallback<AutocompletePredictionBuffer>() {
            @Override
            public void onResult(AutocompletePredictionBuffer result) {
                List<AutocompletePrediction> predictions = new ArrayList<AutocompletePrediction>();
                for (AutocompletePrediction prediction : result) {
                    predictions.add(prediction.freeze());
                }
                result.release();
                setPredictions(predictions);
            }
        });
    }

    public void validateAndSubmitRequest() {
        boolean hasError = false;

        if (mSchool == null)
            mSchool = new School();

        String name = mSchoolName.getText().toString();
        String address = mSchoolAddress.getText().toString();

        if (name.isEmpty()) {
            mSchoolName.setError(getString(R.string.cannot_be_blank, "Name"));
            hasError = true;
        }

        if (address.isEmpty()) {
            mSchoolAddress.setError(getString(R.string.cannot_be_blank, "Address"));
            hasError = true;
        }

        if (hasError)
            return;

        LatLng bounds = MapUtils.getLatLngFromAddress(getActivity(), address);
        School school = new School(name, address, bounds);

        Requests.Schools.with(getActivity()).makeCreateRequest(school);
    }

    public void onEvent(CreateSchoolEvent event) {
        FragUtils.popBackStack(this);
    }

    public void onEvent(UserListEvent event) {
        FragUtils.popBackStack(this);
    }

    private void setUsers(List<User> users) {
        mUsers = users;

    }

    private void setPredictions(List<AutocompletePrediction> predictions) {
        mPredictions = predictions;
        if (mPlaceAdapter != null)
            mPlaceAdapter.setPredictions(predictions);
    }
    private List<AutocompletePrediction> getPredictions() { return mPredictions; }
}
