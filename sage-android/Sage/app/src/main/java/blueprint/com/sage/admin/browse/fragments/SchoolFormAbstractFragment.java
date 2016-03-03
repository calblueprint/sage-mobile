package blueprint.com.sage.admin.browse.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.TextView;

import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.adapters.PlacePredictionAdapter;
import blueprint.com.sage.admin.browse.adapters.SchoolUserSpinnerAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.SchoolsInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.shared.views.ScrollMapView;
import blueprint.com.sage.utility.view.MapUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/29/15.
 */
public abstract class SchoolFormAbstractFragment extends Fragment
          implements FormValidation, OnMapReadyCallback {

    private final int THRESHOLD = 3;

    private List<AutocompletePrediction> mPredictions;

    @Bind(R.id.create_school_layout) View mLayout;
    @Bind(R.id.create_school_name) EditText mSchoolName;
    @Bind(R.id.create_school_address) AutoCompleteTextView mSchoolAddress;
    @Bind(R.id.create_school_map) ScrollMapView mMapView;
    @Bind(R.id.create_school_director) Spinner mDirector;
    @Bind(R.id.create_school_radius) SeekBar mRadius;
    @Bind(R.id.create_school_radius_int) TextView mRadiusInt;

    private List<User> mUsers;
    private SchoolUserSpinnerAdapter mUserAdapter;

    private GoogleMap mMap;
    protected ToolbarInterface mToolbarInterface;
    protected School mSchool;
    protected SchoolsInterface mSchoolsInterface;
    private BaseInterface mBaseInterface;
    private PlacePredictionAdapter mPlaceAdapter;
    private FormValidator mValidator;

    protected MenuItem mItem;
    private LatLng mBounds;
    private final int MAX_RADIUS = 1000;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        MapsInitializer.initialize(getActivity());

        mUsers = new ArrayList<>();
        if (mSchool != null)
            mUsers.add(0, mSchool.getDirector());

        mPredictions = new ArrayList<>();
        mBaseInterface = (BaseInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
        mSchoolsInterface = (SchoolsInterface) getActivity();
        mValidator = FormValidator.newInstance(getActivity());
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
        mItem = item;
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
        queryParams.put("non_director", "true");

        Requests.Users.with(getActivity()).makeListRequest(queryParams);
    }

    public void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);

        mPlaceAdapter = new PlacePredictionAdapter(getActivity(),
                R.layout.place_prediction_list_item, getPredictions());
        mSchoolAddress.setAdapter(mPlaceAdapter);
        mSchoolAddress.setThreshold(THRESHOLD);

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

        mUserAdapter = new SchoolUserSpinnerAdapter(getActivity(), mUsers,
                R.layout.simple_spinner_header, R.layout.simple_spinner_item);
        mDirector.setAdapter(mUserAdapter);
    }

    public abstract void initializeSchool();

    @Override
    public void onMapReady(GoogleMap map) {
        mMap = map;
        mMap.getUiSettings().setCompassEnabled(false);
        mMap.getUiSettings().setMyLocationButtonEnabled(false);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(MapUtils.ZOOM));

        LatLng latLng;
        if (mSchool == null) {
            latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
        } else {
            latLng = new LatLng(mSchool.getLat(), mSchool.getLng());
        }
        moveMapToLatLng(latLng);
        mBounds = latLng;

        mRadius.setMax(MAX_RADIUS);
        final int initialRadius;
        if (mSchool != null) {
            initialRadius = mSchool.getRadius();
            mRadius.setProgress(initialRadius);
        } else {
            initialRadius = 0;
        }

        mRadiusInt.setText(initialRadius + " m");
        mMapView.setRadius(initialRadius);

        mMap.setOnCameraChangeListener(new GoogleMap.OnCameraChangeListener() {
            @Override
            public void onCameraChange(CameraPosition position) {
                mBounds = mMap.getCameraPosition().target;
            }
        });

        mRadius.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                int radius = progress;
                mMapView.setRadius(radius);
                mRadiusInt.setText(radius + " m");
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });
    }

    private void moveMapToLatLng(LatLng latLng) {
        mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
    }

    public void validateAndSubmitRequest() {
        if (!isValid())
            return;

        if (mSchool == null)
            mSchool = new School();

        String name = mSchoolName.getText().toString();
        String address = mSchoolAddress.getText().toString();
        SchoolUserSpinnerAdapter.Item selectedDirector =
                (SchoolUserSpinnerAdapter.Item) mDirector.getSelectedItem();

        mSchool.setName(name);
        mSchool.setAddress(address);
        mSchool.setDirectorId(selectedDirector.toInt());
        mSchool.setRadius(mRadius.getProgress());

        if (mBounds != null) {
            mSchool.setLat((float) mBounds.latitude);
            mSchool.setLng((float) mBounds.longitude);
        }

        mItem.setActionView(R.layout.actionbar_indeterminate_progress);
        makeRequest();
    }

    public abstract void makeRequest();

    private boolean isValid() {
        return mValidator.hasNonBlankField(mSchoolName, "Name") &
                mValidator.hasNonBlankField(mSchoolAddress, "Address") &
                mValidator.mustBePicked(mDirector, "Director", mLayout);
    }

    public void onEvent(UserListEvent event) {
        mUsers = event.getUsers();

        if (mSchool != null && mSchool.getDirector() != null) {
            mUsers.add(0, mSchool.getDirector());
        }

        mUserAdapter.setUsers(mUsers);

        if (mSchool != null)
            setUserSpinner();
    }

    public void setUserSpinner() {
        User director = mSchool.getDirector();

        if (director == null) return;

        for (int i = 0; i < mUsers.size(); i++)
            if (mUsers.get(i).getId() == director.getId())
                mDirector.setSelection(i + 1);
    }

    private void setPredictions(List<AutocompletePrediction> predictions) {
        mPredictions = predictions;
        if (mPlaceAdapter != null)
            mPlaceAdapter.setPredictions(predictions);
    }
    private List<AutocompletePrediction> getPredictions() { return mPredictions; }

    public void onEvent(APIErrorEvent event) {
        mItem.setActionView(null);
    }
}
