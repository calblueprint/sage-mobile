package blueprint.com.sage.schools.fragments;

import android.os.Bundle;
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

import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.schools.CreateSchoolEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.schools.adapters.PlacePredictionAdapter;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.MapUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/16/15.
 */
public class CreateSchoolFragment extends SchoolAbstractFragment implements FormValidation {

    private final int SW_LAT = 37;
    private final int SW_LNG = -123;
    private final int NE_LAT = 38;
    private final int NE_LNG = -122;
    private final int THRESHOLD = 3;

    private List<AutocompletePrediction> mPredictions;

    @Bind(R.id.create_school_name) EditText mSchoolName;
    @Bind(R.id.create_school_address) AutoCompleteTextView mSchoolAddress;
    private long mLat;
    private long mLng;

    private PlacePredictionAdapter mPlaceAdapter;

    public static CreateSchoolFragment newInstance() {
        return new CreateSchoolFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mPredictions = new ArrayList<>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_school, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
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

    private void initializeViews() {
        mPlaceAdapter = new PlacePredictionAdapter(getParentActivity(),
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
            }
        });
    }

    private void getPredictions(String address) {
        PendingResult<AutocompletePredictionBuffer> result =
                Places.GeoDataApi.getAutocompletePredictions(getParentActivity().getGoogleApiClient(), address,
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

        LatLng bounds = MapUtils.getLatLngFromAddress(getParentActivity(), address);
        School school = new School(name, address, bounds);

        Requests.Schools.with(getParentActivity()).makeCreateRequest(school);
    }

    public void onEvent(CreateSchoolEvent event) {
        FragUtils.popBackStack(this);
    }

    private void setPredictions(List<AutocompletePrediction> predictions) {
        mPredictions = predictions;
        if (mPlaceAdapter != null)
            mPlaceAdapter.setPredictions(predictions);
    }
    private List<AutocompletePrediction> getPredictions() { return mPredictions; }
}
